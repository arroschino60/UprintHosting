//let leftPage = document.getElementById("leftPage");
//let rightPage = document.getElementById("rightPage");

//let leftCtx = leftPage.getContext("2d");
//let rigthCtx = rightPage.getContext("2d");

//leftCtx.fillRect(0,0,300,300);

// leftPage.onclick = ()=>{
//     rigthCtx.putImageData(leftCtx.getImageData(0,0,leftPage.width, leftPage.height),0,0);
// }

class ToolPanel{
    constructor(tittle, body){
        this.tittle = tittle;
        this.body = body;
    }

    changeElement(args){}
    setListeners(){}

}

class ImagePanel extends ToolPanel{
    constructor(baseImages){

        super(`Imagen`,``);

        this.baseImages = baseImages;
        this.currentImage = ``;


        // for(let image of this.baseImages){
        //     this.body += `<img class="imagePreviw" src="${image}" alt="foto">`;
        // }

        this.body += `
                </div>
                <img id="output" class="currentImagePreview" src="" alt="foto">
                <label for="imgInput" class="inputBtn">Subir otra imágen</label>
                <input id="imgInput" type="file" style="display: none">
                <div class="imgZoomContainer">   
                    <i id="scaleDown" class="material-icons md-42" style="margin-right: 10px">zoom_out</i>
                    <i id="scaleUp" class="material-icons md-42">zoom_in</i>
                </div>
                <div id="delete" class="red inputBtn">Eliminar</div>
                `;

        
    }

    changeElement(args){
        this.currentImage = args.imageSrc;
        document.getElementById(`output`).src = args.imageSrc;
        if(args.deletable == false){
            document.getElementById("delete").className ="hidden";
        }else {
            document.getElementById("delete").className ="red inputBtn";
        }
    }
}


class TextPanel extends ToolPanel{
    constructor(){
        super(`Texto`,`<input id="text-edit" type="text"><div id="delete" class="red inputBtn">Eliminar</div>`);
        this.text = '';
    }

    changeElement(text){
        this.text = text;
        document.getElementById(`text-edit`).value = text;

    }

}

class Transformation{
    constructor(target, actions){
        this.target = target;
        this.actions = actions;
    }

    apply(drawable){
        return this.actions(drawable);
    }
}

class Drawable{
    constructor(x, y, w, h, className, index = 0){
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
        this.className = className;
        this.index = index;
        this.selectable = true;
        this.scale = 1;
        this.w1 = w;
        this.h1 = h;
    }

    setIndex(index){
        this.index = index;
    }
    
    isInside(x,y){
        if(x>this.x && x < this.x + this.w && y > this.y && y < this.y + this.h)
            return true;
        else 
            return false;
    }

    drag(x,y){
        this.x -= x;
        this.y -= y;
    }

    toStirng(){
        return `<br> clase: ${this.className} <br> z: ${this.index} <br> x: ${this.x} <br> y: ${this.y} <br> ancho: ${this.w} <br> alto ${this.h} <div class="flexCenter"><input type = "range" min=0.1 max=10 value=1 step = 0.1 oninput="document.getElementById('dw-${this.index}').innerHTML = this.value; resize(${this.index},this.value)";>  <p id="dw-${this.index}">1</p></div>`;
    }
    resize(){
        this.w= this.w1 * this.scale;
        this.h*=this.h1 * this.scale;
    }

}

class Picture extends Drawable{
    constructor(x,y,src, w=false, h=false){
        super(x,y,w,h,"Picture");
        this.img = document.createElement('IMG');
        this.img.src= src;
        this.src = src;
        this.loadPicture();
    }

    loadPicture(){
        return new Promise((resolve,reject) => {
            this.img.addEventListener('load', ()=> {
                if(!this.w){
                    this.w = this.img.width;
                    this.w1 = this.w;
                }
                if(!this.h){
                    this.h = this.img.height;
                    this.h1 = this.h;
                }
                resolve();
            });
            this.img.addEventListener('error', err=> reject(err));
        });
    }

    changeImage(src){

        let newImg = document.createElement('IMG')
        newImg.src = src;

        this.img = newImg;
        this.src = src;


        return new Promise((resolve,reject) => {
            this.img.addEventListener('load', ()=> {
                this.w = this.img.width;
                this.h = this.img.height;
                this.w1 = this.w;
                this.h1 = this.h;
                resolve();
            });
            this.img.addEventListener('error', err=> reject(err));
        });
    }

