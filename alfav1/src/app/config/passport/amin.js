const conexion = require("./connection.js");
module.exports = {
    obtenerUnidades() {
        return new Promise((resolve, reject) => {
            conexion.query(`select * from ventas LIMIT 50`,
                (err, resultados) => {
                    if (err) reject(err);
                    else resolve(resultados);
                });
        });
      },
      obtenerVentas(limit1, limit2) {
        return new Promise((resolve, reject) => {
            conexion.query(`select * from ventas WHERE fecha BETWEEN ? AND ? `,
                [limit1, limit2],
                (err, resultados) => {
                    if (err) reject(err);
                    else resolve(resultados);
                });
        });
      },
    cambiarStatus(id, art, status) {
        return new Promise((resolve, reject) => {
            conexion.query(`UPDATE orders SET statusOrder= ? WHERE idSelling = ? AND idArticle = ? `,
                [status, id, art], 
                    (err) => {
                        if (err) reject(err);
                        else resolve();
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