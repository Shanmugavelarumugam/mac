// models/restaurantModel.js

const { DataTypes } = require('sequelize');
const sequelize = require('../db');

const Restaurant = sequelize.define('Restaurant', {
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
  address: {
    type: DataTypes.TEXT,
  },
  city: {
    type: DataTypes.STRING,
  },
  state: {
    type: DataTypes.STRING,
  },
  pincode: {
    type: DataTypes.STRING,
  },
  cuisine_type: {
    type: DataTypes.STRING,
  },
  opening_hours: {
    type: DataTypes.STRING,
  },
  status: {
    type: DataTypes.ENUM('Active', 'Inactive'),
    defaultValue: 'Active',
  },
  profile_image: {
    type: DataTypes.STRING,
  },
  rating: {
    type: DataTypes.FLOAT,
    defaultValue: 0.0,
  },
  wallet_balance: {
    type: DataTypes.DECIMAL(10, 2),
    defaultValue: 0.00,
  },
  description: {
    type: DataTypes.TEXT,
  },
  gstin: {
    type: DataTypes.STRING,
  },
  delivery_fee: {
    type: DataTypes.DECIMAL(10, 2),
    defaultValue: 0.00,
  },
  latitude: {
    type: DataTypes.DECIMAL(10, 7),
    allowNull: true,
  },
  longitude: {
    type: DataTypes.DECIMAL(10, 7),
    allowNull: true,
  },

  /** 🔷 Added Service Options **/
  delivery: {
    type: DataTypes.BOOLEAN,
    defaultValue: true,
  },
  dine_in: {
    type: DataTypes.BOOLEAN,
    defaultValue: false,
  },
  takeaway: {
    type: DataTypes.BOOLEAN,
    defaultValue: true,
  },

  /** 🔷 Table count only relevant for dine-in **/
  table_count: {
    type: DataTypes.INTEGER,
    allowNull: true,
    validate: {
      min: 0,
    }
  },

}, {
  tableName: 'restaurants',
  timestamps: true,
});

module.exports = Restaurant;
