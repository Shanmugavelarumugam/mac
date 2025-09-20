const express = require('express');
const router = express.Router();
const wishlistController = require('../controllers/wishlistController');

router.get('/:userId', wishlistController.getUserWish);
router.post('/', wishlistController.addToWish);
router.delete('/:id', wishlistController.removeFromWish);
router.delete('/clear/:userId', wishlistController.clearWish);

module.exports = router;
