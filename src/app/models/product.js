module.exports = function(sequelize, Sequelize) {

	var User = sequelize.define('user', {
		idProduct: { autoIncrement: true, primaryKey: true, type: Sequelize.INTEGER},
		nameProduct: { type: Sequelize.STRING,notEmpty: true},
		imageProduct: { type: Sequelize.STRING,notEmpty: true},
		enableProduct: {type: Sequelize.ENUM('active','inactive'),defaultValue:'active'},
		featuresProduct : {type:Sequelize.TEXT},
		statusProduct: { type:Sequelize.STRING, validate: {isEmail:true} },
		idCategory : {type: Sequelize.STRING,allowNull: false }, 
		idSubcategory: {type: Sequelize.DATE},
        idBrand: {type: Sequelize.ENUM('active','inactive'),defaultValue:'active' }

    });

	return User;

}