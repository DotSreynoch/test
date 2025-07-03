const express = require("express");
const cors = require("cors");
const dotenv = require("dotenv");
const { connectionPromise } = require("./db"); 
const router = require("./routes/product");

dotenv.config();

const app = express();
app.use(cors());
app.use(express.json());
app.use("/api/products", router);

const PORT = process.env.PORT || 3000;

connectionPromise.then(() => {
  app.listen(PORT, () =>
    console.log(`Server running at http://localhost:${PORT}`)
  );
}).catch((err) => {
  console.error("DB Connection failed:", err.message);
  process.exit(1);
});
