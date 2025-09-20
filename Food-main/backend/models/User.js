const { DataTypes } = require('sequelize');
const sequelize = require('../db');
// const SearchHistory=require('./SearchHistory');

const User = sequelize.define('User', {
  name: {
    type: DataTypes.STRING,
    allowNull: false
  },
  email: {
    type: DataTypes.STRING,
    allowNull: false,
    unique: true
  },
  password: {
    type: DataTypes.STRING,
    allowNull: false
  },
  gender: {
    type: DataTypes.STRING,
    allowNull: true
  },
  age: {
    type: DataTypes.INTEGER,
    allowNull: true
  },
  location: {
    type: DataTypes.STRING,
    allowNull: true
  },
  pincode: {
    type: DataTypes.STRING,
    allowNull: true
  }
});
// User.hasMany(SearchHistory, { foreignKey: 'userId' });
// SearchHistory.belongsTo(User, { foreignKey: 'userId' });


module.exports = User;
