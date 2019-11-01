//let leftPage = document.getElementById("leftPage");
//let rightPage = document.getElementById("rightPage");

//let leftCtx = leftPage.getContext("2d");
//let rigthCtx = rightPage.getContext("2d");

//leftCtx.fillRect(0,0,300,300);

// leftPage.onclick = ()=>{
//     rigthCtx.putImageData(leftCtx.getImageData(0,0,leftPage.width, leftPage.height),0,0);
// }

class Picture{
    constructor(x,y,src,w = false,h= false){
        this.x = x;
        this.y = y;
        this.img = document.createElement('IMG');
        this.img.src= src;
        if(w)
            this.w = w;
        if(h)
            this.h = h;
    }

    translate(x,y,absolute=false){
        if(absolute){
            this.x = x;
            this.y = y;
        }
        else{
            this.x -= x;
            this.y -= y;
        }
    }

}

class Mask{
    constructor(x,y,w,h,picture = false){
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
        this.editing = false;
        this.inside = false;
        if(picture){
            this.picture = picture;
        }
    }

    //Te dice si un punto en las coordenadas x,y esta dentro de la mascara
    isInside(x,y){
        if(x>this.x && x < this.x + this.w && y > this.y && y < this.y + this.h)
            this.inside = true;
        else 
            this.inside = false;
        
        return this.inside;
    }

    setPicture(picture){this.picture = picture;}

    translatePicture(x,y,absolute=false){
        this.picture.translate(x,y,absolute);
    }
}

class Editor {
    constructor(canvas){
        this.canvas = canvas;
        this.ctx = this.canvas.getContext("2d");
        this.masks = [];
    }

    resetMasks(){
        this.masks = [];
    }

    drawMask(mask){
            this.ctx.save();
            this.ctx.beginPath();
            this.ctx.rect(mask.x,mask.y,mask.w,mask.h);
            this.ctx.clip();
            this.ctx.drawImage(mask.picture.img, mask.picture.x, mask.picture.y, mask.picture.w, mask.picture.h);
            this.ctx.restore();
    }

    clear(){
        this.ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);
        this.ctx.fillStyle = "rgba(255, 255, 255, 1)";
        this.ctx.fillRect(0,0,this.canvas.width, this.canvas.height);

    }

    addMask(mask){
        this.masks.push(mask);
        mask.picture.img.onload = ()=>{
            if(!mask.picture.w)
                mask.picture.w = mask.picture.img.width;
            if(!mask.picture.h)
                mask.picture.h = mask.picture.img.height;
            this.drawMask(mask);
        }
    }

    drawAll(){
        mainEditor.clear();
        for(let mask of this.masks){
            this.drawMask(mask);
        }
    }
}

function drawPages(){
    let leftPage = document.getElementById("leftPage");

    let leftEditor = new Editor(leftPage);
    leftEditor.ctx.fillStyle = "rgba(220, 220, 220, 1)";
    leftEditor.ctx.fillRect(3.3,3.3,100,113.3);
    leftEditor.ctx.fillRect(106.66,3.33,100,55);
    leftEditor.ctx.fillRect(106.66,61.66,100,55);

    leftEditor.ctx.fillStyle = "rgba(255, 255, 255, 1)";
    leftEditor.ctx.beginPath();
    leftEditor.ctx.arc(100, 60, 40, 0, 2 * Math.PI);
    leftEditor.ctx.fill();

    leftEditor.ctx.fillStyle = "rgba(220, 220, 220, 1)";
    leftEditor.ctx.font = "30px Arial";
    leftEditor.ctx.fillText("1", 91, 70);

    leftPage.onclick = function() {setLeft()};


    let rightPage = document.getElementById("rightPage");
    let rightEditor = new Editor(rightPage);
    rightEditor.ctx.fillStyle = "rgba(220, 220, 220, 1)";
    rightEditor.ctx.fillRect(106.66,3.3,100,113.3);
    rightEditor.ctx.fillRect(3.3,3.33,100,55);
    rightEditor.ctx.fillRect(3.3,61.66,100,55);

    rightEditor.ctx.fillStyle = "rgba(255, 255, 255, 1)";
    rightEditor.ctx.beginPath();
    rightEditor.ctx.arc(100, 60, 40, 0, 2 * Math.PI);
    rightEditor.ctx.fill();

    rightEditor.ctx.fillStyle = "rgba(220, 220, 220, 1)";
    rightEditor.ctx.font = "30px Arial";
    rightEditor.ctx.fillText("2", 91, 70);

    rightPage.onclick = function() {setRight()};

}

function save(){
    let dt = mainEditor.canvas.toDataURL("image/jpeg");
    this.href= dt;
}

function setLeft(){
    let mask1 = new Mask(320,185,300,165, new Picture(310,-80,'./img/foto1.jpg',341.625,512));
    let mask2 = new Mask(320,10,300,165, new Picture(310,-80,'./img/foto1.jpg',341.625,512));
    let mask3 = new Mask(10,10,300,340, new Picture(-50,-80,'./img/foto3.jpg',500,750));

    mainEditor.resetMasks();
    mainEditor.clear();
    mainEditor.addMask(mask1);
    mainEditor.addMask(mask2);
    mainEditor.addMask(mask3);
}

function setRight(){
    let mask1 = new Mask(10,185,300,165, new Picture(-10,-80,'./img/foto1.jpg',341.625,512));
    let mask2 = new Mask(10,10,300,165, new Picture(-10,-80,'./img/foto1.jpg',341.625,512));
    let mask3 = new Mask(320,10,300,340, new Picture(280,-80,'./img/foto3.jpg',500,750));
    
    mainEditor.resetMasks();
    mainEditor.clear();
    mainEditor.addMask(mask1);
    mainEditor.addMask(mask2);
    mainEditor.addMask(mask3);
}

function setListeners(){
    mainEditor.canvas.onmousemove = function(e){
        let newMouseX = e.pageX - this.offsetLeft;
        let newMouseY = e.pageY - this.offsetTop;
        let inside = false;
    
        for(let mask of mainEditor.masks){
    
            if(mask.isInside(newMouseX, newMouseY)){
                inside = true;
                if(mask.editing){
                    mask.translatePicture(parseInt(mouseX - newMouseX),parseInt(mouseY - newMouseY));
                    mainEditor.drawAll();
                }
            }
        }
    
        if(inside)
             mainEditor.canvas.style.cursor = "pointer";
        else mainEditor.canvas.style.cursor = "default";
    
        mouseX = newMouseX;
        mouseY = newMouseY;
    }
    
    mainEditor.canvas.onmousedown = function(){
        for(let mask of mainEditor.masks){
            if(mask.inside)
                mask.editing = true;
        }
    }
    
    mainEditor.canvas.onmouseup = function(){
        for(let mask of mainEditor.masks){
            if(mask.editing)
                mask.editing = false;
        }
    }
    
    document.getElementsByTagName("body")[0].onmouseup = ()=>{
        for(let mask of mainEditor.masks){
            if(mask.editing){
                mask.editing = false;
            }
        }
    }

    document.getElementById("downloadLink").addEventListener('click',save, false);
}

let mouseX = 0, mouseY = 0;

let mainCanvas = document.getElementById("mainEditor");
let mainEditor = new Editor(mainCanvas);

drawPages();

setListeners();

setLeft();