    resize(scale){
        this.img.width = this.w1 * scale;
        this.img.height =  this.h1 * scale;
        this.w = this.w1 * scale;
        this.h = this.h1 * scale;
    }

}

class Text extends Drawable{
    constructor(x,y,text, size="30px", font="Arial", color="rgba(220, 220, 220, 1)"){
        super(x,y,100,100,"Text");
        this.text = text;
        this.size = size;
        this.font = font;
        this.color= color;
    }
    

    toStirng(){
        return `<br> clase: ${this.className} <br> z: ${this.index} <br> x: ${this.x} <br> y: ${this.y} <br> ancho: ${this.w} <br> alto ${this.h} <br> <input id="text-${this.index}" onkeyup="setText(${this.index})" type="text" value="${this.text}"> <br>  <div class="flexCenter"><input type = "range" min=0.1 max=10 value=1 step = 0.1 oninput="document.getElementById('p-${this.index}').innerHTML = this.value; resize(${this.index},this.value)";>  <p id="p-${this.index}">1</p></div>`;
    }
}

function setText(index){
mainEditor.drawables[index].text = document.getElementById(`text-${index}`).value;
mainEditor.redraw();
}

function resize(index, scale){
    //console.log(mainEditor.drawables[index]);
    mainEditor.drawables[index].scale += scale;
    mainEditor.drawables[index].resize( mainEditor.drawables[index].scale);
    mainEditor.redraw();
   // console.log("rezise");
}

class Mask extends Drawable{
    constructor(x,y,w,h, shape='rect', bgColor="rgba(51, 51, 51, 1)"){
        super(x,y,w,h,"Mask");
        this.bgColor = bgColor;
        this.drawables=[];
        this.shape = shape;
    }

    drag(x,y){
        this.drawables[0].drag(x,y);
    }

    addDrawable(drawable){
        drawable.setIndex(this.drawables.length);
        this.drawables.push(drawable);
    }
    toStirng(){
        return `<br> clase: ${this.className} <br> z: ${this.index} <br> x: ${this.drawables[0].x} <br> y: ${this.drawables[0].y} <br> ancho: ${this.drawables[0].w} <br> alto ${this.drawables[0].h} <div class="flexCenter"><input type = "range" min=0.1 max=10 value=1 step = 0.1 oninput="document.getElementById('mask-${this.index}').innerHTML = this.value; resize(${this.index},this.value)";>  <p id="mask-${this.index}">1</p></div> `;
    }

    changeImage(src){
        return new Promise(resolve=>{
            this.drawables[0].changeImage(src).then(()=>{
                resolve();
            });
        });
        
    }
    resize(scale){
        this.drawables[0].scale = scale;
        this.drawables[0].resize(scale);
        //console.log(this.drawables);
    }
}

class Editor {
    constructor(canvas, mode ='fotolibro'){
        this.canvas = canvas;
        this.ctx = this.canvas.getContext("2d");
        this.drawables = [];
        this.state = 1;
        this.transformations = [new Transformation(0,drawable=>drawable)];
        this.focusedIndex = false;
        this.hover=false;
        this.draggin = false;
        this.activeElement = 0;
        this.panels = [
            new ToolPanel('Empty','<p>Empty pannel</p>'),
            new ImagePanel(["./img/foto1.jpg","./img/foto2.jpg","./img/foto3.jpg","./img/foto3.jpg"]),
            new TextPanel(),
        ];
        this.currentPanel = 0;
        this.mode = mode ;
        this.bgColor = "rgba(255, 255, 255, 1)";
    }

    deleteDrawable(index){
        this.drawables.splice(index, 1);
        console.log(this.drawables);
        for(let i = 0; i<this.drawables.length; i++){
            this.drawables[i].index = i;
        }
    }


    setPanel(panelName, args){
        
        switch(panelName){
            case 'imagen':{
                this.currentPanel = 1;
            }break;

            case 'Text':{
                this.currentPanel = 2;
            }break;

            default : {
                this.currentPanel = 0;
            }
        }

        let panel = this.panels[this.currentPanel];
        document.getElementById("panelsHeader").innerHTML = panel.tittle;
        document.getElementById("panelsContainer").innerHTML = panel.body;
        panel.changeElement(args);

        this.setPanelListneners(panelName);
    }

