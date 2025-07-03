const express = require("express");
const router = express.Router();
const { pool } = require("../db");

// GET all products
router.get("/", async (req, res) => {
  try {
    const result = await pool.request().query("SELECT * FROM PRODUCTS");
    res.json(result.recordset);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});
router.get("/:id", async (req, res) => {
  const { id } = req.params;
  try {
    const result = await pool
      .request()
      .input("id", id)
      .query("SELECT * FROM PRODUCTS WHERE PRODUCTID = @id");

    if (result.recordset.length === 0) {
      return res.status(404).json({ error: "Product not found" });
    }

    res.json(result.recordset[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// POST /api/products - Add new product
router.post("/", async (req, res) => {
  const { PRODUCTNAME, PRICE, STOCK } = req.body;

  // Validate input
  if (!PRODUCTNAME || PRICE <= 0 || STOCK < 0) {
    return res.status(400).json({ error: "Invalid input" });
  }

  try {
    const result = await pool
      .request()
      .input("PRODUCTNAME", PRODUCTNAME)
      .input("PRICE", PRICE)
      .input("STOCK", STOCK)
      .query(
        "INSERT INTO PRODUCTS (PRODUCTNAME, PRICE, STOCK) VALUES (@PRODUCTNAME, @PRICE, @STOCK)"
      );

    res.status(201).json({ message: "Product created" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// PUT /api/products/:id - Update a product
router.put("/:id", async (req, res) => {
  const { id } = req.params;
  const { PRODUCTNAME, PRICE, STOCK } = req.body;

  // Validate input
  if (!PRODUCTNAME || PRICE <= 0 || STOCK < 0) {
    return res.status(400).json({ error: "Invalid input" });
  }

  try {
    const result = await pool
      .request()
      .input("id", id)
      .input("PRODUCTNAME", PRODUCTNAME)
      .input("PRICE", PRICE)
      .input("STOCK", STOCK)
      .query(`
        UPDATE PRODUCTS
        SET PRODUCTNAME = @PRODUCTNAME, PRICE = @PRICE, STOCK = @STOCK
        WHERE PRODUCTID = @id
      `);

    // Check if any row was affected
    if (result.rowsAffected[0] === 0) {
      return res.status(404).json({ error: "Product not found" });
    }

    res.json({ message: "Product updated" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// DELETE /api/products/:id - Delete a product
router.delete("/:id", async (req, res) => {
  const { id } = req.params;

  try {
    const result = await pool
      .request()
      .input("id", id)
      .query("DELETE FROM PRODUCTS WHERE PRODUCTID = @id");

    // Check if any row was affected
    if (result.rowsAffected[0] === 0) {
      return res.status(404).json({ error: "Product not found" });
    }

    res.json({ message: "Product deleted" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});




module.exports = router;







