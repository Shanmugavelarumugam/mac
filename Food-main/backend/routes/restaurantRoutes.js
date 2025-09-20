const express = require('express');
const router = express.Router();
const restaurantController = require('../controllers/restaurantController');

router.post('/signup', restaurantController.signup);
router.post('/login', restaurantController.login);
router.get('/top-rated-nearby', restaurantController.getTopRatedNearbyRestaurants);
router.get('/top-rated', restaurantController.getTopRatedRestaurants);
router.post('/', restaurantController.createRestaurant);
router.get('/nearby', restaurantController.getNearbyRestaurants); // 👈 place static first
router.get('/', restaurantController.getAllRestaurants);
router.get('/:id', restaurantController.getRestaurantById);
router.put('/:id', restaurantController.updateRestaurant);
router.delete('/:id', restaurantController.deleteRestaurant);
router.get('/getMenu/:id',restaurantController.getAllFoodsForMenu);




module.exports = router;