    setPanelListneners(panelName){
        switch(panelName){
            case 'imagen':{

                document.getElementById("panelsContainer").className  =` panelsContainer editImagePanel`;

                let imgInput = document.getElementById("imgInput");
                let output = document.getElementById('output');
                let scaleUp = document.getElementById('scaleUp');
                let scaleDown = document.getElementById('scaleDown');
            
                imgInput.onchange = function(event) {
                    output.src = URL.createObjectURL(event.target.files[0]);

                    mainEditor.drawables[mainEditor.activeElement].changeImage(URL.createObjectURL(event.target.files[0])).then(resolve=>{
                        mainEditor.redraw();
                    });
                };
                
                scaleUp.onclick = function(){
                    resize(mainEditor.activeElement,0.05);
                    mainEditor.redraw();
                }
                
                scaleDown.onclick = function(){
                    resize(mainEditor.activeElement,-0.05);
                    mainEditor.redraw();
                }

                document.getElementById("delete").onclick = function(){
                    mainEditor.deleteDrawable(mainEditor.activeElement);
                    mainEditor.redraw();
                    mainEditor.setPanel('d');
                }
            }break;

        case 'Text':{
            document.getElementById("panelsContainer").className  =` panelsContainer editTextPanel`;

            document.getElementById(`text-edit`).onkeyup = function(){
                mainEditor.drawables[mainEditor.activeElement].text = document.getElementById(`text-edit`).value;
                mainEditor.redraw();
            }

            document.getElementById("delete").onclick = function(){
                mainEditor.deleteDrawable(mainEditor.activeElement);
                mainEditor.redraw();
                mainEditor.setPanel('d');
            }
            
            
        }break;
        }
    }

    drawControls(){
        let drawable = this.drawables[this.focusedIndex];
        this.ctx.strokeStyle = "rgb(108, 108, 240)";
        this.ctx.lineWidth = "6";
        this.ctx.beginPath();
        this.ctx.rect(drawable.x-3,drawable.y-3,drawable.w+6,drawable.h+6);
        this.ctx.stroke();
    }

    redraw(){
        this.clear();
        this.drawAll();
    }

    reset(){
        this.drawables = [];
        this.transformations = [];
    }

    resetDrawables(){
        this.drawables = [];
    }xS

    drawMask(mask){
        this.ctx.save();
        this.ctx.beginPath();
        if(mask.shape == 'heart'){
            this.ctx.strokeStyle = mask.bgColor;
            this.ctx.strokeWeight = 3;
            this.ctx.lineWidth = 10.0;
            let d = Math.min(mask.w, mask.h);
            let x = mask.x;
            let y = mask.y;

            this.ctx.moveTo(x, y + d / 4);
            this.ctx.quadraticCurveTo(x, y, x + d / 4, y);
            this.ctx.quadraticCurveTo(x + d / 2, y, x + d / 2, y + d / 4);
            this.ctx.quadraticCurveTo(x + d / 2, y, x + d * 3/4, y);
            this.ctx.quadraticCurveTo(x + d, y, x + d, y + d / 4);
            this.ctx.quadraticCurveTo(x + d, y + d / 2, x + d * 3/4, y + d * 3/4);
            this.ctx.lineTo(x + d / 2, y + d);
            this.ctx.lineTo(x + d / 4, y + d * 3/4);
            this.ctx.quadraticCurveTo(x, y + d / 2, x, y + d / 4);
            this.ctx.stroke();
        }
        else this.ctx.rect(mask.x,mask.y,mask.w,mask.h);

        this.ctx.clip();
         this.ctx.fillStyle =mask.bgColor;
         this.ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);
         this.ctx.fillRect(0,0,this.canvas.width, this.canvas.height);
        //this.ctx.scale(mask.scale, mask.scale, mask.drawables[0].x + mask.drawables[0].w/2, mask.drawables[0].y + mask.drawables[0].h/2 );
        //this.ctx.scale(mask.scale, mask.scale);
        
        for(let drawable of mask.drawables){
            this.draw(drawable);
        }

