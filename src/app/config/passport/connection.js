const mysql = require("mysql");
// Coloca aquí tus credenciales
module.exports = mysql.createPool({
  host: "www.db4free.net",
  user: "uprintuser",
  password: "qwertyuiop",
  database: "uprint"
});
