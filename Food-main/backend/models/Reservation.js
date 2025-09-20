// models/Reservation.js
const { DataTypes } = require('sequelize');
const sequelize = require('../db');

const Reservation = sequelize.define('Reservation', {
  userId: {
    type: DataTypes.INTEGER,
    allowNull: false
  },
  restaurantId: {
    type: DataTypes.INTEGER,
    allowNull: false
  },
  tableId: {
    type: DataTypes.INTEGER,
    allowNull: false
  },
  date: {
    type: DataTypes.DATEONLY,
    allowNull: false
  },
  time_slot: {
    type: DataTypes.STRING,
    allowNull: false
  },
  status: {
    type: DataTypes.ENUM('Reserved', 'Checked-In', 'Checked-Out', 'Cancelled'),
    defaultValue: 'Reserved'
  }
});

module.exports = Reservation;
