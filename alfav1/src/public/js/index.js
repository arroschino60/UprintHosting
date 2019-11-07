function mostrarOcultarBarra (){
    if(document.body.scrollTop> 80 || document.documentElement.scrollTop > 80)
        document.getElementById("navbar").style = "transform: translateY(0px);";
    else document.getElementById("navbar").style = "transform: translateY(-80px);";
}

window.onscroll = () => mostrarOcultarBarra();

mostrarOcultarBarra();

var vista = document.getElementById("imagensota");
function change_img(image){
    vista.src = image.src;
}
var vista2 = document.getElementById("imagensotaFL");
function change_img2(image){
    vista2.src = image.src;
}
var vista3 = document.getElementById("imagensotaFM");
function change_img3(image){
    vista3.src = image.src;
}

function LoadETOButton(){
    document.getElementById("ETOButton").style.display="inline-block";
}

LoadETOButton();