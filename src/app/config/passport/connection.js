const mysql = require("mysql");
// Coloca aquí tus credenciales
module.exports = mysql.createPool({
  host: "us-cdbr-iron-east-05.cleardb.net",
  user: "b0db61a76cd7a3",
  password: "678596d5",
  database: "heroku_1a2a8fb0b1eda80"
});
