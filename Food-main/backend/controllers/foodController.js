const Food = require('../models/foodModel');
const Review = require('../models/Review');
const { Sequelize } = require('sequelize');

/** 🔹 Get all foods */
exports.getAllFoods = async (req, res) => {
  try {
    const foods = await Food.findAll();
    res.json(foods);
  } catch (err) {
    console.log("Get All Foods Error:", err);
    res.status(500).json({ message: err.message });
  }
};

/** 🔹 Get food by ID */
exports.getFoodById = async (req, res) => {
  try {
    const food = await Food.findByPk(req.params.id);
    if (!food) {
      return res.status(404).json({ message: 'Food not found' });
    }
    res.json(food);
  } catch (err) {
    console.log("Get Food By ID Error:", err);
    res.status(500).json({ message: err.message });
  }
};

/** 🔹 Create food (single or bulk) */
exports.createFood = async (req, res) => {
  try {
    if (Array.isArray(req.body)) {
      const newFoods = await Food.bulkCreate(req.body);
      res.status(201).json(newFoods);
    } else {
      const {
        name, price, restaurantId, veg_nonveg, description, tagline,
        cuisine, rating, time_to_delivery, image_url, stock_quantity,
        calories, spicy_level, category
      } = req.body;

      const newFood = await Food.create({
        name, price, restaurantId, veg_nonveg, description, tagline,
        cuisine, rating, time_to_delivery, image_url, stock_quantity,
        calories, spicy_level, category
      });

      res.status(201).json(newFood);
    }
  } catch (err) {
    console.log("Create Food Error:", err);
    res.status(500).json({ message: err.message });
  }
};

/** 🔹 Update food */
exports.updateFood = async (req, res) => {
  const { name, price, restaurantId, veg_nonveg, description, tagline,
        cuisine, rating, time_to_delivery, image_url, stock_quantity,
        calories, spicy_level, category } = req.body;
  try {
    const [updated] = await Food.update(
      {name, price, restaurantId, veg_nonveg, description, tagline,
        cuisine, rating, time_to_delivery, image_url, stock_quantity,
        calories, spicy_level, category},
      { where: { id: req.params.id } }
    );

    if (!updated) {
      return res.status(404).json({ message: 'Food not found' });
    }

    const updatedFood = await Food.findByPk(req.params.id);
    res.json(updatedFood);
  } catch (err) {
    console.log("Update Food Error:", err);
    res.status(500).json({ message: err.message });
  }
};

/** 🔹 Delete food */
exports.deleteFood = async (req, res) => {
  try {
    const deleted = await Food.destroy({ where: { id: req.params.id } });
    if (!deleted) {
      return res.status(404).json({ message: 'Food not found' });
    }
    res.json({ message: 'Food deleted successfully' });
  } catch (err) {
    console.log("Delete Food Error:", err);
    res.status(500).json({ message: err.message });
  }
};

/** 🔹 Get foods by category */
exports.getFoodsByCategory = async (req, res) => {
  const { category } = req.params;
  try {
    const foods = await Food.findAll({ where: { category } });
    res.json(foods);
  } catch (err) {
    console.log("Get Foods by Category Error:", err);
    res.status(500).json({ message: err.message });
  }
};

/** 🔹 Get food with average rating */
exports.getFoodWithAvgRating = async (req, res) => {
  const { id } = req.params;
  try {
    const food = await Food.findByPk(id);
    if (!food) return res.status(404).json({ message: "Food not found" });

    const reviews = await Review.findAll({ where: { foodId: id } });

    let avgRating = 0;
    if (reviews.length > 0) {
      avgRating = reviews.reduce((sum, r) => sum + r.rating, 0) / reviews.length;
    }

    res.json({ food, avgRating: parseFloat(avgRating).toFixed(2) });
  } catch (err) {
    console.log("Get Food with Avg Rating Error:", err);
    res.status(500).json({ message: err.message });
  }
};

/** 🔹 Get similar foods by category */
exports.getSimilarFoods = async (req, res) => {
  const { foodId } = req.params;
  try {
    const food = await Food.findByPk(foodId);
    if (!food) return res.status(404).json({ message: "Food not found" });

    const similarFoods = await Food.findAll({
      where: {
        id: { [Sequelize.Op.ne]: foodId },
        category: food.category
      },
      limit: 5
    });

    res.json({ similarFoods });
  } catch (err) {
    console.log("Get Similar Foods Error:", err);
    res.status(500).json({ message: err.message });
  }
};
/** 🔹 Update Food Stock Quantity */
exports.updateFoodStock = async (req, res) => {
  const { id } = req.params;
  const { stock_quantity } = req.body;

  try {
    const food = await Food.findByPk(id);
    if (!food) {
      return res.status(404).json({ message: "Food not found" });
    }

    food.stock_quantity = stock_quantity;
    await food.save();

    res.json({ food, message: "Stock quantity updated successfully" });
  } catch (err) {
    console.log("Update Food Stock Error:", err);
    res.status(500).json({ message: err.message });
  }
};
