const { DataTypes } = require('sequelize');
const sequelize = require('../db');

const Cart = sequelize.define('Cart', {
  userId: {
    type: DataTypes.INTEGER,
    allowNull: false,
  },
  foodId: {
    type: DataTypes.INTEGER,
    allowNull: false,
  },
  quantity: {
    type: DataTypes.INTEGER,
    defaultValue: 1,
  },
}, {
  tableName: 'carts',
  timestamps: true, // createdAt and updatedAt
});

module.exports = Cart;
