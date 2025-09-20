const Table = require('../models/Table');

/** 🔹 Get Table Availability for Restaurant */
exports.getTableAvailability = async (req, res) => {
  const { restaurantId } = req.params;
  try {
    const tables = await Table.findAll({ where: { restaurantId } });
    res.json(tables);
  } catch (err) {
    console.log("Get Table Availability Error:", err);
    res.status(500).json({ message: err.message });
  }
};

/** 🔹 Update Table Status */
exports.updateTableStatus = async (req, res) => {
  const { id } = req.params;
  const { status } = req.body;
  try {
    const table = await Table.findByPk(id);
    if (!table) return res.status(404).json({ message: "Table not found" });

    table.status = status;
    await table.save();
    res.json({ table, message: "Table status updated" });
  } catch (err) {
    console.log("Update Table Status Error:", err);
    res.status(500).json({ message: err.message });
  }
};

/** 🔹 Create Table */
exports.createTable = async (req, res) => {
  const { table_number, capacity, restaurantId } = req.body;

  try {
    const table = await Table.create({
      table_number,
      capacity,
      restaurantId,
      status: 'Available' // default status
    });

    res.json({ table, message: "Table created successfully" });
  } catch (err) {
    console.log("Create Table Error:", err);
    res.status(500).json({ message: err.message });
  }
};
