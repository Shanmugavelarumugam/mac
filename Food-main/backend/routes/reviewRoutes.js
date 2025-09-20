const express = require('express');
const router = express.Router();
const reviewController = require('../controllers/reviewController');

router.get('/:foodId', reviewController.getReviewsByFood);
router.post('/', reviewController.addReview);
router.put('/:id', reviewController.updateReview);
router.delete('/:id', reviewController.deleteReview);
router.get('/restaurant/:restaurantId', reviewController.getReviewsByRestaurant);
router.get('/restaurant/:restaurantId/average', reviewController.getRestaurantAvgRating);

module.exports = router;
