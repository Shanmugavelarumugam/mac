const { DataTypes } = require('sequelize');
const sequelize = require('../db');

const SuperAdmin = sequelize.define('SuperAdmin', {
  name: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  email: {
    type: DataTypes.STRING,
    allowNull: false,
    unique: true,
  },
  password: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  phone: {
    type: DataTypes.STRING,
  },
  role: {
    type: DataTypes.STRING,
    defaultValue: 'SuperAdmin',
  }
}, {
  tableName: 'superadmins',
  timestamps: true,
});

module.exports = SuperAdmin;
