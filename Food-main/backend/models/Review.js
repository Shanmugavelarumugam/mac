const { DataTypes } = require('sequelize');
const sequelize = require('../db');
// const Food =require('./foodModel');

const Review = sequelize.define('Review', {
  userId: {
    type: DataTypes.INTEGER,
    allowNull: false,
  },
  foodId: {
    type: DataTypes.INTEGER,
    allowNull: false,
  },
  rating: {
    type: DataTypes.FLOAT,
    allowNull: false,
    validate: { min: 1, max: 5 },
  },
  comment: {
    type: DataTypes.TEXT,
    allowNull: true,
  },
}, {
  tableName: 'reviews',
  timestamps: true, // createdAt and updatedAt
});
// Review.belongsTo(Food, { foreignKey: 'foodId' });
// Food.hasMany(Review, { foreignKey: 'foodId' });

module.exports = Review;
