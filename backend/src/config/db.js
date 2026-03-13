const mongoose = require("mongoose");

const connectDB = async () => {
  const mongoUri = process.env.MONGO_URI;
  const hasValidMongoUri =
    typeof mongoUri === "string" &&
    (mongoUri.startsWith("mongodb://") ||
      mongoUri.startsWith("mongodb+srv://"));
  if (!hasValidMongoUri) {
    console.log("MongoDB disabled: MONGO_URI not set");
    return false;
  }
  try {
    const conn = await mongoose.connect(mongoUri);
    console.log(`MongoDB Connected: ${conn.connection.host}`);
    return true;
  } catch (error) {
    console.error(`Error: ${error.message}`);
    return false;
  }
};

module.exports = connectDB;
