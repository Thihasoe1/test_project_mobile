
const supabase = require('../config/supabase');

class MachineRepository {
  static async getAllMachines() {
    const { data, error } = await supabase
      .from('machines')
      .select('*')
      .order('created_at', { ascending: false });
    if (error) throw error;
    return data;
  }

  static async getMachineById(id) {
    const { data, error } = await supabase
      .from('machines')
      .select('*')
      .eq('id', id)
      .single();
    if (error) throw error;
    return data;
  }

  static async createMachine(machineData) {
    const { data, error } = await supabase
      .from('machines')
      .insert([{ ...machineData, created_at: new Date().toISOString() }])
      .select()
      .single();
    if (error) throw error;
    return data;
  }

  static async updateMachine(id, updateData) {
    const { data, error } = await supabase
      .from('machines')
      .update(updateData)
      .eq('id', id)
      .select()
      .single();
    if (error) throw error;
    return data;
  }

  static async deleteMachine(id) {
    const { data, error } = await supabase
      .from('machines')
      .delete()
      .eq('id', id)
      .select()
      .single();
    if (error) throw error;
    return data;
  }
}

module.exports = MachineRepository;
