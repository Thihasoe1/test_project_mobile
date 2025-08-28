
const express = require('express');
const cors = require('cors');
const machineRoutes = require('./routes/machineRoutes');
const errorHandler = require('./middleware/errorHandler');


const app = express();

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({extend: false}));

// Routes
app.use('/api/machines', machineRoutes);

// Health check
app.get('/health', (req, res) => {
  res.json({ success: true, message: 'Server is running', timestamp: new Date().toISOString() });
});

// Middleware
app.use(errorHandler);

module.exports = app;
