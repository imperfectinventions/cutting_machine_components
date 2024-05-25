include <BOSL2/std.scad>

scraper_dim = [50, 50, 35, 0.2, 2];

module rounding_fancy() {
      iso_l = sqrt(pow((scraper_dim[4] - scraper_dim[3]), 2)+scraper_dim[2]*scraper_dim[2]);
      iso_a = 90 - atan((scraper_dim[4] - scraper_dim[3])/scraper_dim[2]);
      iso_r = (iso_l/2)/cos(iso_a);
      echo (iso_a, cos(iso_a), iso_l, iso_r);
      xmove(scraper_dim[2]+(scraper_dim[1]/2-scraper_dim[2])) zmove(iso_r-(scraper_dim[4] - scraper_dim[3])/2) {
        xrot(90) cyl(r=iso_r, h=scraper_dim[0]+0.1, $fn=1000);
      }
  }

module scraper() {
  diff("scraper_main_cuts") {
    linear_extrude(scraper_dim[4], center=true, $fn=128) rect([scraper_dim[1],scraper_dim[0]], rounding=scraper_dim[1]/8);
    tag("scraper_main_cuts") {
      rounding_fancy();
      xmove(-scraper_dim[1]/2+scraper_dim[1]/8) linear_extrude(scraper_dim[4]+0.1, center=true, $fn=128) rect([scraper_dim[1]/8,scraper_dim[0]/4], rounding=scraper_dim[1]/64);
    }
  }   
}

scraper();