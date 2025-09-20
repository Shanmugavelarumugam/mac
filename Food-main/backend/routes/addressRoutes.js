const express = require('express');
const router = express.Router();
const addressController = require('../controllers/addressController');

router.post('/', addressController.createAddress);
router.get('/:userId', addressController.getUserAddresses);

module.exports = router;
