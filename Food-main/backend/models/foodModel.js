const { DataTypes } = require('sequelize');
const sequelize = require('../db');
const Review = require('../models/Review');

const Food = sequelize.define('Food', {
  name: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  price: {
    type: DataTypes.DECIMAL(10, 2),
    allowNull: false,
  },
  description: {
    type: DataTypes.TEXT,
  },
  restaurantId: {
  type: DataTypes.INTEGER,
  allowNull: false,
},
  tagline: {
    type: DataTypes.ARRAY(DataTypes.STRING), // ✅ tagline as array
    allowNull: true,
  },
  cuisine: {
    type: DataTypes.STRING,
  },
  rating: {
    type: DataTypes.FLOAT,
    defaultValue: 0.0,
  },
  time_to_delivery: {
    type: DataTypes.INTEGER,
  },
  image_url: {
    type: DataTypes.STRING,
  },
  stock_quantity: {
    type: DataTypes.INTEGER,
    defaultValue: 0,
  },
  calories: {
    type: DataTypes.INTEGER,
  },
  spicy_level: {
    type: DataTypes.STRING,
  },
  veg_nonveg: {
    type: DataTypes.ENUM('Veg', 'Non-Veg'),
    allowNull: false,
  },
  category: {
    type: DataTypes.STRING,
  },
}, {
  tableName: 'foods',
  timestamps: true,
});

Food.hasMany(Review, { foreignKey: 'foodId' });


/** ✅ Static method to find similar products based on overlapping taglines */
Food.findSimilarProducts = async function(foodId) {
  const food = await Food.findByPk(foodId);
  if (!food || !food.tagline) return [];

  const similarFoods = await Food.findAll({
    where: {
      id: {
        [sequelize.Sequelize.Op.ne]: foodId // exclude current food
      },
      tagline: {
        [sequelize.Sequelize.Op.overlap]: food.tagline
      }
    }
  });

  return similarFoods;
};

module.exports = Food;