        this.ctx.restore();
    }

    drawText(text){
        this.ctx.save();
        this.ctx.scale(text.scale, text.scale);
        this.ctx.fillStyle = text.color;
        this.ctx.font = `${text.size} ${text.font}`;   
        this.ctx.textBaseline = "hanging";     
        this.ctx.fillText(text.text, text.x,text.y);
        this.ctx.restore();
    }

    drawPicture(picture){
        this.ctx.drawImage(picture.img, picture.x, picture.y, picture.w, picture.h);
    }

    clear(){
        this.ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);
        this.ctx.fillStyle = this.bgColor;
        this.ctx.fillRect(0,0,this.canvas.width, this.canvas.height);
    }

    addDrawable(drawable){
        drawable.setIndex(this.drawables.length);
        if(drawable.className == "Text"){
            this.ctx.font = `${drawable.size} ${drawable.font}`
            drawable.w = this.ctx.measureText(drawable.text).width;
            drawable.h = parseInt(this.ctx.font);
        }
        this.drawables.push(drawable);
    }

    draw(drawable){
        switch(drawable.className){
            case "Mask":{this.drawMask(drawable)}break;
            case "Text":{this.drawText(drawable)}break;
            case "Picture":{this.drawPicture(drawable)}break;
        }
    }

    drawAll(){
        this.clear();
        for(let drawable of this.drawables){
            this.draw(drawable);
        }
    }

    applyTransfotmations(state){
        if(state==0){
            this.reset();
        }
        else{
            for(let transformation of this.transformations[state]){
                this.drawables[transformation.target] = transformation.apply(this.drawables[transformation.target]);
            }
        }
        this.drawAll();
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
    
    let picture1 = new Picture(310,-80,'./fotos/foto1.jpg',341.625,512);
    let picture2 = new Picture(310,-80,'./fotos/foto1.jpg',341.625,512);
    let picture3 = new Picture(-50,-80,'./fotos/foto3.jpg',500,750);
    
    let mask1 = new Mask(320,185,300,165);
    let mask2 = new Mask(320,10,300,165);
    let mask3 = new Mask(10,10,300,340);
    
    mainEditor.resetDrawables();
    mainEditor.clear();
    mainEditor.addMask(mask1);
    mainEditor.addMask(mask2);
    mainEditor.addMask(mask3).then(()=>{
        mainEditor.drawAll();
    });
    mainEditor.addDrawable(new Text(100,100,"Holis"));

}

async function loadPictures(pictures){
    for(let picture of pictures){
        await picture.loadPicture().catch(error => get.log(error));
        //ge.log(picture);
    }
    return pictures;
}


function main(){

    let pictures =[];

    switch(mainEditor.mode){

        case'fotolibro':{
            pictures.push(new Picture(310,-80,'/img/foto1.jpg',341.625,512));
            pictures.push(new Picture(310,-80,'/img/foto1.jpg',341.625,512));
            pictures.push(new Picture(-50,-80,'/img/foto3.jpg',500,750));

            let mask1 = new Mask(320,185,300,165);
            let mask2 = new Mask(320,10,300,165);
            let mask3 = new Mask(10,10,300,340);
        
            loadPictures(pictures).then(lPictures=>{
                mask1.addDrawable(lPictures[0]);
                mask2.addDrawable(lPictures[1]);
                mask3.addDrawable(lPictures[2]);
        
                mainEditor.addDrawable(mask1);
                mainEditor.addDrawable(mask2);
                mainEditor.addDrawable(mask3);
                mainEditor.addDrawable(new Text(100,100,"Un texto"));
                mainEditor.drawAll();
            });
        }break;
        case'rompecabezas':{
            pictures.push(new Picture(210,-80,'/img/foto1.jpg',341.625,512));
            pictures.push(new Picture(110,-80,'/img/jigsaw.png',424.25,600));

            let mask1 = new Mask(157,5,350,350,"heart","rgba(255,255,255,1)");

            mainEditor.bgColor="rgba(51,51,51,1)"
            loadPictures(pictures).then(lPictures=>{
                mask1.addDrawable(lPictures[0]);
                mask1.addDrawable(lPictures[1]);

                mainEditor.addDrawable(mask1);
                mainEditor.addDrawable(new Text(100,100,"Un texto"));
                mainEditor.addDrawable(new Picture(310,-80,'/img/iconuprint.png',205,205));

                mainEditor.drawAll();
            });
        }break;
    }

  



    

}

function setRight(){
    let mask1 = new Mask(10,185,300,165, new Picture(-10,-80,'./img/foto1.jpg',341.625,512));
    let mask2 = new Mask(10,10,300,165, new Picture(-10,-80,'./img/foto1.jpg',341.625,512));
    let mask3 = new Mask(320,10,300,340, new Picture(280,-80,'./img/foto3.jpg',500,750));
    
    mainEditor.resetDrawables();
    mainEditor.clear();
    mainEditor.addMask(mask1);
    mainEditor.addMask(mask2);
    mainEditor.addMask(mask3);
}

