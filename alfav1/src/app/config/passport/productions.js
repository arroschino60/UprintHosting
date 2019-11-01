const conexion = require("./connection.js");
module.exports = {
    obtenerProd(){
        return new Promise((resolve, reject) => {
            conexion.query(`SELECT * FROM productos`,
                (err, resultados) => {
                    if (err) reject(err);
                    else resolve(resultados);
                });
        });
    },
    
    obtenerPorId(id) {
        return new Promise((resolve, reject) => {
            conexion.query(`select * from productos where idProduct = ?`,
                [id],
                (err, resultados) => {
                    console.log({resultados});
                    if (err) reject(err);
                    else resolve(resultados[0]);
                });
        });
    },
  }