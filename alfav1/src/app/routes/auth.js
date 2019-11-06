var authController = require('../controllers/authcontroller.js');
const productosModel = require("../config/passport/productions.js");
const admModel = require("../config/passport/amin.js");
const nodemailer = require('nodemailer');

module.exports = function(app,passport){

// index routes
	app.get('/', (req, res) => {
		res.render('logo');
    });

    app.get('/personalizar', (req, res) => {
		res.render('personalizar');
    });
    
    //Para obtener productos para el catálogo
	app.get('/productos', (req, res) => {
        productosModel
		.obtenerProd()
		.then(productos => {
			res.render("productos", {
				productos: productos,
			});
		})
		.catch(err => {
			return res.status(500).send("Error obteniendo productos");
		});
        //res.render('productos');
	});

	app.get('/tc', (req, res) => {
		res.render('tc');
	});

    app.get('/tc2', (req, res) => {
		res.render('tc2');
	});

    app.get('/editor', (req, res) => {
		res.render('editor');
	});
        
    app.get('/contacto', (req, res) => {
		res.render('contacto');
	});

    app.get('/comprar', (req, res) => {
		res.render('index3');
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

//Funcion para registrarse
app.post('/signup', 
	passport.authenticate('local-signup',  { successRedirect: '/dashboard',
    failureRedirect: '/signup'}
));

//Ejemplo de cómo poner que debe estar loggeado
app.get('/dashboard',isLoggedIn, authController.dashboard);

//Función para desloggearse
app.get('/logout',authController.logout);

//Funcion para autenticarse
app.post('/signin', passport.authenticate('local-signin',  { successRedirect: '/dashboard',
	successRedirect: '/dashboard',	
	failureRedirect: '/signin'}
));

//Función para recuperar información de pedidos
app.get('/pro', function (req, res, next) {
	admModel
		.obtenerUnidades()
		.then(productos => {
			res.render("production", {
				productos: productos,
			});
		})
		.catch(err => {
			return res.status(500).send("Error obteniendo productos");
		});

});

//Función para obtener productos
app.get('/prodd', function (req, res, next) {
	productosModel
		.obtenerProd()
		.then(productos => {
			res.render("index6", {
				productos: productos,
			});
		})
		.catch(err => {
			return res.status(500).send("Error obteniendo productos");
		});

});

//Función para obtener las ventas en un periodo de tiempo
app.post('/proselect', function (req, res, next) {
    const {
        fechafin,
        fechaini
      } = req.body;
	admModel
		.obtenerVentas(fechaini, fechafin)
		.then(productos => {
			res.render("production", {
				productos: productos,
			});
		})
		.catch(err => {
			return res.status(500).send(err);
		});

});

//Función para cambiar el status de los pedidos
app.post('/cambStatus/:id/:idos', function(req, res, next){
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
app.post('/insertar', function (req, res, next) {
    // Obtener el nombre y precio. Es lo mismo que
    // const nombre = req.body.nombre;
    // const precio = req.body.precio;
    const { nombre, precio, tiempo, min, max, categoria, validatedCustomFile, dimen, comment, exist } = req.body;
    if (!nombre) {
        return res.status(500).send("No hay nombre");
	}
	if (!precio ) {
        return res.status(500).send("No hay precio");
	}
	if (!tiempo) {
        return res.status(500).send("No hay tiempo");
	}
	if (!min ) {
        return res.status(500).send("No hay min");
	}
	if ( !max ) {
        return res.status(500).send("No hay max");
	}
	if ( !categoria ) {
        return res.status(500).send("No hay categoria");
	}
	if ( !dimen ) {
        return res.status(500).send("No hay dimen");
	}
	if ( !comment) {
        return res.status(500).send("No hay comment");
	}
    // Si todo va bien, seguimos
    admModel
        .insertarProducto(nombre, precio, tiempo, min, max, categoria, validatedCustomFile, dimen, comment, exist)
        .then(idProductoInsertado => {
            res.redirect("/prodd");
        })
        .catch(err => {
            return res.status(500).send(err);
        });
});

//Función para buscar producto por id
	
app.get('/editar/:id', function (req, res, next) {
    productosModel
        .obtenerPorId(req.params.id)
        .then(producto => {
            if (producto) {
                console.log({ producto });
                res.render("index7", {
                    producto: producto,
                });
            } else {
                return res.status(500).send("No existe producto con ese id");
            }
        })
        .catch(err => {
            return res.status(500).send("Error obteniendo producto");
        });
});

app.post('/actualiza', (req, res) => {
    passport.query('UPDATE `users` SET `password`='+req.body.newpass+ 'WHERE email =' + req.body.campo1,
      (err, result) => {
        res.redirect('logo');
      });
  });

//Función para modificar 
app.post('/actualizar/', function (req, res, next) {
    // Obtener el nombre y precio. Es lo mismo que
    // const nombre = req.body.nombre;
    // const precio = req.body.precio;
    const { id, nombre, precio, tiempo, min, max, categoria, validatedCustomFile,imagen, dimen, comment, exist } = req.body;
    if (!nombre) {
        return res.status(500).send("No hay nombre");
	}
	if (!precio ) {
        return res.status(500).send("No hay precio");
	}
	if (!tiempo) {
        return res.status(500).send("No hay tiempo");
	}
	if (!min ) {
        return res.status(500).send("No hay min");
	}
	if ( !max ) {
        return res.status(500).send("No hay max");
	}
	
	if ( !comment) {
        return res.status(500).send("No hay comment");
	}
	if(!validatedCustomFile) {
		admModel
        .actualizar(id, nombre, precio, tiempo, min, max, categoria, imagen, dimen, comment, exist)
        .then(() => {
            res.redirect("/prodd");
        })
        .catch(err => {
            return res.status(500).send(err);
        });	
	}else {
		// Si no se cambió la imagen
		admModel
        .actualizar(id, nombre, precio, tiempo, min, max, categoria, validatedCustomFile, dimen, comment, exist)
        .then(() => {
            res.redirect("/prodd");
        })
        .catch(err => {
            return res.status(500).send(err);
        });
	}
    
});

//Función para eliminar producto
app.get('/eliminar/:id', function (req, res, next) {
    admModel
        .eliminar(req.params.id)
        .then(() => {
            res.redirect("/prodd");
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

/*
//Función para actualizar status de productos FALTA MODIFICAR
router.post('/act/', function (req, res, next) {
    // Obtener el nombre y precio. Es lo mismo que
    // const nombre = req.body.nombre;
    // const precio = req.body.precio;
    const { id, nombre, precio } = req.body;
    if (!nombre || !precio || !id) {
        return res.status(500).send("No hay suficientes datos");
    }
    // Si todo va bien, seguimos
    productosModel
        .actualizar(id, nombre, precio)
        .then(() => {
            res.redirect("/pro");
        })
        .catch(err => {
            return res.status(500).send("Error actualizando producto");
        });
});
*/
function isLoggedIn(req, res, next) {
    if (req.isAuthenticated())
        return next();

    res.redirect('/signin');
}

app.post('/reestablecer', (req, res) => {
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
    
    <body><p style="font-size: 24px; color: Blue;">Recientemente se solicito un cambio para la contraseña del correo:<br> ${req.body.campo1}</p>
    <a>De ser veridico, sigue este enlace:</a><br>
    <a href="http://localhost:3000/newpass" class="btn btn-success">enlace</a>
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
        }
        console.log('Message sent: %s', info.messageId);   
        console.log('Preview URL: %s', nodemailer.getTestMessageUrl(info));
    
        console.log(req.body);
        res.render('logo');
    });
    
    
      });


}






