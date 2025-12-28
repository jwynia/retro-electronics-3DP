Countersink_or_Counterbore = false;
Countersink_on_One_Part_Only = true;
Length = 32; //[15:300]

Width = 22; //[22:300]
//Height dimension is for Hole Diameter 4...                      (Minimum Height for Counterbore is 12)
Height = 8; //[8:300]




Hole_Diameter = 4; //[2:20]
Y_Hole = 6; //[0:300]
plusY_Hole = 20; //[0:300]




if(Countersink_or_Counterbore) {
//Countersink
difference(){
translate([7,17,0])
union(){
//horni zaoblení-iluze
difference(){
minkowski(){
    translate([-14,-20,Height-12])
    cube([Width-8,Length,3]);
    sphere(4,$fn=150);
}

//spodni orez
translate([-30,-30,-16])
cube([Width+30,Length+20,Height+20]);
//orez -Y
translate([-40,-50,-24])
cube([Width+60,30,Height+80]);
//orez+Y
translate([-40,Length-20,-24])
cube([Width+60,30,Height+80]);

}

//spodni zaobleni

difference(){
minkowski(){
    translate([-15,-20,-(Hole_Diameter-Hole_Diameter/3.9)+3.5])
    cube([Width-6,Length,Height-9+(Hole_Diameter-Hole_Diameter/3.9)]);
    sphere(3,$fn=150);   
}

//orez -Y
translate([-50,-50,-24])
cube([Width+50,30,Height+50]);
//orez+Y
translate([-50,Length-20,-24])
cube([Width+50,30,Height+50]);
translate([0,0,-10])
//zahloubeni a dira -Y
hull() {
   rotate([0,180,0])
   translate([-(Width-36)/2,Y_Hole-17,-10.001]) 
   cylinder(Hole_Diameter+1,Hole_Diameter,0,$fn=150);
}   
   translate([(Width-36)/2,Y_Hole-17,-30])
   cylinder(60,Hole_Diameter/2+0.1,Hole_Diameter/2+0.1,$fn=150);
//zahloubeni a dira +Y
hull() {
   rotate([0,180,0])
   translate([-(Width-36)/2,plusY_Hole-17,-0.001]) 
   cylinder(Hole_Diameter+1,Hole_Diameter,0,$fn=150);
}   
   translate([(Width-36)/2,plusY_Hole-17,-30])
   cylinder(60,Hole_Diameter/2+0.1,Hole_Diameter/2+0.1,$fn=150);

}
}


translate([7,17,0])
union(){
//spodni vyrez
translate([-15,-17,0])
cube([Width-6,Length+10,Height-6]);
//spodni vyrez uprostred
translate([-12.15,-17,0])
cube([Width-11.7,Length+10,Height+15.5]);
//prostredni vyrez
translate([-7,-17,0])
cube([Width-22,Length+10,31]);
//vpravo vyrez
translate([-13.51,-17,Height-7.48])
rotate([0,-45,0])
cube([5,Length+10,2.1]);
//vlevo vyrez
translate([Width-26.02,-17,Height-3.95])
rotate([0,45,0])
cube([5,Length+10,2.1]);
//zkoseni
union(){  
translate([0,Length-30,0])
rotate([60,0,0])
translate([-15,3.55,-10.6])
cube([Width-6,1.7,4.6]);
}
}
}







//protikus vevnitr
difference(){

rotate([180,0,180])
translate([30.5,17,-Height+1+Hole_Diameter-Hole_Diameter/3.9])
union(){
//spodni vyrez
translate([-14.9,-17,0])
cube([Width-7+0.8,Length-3,Height-10.5+4.4]);
//spodni vyrez uprostred
translate([-12.05,-17,0.5])
cube([Width-12.5+0.6,Length-3,Height-2]);
//vpravo vyrez
translate([-13.01-0.4,-17,Height-11.98+4.4])
rotate([0,-45,0])
cube([5,Length-3,2.1]);
//vlevo vyrez
translate([Width-26.52+0.4,-17,Height-8.45+4.4])
rotate([0,45,0])
cube([5,Length-3,2.1]);

}

//zahloubeni a dira -Y
rotate([180,0,180])
translate([-5,0,20.4])
union(){
hull() {
   rotate([0,0,180])
   translate([-(Width+35)/2,-Y_Hole,-Height-19.901+Hole_Diameter-Hole_Diameter/3.9]) 
   cylinder(Hole_Diameter+1,Hole_Diameter,0,$fn=150);
}   
   translate([(Width+35)/2,Y_Hole-0,-Height-50.401])
   cylinder(100+Height,Hole_Diameter/2+0.1,Hole_Diameter/2+0.1,$fn=150);
//zahloubeni a dira +Y
hull() {
   rotate([0,0,180])
   translate([-(Width+35)/2,-plusY_Hole+0,-Height-19.901+Hole_Diameter-Hole_Diameter/3.9]) 
   cylinder(Hole_Diameter+1,Hole_Diameter,0,$fn=150);
}   
   translate([(Width+35)/2,plusY_Hole-0,-Height-50.401])
   cylinder(100+Height,Hole_Diameter/2+0.1,Hole_Diameter/2+0.1,$fn=150);

}
}
}










