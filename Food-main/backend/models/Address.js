const { DataTypes } = require('sequelize');
const sequelize = require('../db');

const Address = sequelize.define('Address', {
  userId: {
    type: DataTypes.INTEGER,
    allowNull: false,
  },
  addressLine: {
    type: DataTypes.STRING,
    allowNull: true,
  },
  latitude: {
    type: DataTypes.DECIMAL(10, 7),
    allowNull: false,
  },
  longitude: {
    type: DataTypes.DECIMAL(10, 7),
    allowNull: false,
  },
  label: {
    type: DataTypes.STRING, // Home, Work, Other
  },
}, {
  tableName: 'addresses',
  timestamps: true, // adds createdAt and updatedAt fields
});

module.exports = Address;
