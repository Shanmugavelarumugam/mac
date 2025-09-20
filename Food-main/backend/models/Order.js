const { DataTypes } = require('sequelize');
const sequelize = require('../db');
const Food = require('./foodModel'); // import Food model


const Order = sequelize.define('Order', {
  userId: {
    type: DataTypes.INTEGER,
    allowNull: false,
  },
  foodId: {
    type: DataTypes.INTEGER,
    allowNull: false,
  },
  restaurantId: {
  type: DataTypes.INTEGER,
  allowNull: false,
},
  quantity: {
    type: DataTypes.INTEGER,
    allowNull: false,
    defaultValue: 1,
  },
  tableId: {
  type: DataTypes.INTEGER,
  allowNull: true
},
orderType: {
  type: DataTypes.ENUM('Dine-In', 'Delivery', 'Takeaway'),
  defaultValue: 'Delivery'
},
  totalAmount: {
    type: DataTypes.DECIMAL(10, 2),
    allowNull: false,
  },
  status: {
    type: DataTypes.ENUM('Placed', 'Preparing', 'Delivered', 'Cancelled','Completed'),
    defaultValue: 'Placed',
  },
  deliveryAddress: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  orderDate: {
    type: DataTypes.DATE,
    defaultValue: DataTypes.NOW,
  },
}, {
  tableName: 'orders',
  timestamps: true,
});

Order.belongsTo(Food, { foreignKey: 'foodId' });

module.exports = Order;
