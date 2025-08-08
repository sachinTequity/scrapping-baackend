const express = require("express");
const cors = require("cors");
const path = require("path");

const app = express();
const PORT = 3000;


app.use(express.json());
app.use("/public", express.static(path.join(__dirname, "public")));

// Import routes
const frontendRoutes = require("./routes/frontend");
const backendRoutes = require("./routes/backend");
const qaRoutes = require("./routes/qa");



// Mount routes
app.use("/", frontendRoutes);    // → /trending-cards
app.use("/", backendRoutes);     // → /nike/shoes
app.use("/", qaRoutes);          // → /layout-check


app.listen(PORT, () => {
  console.log(`🚀 Server running on http://localhost:${PORT}`);
});