//-----------------------------------//










//jedna cast jina



else if (Countersink_on_One_Part_Only) {
difference(){
translate([7,17,0])
union(){
//horni zaoblení-iluze
difference(){
minkowski(){
    translate([-14,-20,Height-12])
    cube([Width-8,Length,3]);
    sphere(4,$fn=150);
}

//spodni orez
translate([-30,-30,-16])
cube([Width+30,Length+20,Height+20]);
//orez -Y
translate([-40,-50,-24])
cube([Width+60,30,Height+80]);
//orez+Y
translate([-40,Length-20,-24])
cube([Width+60,30,Height+80]);

}

//spodni zaobleni

difference(){
minkowski(){
    translate([-15,-20,-(Hole_Diameter-Hole_Diameter/3.9)+3.5])
    cube([Width-6,Length,Height-9+(Hole_Diameter-Hole_Diameter/3.9)]);
    sphere(3,$fn=150);   
}

//orez -Y
translate([-50,-50,-24])
cube([Width+50,30,Height+50]);
//orez+Y
translate([-50,Length-20,-24])
cube([Width+50,30,Height+50]);
translate([0,0,-10])
//zahloubeni a dira -Y
hull() {
   rotate([0,180,0])
   translate([-(Width-36)/2,Y_Hole-17,-10.001]) 
   cylinder(Hole_Diameter+1,Hole_Diameter,0,$fn=150);
}   
   translate([(Width-36)/2,Y_Hole-17,-30])
   cylinder(60,Hole_Diameter/2+0.1,Hole_Diameter/2+0.1,$fn=150);
//zahloubeni a dira +Y
hull() {
   rotate([0,180,0])
   translate([-(Width-36)/2,plusY_Hole-17,-0.001]) 
   cylinder(Hole_Diameter+1,Hole_Diameter,0,$fn=150);
}   
   translate([(Width-36)/2,plusY_Hole-17,-30])
   cylinder(60,Hole_Diameter/2+0.1,Hole_Diameter/2+0.1,$fn=150);

}
}


translate([7,17,0])
union(){
//spodni vyrez
translate([-15,-17,0])
cube([Width-6,Length+10,Height-6]);
//spodni vyrez uprostred
translate([-12.15,-17,0])
cube([Width-11.7,Length+10,Height+15.5]);
//prostredni vyrez
translate([-7,-17,0])
cube([Width-22,Length+10,31]);
//vpravo vyrez
translate([-13.51,-17,Height-7.48])
rotate([0,-45,0])
cube([5,Length+10,2.1]);
//vlevo vyrez
translate([Width-26.02,-17,Height-3.95])
rotate([0,45,0])
cube([5,Length+10,2.1]);
//zkoseni
union(){  
translate([0,Length-30,0])
rotate([60,0,0])
translate([-15,3.55,-10.6])
cube([Width-6,1.7,4.6]);
}
}
}






//protikus vevnitr
difference(){

rotate([180,0,180])
translate([30.5,17,-Height+2.5+(Hole_Diameter-Hole_Diameter/3.9)])
union(){
//spodni vyrez
translate([-14.9,-17,-1])
cube([Width-7+0.8,Length-3,Height-10.5+4.4]);
//spodni vyrez uprostred
translate([-12.05,-17,0])
cube([Width-12.5+0.6,Length-3,Height-3]);
//vpravo vyrez
translate([-13.01-0.4,-17,Height-11.98+3.4])
rotate([0,-45,0])
cube([5,Length-3,2.1]);
//vlevo vyrez
translate([Width-26.52+0.4,-17,Height-8.45+3.4])
rotate([0,45,0])
cube([5,Length-3,2.1]);

}




//zahloubeni a dira -Y
rotate([180,0,180])
translate([-5,0,-14.4])
union(){
hull() {
   rotate([0,0,0])
   translate([(Width+35)/2,Y_Hole,-Height+15.899+(Hole_Diameter-Hole_Diameter/3.9)]) 
    cylinder(Hole_Diameter+1,Hole_Diameter/2*2,Hole_Diameter/2*2,$fn=150);
}   
   translate([(Width+35)/2,Y_Hole,-Height-10])
   cylinder(50+Height,Hole_Diameter/2+0.1,Hole_Diameter/2+0.1,$fn=150);
//zahloubeni a dira +Y
hull() {
   rotate([0,0,0])
   translate([(Width+35)/2,plusY_Hole,-Height+15.899+(Hole_Diameter-Hole_Diameter/3.9)]) 
   cylinder(Hole_Diameter+1,Hole_Diameter/2*2,Hole_Diameter/2*2,$fn=150);
}   
  translate([(Width+35)/2,plusY_Hole,-Height-10])
   cylinder(50+Height,Hole_Diameter/2+0.1,Hole_Diameter/2+0.1,$fn=150);

}
}
}












