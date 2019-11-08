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
    reestablecerContrasena(mail,newpass) {
        return new Promise((resolve, reject) => {
            conexion.query(`UPDATE users SET password= ? WHERE email = ? `,
                [generateHash(newpass), mail], 
                    (err) => {
                        if (err) reject(err);
                        else resolve();
                });
        });
    },
    
    existes(id) {
        return new Promise((resolve, reject) => {
            conexion.query(`select email FROM users where email = ?`,
                [id],
                (err, resultados) => {
                    console.log({resultados});
                    if (err) reject(err);
                    else resolve(resultados[0]);
                });
        });
    },
  }