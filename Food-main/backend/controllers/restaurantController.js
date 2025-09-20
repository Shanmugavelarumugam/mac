// controllers/restaurantController.js


const jwt = require('jsonwebtoken');

const sequelize = require('../db'); // ✅ Correct import

const Restaurant = require('../models/restaurantModel');
// const Restaurant = require('../models/Restaurant');
const Food = require('../models/foodModel');
const bcrypt = require('bcrypt');
const { QueryTypes } = require('sequelize');

/** 🔹 Get Top Rated Restaurants */
exports.getTopRatedRestaurants = async (req, res) => {
  try {
    const topRestaurants = await Restaurant.findAll({
      order: [['rating', 'DESC']], // Sort by rating descending
      limit: 10 // Adjust the number as needed for top N
    });

    res.json(topRestaurants);
  } catch (err) {
    console.log("Get Top Rated Restaurants Error:", err);
    res.status(500).json({ message: err.message });
  }
};

/** 🔹 Get Top Rated Restaurants Nearby */
exports.getTopRatedNearbyRestaurants = async (req, res) => {
  const { latitude, longitude } = req.query;

  if (!latitude || !longitude) {
    return res.status(400).json({ message: "Latitude and longitude are required." });
  }

  try {
    const radius = 10; // km

    const topRatedNearbyRestaurants = await sequelize.query(
      `
      SELECT * FROM (
        SELECT *,
          ( 6371 * acos(
            cos(radians(:latitude))
            * cos(radians(latitude))
            * cos(radians(longitude) - radians(:longitude))
            + sin(radians(:latitude))
            * sin(radians(latitude))
          )) AS distance
        FROM restaurants
      ) AS subquery
      WHERE distance <= :radius
      ORDER BY rating DESC, distance ASC;
      `,
      {
        replacements: { latitude, longitude, radius },
        type: QueryTypes.SELECT
      }
    );

    res.json(topRatedNearbyRestaurants);
  } catch (err) {
    console.log("Get Top Rated Nearby Restaurants Error:", err);
    res.status(500).json({ message: err.message });
  }
};



/** 🔹 Get Nearby Restaurants within 10 km */
exports.getNearbyRestaurants = async (req, res) => {
  console.log("Request Query:", req.query); 
  const { latitude, longitude } = req.query;

  if (!latitude || !longitude) {
    return res.status(400).json({ message: "Latitude and longitude are required." });
  }

  try {
    const radius = 300; // km

    const nearbyRestaurants = await sequelize.query(
  `
  SELECT * FROM (
    SELECT *,
      ( 6371 * acos(
        cos(radians(:latitude))
        * cos(radians(latitude))
        * cos(radians(longitude) - radians(:longitude))
        + sin(radians(:latitude))
        * sin(radians(latitude))
      )) AS distance
    FROM restaurants
  ) AS subquery
  WHERE distance <= :radius
  ORDER BY distance ASC;
  `,
  {
    replacements: { latitude, longitude, radius },
    type: QueryTypes.SELECT
  }
);

    res.json(nearbyRestaurants);
  } catch (err) {
    console.log("Get Nearby Restaurants Error:", err);
    res.status(500).json({ message: err.message });
  }
};


exports.createRestaurant = async (req, res) => {
  const {
    name,
    email,
    password,
    phone,
    address,
    city,
    state,
    pincode,
    cuisine_type,
    opening_hours,
    status,
    profile_image,
    rating,
    wallet_balance,
    description,
    gstin,
    delivery_fee,
    latitude,
    longitude,
    delivery,
    dine_in,
    takeaway,
    table_count
  } = req.body;

  try {
      const existing = await Restaurant.findOne({ where: { email } });
    if (existing) return res.status(400).json({ message: "Email already in use" });

    const hashedPassword = await bcrypt.hash(password, 10);
    if (dine_in && (!table_count || table_count < 1)) {
      return res.status(400).json({ message: "Please provide a valid table count for dine-in" });
    }

    const restaurant = await Restaurant.create({
      name,
      email,
      password: hashedPassword,
      phone,
      address,
      city,
      state,
      pincode,
      cuisine_type,
      opening_hours,
      status,
      profile_image,
      rating,
      wallet_balance,
      description,
      gstin,
      delivery_fee,
      latitude,
      longitude,
      delivery,
      dine_in,
      takeaway,
      table_count: dine_in ? table_count : null // set table_count only if dine_in is true
    });

    res.status(201).json({ restaurant, message: "Restaurant created successfully" });
  } catch (err) {
    console.log("Create Restaurant Error:", err);
    res.status(500).json({ message: err.message });
  }
};

