// body size
width=40;
height=41;
length=82;
wallWidth=2;


//Connector
connectorCutoutWidth=1;
connectorCutoutHeight=6;
connectorCutoutClearance=2;
connectorCutoutPitch=3;

// PCB holder
shelfDepth=18-13;
shelfWidth=8;
insertHoleDepth=10;
insertHoleDiameter=4;
PCBWidth=1.57;

// side positioners
positionerWidth=1;

// LED
ledCutoutRadius=5.5;
ledCutoutWidth=0.4;

// srcew
screw_dk=5.7;
screw_k=3.5;
screw_L=12;
screw_d=3.2;

// Lid clearence
lid_clearence=0.25;

// AUX
height2=20;
width2=11;




// Main outline from side view
outerLine =[[0,-2],[width,-2],[width,height2],[width-width2,height2],[0,height]];
innerLine =[[wallWidth,-2],[width-wallWidth,-2],[width-wallWidth,height2-wallWidth],[width-width2-wallWidth*0.5,height2-wallWidth],[wallWidth,height-wallWidth*1.5]];
bodyPolygon = concat(outerLine,innerLine);
holderLine = [[0,shelfDepth],[width,shelfDepth],[width,height2],[width-width2,height2],[0,height]];
    
module side() {
    linear_extrude(height = wallWidth, center = true, convexity = 10, twist = 0, slices = 1, scale = 1.0, $fn = 64)
    polygon(outerLine,[[0,1,2,3,4]],10);
}

module connectorCutout() {
    union() {
        translate([width-wallWidth-connectorCutoutHeight-connectorCutoutClearance,0,27.5-connectorCutoutWidth/2])
        for(ii=[0:1:6])
            if (ii!=1)
                translate([1,0,connectorCutoutPitch*ii]) cube([connectorCutoutHeight+0.5,height,connectorCutoutWidth]);
        translate([width-wallWidth-connectorCutoutHeight-connectorCutoutClearance-3,height2-1,27.5-connectorCutoutWidth/2-3]) cube([connectorCutoutHeight+6,10,connectorCutoutWidth*connectorCutoutPitch*7*1.2]);
        }
}

module body() {
    difference() {
        linear_extrude(height = length-2*wallWidth, center = true, convexity = 10, twist = 0, slices = 40, scale = 1.0, $fn = 64)
        polygon(bodyPolygon,[[0,1,2,3,4],[5,6,7,8,9]],10); 
    }
}

module ledCutout() {
    translate([(width-2*wallWidth-2*lid_clearence)/2,wallWidth+ledCutoutWidth+1,(length-2*wallWidth)/2+21]) rotate([90,0,0]) cylinder(wallWidth,1.5*ledCutoutRadius,ledCutoutRadius, $fn = 64);
}

module lidScrew() {
        union() {       
            translate([0,shelfDepth*2,shelfWidth/2]) rotate([90,0,0]) cylinder(shelfDepth*1.5,screw_d/2,screw_d/2,$fn = 64);    
            translate([0,screw_k,shelfWidth/2]) rotate([90,0,0]) cylinder(screw_k*1.5,screw_dk/2,screw_dk/2,$fn = 64);    
    }
}

module lid() {
    difference() {
        union() {
            cube([width-2*wallWidth-2*lid_clearence, wallWidth+1, length-2*wallWidth-2*lid_clearence],false);
            cube([width-2*wallWidth-2*lid_clearence, wallWidth+1+2,shelfWidth-lid_clearence],false);
            translate([0,0,length-2*wallWidth-shelfWidth-lid_clearence]) cube([width-2*wallWidth-2*lid_clearence,wallWidth+1+2,shelfWidth-lid_clearence],false);
        }
        translate([(width-2*wallWidth)/2-13-lid_clearence,0,lid_clearence]) lidScrew();
        translate([(width-2*wallWidth)/2+13-lid_clearence,0,lid_clearence]) lidScrew();
        translate([(width-2*wallWidth)/2-13-lid_clearence,0,length-2*wallWidth-shelfWidth-3*lid_clearence]) lidScrew();
        translate([(width-2*wallWidth)/2+13-lid_clearence,0,length-2*wallWidth-shelfWidth-3*lid_clearence]) lidScrew();
          
        ledCutout(); 
        translate([(width-2*wallWidth-2*lid_clearence)/2,1,(length-2*wallWidth-2*lid_clearence)/2]) rotate([90,-90,0]) noboText();
    }
    
    

}

module noboText(){
    difference()
    {
        
    scale(1.4) linear_extrude(3) text("NOBO",
    font="Raleway:style=ExtraBold",
    "Center Aligned" ,halign = "center",valign = "center");
    translate([-7,-10,-1]) cube([1.5,20,5]);
    translate([14,-6,-1]) rotate([0,0,-45]) cube([1.5,20,5]);
    }
    
}
module insertHole(){
    rotate([90,0,0]) cylinder(insertHoleDepth,insertHoleDiameter/2,insertHoleDiameter/2,$fn = 64);
}

