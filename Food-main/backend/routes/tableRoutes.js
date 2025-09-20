const express = require('express');
const router = express.Router();
const tableController = require('../controllers/tableController');

router.get('/:restaurantId', tableController.getTableAvailability);
router.put('/:id/status', tableController.updateTableStatus);
router.post('/', tableController.createTable);


module.exports = router;
