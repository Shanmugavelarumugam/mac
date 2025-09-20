const express = require('express');
const router = express.Router();
const orderController = require('../controllers/orderController');

router.get('/completed/:restaurantId',orderController.getAllCompletedOrders);
router.get('/', orderController.getAllOrders);
router.get('/:id', orderController.getOrderById);
router.post('/', orderController.createOrder);
router.put('/cancel/:id', orderController.cancelOrder);
router.get('/orders/:id',orderController.getAllOrderForRes);
router.put('/:id/status', orderController.updateOrderStatus);


module.exports = router;
