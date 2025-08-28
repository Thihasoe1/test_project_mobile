
const express = require('express');
const MachineService = require('../services/machineService');
const MachineRepository = require('../repositories/machineRepository');

const router = express.Router();

router.get('/', async (req, res) => {
  try {
    const machines = await MachineRepository.getAllMachines();
    res.json({ success: true, data: machines });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

router.get('/:id', async (req, res) => {
  try {
    const machine = await MachineRepository.getMachineById(req.params.id);
    res.json({ success: true, data: machine });
  } catch (err) {
    res.status(404).json({ success: false, error: err.message });
  }
});

router.post('/', async (req, res) => {
  try {
    const machine = await MachineService.createMachine(req.body);
    res.status(201).json({ success: true, data: machine });
  } catch (err) {
    res.status(400).json({ success: false, error: err.message });
  }
});

router.put('/:id', async (req, res) => {
  try {
    const machine = await MachineService.updateMachine(req.params.id, req.body);
    res.json({ success: true, data: machine });
  } catch (err) {
    res.status(400).json({ success: false, error: err.message });
  }
});

router.delete('/:id', async (req, res) => {
  try {
    const machine = await MachineRepository.deleteMachine(req.params.id);
    res.json({ success: true, data: machine });
  } catch (err) {
    res.status(400).json({ success: false, error: err.message });
  }
});

module.exports = router;
