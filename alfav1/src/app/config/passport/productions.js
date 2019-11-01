const conexion = require("./connection.js");
module.exports = {
    obtenerUnidades() {
      return new Promise((resolve, reject) => {
          conexion.query(`select * from PRODUCCION`,
              (err, resultados) => {
                  if (err) reject(err);
                  else resolve(resultados);
              });
      });
    },
    cambiarStatus(id, art, status) {
        return new Promise((resolve, reject) => {
            conexion.query(`UPDATE orders SET statusOrder= ? WHERE idSelling = ? AND idArticle = ? `,
                [id,art, status], 
                    (err) => {
                        if (err) reject(err);
                        else resolve();
                });
        });
    },
    obtenerProd(){
        return new Promise((resolve, reject) => {
            conexion.query(`SELECT * FROM productos`,
                (err, resultados) => {
                    if (err) reject(err);
                    else resolve(resultados);
                });
        });
    },
    insertarProducto(nombre, precio, tiempo, min, max, categoria, validatedCustomFile, dimen, comment, exist) {
        return new Promise((resolve, reject) => {
            conexion.query(`INSERT INTO products 
            ( nameProduct, imageProduct, featuresProduct, idCategory,idDimension, max, min, time, price, enableProduct) 
            VALUES 
            ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
                [nombre, validatedCustomFile, comment, categoria, dimen, max, min, tiempo, precio, exist], (err, resultados) => {
                    if (err) reject(err);
                    else resolve(resultados.insertId);
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
    actualizar(id, nombre, precio, tiempo, min, max, categoria, validatedCustomFile, dimen, comment, exist) {
        return new Promise((resolve, reject) => {
            conexion.query(`update products
            set nameProduct = ?, 
            imageProduct = ?, 
            featuresProduct = ?, 
            idCategory = ?,
            idDimension = ?, 
            max = ?, 
            min = ?, 
            time = ?, 
            price = ?,
            enableProduct = ?
            where idProduct = ?`,
                [nombre, validatedCustomFile, comment, categoria, dimen, max, min, tiempo, precio, exist, id],
                (err) => {
                    if (err) reject(err);
                    else resolve();
                });
        });
    },
    eliminar(id) {
        return new Promise((resolve, reject) => {
            conexion.query(`update products
            set statusProduct = false
            where idProduct = ?`,
                [id],
                (err) => {
                    if (err) reject(err);
                    else resolve();
                });
        });
    },
  }