function triggerpanel(){
    let drawable = mainEditor.drawables[mainEditor.activeElement];
        if(drawable.className == "Mask")
            mainEditor.setPanel('imagen',
            {"imageSrc": drawable.drawables[0].src, "deletable":false}); 
        else if(drawable.className == "Text"){
            mainEditor.setPanel('Text', mainEditor.drawables[mainEditor.activeElement].text);
        }
        else if(drawable.className == "Picture"){
            mainEditor.setPanel('imagen', {"imageSrc": drawable.src, "deletable":true});
        }
}

function setListeners(){

    mainEditor.canvas.onmouseout = function(){
        mainEditor.redraw();
    }

    mainEditor.canvas.onmousemove = function(e){
        let newMouseX = e.pageX - this.offsetLeft;
        let newMouseY = e.pageY - this.offsetTop;
        //clicklenable=false;

        if(mainEditor.draggin){
            mainEditor.drawables[mainEditor.focusedIndex].drag(parseInt(mouseX - newMouseX),parseInt(mouseY - newMouseY));
            mainEditor.redraw();
            //document.getElementById("properties").innerHTML = mainEditor.drawables[mainEditor.focusedIndex].toStirng();
        } else{
            let lastHover = mainEditor.hover;
            mainEditor.hover = false;
            
            for(let i = mainEditor.drawables.length-1; i>=0; i--){

                let drawable = mainEditor.drawables[i];
                
                if(drawable.isInside(newMouseX, newMouseY) && drawable.selectable ){
                    
                    if(mainEditor.focusedIndex!=drawable.index){
                        mainEditor.focusedIndex = drawable.index;
                        mainEditor.redraw();
                    }
    
                    mainEditor.hover = true;
                    //mainEditor.drawControls();
    
                    if(mainEditor.draggin){
                        drawable.drag(parseInt(mouseX - newMouseX),parseInt(mouseY - newMouseY));
                        mainEditor.redraw();
                        //document.getElementById("properties").innerHTML = mainEditor.drawables[mainEditor.focusedIndex].toStirng();
                    }
    
                    break;
    
                }
            }
    
            if(mainEditor.hover)
                mainEditor.canvas.style.cursor = "pointer";
            else {
                mainEditor.canvas.style.cursor = "default";
                if(lastHover){
                    mainEditor.redraw();
                }
            };

        }
        mouseX = newMouseX;
        mouseY = newMouseY;
    }
    
    mainEditor.canvas.onmousedown = function(){
        clicklenable = true;
        mainEditor.draggin= true;
        mainEditor.activeElement = mainEditor.focusedIndex;
    }
    
    mainEditor.canvas.onmouseup = function(){
        mainEditor.draggin= false;

        triggerpanel();
        
    }

   
    
    document.getElementsByTagName("body")[0].onmouseup = ()=>{
        mainEditor.draggin= false;
    }

    document.getElementsByTagName("body")[0].onmouseleave = ()=>{
        mainEditor.draggin= false;
    }

    // document.getElementById("downloadLink").addEventListener('click',save, false);

    document.getElementById("addTextBtn").onclick = function(){
        mainEditor.addDrawable(new Text(100,100,"Otro texto"));
        mainEditor.redraw();
        mainEditor.activeElement = mainEditor.drawables.length-1;
        triggerpanel();
    }

    document.getElementById("addPhotoBtn").onclick = function(){
        let pic =new Picture(100,100,"/img/iconuprint.png");
        pic.loadPicture().then((result) => {
            mainEditor.addDrawable(pic);
            mainEditor.redraw();
            mainEditor.activeElement = mainEditor.drawables.length-1;
        triggerpanel();
            console.log(mainEditor.drawables);
        });
        
    }

    
}
let mouseX = 0, mouseY = 0;
let clicklenable = false;
let mainCanvas ;
let mainEditor ;


mainCanvas = document.getElementById("mainEditor");
mainEditor = new Editor(mainCanvas,'fotolibro');


//let scaleUp = document.getElementById("scaleUp");
//let scaleDown = document.getElementById("scaleDown");

main();
setListeners();
//setLeft();
//drawPages();