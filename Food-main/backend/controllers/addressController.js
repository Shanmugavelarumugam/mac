const  Address  = require('../models/Address');

/** ✅ Create Address */
exports.createAddress = async (req, res) => {
  const { userId, addressLine, latitude, longitude, label } = req.body;
  try {
    const address = await Address.create({
      userId,
      addressLine,
      latitude,
      longitude,
      label
    });
    res.json({ address, message: "Address saved successfully" });
  } catch (err) {
    console.log("Create Address Error:", err);
    res.status(500).json({ message: err.message });
  }
};

/** ✅ Get all addresses for a user */
exports.getUserAddresses = async (req, res) => {
  const { userId } = req.params;
  try {
    const addresses = await Address.findAll({ where: { userId } });
    res.json(addresses);
  } catch (err) {
    console.log("Get Addresses Error:", err);
    res.status(500).json({ message: err.message });
  }
};
