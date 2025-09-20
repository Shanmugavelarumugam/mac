// models/Table.js
const { DataTypes } = require('sequelize');
const sequelize = require('../db');

const Table = sequelize.define('Table', {
  table_number: {
    type: DataTypes.STRING,
    allowNull: false
  },
  capacity: {
    type: DataTypes.INTEGER,
    allowNull: false
  },
  status: {
    type: DataTypes.ENUM('Available', 'Occupied', 'Reserved'),
    defaultValue: 'Available'
  },
  restaurantId: {
    type: DataTypes.INTEGER,
    allowNull: false
  }
});

module.exports = Table;
