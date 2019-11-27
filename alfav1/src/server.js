    const express    = require('express');
    const fileUpload = require('express-fileupload')
    const app        = express();
    const path = require('path');
    var passport   = require('passport');
    var session    = require('express-session');
   const { check, validationResult } = require('express-validator');
    var bodyParser = require('body-parser');
    var env        = require('dotenv').load;
    var exphbs     = require('express-handlebars');
    var formidable = require('express-form-data');
    
    //For BodyParser
    app.use(bodyParser.urlencoded({ extended: true }));
    app.use(bodyParser.json());
  // static files
  app.use(express.static(path.join(__dirname, 'public')));

     // For Passport
    app.use(session({ secret: 'keyboard cat',resave: true, saveUninitialized:true})); // session secret
    app.use(passport.initialize());
    app.use(passport.session()); // persistent login sessions

    app.use(formidable.parse({ keepExtensions: true}));


     //For Handlebars
     app.set('port', process.env.PORT || 3000);
    app.set('views', path.join(__dirname, 'app/views'));
    //app.engine('hbs', exphbs({extname: '.hbs'}));
    app.set('view engine', 'ejs');
    

    //app.get('/', function(req, res){
	  //res.send('Welcome to Passport with Sequelize');
	//});


	//Models
    var models = require("./app/models");


    //Routes
    var authRoute = require('./app/routes/auth.js')(app,passport);
  

    //load passport strategies
    require('./app/config/passport/passport.js')(passport,models.user);


    //Sync Database
   	models.sequelize.sync().then(function(){
    console.log('Nice! Database looks fine')

    }).catch(function(err){
    console.log(err,"Something went wrong with the Database Update!")
    });

  

	app.listen(app.get('port'), function(err){
		if(!err)
		console.log("Site is live on ", app.get('port')); else console.log(err)

	});


 



    