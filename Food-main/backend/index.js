const express = require('express');
const cors = require('cors');
const sequelize = require('./db');
const Food = require('./models/foodModel');
const foodRoutes = require('./routes/foodRoutes'); // ✅ Import your food routes
const restaurantRoutes = require('./routes/restaurantRoutes');
const userRoutes = require('./routes/userRoutes');



require('dotenv').config();

const app = express();
app.use(cors());
app.use(express.json());

// ✅ Use food routes
app.use('/api/foods', foodRoutes);
app.use('/api/restaurants', restaurantRoutes);
app.use('/api/users', userRoutes);


const authRoutes = require('./routes/authRoutes');
app.use('/api/auth', authRoutes);

const superAdminRoutes = require('./routes/superAdminRoutes');
app.use('/api/superadmins', superAdminRoutes);

const addressRoutes = require('./routes/addressRoutes');
app.use('/api/addresses', addressRoutes);

const orderRoutes =require('./routes/orderRoutes');
app.use('/api/order',orderRoutes);
const cartRoutes = require('./routes/cartRoutes');
app.use('/api/carts', cartRoutes);

const wishlistRoutes = require('./routes/wishlistRoutes');
app.use('/api/wish', wishlistRoutes);

const reviewRoutes = require('./routes/reviewRoutes');
app.use('/api/reviews', reviewRoutes);

const restaurantInsightsRoutes = require('./routes/restaurantInsightsRoutes');
app.use('/api/insights', restaurantInsightsRoutes);
const customerRoutes =require('./routes/customerRoutes');
app.use('/api/customers',customerRoutes);

const tableRoutes =require('./routes/tableRoutes');
app.use('/api/tables',tableRoutes);

const reservationRoutes =require('./routes/reservationRoutes');
app.use('/api/reservation',reservationRoutes);

// const Food = require('./foodModel');
const Review = require('./models/Review');


Food.hasMany(Review, { foreignKey: 'foodId' });
Review.belongsTo(Food, { foreignKey: 'foodId' });

module.exports = {
  Food,
  Review,
  sequelize
};

const PORT = process.env.PORT || 3001;

// ✅ Test DB connection and sync models
sequelize.authenticate({ alter: true })
  .then(() => console.log('Database connected.'))
  .then(() => sequelize.sync()) // Auto creates table if not exist
  .then(() => console.log('Models synced.'))
  .catch(err => console.log('Error: ' + err));

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