module shelf(dir) {
    difference() {
        linear_extrude(height = shelfWidth, center = true, convexity = 10, twist = 0, slices = 1, scale = 1.0, $fn = 64)
            polygon(holderLine,[[0,1,2,3,4]],10);
        translate([width/2-13,shelfDepth+insertHoleDepth-1,dir]) insertHole();
        translate([width/2+13,shelfDepth+insertHoleDepth-1,dir]) insertHole();
    }
}

module positioner() {
    linear_extrude(height = positionerWidth, center = true, convexity = 10, twist = 0, slices = 1, scale = 1.0, $fn = 64)
        polygon([[0,0],[25,0],[25,11],[25-8,11],[25-8,2],[25-8-3,2],[25-8-3,11],[0,11]],10);
}

module screw()
{
    difference() {
        union() {
            cylinder(h=screw_L+0.9*screw_k,d=0.90*screw_d,$fn = 64);
            cylinder(h=0.9*screw_k,d=0.9*screw_dk,$fn = 64);
        }
        cylinder(r=2, h=2, $fn=6);
    }
}

module PCB() {
    difference() {
        cube([width-2*wallWidth-1,PCBWidth,length-2*wallWidth-1]);
        translate([(width-2*wallWidth)/2-13-lid_clearence,shelfDepth*1.25,shelfWidth/2-lid_clearence+0.5]) rotate([90,0,0]) cylinder(shelfDepth*1.5,screw_d/2,screw_d/2,$fn = 64);
        translate([(width-2*wallWidth)/2+13-lid_clearence,shelfDepth*1.25,shelfWidth/2-lid_clearence+0.5]) rotate([90,0,0]) cylinder(shelfDepth*1.5,screw_d/2,screw_d/2,$fn = 64);
        translate([(width-2*wallWidth)/2-13-lid_clearence,shelfDepth*1.25,length-2*wallWidth-shelfWidth-lid_clearence+shelfWidth/2-0.5]) rotate([90,0,0]) cylinder(shelfDepth*1.5,screw_d/2,screw_d/2,$fn = 64);
        translate([(width-2*wallWidth)/2+13-lid_clearence,shelfDepth*1.25,length-2*wallWidth-shelfWidth-lid_clearence+shelfWidth/2-0.5]) rotate([90,0,0]) cylinder(shelfDepth*1.5,screw_d/2,screw_d/2,$fn = 64);
    }
}

module clamp() {
    clampPoly =[[0,0],[0,10],[-1,10],[-2,8],[-2,7],[-1,7],[-1,0]];
    linear_extrude(height = 7, center = true, convexity = 10, twist = 0, slices = 1, scale = 1.0, $fn = 64)
    polygon(clampPoly,[[0,1,2,3,4,5,6]],10);
}

module base() {
    difference() {
        union() {
            translate([0,0,wallWidth/2]) side();
            translate([0,0,length/2]) body();
            translate([0,0,length-wallWidth/2]) side();
            translate([0,0,wallWidth+shelfWidth/2]) shelf(+0.5);
            translate([0,0,length-wallWidth-shelfWidth/2]) shelf(-0.5);
            translate([width-25,height2-2,positionerWidth/2]) positioner();
            translate([width-25,height2-2,length-positionerWidth/2]) positioner();
            translate([9,height-7.5,20]) clamp();
            translate([9,height-7.5,length-22]) clamp();
        }
        connectorCutout();
        
        translate([21,35,length-11]) rotate([90,0,0]) cylinder(h=40,d=9,$fn = 64);
    }
}

module crossSection() {
    difference() {
        union(){
            color("white") base();
            color ("green", alpha=0.5) translate([wallWidth+lid_clearence,shelfDepth-PCBWidth-0.2,wallWidth+lid_clearence]) PCB();
            color("red",alpha=0.9) translate([wallWidth+lid_clearence,-1.9,wallWidth+lid_clearence]) lid();
            color("yellow") translate([wallWidth+lid_clearence+4.75,-1.9,wallWidth+lid_clearence+4.25]) rotate([-90,0,0]) screw();
        }
       //translate([-17,0,0]) cube([100,500,500],true);
       translate([-43,0,0]) cube([100,500,500],true);
    }
}

module exploded() {
        union(){
            color("white") base();
            color ("green", alpha=0.5) translate([wallWidth+lid_clearence,shelfDepth-PCBWidth-30,wallWidth+lid_clearence]) PCB();
            color("red",alpha=0.9) translate([wallWidth+lid_clearence,-60,wallWidth+lid_clearence]) lid();
            color("yellow") translate([wallWidth+lid_clearence+4.75,-90,wallWidth+lid_clearence+4.25]) rotate([-90,0,0]) screw();
        }
}

module assembled() {
        union(){
            color("white") base();
            color ("green", alpha=0.5) translate([wallWidth+lid_clearence,shelfDepth-PCBWidth-0.2,wallWidth+lid_clearence]) PCB();
            color("red",alpha=0.9) translate([wallWidth+lid_clearence,-1.9+0,wallWidth+lid_clearence]) lid();
        }
    
}

//assembled();
exploded();
//crossSection();

//rotate([90,0,0]) lid();
//rotate([0,-90,0]) base();
