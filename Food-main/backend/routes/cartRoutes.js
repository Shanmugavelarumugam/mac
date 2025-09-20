const express = require('express');
const router = express.Router();
const cartController = require('../controllers/cartController');

router.get('/:userId', cartController.getUserCart);
router.post('/', cartController.addToCart);
router.delete('/:id', cartController.removeFromCart);
router.delete('/clear/:userId', cartController.clearCart);
router.put('/:id',cartController.updateCart);

module.exports = router;
