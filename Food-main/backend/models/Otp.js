const { DataTypes } = require('sequelize');
const sequelize = require('../db');

const Otp = sequelize.define('Otp', {
  email: {
    type: DataTypes.STRING,
    allowNull: false
  },
  otp: {
    type: DataTypes.STRING,
    allowNull: false
  },
  expiresAt: {
    type: DataTypes.DATE,
    allowNull: false
  }
}, {
  timestamps: false // ✅ Optional: disables createdAt/updatedAt if not needed
});

module.exports = Otp;
