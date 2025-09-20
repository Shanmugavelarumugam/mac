const express = require('express');
const router = express.Router();
const bcrypt = require('bcryptjs');
const User = require('../models/User');
const Restaurant = require('../models/restaurantModel');
const Otp = require('../models/Otp');
const sendEmail = require('../utils/sendEmail');

/** 🔹 Forgot Password - Common Function */
async function generateAndSendOtp(email, model, res) {
  const account = await model.findOne({ where: { email } });
  if (!account) return res.status(404).json({ message: "Account not found" });

  const otp = Math.floor(100000 + Math.random() * 900000).toString();
  const expiresAt = new Date(Date.now() + 10 * 60 * 1000); // 10 mins

  await Otp.create({ email, otp, expiresAt });
  await sendEmail(email, 'Your OTP Code', `Your OTP is ${otp}`);

  res.json({ message: "OTP sent to email" });
}

/** 🔹 User Forgot Password */
router.post('/user/forgot-password', async (req, res) => {
  const { email } = req.body;
  try {
    await generateAndSendOtp(email, User, res);
  } catch (err) {
    console.log(err);
    res.status(500).json({ message: err.message });
  }
});

/** 🔹 Restaurant Forgot Password */
router.post('/restaurant/forgot-password', async (req, res) => {
  const { email } = req.body;
  try {
    await generateAndSendOtp(email, Restaurant, res);
  } catch (err) {
    console.log(err);
    res.status(500).json({ message: err.message });
  }
});

/** 🔹 Verify OTP (common for both) */
router.post('/verify-otp', async (req, res) => {
  const { email, otp } = req.body;
  try {
    const otpRecord = await Otp.findOne({ where: { email, otp } });
    if (!otpRecord) return res.status(400).json({ message: "Invalid OTP" });

    if (otpRecord.expiresAt < new Date()) {
      await otpRecord.destroy(); // delete expired OTP
      return res.status(400).json({ message: "OTP expired" });
    }

    res.json({ message: "OTP verified" });
  } catch (err) {
    console.log(err);
    res.status(500).json({ message: err.message });
  }
});

/** 🔹 Reset Password - Common Function */
async function resetPassword(email, newPassword, model, res) {
  const account = await model.findOne({ where: { email } });
  if (!account) return res.status(404).json({ message: "Account not found" });

  const hashedPassword = await bcrypt.hash(newPassword, 10);
  account.password = hashedPassword;
  await account.save();

  await Otp.destroy({ where: { email } }); // Remove used OTPs

  res.json({ message: "Password updated successfully" });
}

/** 🔹 User Reset Password */
router.post('/user/reset-password', async (req, res) => {
  const { email, newPassword } = req.body;
  try {
    await resetPassword(email, newPassword, User, res);
  } catch (err) {
    console.log(err);
    res.status(500).json({ message: err.message });
  }
});

/** 🔹 Restaurant Reset Password */
router.post('/restaurant/reset-password', async (req, res) => {
  const { email, newPassword } = req.body;
  try {
    await resetPassword(email, newPassword, Restaurant, res);
  } catch (err) {
    console.log(err);
    res.status(500).json({ message: err.message });
  }
});

module.exports = router;
