const express = require('express');
const router = express.Router();
const foodController = require('../controllers/foodController');

/** 🔹 Specific routes FIRST to avoid conflicts */

// Get foods by category
router.get('/category/:category', foodController.getFoodsByCategory);

// Get similar foods by foodId
router.get('/similar/:foodId', foodController.getSimilarFoods);

// Get food with average rating
router.get('/:id/avg-rating', foodController.getFoodWithAvgRating);

/** 🔹 General CRUD routes */

// Get all foods
router.get('/', foodController.getAllFoods);

// Get food by ID
router.get('/:id', foodController.getFoodById);

// Create new food (single or bulk)
router.post('/', foodController.createFood);

// Update food by ID
router.put('/:id', foodController.updateFood);

// Delete food by ID
router.delete('/:id', foodController.deleteFood);

router.put('/:id/stock', foodController.updateFoodStock);

module.exports = router;
