const Order = require('../models/Order');
const User = require('../models/User');

/** 🔹 Get All Customers Who Ordered from a Specific Restaurant */
exports.getCustomersByRestaurant = async (req, res) => {
  const { id } = req.params;

  try {
    const orders = await Order.findAll({
      where: { restaurantId: id },
      attributes: ['userId'],
      group: ['userId']
    });

    const userIds = orders.map(order => order.userId);

    const customers = await User.findAll({
      where: { id: userIds },
      attributes: ['id', 'name', 'email'] // adjust based on your User model fields
    });

    res.json(customers);
  } catch (err) {
    console.log("Get Customers by Restaurant Error:", err);
    res.status(500).json({ message: err.message });
  }
};
