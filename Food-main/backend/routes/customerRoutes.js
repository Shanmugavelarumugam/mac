const express = require('express');
const router = express.Router();
const customerController = require('../controllers/customerController'); // adjust import path

router.get('/restaurant/:id', customerController.getCustomersByRestaurant);

module.exports = router;
