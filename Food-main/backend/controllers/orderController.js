const Order = require('../models/Order');
const Restaurant = require('../models/restaurantModel'); 

/** 🔹 Get All Orders */
exports.getAllOrders = async (req, res) => {
  try {
    const orders = await Order.findAll();
    res.json(orders);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

/** 🔹 Get Single Order by ID */
exports.getOrderById = async (req, res) => {
  const { id } = req.params;
  try {
    const order = await Order.findByPk(id);
    if (!order) return res.status(404).json({ message: "Order not found" });
    res.json(order);
  } catch (err) {
    console.log("Get Order Error:", err);
    res.status(500).json({ message: err.message });
  }
};

/** 🔹 Create New Order */
exports.createOrder = async (req, res) => {
  const { userId, foodId,restaurantId, quantity, totalAmount, deliveryAddress } = req.body;
  try {
    const order = await Order.create({
      userId,
      foodId,
      restaurantId,
      quantity,
      totalAmount,
      deliveryAddress
    });
    res.json({ order, message: "Order placed successfully" });
  } catch (err) {
    console.log("Create Order Error:", err);
    res.status(500).json({ message: err.message });
  }
};

/** 🔹 Cancel Order */
exports.cancelOrder = async (req, res) => {
  const { id } = req.params;
  try {
    const order = await Order.findByPk(id);
    if (!order) return res.status(404).json({ message: "Order not found" });

    order.status = 'Cancelled';
    await order.save();
    res.json({ order, message: "Order cancelled successfully" });
  } catch (err) {
    console.log("Cancel Order Error:", err);
    res.status(500).json({ message: err.message });
  }
};
exports.getAllOrderForRes = async (req, res) => {
  const { id } = req.params;

  try {
    const restaurant = await Restaurant.findByPk(id);
    if (!restaurant) {
      return res.status(404).json({ message: "Restaurant not found" });
    }
    const orders = await Order.findAll({
      where: { restaurantId: id }
    });

    res.json({
      restaurant: restaurant,
      menu: orders
    });
  } catch (err) {
    console.log("Get All Foods For Menu Error:", err);
    res.status(500).json({ message: err.message });
  }
};
exports.updateOrderStatus = async (req, res) => {
  const { id } = req.params;
  const { status } = req.body;

  try {
    const order = await Order.findByPk(id);
    if (!order) return res.status(404).json({ message: "Order not found" });

    order.status = status;
    await order.save();
    res.json({ order, message: `Order status updated to ${status}` });
  } catch (err) {
    console.log("Update Order Status Error:", err);
    res.status(500).json({ message: err.message });
  }
};

exports.getAllCompletedOrders = async (req, res) => {
  const { restaurantId } = req.params; // 🔑 get restaurantId from URL params

  try {
    const completedOrders = await Order.findAll({
      where: {
        status: 'Completed',
        restaurantId: restaurantId // 🔑 filter by restaurantId
      }
    });

    res.json(completedOrders);
  } catch (err) {
    console.log("Get Completed Orders Error:", err);
    res.status(500).json({ message: err.message });
  }
};
