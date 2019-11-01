var authController = require('../controllers/authcontroller.js');
const productosModel = require("../config/passport/productions.js");

module.exports = function(app,passport){

// index routes
	app.get('/', (req, res) => {
		res.render('logo');
    });

    app.get('/personalizar', (req, res) => {
		res.render('personalizar');
	});
	app.get('/productos', (req, res) => {
		res.render('productos');
	});

	app.get('/catalogo', (req, res) => {
		res.render('catalogo');
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
	productosModel
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
    productosModel
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
		productosModel
        .actualizar(id, nombre, precio, tiempo, min, max, categoria, imagen, dimen, comment, exist)
        .then(() => {
            res.redirect("/prodd");
        })
        .catch(err => {
            return res.status(500).send(err);
        });	
	}else {
		// Si no se cambió la imagen
		productosModel
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
    productosModel
        .eliminar(req.params.id)
        .then(() => {
            res.redirect("/prodd");
        })
        .catch(err => {
            return res.status(500).send(err);
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


}






