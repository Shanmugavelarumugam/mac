const Cart = require('../models/Cart');

/** 🔹 Get All Cart Items for a User */
exports.getUserCart = async (req, res) => {
  const { userId } = req.params;
  try {
    const cartItems = await Cart.findAll({ where: { userId } });
    res.json(cartItems);
  } catch (err) {
    console.log("Get Cart Error:", err);
    res.status(500).json({ message: err.message });
  }
};

/** 🔹 Add Item to Cart */
exports.addToCart = async (req, res) => {
  const { userId, foodId, quantity } = req.body;
  try {
    // Check if item already exists in cart
    let cartItem = await Cart.findOne({ where: { userId, foodId } });
    if (cartItem) {
      cartItem.quantity += quantity; // increment quantity
      await cartItem.save();
    } else {
      cartItem = await Cart.create({
        userId,
        foodId,
        quantity
      });
    }

    res.json({ cartItem, message: "Item added to cart" });
  } catch (err) {
    console.log("Add to Cart Error:", err);
    res.status(500).json({ message: err.message });
  }
};

exports.updateCart = async (req, res) => {
  const { id } = req.params; // ✅ Correct destructuring
  const { userId, foodId, quantity } = req.body;

  console.log("Updating cart id:", id); // 🐞 Debug log

  try {
    const cartItem = await Cart.findOne({ where: { id } }); // ✅ Correct field

    if (!cartItem) {
      return res.status(404).json({ message: "Cart not found" });
    }

    // Update fields only if provided
    cartItem.userId = userId || cartItem.userId;
    cartItem.foodId = foodId || cartItem.foodId;
    cartItem.quantity = quantity || cartItem.quantity;

    await cartItem.save();

    res.json({ cartItem, message: "Cart information updated successfully" });
  } catch (err) {
    console.log("Update Cart Error:", err);
    res.status(500).json({ message: err.message });
  }
};



/** 🔹 Remove Item from Cart */
exports.removeFromCart = async (req, res) => {
  const { id } = req.params;
  try {
    const cartItem = await Cart.findByPk(id);
    if (!cartItem) return res.status(404).json({ message: "Cart item not found" });

    await cartItem.destroy();
    res.json({ message: "Item removed from cart" });
  } catch (err) {
    console.log("Remove Cart Item Error:", err);
    res.status(500).json({ message: err.message });
  }
};

/** 🔹 Clear Entire Cart for a User */
exports.clearCart = async (req, res) => {
  const { userId } = req.params;
  try {
    await Cart.destroy({ where: { userId } });
    res.json({ message: "Cart cleared successfully" });
  } catch (err) {
    console.log("Clear Cart Error:", err);
    res.status(500).json({ message: err.message });
  }
};
