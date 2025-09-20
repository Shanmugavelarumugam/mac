const Review = require('../models/Review');
const Food = require('../models/foodModel');
const Sequelize = require('../db');


/** 🔹 Get All Reviews for a Food */
exports.getReviewsByFood = async (req, res) => {
  const { foodId } = req.params;
  try {
    const reviews = await Review.findAll({ where: { foodId } });
    res.json(reviews);
  } catch (err) {
    console.log("Get Reviews Error:", err);
    res.status(500).json({ message: err.message });
  }
};

/** 🔹 Add a Review */
exports.addReview = async (req, res) => {
  const { userId, foodId, rating, comment } = req.body;
  try {
    const review = await Review.create({
      userId,
      foodId,
      rating,
      comment
    });
    res.json({ review, message: "Review added successfully" });
  } catch (err) {
    console.log("Add Review Error:", err);
    res.status(500).json({ message: err.message });
  }
};

/** 🔹 Update a Review */
exports.updateReview = async (req, res) => {
  const { id } = req.params;
  const { rating, comment } = req.body;
  try {
    const review = await Review.findByPk(id);
    if (!review) return res.status(404).json({ message: "Review not found" });

    review.rating = rating || review.rating;
    review.comment = comment || review.comment;
    await review.save();

    res.json({ review, message: "Review updated successfully" });
  } catch (err) {
    console.log("Update Review Error:", err);
    res.status(500).json({ message: err.message });
  }
};

/** 🔹 Delete a Review */
exports.deleteReview = async (req, res) => {
  const { id } = req.params;
  try {
    const review = await Review.findByPk(id);
    if (!review) return res.status(404).json({ message: "Review not found" });

    await review.destroy();
    res.json({ message: "Review deleted successfully" });
  } catch (err) {
    console.log("Delete Review Error:", err);
    res.status(500).json({ message: err.message });
  }
};
exports.getReviewsByRestaurant = async (req, res) => {
  const { restaurantId } = req.params;
  try {
    // Find all foods for that restaurant
    const foods = await Food.findAll({ where: { restaurantId } });
    const foodIds = foods.map(f => f.id);

    // Find reviews for those foods
    const reviews = await Review.findAll({
      where: { foodId: foodIds }
    });

    res.json(reviews);
  } catch (err) {
    console.log("Get Restaurant Reviews Error:", err);
    res.status(500).json({ message: err.message });
  }
};

/** 🔹 Get Average Rating for a Restaurant */
exports.getRestaurantAvgRating = async (req, res) => {
  const { restaurantId } = req.params;
  try {
    const foods = await Food.findAll({ where: { restaurantId } });
    const foodIds = foods.map(f => f.id);

    const result = await Review.findAll({
      attributes: [
        [Sequelize.fn('AVG', Sequelize.col('rating')), 'avgRating']
      ],
      where: { foodId: foodIds },
      raw: true
    });

    res.json({
      avgRating: parseFloat(result[0].avgRating || 0).toFixed(2)
    });
  } catch (err) {
    console.log("Get Restaurant Avg Rating Error:", err);
    res.status(500).json({ message: err.message });
  }
};