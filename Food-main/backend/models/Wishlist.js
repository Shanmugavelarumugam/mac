const { DataTypes } = require('sequelize');
const sequelize = require('../db');

const Wishlist = sequelize.define('Wishlist', {
  id: {
    type: DataTypes.INTEGER,
    autoIncrement: true,
    primaryKey: true,
  },
  userId: {
    type: DataTypes.INTEGER,
    allowNull: false,
  },
  foodId: {
    type: DataTypes.INTEGER,
    allowNull: false,
  },
}, {
  tableName: 'wishlist',
  timestamps: true,
});

module.exports = Wishlist;
