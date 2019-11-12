function validar(){
    var user=document.getElementById('username').value
    if(user==""){
        document.getElementById('erroruser').value="Favor de Ingresar un Nombre de usuario"
    }
}