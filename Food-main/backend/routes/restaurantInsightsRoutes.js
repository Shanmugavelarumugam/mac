const express = require('express');
const router = express.Router();
const insightsController = require('../controllers/restaurantInsightsController');

router.get('/:restaurantId/orders-today', insightsController.getOrdersToday);
router.get('/:restaurantId/revenue-today', insightsController.getRevenueToday);
router.get('/:restaurantId/top-selling-foods', insightsController.getTopSellingFoods);
router.get('/:restaurantId/total-customers', insightsController.getTotalCustomers);
// router.get('/:restaurantId/overall-rating', insightsController.getOverallRating);
module.exports = router;
