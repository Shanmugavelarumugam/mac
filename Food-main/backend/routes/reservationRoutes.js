const express = require('express');
const router = express.Router();
const reservationController = require('../controllers/reservationController');

router.post('/', reservationController.createReservation);
router.put('/:id/checkin', reservationController.checkIn);
router.put('/:id/checkout', reservationController.checkOut);

module.exports = router;
