var authController = require('../controllers/authcontroller.js');
const productosModel = require("../config/passport/productions.js");
const admModel = require("../config/passport/amin.js");
const nodemailer = require('nodemailer');
var fs = require("fs"); 
const { check, validationResult } = require('express-validator');


module.exports = function(app,passport){

// index routes
	app.get('/pasaber', (req, res) => {
		res.render('logo');
    });

    app.get('/personalizar', (req, res) => {
		res.render('personalizar', {
            user: req.user
        });
    });
    app.get('/', (req, res) => {
		res.render('logoCopy');
	});
    //Para obtener productos para el catálogo
    app.get('/pasaber', (req, res) => {
		res.render('logoCopy');
	});
	app.get('/productos', (req, res) => {
        productosModel
		.obtenerProd()
		.then(productos => {
			res.render("productos", {
                productos: productos,
                user: req.user,
			});
		})
		.catch(err => {
			return res.status(500).send("Error obteniendo productos");
		});
        //res.render('productos');
	});

	app.get('/tc', (req, res) => {
		res.render('tc', {
            user: req.user,
        });
	});

    app.get('/tc2', (req, res) => {
		res.render('tc2', {
            user: req.user,
        });
	});

    app.get('/editor/:id', (req, res) => {
        productosModel
        .obtenerPorId(req.params.id)
        .then(producto => {
            if (producto) {
                console.log({ producto });
                res.render("editor", {
                    producto: producto,
                    user : req.user,
                });
            } else {
                return res.status(500).send("No existe producto con ese id");
            }
        })
        .catch(err => {
            return res.status(500).send("Error obteniendo producto");
        });
	});
        
    app.get('/contacto', (req, res) => {
		res.render('contacto', {
            user: req.user
        });
    });

    app.get('/kioskomod', (req, res) => {
		res.render('index77');
	});
    
    //Funciones para la administración  de kioskos
    app.get('/kiosko',isLoggedIn, (req, res) => {
        productosModel
        .obtenerKioskos()
        .then(producto => {
            if (producto) {
                res.render("index66", {
                    producto: producto,
                    user : req.user,
                });
            } 
        })
        .catch(err => {
            return res.status(500).send("Error obteniendo Kioskos");
        });
        //res.render('index66');
        
    });

    /*app.get('/comprar', (req, res) => {
		res.render('dashboard', {
            user: req.user
        });
    });*/

    app.post('/comprar/:id', (req, res) => {
        productosModel
        .obtenerPorId(req.params.id)
        .then(producto => {
            if (producto) {
                console.log({ producto });
                res.render("index3", {
                    producto: producto,
                    user : req.user,
                });
            } else {
                return res.status(500).send("No existe producto con ese id");
            }
        })
        .catch(err => {
            return res.status(500).send("Error obteniendo producto");
        });
	});

     app.get('/carrito',isLoggedIn, (req, res) => {
        //revisar si hay mac sin usuario
        require('getmac').getMac(function(err, macAddress){
            if (err){  throw err }
            else{
                var uss;
                if(req.user){
                    uss = req.user.id;
                }else{
                    uss = 0;
                }
                productosModel
                .mimac(macAddress, uss)
                .then(producto => {
                    //SI HAY USUARIO
                    if (producto) {
                        //consulta de lo que hay en el carrito
                        productosModel
                        .carritode(req.user.id)
                        .then(micarrito => {
                            var suma= 0;
                            for(var i=0; i< micarrito.length; i++){
                                suma= suma + micarrito[i].priceProduct;
                            }
                            console.log("La suma de lo del carrito es: "+suma);
                            res.render("index33", {
                                micarrito: micarrito,
                                user: req.user,
                                suma: suma,
                            });
                        })
                        .catch(err => {
                            return res.status(500).send("Error obteniendo productos");
                        });
                    }
                    //SI NO HAY USUARIO
                    else {
                        //SE AGREGA AL USUARIO
                        productosModel
                        .registro(req.user.id, macAddress)
                        .then(idProductoInsertado => {
                            productosModel
                        .carritode(req.user.id)
                        .then(micarrito => {
                            var suma= 0;
                            for(var i=0; i< micarrito.length; i++){
                                suma= suma + micarrito[i].priceProduct;
                            }
                            console.log("La suma de lo del carrito es: "+suma);
                            res.render("index33", {
                                micarrito: micarrito,
                                user: req.user,
                                suma: suma,
                            });
                        })
                        .catch(err => {
                            return res.status(500).send("Error obteniendo productos");
                        });
                        })
                        .catch(err => {
                            return res.status(500).send(err);
                        });
                    }
                })
                .catch(err => {
                    console.log(err);
                    res.redirect("/productos");
                });
            }
        })
	});
    
    app.get('/pago', (req, res) => {
		res.render('index333', {
            user: req.user
        });
	});

    
	//app.get('/login', (req, res) => {
	//	res.render('login.ejs');
	//});
	//login view
	//app.get('/login', (req, res) => {
	//	res.render('login.ejs', {
	//		message: req.flash('loginMessage')
	//	});
	//});
    
//profile view
app.get('/dashboard', isLoggedIn, (req, res) => {
    res.render('dashboard', {
        user: req.user
    });
});

//Llama a la interfaz de signuo
app.get('/signup', authController.signup);

//llama a la interfaz del login
app.get('/signin', authController.signin);

//Funcion para guardar la mac
app.post('/preregistro/:id',function(req, res) {
    if(req.user){
        productosModel
        .agregaAlCarrito(req.params.id, req.user.id)
        .then(idProductoInsertado => {
            res.redirect("/carrito");
        })
        .catch(err => {
            res.redirect("/carrito");
        });
    }else{
    // successful auth, user is set at req.user.  redirect as necessary.
    require('getmac').getMac(function(err, macAddress){
        if (err){  throw err }
        else{ 
            console.log(macAddress);
            productosModel
            .preRegistro(macAddress,req.params.id)
            .then(() => {
                res.redirect('/signin');
            })
            .catch(err => {
                return res.status(500).send(err);
            });
        }
        })
    }
});

//Funcion para registrarse
app.post('/signup', 
	passport.authenticate('local-signup',  { //successRedirect: '/dashboard',
    failureRedirect: '/signup'}
), function(req, res) {
    // successful auth, user is set at req.user.  redirect as necessary.
    if (req.user.username == "Adm1n") { return res.redirect('/dashboard'); }
    res.redirect('/carrito');
    }
);

//Ejemplo de cómo poner que debe estar loggeado
app.get('/dashboard',isLoggedIn, authController.dashboard);

//Función para desloggearse
app.get('/logout',authController.logout);

app.get('/salir',function (req, res) {
    admModel
    .eliminarCarrito(req.user.id)
    .then(() => {
            res.redirect('/logout');
    })
    .catch(err => {
        return res.status(500).send(err);
    });
    }
);

//Funcion para autenticarse
app.post('/signin', passport.authenticate('local-signin',  { 
    
    //successRedirect: '/dashboard',	
    failureRedirect: '/signin'
}), function(req, res) {
    console.log(req.user);
    // successful auth, user is set at req.user.  redirect as necessary.
    if (req.user.username == "Adm1n") { return res.redirect('/dashboard'); }
    res.redirect('/carrito');
    }
);

//Función para recuperar información de pedidos
app.get('/pro', isLoggedIn, function (req, res, next) {
    if (req.user.username == "Adm1n") { 
    admModel
		.obtenerUnidades()
		.then(productos => {
			res.render("production", {
                productos: productos,
                user: req.user,
			});
		})
		.catch(err => {
			return res.status(500).send("Error obteniendo productos");
        });
    }else{
        res.redirect('/');
    }
});

app.get('/pro2', isLoggedIn, function (req, res, next) {
    console.log(req.user);
    if (req.user.username = "Adm1n") { 
    admModel
		.obtenerUnidades()
		.then(productos => {
			res.render("productioncopy", {
                productos: productos,
                user : req.user,
			});
		})
		.catch(err => {
			return res.status(500).send("Error obteniendo productos");
        });
    }else{
        res.redirect('/');
        }
});

//Función para obtener productos
app.get('/prodd', isLoggedIn, function (req, res, next) {
    if (req.user.username == "Adm1n") { 
    productosModel
		.obtenerProd()
		.then(productos => {
			res.render("index6", {
                productos: productos,
                user : req.user,
			});
		})
		.catch(err => {
			return res.status(500).send("Error obteniendo productos");
        });
    }else{
        res.redirect('/');
        }
});

app.get('/prodd2', isLoggedIn, function (req, res, next) {
    if (req.user.username == "Adm1n") { 
    productosModel
		.obtenerProd()
		.then(productos => {
			res.render("index6copy", {
                productos: productos,
                user : req.user,
			});
		})
		.catch(err => {
			return res.status(500).send("Error obteniendo productos");
        });
    }else{
        res.redirect('/');
    }

});

//Función para obtener las ventas en un periodo de tiempo
app.post('/proselect',isLoggedIn, function (req, res, next) {
    const {
        fechafin,
        fechaini
      } = req.body;
	admModel
		.obtenerVentas(fechaini, fechafin)
		.then(productos => {
			res.render("production", {
                productos: productos,
                user : req.user,
			});
		})
		.catch(err => {
			return res.status(500).send(err);
		});

});

//Función para cambiar el status de los pedidos
app.post('/cambStatus/:id/:idos',isLoggedIn, function(req, res, next){
    const { exampleFormControlSelect1 } = req.body;
    console.log(req.params.idos);
    console.log(req.params.id);
    console.log(exampleFormControlSelect1);
    admModel
    .cambiarStatus(req.params.idos, req.params.id, exampleFormControlSelect1)
    .then(() => {
        res.redirect("/pro");
    })
    .catch(err => {
        return res.status(500).send(err);
    });
});


//Función para insertar productos

app.post('/insertar', [
    check('nombre', 'Se debe ingresar nombre del producto').not().isEmpty(),
check('precio', 'Se debe ingresar un precio').not().isEmpty(),
check('precio', 'El precio debe ser numerico').isNumeric(),
check('tiempo', 'Se debe ingresar un tiempo de entrega').not().isEmpty(),
check('tiempo', 'El tiempo debe ser numerico').isNumeric(),
//check('file', 'Se debe elegir una imagen para el producto').not().isEmpty(),
check('min', 'Se debe ingresar un minimo de venta').not().isEmpty(),
check('max', 'Se debe ingresar un maximo de venta').not().isEmpty(),
check('categoria', 'Se debe ingresar una categoria').not().isEmpty(),
check('dimen', 'Se debe ingresar una dimension').not().isEmpty(),
check('comment', 'Se debe ingresar un comentario').not().isEmpty()

  ], isLoggedIn,
  function (req, res) {
    const errors = validationResult(req);
    var malo = errors.errors;
    console.log(req.body);

    if (!errors.isEmpty()) {
        console.log(errors);
        res.render('errores', {
            malo: errors
          })
    } else {
      // Si todo va bien, seguimos
    //saca la extención de la imagén
    var extension = req.files.file.name.split(".").pop();
    //Aquí se le asigna dirección y nombre
    var newPath =  "./src/public/img/"+req.files.file.name;
    var oldPath = req.files.file.path;
    console.log(newPath);
    //Se cambia el archivo de carpeta
    fs.rename(oldPath, newPath, function (err) {
        if (err) throw err
        console.log('Successfully renamed - AKA moved!')
    })
    //se hacen los cambios
    const {file, id, nombre, precio, tiempo, min, max, categoria, imagen, dimen, comment, exist } = req.body;
    admModel
        .insertarProducto(nombre, precio, tiempo, min, max, categoria, req.files.file.name, dimen, comment, exist)
        .then(idProductoInsertado => {
            res.redirect("/prodd");
        })
        .catch(err => {
            return res.status(500).send(err);
        });
    }
  });

app.post('/insertarKiosko', function (req, res, next) {
    const { nombre, encargado, snencargado, inputAddress, inputAddress2, inputZip, inputEmail4, inputEmail2} = req.body;
    // Si todo va bien, seguimos
    //se hacen los cambios
   productosModel
        .insertarKiosko(nombre, inputAddress, inputAddress2, encargado, inputZip, snencargado, inputEmail4, inputEmail2  )
        .then(idProductoInsertado => {
            res.redirect("/kiosko");
        })
        .catch(err => {
          return res.status(500).send(err);
        });
});

app.get('/editarKiosko/:id',isLoggedIn, function (req, res, next) {
    productosModel
        .obtenerKioskoPorId(req.params.id)
        .then(producto => {
            if (producto) {
                console.log({ producto });
                res.render("index77", {
                    producto: producto,
                    user : req.user,
                });
            } else {
                return res.status(500).send("No existe kiosko con ese id");
            }
        })
        .catch(err => {
            return res.status(500).send("Error obteniendo kiosko");
        });
});

app.post('/actualizarKiosko',
      function (req, res) {
        const { nombre, encargado, snencargado, inputAddress, inputAddress2, inputZip, inputEmail4, inputEmail2} = req.body;
        //se hacen los cambios
        productosModel
        .editarKioskos(nombre, inputAddress, inputAddress2, encargado, inputZip, snencargado,"00", inputEmail4, inputEmail2 )
        .then(() => {
            res.redirect("/kiosko");
        })
        .catch(err => {
            return res.status(500).send(err);
        });
        }
      );

//Función para buscar producto por id
	
app.get('/editar/:id',isLoggedIn, function (req, res, next) {
    productosModel
        .obtenerPorId(req.params.id)
        .then(producto => {
            if (producto) {
                console.log({ producto });
                res.render("index7", {
                    producto: producto,
                    user : req.user,
                });
            } else {
                return res.status(500).send("No existe producto con ese id");
            }
        })
        .catch(err => {
            return res.status(500).send("Error obteniendo producto");
        });
});

app.post('/actualiza',isLoggedIn, (req, res) => {
    passport.query('UPDATE `users` SET `password`='+req.body.newpass+ 'WHERE email =' + req.body.campo1,
      (err, result) => {
        res.redirect('logo');
      });
  });

//Función para modificar 
app.post('/actualizar', [
    check('nombre', 'Se debe ingresar nombre del producto').not().isEmpty(),
    check('precio', 'Se debe ingresar un precio').not().isEmpty(),
    check('precio', 'El precio debe ser numerico').isNumeric(),
    check('tiempo', 'Se debe ingresar un tiempo de entrega').not().isEmpty(),
    check('tiempo', 'El tiempo debe ser numerico').isNumeric(),
    check('min', 'Se debe ingresar un minimo de venta').not().isEmpty(),
    check('max', 'Se debe ingresar un maximo de venta').not().isEmpty(),
    //check('categoria', 'Se debe ingresar una categoria').not().isEmpty(),
    check('dimen', 'Se debe ingresar una dimension').not().isEmpty(),
    check('comment', 'Se debe ingresar un comentario').not().isEmpty()
    
      ], isLoggedIn,
      function (req, res) {
        const errors = validationResult(req);
        console.log(req.body);
        const {file, id, nombre, precio, tiempo, min, max, categoria, imagen, dimen, comment, exist } = req.body;
        if (!errors.isEmpty()) {
        console.log(errors)
        return res.status(422).jsonp(errors.array());
          //codigo cuando hay errores
        } else {
         //codigo cuando no hay errores
          //Si se cambió la imagen
        //saca la extensión de la imagén
        var extension = req.files.file.name.split(".").pop();
        //Aquí se le asigna dirección y nombre
        var newPath =  "./src/public/img/product"+id+"."+extension;
        var oldPath = req.files.file.path;
        console.log(newPath);
        //Se cambia el archivo de carpeta
        fs.rename(oldPath, newPath, function (err) {
            if (err) throw err
            console.log('Successfully renamed - AKA moved!')
        })
        //se hacen los cambios
        
        admModel
        .actualizar(id, nombre, precio, tiempo, min, max, categoria, "product"+id+"."+extension , dimen, comment, exist)
        .then(() => {
            res.redirect("/prodd");
        })
        .catch(err => {
            return res.status(500).send(err);
        });
        }
      });
//Función para eliminar producto
app.get('/eliminar/:id',isLoggedIn, function (req, res, next) {
    admModel
        .eliminar(req.params.id)
        .then(() => {
            res.redirect("/prodd");
        })
        .catch(err => {
            return res.status(500).send(err);
        });
});

//Función para eliminar kiosko
app.get('/eliminarKiosko/:id',isLoggedIn, function (req, res, next) {
    productosModel
        .eliminarKiosko(req.params.id)
        .then(() => {
            res.redirect("/kiosko");
        })
        .catch(err => {
            return res.status(500).send(err);
        });
});

app.get('/reccont', (req, res) => {
    res.render('Reestablecer', {
      //news: result
    });
  });

  app.get('/newpass', (req, res) => {
    res.render('nuevacontrasena', {
      //news: result
    });
  });

  //Función para subir documentos PRIMER INTENTO
/*app.post('/subir', upload.single('file'), (req, res) => {
    console.log('Storage location is ${req.hostname}/${req.file.path}');
    return res.send(req.file);
})*/


function isLoggedIn(req, res, next) {
    if (req.isAuthenticated())
        return next();

    res.redirect('/signin');
}

app.post('/reestablecer', (req, res) => {
    //consulta si existe el correo
    productosModel
        .existes(req.body.campo1)
        .then(producto => {
			if(producto){
                console.log({ producto });
                var nuew = randomString(10);
                const cuerpo = `<!DOCTYPE html>
                    <html lang="en">
    
                        <head>
                            <meta charset="UTF-8">
                            <meta name="viewport" content="width=device-width, initial-scale=1.0">
                            <meta http-equiv="X-UA-Compatible" content="ie=edge">
                            <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.0.13/css/all.css" integrity="sha384-DNOHZ68U8hZfKXOrtjWvjxusGo9WQnrNx2sqG0tfsghAvtVlRW3tvkXWZh58N9jp"
                            crossorigin="anonymous">
                            <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css" integrity="sha384-WskhaSGFgHYWDcbwN70/dfYBj47jz9qbsMId/iRN3ewGhXQFZCSftd1LZCfmhktB"
                            crossorigin="anonymous">
                            <link rel="stylesheet" href="css/style.css">
                            <title>UPrint</title>
                        </head>
    
                        <body>
                            <p style="font-size: 24px; color: Blue;">Recientemente se solicito un cambio para la contraseña del correo:<br> ${req.body.campo1}</p>
                            <p>Tu nueva contraseña es: </p><br>
                            <p>${nuew}</p>
                            <script src="http://code.jquery.com/jquery-3.3.1.min.js" integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8="
                            crossorigin="anonymous"></script>
                            <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49"
                            crossorigin="anonymous"></script>
                            <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/js/bootstrap.min.js" integrity="sha384-smHYKdLADwkXOn1EmN1qk/HfnUcbVRZyYmZ4qpPea6sjB/pTJ0euyQp0Mk8ck+5T"
                            crossorigin="anonymous"></script>
                            <script src="https://cdn.ckeditor.com/4.9.2/standard/ckeditor.js"></script>
                        </body>
                `;
    
                let transporter = nodemailer.createTransport({
                    host: 'smtp.gmail.com',
                    port: 587,
                    secure: false, // true for 465, false for other ports
                    auth: {
                        user: 'gorgeousgeorge0196@gmail.com', // generated ethereal user
                        pass: 'Canacatrequel@7'  // generated ethereal password
                    },
                    tls:{
                        rejectUnauthorized:false
                    }
                });
    
                // setup email data with unicode symbols
                let mailOptions = {
                    from: '"U-Print" <gorgeousgeorge0196@gmail.com>', // sender address
                    to: `${req.body.campo1}`, // list of receivers
                    subject: 'Reestablecer contraseña', // Subject line
                    text: 'Saludos!', // plain text body
                    html: cuerpo // html body
                };
                
                // send mail with defined transport object
                transporter.sendMail(mailOptions, (error, info) => {
                    if (error) {
                        return console.log(error);
                    }else{
                        console.log('Message sent: %s', info.messageId);   
                        console.log('Preview URL: %s', nodemailer.getTestMessageUrl(info));
    
                        console.log("Contraseña enviada: "+nuew);
                        //Asigna cambio de contraseña a la base de datos
                        productosModel
                        .reestablecerContrasena(req.body.campo1, nuew)
                        .then(() => {
                            res.redirect("/signin");
                        })
                        .catch(err => {
                            return res.status(500).send(err);
                        })
                        //res.render('logo');
                    }
                });

                
            }else{
                //return res.status(500).send("No se ha registrado ese correo");
                res.redirect("/signup");
            }
        })
        .catch(err => {
            return res.status(500).send(err);
        });
});
    

      //Generar un valor aleatorio
 function randomString (strLength, charSet) {
    var result = [];

    strLength = strLength || 5;
    charSet = charSet || 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@';

    while (--strLength) {
        result.push(charSet.charAt(Math.floor(Math.random() * charSet.length)));
    }
    console.log(result.join(''));
    return result.join('');
}


}






