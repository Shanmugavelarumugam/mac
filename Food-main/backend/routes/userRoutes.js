const express = require('express');
const router = express.Router();
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { OAuth2Client } = require('google-auth-library');
const User = require('../models/User');

const client = new OAuth2Client('YOUR_GOOGLE_CLIENT_ID'); // replace with your actual client ID

/** ✅ Google Signin/Signup */
router.post('/google', async (req, res) => {
  const { token } = req.body;
  try {
    const ticket = await client.verifyIdToken({
      idToken: token,
      audience: 'YOUR_GOOGLE_CLIENT_ID',
    });

    const payload = ticket.getPayload();
    const { email, name } = payload;

    let user = await User.findOne({ where: { email } });
    if (!user) {
      user = await User.create({
        name,
        email,
        password: '',
      });
    }

    const jwtToken = jwt.sign({ id: user.id }, process.env.JWT_SECRET, { expiresIn: '1h' });

    res.json({ token: jwtToken, user, message: "Logged in with Google successfully" });

  } catch (err) {
    console.log("Google Auth Error:", err);
    res.status(500).json({ message: "Google login failed" });
  }
});

/** ✅ Signup route */
router.post('/signup', async (req, res) => {
  const { name, email, password } = req.body;
  try {
    const existingUser = await User.findOne({ where: { email } });
    if (existingUser) {
      return res.status(400).json({ message: "User with this email already exists" });
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    const user = await User.create({
      name,
      email,
      password: hashedPassword
    });

    const token = jwt.sign({ id: user.id }, process.env.JWT_SECRET, { expiresIn: '1h' });

    res.json({ token, user, message: "User registered successfully" });
  } catch (err) {
    console.log("Signup Error:", err);
    res.status(500).json({ message: err.message });
  }
});

/** ✅ Login route */
router.post('/login', async (req, res) => {
  const { email, password } = req.body;
  try {
    const user = await User.findOne({ where: { email } });
    if (!user) return res.status(401).json({ message: "Invalid credentials" });

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) return res.status(401).json({ message: "Invalid credentials" });

    const token = jwt.sign({ id: user.id }, process.env.JWT_SECRET, { expiresIn: '1h' });

    res.json({ token, user, message: "Login successful" });
  } catch (err) {
    console.log("Login Error:", err);
    res.status(500).json({ message: err.message });
  }
});

/** ✅ Update user additional info */
router.put('/:id', async (req, res) => {
  const { gender, age, location, pincode } = req.body;
  try {
    const user = await User.findByPk(req.params.id);
    if (!user) return res.status(404).json({ message: "User not found" });

    user.gender = gender || user.gender;
    user.age = age || user.age;
    user.location = location || user.location;
    user.pincode = pincode || user.pincode;

    await user.save();
    res.json({ user, message: "User information updated successfully" });
  } catch (err) {
    console.log("Update User Error:", err);
    res.status(500).json({ message: err.message });
  }
});

/** ✅ Get all users */
router.get('/', async (req, res) => {
  try {
    const users = await User.findAll();
    res.json(users);
  } catch (err) {
    console.log("Get Users Error:", err);
    res.status(500).json({ message: err.message });
  }
});

/** ✅ Get user by ID */
router.get('/:id', async (req, res) => {
  try {
    const user = await User.findByPk(req.params.id);
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }
    res.json(user);
  } catch (err) {
    console.log("Get User by ID Error:", err);
    res.status(500).json({ message: err.message });
  }
});

/** ✅ Delete user by ID */
router.delete('/:id', async (req, res) => {
  try {
    const user = await User.findByPk(req.params.id);
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    await user.destroy();
    res.json({ message: "User deleted successfully" });
  } catch (err) {
    console.log("Delete User Error:", err);
    res.status(500).json({ message: err.message });
  }
});

/** ✅ Logout route */
router.post('/logout', (req, res) => {
  res.json({ message: "Logout successful" });
});

module.exports = router;
