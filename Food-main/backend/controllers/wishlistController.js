const Wishlist = require('../models/Wishlist');

/** 🔹 Get All Wishlist Items for a User */
exports.getUserWish = async (req, res) => {
  const { userId } = req.params;
  try {
    const wishItems = await Wishlist.findAll({ where: { userId } });
    res.json(wishItems);
  } catch (err) {
    console.log("Get Wishlist Error:", err);
    res.status(500).json({ message: err.message });
  }
};

/** 🔹 Add Item to Wishlist */
exports.addToWish = async (req, res) => {
  const { userId, foodId } = req.body;
  try {
    // Check if item already exists in wishlist
    let wishItem = await Wishlist.findOne({ where: { userId, foodId } });
    if (wishItem) {
      await wishItem.save();
    } else {
      wishItem = await Wishlist.create({
        userId,
        foodId,
      });
    }

    res.json({ wishItem, message: "Item added to wishlist" });
  } catch (err) {
    console.log("Add to Wishlist Error:", err);
    res.status(500).json({ message: err.message });
  }
};

/** 🔹 Remove Item from Wishlist */
exports.removeFromWish = async (req, res) => {
  const { id } = req.params;
  try {
    const wishItem = await Wishlist.findByPk(id);
    if (!wishItem) return res.status(404).json({ message: "Wishlist item not found" });

    await wishItem.destroy();
    res.json({ message: "Item removed from wishlist" });
  } catch (err) {
    console.log("Remove Wishlist Item Error:", err);
    res.status(500).json({ message: err.message });
  }
};

/** 🔹 Clear Entire Wishlist for a User */
exports.clearWish = async (req, res) => {
  const { userId } = req.params;
  try {
    await Wishlist.destroy({ where: { userId } });
    res.json({ message: "Wishlist cleared successfully" });
  } catch (err) {
    console.log("Clear Wishlist Error:", err);
    res.status(500).json({ message: err.message });
  }
};
