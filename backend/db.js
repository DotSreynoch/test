const sql = require("mssql");
require("dotenv").config();

const config = {
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  server: process.env.DB_SERVER,
  database: process.env.DB_DATABASE,
  options: {
    encrypt: false,
    trustServerCertificate: true,
  },
};

// Create a single connection pool to reuse
const pool = new sql.ConnectionPool(config);
const connectionPromise = pool.connect();

module.exports = {
  sql,
  pool,
  connectionPromise,
};
