module.exports = function(sequelize, Sequelize) {

	var Units = sequelize.define('units', {
		id: { autoIncrement: true, primaryKey: true, type: Sequelize.INTEGER},
		descripcion: { type: Sequelize.STRING,notEmpty: true}
    });

	return Units;

}