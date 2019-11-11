var bCrypt = require('bcrypt-nodejs');
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
        console.log("antes de hash: "+newpass);
        var generateHash =  bCrypt.hashSync(newpass, bCrypt.genSaltSync(8), null);
        console.log("Contraseña: "+generateHash);
        return new Promise((resolve, reject) => {
            conexion.query(`UPDATE users SET password= ? WHERE email = ? `,
                [generateHash, mail], 
                    (err) => {
                        if (err) {
                            console.log("Hubo un error desde aquí");
                            reject(err);
                        }
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
    obtenerKioskos(){
        return new Promise((resolve, reject) => {
            conexion.query(`SELECT * FROM kiosko`,
                (err, resultados) => {
                    if (err) reject(err);
                    else resolve(resultados);
                });
        });
    },
    editarKioskos(user, street, suburb, attendantName, zipcode, attendantSecondName, pass, email, otheremail){
        return new Promise((resolve, reject) => {
            conexion.query(`UPDATE kiosko SET 
                street=?,
                suburb=?,
                attendantName=?,
                zipcode=?,
                attendantSecondName=?,
                pass=?,
                email=?,
                otheremail=? 
                WHERE user=?`,
                [street, suburb, attendantName, zipcode, attendantSecondName, pass, email, otheremail, user],
                (err) => {
                    if (err) reject(err);
                    else resolve();
                });
        });
    },
    insertarKiosko(user, street, suburb, attendantName, zipcode, attendantSecondName, email, otheremail){
        return new Promise((resolve, reject) => {
            conexion.query(`INSERT INTO kiosko
                (user, street, suburb, attendantName, zipcode, attendantSecondName, email, otheremail) 
                VALUES (?,?,?,?,?,?,?,?)`,
                [user, street, suburb, attendantName, zipcode, attendantSecondName, email, otheremail], (err, resultados) => {
                    if (err) reject(err);
                    else resolve(resultados.insertId);
                });
        });
    },
    eliminarKiosko(id){
        return new Promise((resolve, reject) => {
            conexion.query(`update kiosko
            set status = false
            where user = ?`,
                [id],
                (err) => {
                    if (err) reject(err);
                    else resolve();
                });
        });
    },
    obtenerKioskoPorId(id) {
        return new Promise((resolve, reject) => {
            conexion.query(`select * from kiosko where user = ?`,
                [id],
                (err, resultados) => {
                    console.log({resultados});
                    if (err) reject(err);
                    else resolve(resultados[0]);
                });
        });
    },
    preRegistro(mac, prod){
        return new Promise((resolve, reject) => {
            conexion.query(`INSERT INTO shop( idProduct,mac) VALUES (?, ?)`,
                [prod, mac], (err, resultados) => {
                    if (err) reject(err);
                    else resolve(resultados.insertId);
                });
        });
    },
    mimac(id){
        return new Promise((resolve, reject) => {
            conexion.query(`select idUser from shop where mac = ?`,
                [id],
                (err, resultados) => {
                    console.log({resultados});
                    if (err) reject(err);
                    else resolve(resultados[0]);
                });
        });
    },
    registro(id,mac){
        return new Promise((resolve, reject) => {
            conexion.query(`UPDATE shop SET idUser=? where mac=?`,
                [id, mac], (err, resultados) => {
                    if (err) reject(err);
                    else resolve(resultados.insertId);
                });
        });
    },
    carritode(id){
        return new Promise((resolve, reject) => {
            conexion.query(`select * from carrito where idUser = ?`,
                [id],
                (err, resultados) => {
                    if (err) reject(err);
                    else resolve(resultados);
                });
        });
    },
    agregaAlCarrito(prod, us){
        return new Promise((resolve, reject) => {
            conexion.query(`INSERT INTO shop( idProduct,idUser) VALUES (?, ?)`,
                [prod, us], (err, resultados) => {
                    if (err) reject(err);
                    else resolve(resultados.insertId);
                });
        });
    }
  }