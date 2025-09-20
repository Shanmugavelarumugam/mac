const Order = require('../models/Order');
const Food = require('../models/foodModel');
const Review = require('../models/Review');
const User = require('../models/User');
const { Sequelize } = require('sequelize');

/** 🔹 Total Orders Today */
exports.getOrdersToday = async (req, res) => {
  const { restaurantId } = req.params;

  try {
    const today = new Date();
    today.setHours(0, 0, 0, 0);

    const ordersToday = await Order.count({
      where: {
        restaurantId,
        createdAt: { [Sequelize.Op.gte]: today },
      },
    });

    res.json({ ordersToday });
  } catch (err) {
    console.log("Orders Today Error:", err);
    res.status(500).json({ message: err.message });
  }
};

/** 🔹 Revenue Today */
exports.getRevenueToday = async (req, res) => {
  const { restaurantId } = req.params;

  try {
    const today = new Date();
    today.setHours(0, 0, 0, 0);

    const result = await Order.findAll({
      attributes: [
        [Sequelize.fn('SUM', Sequelize.col('totalAmount')), 'totalRevenue'],
      ],
      where: {
        restaurantId,
        createdAt: { [Sequelize.Op.gte]: today },
      },
      raw: true,
    });

    res.json({ totalRevenue: result[0].totalRevenue || 0 });
  } catch (err) {
    console.log("Revenue Today Error:", err);
    res.status(500).json({ message: err.message });
  }
};

/** 🔹 Top Selling Foods */
exports.getTopSellingFoods = async (req, res) => {
  const { restaurantId } = req.params;

  try {
    const result = await Order.findAll({
      attributes: [
        'foodId',
        [Sequelize.fn('COUNT', Sequelize.col('foodId')), 'orderCount'],
      ],
      where: { restaurantId }, // filter by restaurant
      group: ['foodId', 'Food.id'],
      order: [[Sequelize.literal('"orderCount"'), 'DESC']], // ✅ corrected with double quotes
      limit: 5,
      include: [{
        model: Food,
        attributes: ['name'],
        where: { restaurantId }, // ensures only that restaurant’s foods are included
      }],
      raw: true,
      nest: true,
    });

    res.json(result);
  } catch (err) {
    console.log("Top Selling Foods Error:", err);
    res.status(500).json({ message: err.message });
  }
};

/** 🔹 Total Unique Customers for a restaurant */
exports.getTotalCustomers = async (req, res) => {
  const { restaurantId } = req.params;

  try {
    const customers = await Order.findAll({
      attributes: [[Sequelize.fn('DISTINCT', Sequelize.col('userId')), 'userId']],
      where: { restaurantId },
      raw: true,
    });

    res.json({ totalCustomers: customers.length });
  } catch (err) {
    console.log("Total Customers Error:", err);
    res.status(500).json({ message: err.message });
  }
};

/** 🔹 Overall Restaurant Rating (Average of Food Ratings) */
// exports.getOverallRating = async (req, res) => {
//   const { restaurantId } = req.params;

//   try {
//     const result = await Review.findAll({
//       attributes: [
//         [Sequelize.fn('AVG', Sequelize.col('rating')), 'avgRating'],
//       ],
//       include: [{
//         model: Food,
//         attributes: [],
//         where: { restaurantId }, // filter by restaurant
//       }],
//       raw: true,
//     });

//     res.json({ avgRating: parseFloat(result[0].avgRating).toFixed(2) || 0 });
//   } catch (err) {
//     console.log("Overall Rating Error:", err);
//     res.status(500).json({ message: err.message });
//   }
// };
