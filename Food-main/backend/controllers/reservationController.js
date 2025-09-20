const Reservation = require('../models/Reservation');

/** 🔹 Create Reservation */
exports.createReservation = async (req, res) => {
  const { userId, restaurantId, tableId, date, time_slot } = req.body;
  try {
    const reservation = await Reservation.create({
      userId, restaurantId, tableId, date, time_slot
    });
    res.json({ reservation, message: "Table reserved successfully" });
  } catch (err) {
    console.log("Create Reservation Error:", err);
    res.status(500).json({ message: err.message });
  }
};

/** 🔹 Check-In */
exports.checkIn = async (req, res) => {
  const { id } = req.params;
  try {
    const reservation = await Reservation.findByPk(id);
    if (!reservation) return res.status(404).json({ message: "Reservation not found" });

    reservation.status = 'Checked-In';
    await reservation.save();

    res.json({ reservation, message: "Checked in successfully" });
  } catch (err) {
    console.log("Check-In Error:", err);
    res.status(500).json({ message: err.message });
  }
};

/** 🔹 Check-Out */
exports.checkOut = async (req, res) => {
  const { id } = req.params;
  try {
    const reservation = await Reservation.findByPk(id);
    if (!reservation) return res.status(404).json({ message: "Reservation not found" });

    reservation.status = 'Checked-Out';
    await reservation.save();

    res.json({ reservation, message: "Checked out successfully" });
  } catch (err) {
    console.log("Check-Out Error:", err);
    res.status(500).json({ message: err.message });
  }
};