// ✅ Read All Restaurants
exports.getAllRestaurants = async (req, res) => {
  try {
    const restaurants = await Restaurant.findAll();
    res.json(restaurants);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

// ✅ Read Restaurant by ID
exports.getRestaurantById = async (req, res) => {
  const { id } = req.params;
  try {
    const restaurant = await Restaurant.findByPk(id);
    if (!restaurant) {
      return res.status(404).json({ message: 'Restaurant not found' });
    }
    res.json(restaurant);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

// ✅ Update Restaurant
exports.updateRestaurant = async (req, res) => {
  const { id } = req.params;
  const updateData = req.body;

  try {
    const restaurant = await Restaurant.findByPk(id);
    if (!restaurant) {
      return res.status(404).json({ message: 'Restaurant not found' });
    }
    await restaurant.update(updateData);
    res.json(restaurant);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

// ✅ Delete Restaurant
exports.deleteRestaurant = async (req, res) => {
  const { id } = req.params;
  try {
    const restaurant = await Restaurant.findByPk(id);
    if (!restaurant) {
      return res.status(404).json({ message: 'Restaurant not found' });
    }
    await restaurant.destroy();
    res.json({ message: 'Restaurant deleted' });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};



/** ✅ Restaurant Signup */
exports.signup = async (req, res) => {
  const {
    name, email, password, phone, address, city, state, pincode,
    cuisine_type, opening_hours, profile_image, gstin, delivery_fee,
    latitude, longitude, description
  } = req.body;

  try {
    const existing = await Restaurant.findOne({ where: { email } });
    if (existing) return res.status(400).json({ message: "Email already in use" });

    const hashedPassword = await bcrypt.hash(password, 10);

    const restaurant = await Restaurant.create({
      name,
      email,
      password: hashedPassword,
      phone,
      address,
      city,
      state,
      pincode,
      cuisine_type,
      opening_hours,
      profile_image,
      gstin,
      delivery_fee,
      latitude,
      longitude,
      description,
      status: 'Active'
    });

    const token = jwt.sign({ id: restaurant.id }, process.env.JWT_SECRET, { expiresIn: '1h' });

    res.status(201).json({ token, restaurant, message: "Restaurant registered successfully" });
  } catch (err) {
    console.log("Restaurant Signup Error:", err);
    res.status(500).json({ message: err.message });
  }
};

/** ✅ Restaurant Login */
exports.login = async (req, res) => {
  const { email, password } = req.body;
  try {
    const restaurant = await Restaurant.findOne({ where: { email } });
    if (!restaurant) return res.status(401).json({ message: "Invalid credentials" });

    const isMatch = await bcrypt.compare(password, restaurant.password);
    if (!isMatch) return res.status(401).json({ message: "Invalid credentials" });

    const token = jwt.sign({ id: restaurant.id }, process.env.JWT_SECRET, { expiresIn: '1h' });

    res.json({ token, restaurant, message: "Login successful" });
  } catch (err) {
    console.log("Restaurant Login Error:", err);
    res.status(500).json({ message: err.message });
  }
};

exports.getAllFoodsForMenu = async (req, res) => {
  const { id } = req.params;

  try {
    const restaurant = await Restaurant.findByPk(id);
    if (!restaurant) {
      return res.status(404).json({ message: "Restaurant not found" });
    }
    const foods = await Food.findAll({
      where: { restaurantId: id }
    });

    res.json({
      restaurant: restaurant,
      menu: foods
    });
  } catch (err) {
    console.log("Get All Foods For Menu Error:", err);
    res.status(500).json({ message: err.message });
  }
};
