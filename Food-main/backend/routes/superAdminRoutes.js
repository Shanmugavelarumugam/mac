const express = require('express');
const router = express.Router();
const superAdminController = require('../controllers/superAdminController');

router.post('/', superAdminController.createSuperAdmin);
router.get('/', superAdminController.getAllSuperAdmins);
router.get('/:id', superAdminController.getSuperAdminById);
router.put('/:id', superAdminController.updateSuperAdmin);
router.delete('/:id', superAdminController.deleteSuperAdmin);

module.exports = router;
