const SuperAdmin = require('../models/superAdminModel');
const bcrypt = require('bcrypt');

// ✅ Create Super Admin
exports.createSuperAdmin = async (req, res) => {
  const { name, email, password, phone } = req.body;

  try {
    const hashedPassword = await bcrypt.hash(password, 10);
    const superAdmin = await SuperAdmin.create({
      name,
      email,
      password: hashedPassword,
      phone
    });
    res.status(201).json(superAdmin);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

// ✅ Get all Super Admins
exports.getAllSuperAdmins = async (req, res) => {
  try {
    const admins = await SuperAdmin.findAll();
    res.json(admins);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

// ✅ Get Super Admin by ID
exports.getSuperAdminById = async (req, res) => {
  const { id } = req.params;
  try {
    const admin = await SuperAdmin.findByPk(id);
    if (!admin) {
      return res.status(404).json({ message: 'Super Admin not found' });
    }
    res.json(admin);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

// ✅ Update Super Admin
exports.updateSuperAdmin = async (req, res) => {
  const { id } = req.params;
  const updateData = req.body;

  try {
    const admin = await SuperAdmin.findByPk(id);
    if (!admin) {
      return res.status(404).json({ message: 'Super Admin not found' });
    }

    if (updateData.password) {
      updateData.password = await bcrypt.hash(updateData.password, 10);
    }

    await admin.update(updateData);
    res.json(admin);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

// ✅ Delete Super Admin
exports.deleteSuperAdmin = async (req, res) => {
  const { id } = req.params;
  try {
    const admin = await SuperAdmin.findByPk(id);
    if (!admin) {
      return res.status(404).json({ message: 'Super Admin not found' });
    }
    await admin.destroy();
    res.json({ message: 'Super Admin deleted' });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};