//------------------------------------//





//Counterbore
else  {
    assert(Height >= 12 && Height <= 300, "Height is out of range (Minimum is 12)");

difference(){
translate([7,17,0])
union(){
//horni zaoblení-iluze
difference(){
minkowski(){
    translate([-14,-20,Height-12])
    cube([Width-8.,Length,3]);
    sphere(4,$fn=150);
}

//spodni orez
translate([-30,-30,-16])
cube([Width+30,Length+20,Height+20]);
//orez -Y
translate([-40,-50,-24])
cube([Width+60,30,Height+80]);
//orez+Y
translate([-40,Length-20,-24])
cube([Width+60,30,Height+80]);

}

//spodni zaobleni

difference(){
minkowski(){
    translate([-15,-20,-Hole_Diameter+1])
    cube([Width-6,Length,Height-9.5+Hole_Diameter]);
    sphere(3,$fn=150);   
}

//orez -Y
translate([-50,-50,-24])
cube([Width+50,30,Height+50]);
//orez+Y
translate([-50,Length-20,-24])
cube([Width+50,30,Height+50]);
translate([0,0,-10])
//zahloubeni a dira -Y
hull() {
   rotate([0,180,0])
   translate([-(Width-36)/2,Y_Hole-17,-10.001]) 
   cylinder(Hole_Diameter+1,Hole_Diameter/2*2,Hole_Diameter/2*2,$fn=150);
}   
   translate([(Width-36)/2,Y_Hole-17,-60])
   cylinder(60,Hole_Diameter/2+0.1,Hole_Diameter/2+0.1,$fn=150);
//zahloubeni a dira +Y
hull() {
   rotate([0,180,0])
   translate([-(Width-36)/2,plusY_Hole-17,-0.001]) 
   cylinder(Hole_Diameter+1,Hole_Diameter/2*2,Hole_Diameter/2*2,$fn=150);
}   
   translate([(Width-36)/2,plusY_Hole-17,-60])
   cylinder(60,Hole_Diameter/2+0.1,Hole_Diameter/2+0.1,$fn=150);

}
}


translate([7,17,0])
union(){
//spodni vyrez
translate([-15,-17,-0])
cube([Width-6,Length+10,Height-9]);
//spodni vyrez uprostred
translate([-12.15,-17,0])
cube([Width-11.7,Length+10,Height+15.5]);
//prostredni vyrez
translate([-7,-17,0])
cube([Width-22,Length+10,31]);
//vpravo vyrez
translate([-13.51,-17,Height-10.48])
rotate([0,-45,0])
cube([5,Length+10,2.1]);
//vlevo vyrez
translate([Width-26.02,-17,Height-6.95])
rotate([0,45,0])
cube([5,Length+10,2.1]);
//zkoseni
union(){  
translate([0,Length-30,0])
rotate([60,0,0])
translate([-15,3.55,-10.6])
cube([Width-6,1.7,4.6]);
}
}
}






//protikus vevnitr
difference(){

rotate([180,0,180])
translate([30.5,17,-Height+8+Hole_Diameter])
union(){
//spodni vyrez
translate([-14.9,-17,-1])
cube([Width-7+0.8,Length-3,Height-10.5+1.4]);
//spodni vyrez uprostred
translate([-12.05,-17,0])
cube([Width-12.5+0.6,Length-3,Height-6]);
//vpravo vyrez
translate([-13.01-0.4,-17,Height-11.98+0.4])
rotate([0,-45,0])
cube([5,Length-3,2.1]);
//vlevo vyrez
translate([Width-26.52+0.4,-17,Height-8.45+0.4])
rotate([0,45,0])
cube([5,Length-3,2.1]);

}




//zahloubeni a dira -Y
rotate([180,0,180])
translate([-5,0,-14.4])
union(){
hull() {
   rotate([0,0,0])
   translate([(Width+35)/2,Y_Hole,-Height+20.899+Hole_Diameter]) 
    cylinder(Hole_Diameter+1,Hole_Diameter/2*2,Hole_Diameter/2*2,$fn=150);
}   
   translate([(Width+35)/2,Y_Hole,-Height-10])
   cylinder(50+Height,Hole_Diameter/2+0.1,Hole_Diameter/2+0.1,$fn=150);
//zahloubeni a dira +Y
hull() {
   rotate([0,0,0])
   translate([(Width+35)/2,plusY_Hole,-Height+20.899+Hole_Diameter]) 
   cylinder(Hole_Diameter+1,Hole_Diameter/2*2,Hole_Diameter/2*2,$fn=150);
}   
  translate([(Width+35)/2,plusY_Hole,-Height-10])
   cylinder(50+Height,Hole_Diameter/2+0.1,Hole_Diameter/2+0.1,$fn=150);

}
}
}   
 



