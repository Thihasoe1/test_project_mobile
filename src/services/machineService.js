
const MachineRepository = require('../repositories/machineRepository');
const supabase = require('../config/supabase');

class MachineService {
  static validateMachineData(data) {
    const errors = [];
    if (!data.machine_name?.trim()) errors.push('Machine name is required');
    if (data.temperature && (isNaN(data.temperature) || data.temperature < -100 || data.temperature > 200)) {
      errors.push('Temperature must be between -100 and 200');
    }
    if (data.pressure && (isNaN(data.pressure) || data.pressure < 0 || data.pressure > 500)) {
      errors.push('Pressure must be between 0 and 500');
    }
    if (data.speed && (isNaN(data.speed) || data.speed < 0 || data.speed > 5000)) {
      errors.push('Speed must be between 0 and 5000');
    }
    const validStatuses = ['running', 'stopped', 'maintenance', 'error'];
    if (data.status && !validStatuses.includes(data.status)) {
      errors.push(`Status must be one of: ${validStatuses.join(', ')}`);
    }
    return errors;
  }

  static async createMachine(machineData) {
    const errors = this.validateMachineData(machineData);
    if (errors.length) throw new Error(errors.join(', '));

    // Prevent duplicate names
    const { data: existing } = await supabase
      .from('machines')
      .select('id')
      .eq('machine_name', machineData.machine_name)
      .maybeSingle();
    if (existing) throw new Error('Machine with this name already exists');

    return MachineRepository.createMachine({
      ...machineData,
      temperature: machineData.temperature || 0,
      pressure: machineData.pressure || 0,
      speed: machineData.speed || 0,
      status: machineData.status || 'stopped',
    });
  }

  static async updateMachine(id, machineData) {
    const errors = this.validateMachineData(machineData);
    if (errors.length) throw new Error(errors.join(', '));

    const machine = await MachineRepository.getMachineById(id);
    if (!machine) throw new Error('Machine not found');

    // Prevent duplicate names (other than itself)
    if (machineData.machine_name) {
      const { data: duplicate } = await supabase
        .from('machines')
        .select('id')
        .eq('machine_name', machineData.machine_name)
        .neq('id', id)
        .maybeSingle();
      if (duplicate) throw new Error('Machine with this name already exists');
    }

    return MachineRepository.updateMachine(id, machineData);
  }
}

module.exports = MachineService;
