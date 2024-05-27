include <BOSL2/std.scad>
$fn=100;
//rad, cone height, brayer roller height, roller_inner_thick, handle_height, handle_thick, handle_turn_length
brayer_dim = [10, 15, 75, 2, 50, 4, 20];

//tight, loose
tols = [0.4, 0.8];


module brayer_roller() {
  diff("brayer_roller_main_cuts") {
    cyl(r=brayer_dim[0], h=brayer_dim[2], $fn=500);
    tag("brayer_roller_main_cuts") {
      //the grab slopes
      for (i=[1, -1]) {
        zmove(-i*(brayer_dim[2]/2+0.1)) xrot((i==1 ? 0 : -180)) rotate_extrude(angle = 360, $fn=500) difference() {
          right_triangle([brayer_dim[0]-brayer_dim[3],brayer_dim[1]]);
        }
      }
    }
  }  
}

module handle_joiner(cut=false) {
  for (i=[1, -1]) {
    zmove(i*brayer_dim[0]*3/16) xmove(brayer_dim[4]/2+brayer_dim[0]+brayer_dim[5]) yrot(90) cyl(r=brayer_dim[0]*3/8+tols[0]*(cut ? 1/2 : 0), h=brayer_dim[4]+(cut ? tols[1]*4-brayer_dim[5] : -brayer_dim[5]));
  }
}

module brayer_handle_main() {
  diff("brayer_handle_main_main_cuts") {
    zmove(brayer_dim[2]/2+tols[0]+brayer_dim[5]/2) {
      //the inner cone
      xrot(( -180)) zmove(brayer_dim[5]/2-tols[0]) {
        difference() {
          rotate_extrude(angle = 360, $fn=500) right_triangle([brayer_dim[0]-brayer_dim[3],brayer_dim[1]]);
          zmove(brayer_dim[1]-brayer_dim[3]/2) cuboid([brayer_dim[0], brayer_dim[0], brayer_dim[3]]);
        }
      }
      //the outside
      linear_extrude(brayer_dim[5], center=true) {
        xmove(brayer_dim[0]/2+tols[1]) rect([brayer_dim[0]+tols[1]*2, brayer_dim[0]*2-brayer_dim[3]]);
        circle(r=brayer_dim[0]-brayer_dim[3]/2, $fn=300);
      }
      xmove(brayer_dim[0]+tols[1]*2) {
          zmove(-brayer_dim[2]/2+brayer_dim[5]/2) yrot(90) xrot(-90) linear_extrude(brayer_dim[0]*2-brayer_dim[3], center=true) diff("brayer_handle_main_ellipse_fancy_cut") {
          ellipse(r=[brayer_dim[2]/2, brayer_dim[0]/2]);
          tag("brayer_handle_main_ellipse_fancy_cut") {
            ymove(brayer_dim[0]/4) rect([brayer_dim[2], brayer_dim[0]/2]);
            xmove(brayer_dim[2]/4) rect([brayer_dim[2]/2, brayer_dim[0]]);
          }
        }
      }
    }
    //the handle itself
    xmove(brayer_dim[0]+tols[1]*2+brayer_dim[4]/2) zmove((brayer_dim[5])/4) {
      zmove(brayer_dim[5]/2+tols[0]*2) xmove(-brayer_dim[4]/2+brayer_dim[5]/2+tols[0]+0.1) cuboid([brayer_dim[5]*5/4, brayer_dim[0]*2-brayer_dim[3], brayer_dim[5]]);
      difference() {
        cuboid([brayer_dim[4], brayer_dim[0]*2-brayer_dim[3], brayer_dim[5]/2]);
        //back fillet
        translate([-brayer_dim[4]/2, 0, -tols[1]*2]) xrot(90) fillet(l=brayer_dim[0]*3, r=tols[1]*2, spin=0);
      }
      //top fillet to handle
      //translate([-brayer_dim[4]/2+brayer_dim[5]*5/4, 0, tols[1]*3]) xrot(90) fillet(l=brayer_dim[0]*2-brayer_dim[3], r=tols[1]*2, spin=0);
      //grabber handle
      difference() {
        xmove(-brayer_dim[4]/2) yrot(90) pie_slice(ang=180, l=brayer_dim[4], r=brayer_dim[0]-brayer_dim[3]/2, spin=90);
        //end fillet for handle
        translate([brayer_dim[4]/2, 0, brayer_dim[0]]) xrot(90) fillet(l=brayer_dim[0]*3, r=brayer_dim[0], spin=180);
      }
    }
    
    //cuboid([brayer_dim[0]*2-brayer_dim[3], brayer_dim[6], brayer_dim[5]], rounding=tols[0]);
    tag("brayer_handle_main_main_cuts") {
      handle_joiner(cut=true);  
    }
  }
}

module all() {
  difference() {
    brayer_roller();
    ymove(brayer_dim[0]/2) cuboid([brayer_dim[0]*3, brayer_dim[0], brayer_dim[2]*2]);
  }
  brayer_handle_main();   
  //xrot(180) brayer_handle_main();
  handle_joiner();
}
//all();

//brayer_roller();
//brayer_handle_main();
handle_joiner();



