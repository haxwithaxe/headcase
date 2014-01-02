// http://www.thingiverse.com/thing:213934
// ================ variables

//CUSTOMIZER VARIABLES

/* [Main] */

x_inner=42;
y_inner=145;

// Wall thickness in mm
thickness=2; // [1:10]

// in mm
x_width=x_inner+thickness;

// in mm
y_width=y_inner+thickness;

// in mm
height=30/2; //wtf why does this show so tall?

// Corner roundover in mm (0=sharp corner)
radius=5; // [0:50]

// Generate the box
do_box=1; // [0:no,1:yes]

// Generate a lid
do_lid=1; // [0:no,1:yes]

// height in mm
lid_thickness=5;

//CUSTOMIZER VARIABLES END

// Button gaskets
btn_gasket=8;

// Screw pilot hole size
screw_pilot=1.125*1;

// Screw hole size
screw_hole=2.5*1;

// Whether you want the screw countersunk
screw_countersink=1;

// =============== calculated variables
lid_height=min(height/4,lid_thickness);
corner_radius=min(radius,x_width/2,y_width/2);
xadj=x_width-(corner_radius*2);
yadj=y_width-(corner_radius*2);
snugfit=0.5/2;

// 16x15mm + 3mm lower clearance + 4mm upper clearance
rj45_height=9;
rj45_len=31;
rj45_thickness=thickness+5;
rj45_pos=[xadj-34,72,thickness];

//DB9: 30wide x 9mm ?2mm clearance all around?

// PTT Button: 
ptt_btn_height=12;
ptt_btn_len=39;
ptt_btn_clearance=1.5;
ptt_btn_pos=[19,-60,thickness+8.5];

// --- Head Unit Buttons
btn_clearance=3;

// top (above screen facing up)
top_head_btn_height=8;
top_head_btn_len=55;
top_head_btn_dim=[top_head_btn_height, top_head_btn_len, thickness];
top_head_btn_pos=[-21,9,btn_clearance];

// top short (above screen facing up)
tops_head_btn_height=11.5;
tops_head_btn_len=22;
tops_head_btn_dim=[tops_head_btn_height, tops_head_btn_len, thickness];
tops_head_btn_pos=[-21,-54,btn_clearance];

// side (next to screen facing to the side)
side_head_btn_height=9;
side_head_btn_len=21.5;
side_head_btn_dim=[side_head_btn_height, side_head_btn_len, thickness];
side_head_btn_pos=[0,-72,btn_clearance];
//side_head_btn_pos=[xadj-8,0,thickness+2];

// front (below the screen facing forward)
front_head_btn_height=5;
front_head_btn_len=60;
front_btn_dim=[front_head_btn_height, front_head_btn_len, thickness];
front_head_btn_pos=[-19.6+31.5+btn_clearance,-43.6+thickness+49,-5];

// front vertical (next to the screen facing forward)
vfront_head_btn_height=28; //from bottom edge hole is 28 d(2.5);
vfront_head_btn_len=10;
vfront_head_btn_dim=[vfront_head_btn_height, vfront_head_btn_len, thickness+2];
// 94+25=119 from (screen)left edge to (screen)left edge of hole
vfront_head_btn_pos=[2.5,119/2,-3];

// push button encoder
// r=7,x=10-r,y=119+12.5abs
pbe_knob_h=thickness+5;
pbe_knob_r1=7;
pbe_knob_r2=pbe_knob_r1;
pbe_knob_dim=[pbe_knob_h, pbe_knob_r1, pbe_knob_r2];
pbe_knob_pos=[15.01-thickness-1,2-(119+12.5)/2,-5];

// coaxial dual pot
cdp_knob_h=thickness+5;
cdp_knob_r1=7;
cdp_knob_r2=cdp_knob_r1;
cdp_knob_dim=[cdp_knob_h, cdp_knob_r1, cdp_knob_r2];
cdp_knob_pos=[];

// tuning encoder
te_knob_h=thickness+5;
te_knob_r1=7;
te_knob_r2=te_knob_r1;
te_knob_dim=[te_knob_h, te_knob_r1, te_knob_r2];
te_knob_pos=[];


// =============== program

module btn(axis,dim,rpos){
	if (axis==x) {
		do(rot=[0,90,0]);
	} else if (axis==y) {
		do(rot=[0,0,90]);
	} else if (axis==z) {
		do(rot=[0,0,0]);
	} else {
		do(rot=[0,0,0]);
	};

	translate(rpos)
	rotate(rot)
	minkowski() { cube([dim[0],dim[1],dim[2]+10], center=true); }	
	
};

module knob(axis,dim,rpos){
	if (axis==x) {
		do(rot=[0,90,0]);
	} else if (axis==y) {
		do(rot=[0,0,90]);
	} else if (axis==z) {
		do(rot=[0,0,0]);
	} else {
		do(rot=[0,0,0]);
	};

	translate(rpos)
	rotate(rot)
	minkowski() { cylinder(h=dim[0], r1=dim[1], r2=dim[2], center=true); };
};

// ---- The box
if(do_box==1) translate([-((x_width/2+1)*do_lid),0,height/2-thickness]) difference() {

	union() {
		minkowski() // main body
		{
 			cube([xadj,yadj,height-lid_height],center=true);
			cylinder(r=corner_radius,h=height-lid_height);
		}

		translate([0,0,lid_height-thickness]) minkowski() // main body overlap
		{
			cube([xadj-thickness,yadj-thickness,height-(thickness*2)],center=true);
			cylinder(r=corner_radius,h=height);
		}
	}

	translate([0,0,thickness*2]) minkowski() // inside area
	{
		cube([xadj-((thickness+snugfit)*2),yadj-((thickness+snugfit)*2),height],center=true);
		cylinder(r=corner_radius,h=height);
	}

	//RJ45 jack
	poke_hole_y([rj45_height,rj45_len,rj45_thickness],rj45_pos,center=true);

	//PTT
	poke_hole_x([ptt_btn_height, ptt_btn_len, thickness+ptt_btn_clearance], ptt_btn_pos, center=false);


	// -- Head buttons

		// - Top
		btn(x, top_head_btn_dim, top_head_btn_pos);
		btn(x, tops_head_btn_dim, tops_head_btn_pos);

		// - Side
		btn(y, side_head_btn_dim, side_head_btn_pos);

		// - Front
		// Long run
		btn(z, front_btn_dim, front_head_btn_pos);
		// Short run
		btn(z, vfront_head_btn_dim, vfront_head_btn_pos, center=true);

	// -- Knobs
		// push button encoder
		// r=7,x=10-r,y=119+12.5
		//knob(pbe_knob_dim, pbe_knob_pos);

		// coaxial dual pot
		//knob(cdp_knob_dim, cdp_knob_pos);
	
		// tuning encoder
		//knob(te_knob_dim, te_knob_pos);
};

// ---------------------------------------------------------
// LID
// ---------------------------------------------------------

// Speaker
speaker_hole_h=lid_height+2;
speaker_hole_r1=10;
speaker_hole_r2=speaker_hole_r1;
speaker_hole_dim=[speaker_hole_h, speaker_hole_r1, speaker_hole_r2];
speaker_hole_pos=[0,-50,0];

// Mic
mic_hole_h=lid_height+2;
mic_hole_r1=2;
mic_hole_r2=mic_hole_r1;
mic_hole_dim=[mic_hole_h, mic_hole_r1, mic_hole_r2];
mic_hole_pos=[-15,50,0];

// ---- The lid
if(do_lid==1) translate([(x_width/2+1)*do_box,0,lid_height/2]) {
	difference(){
		difference() {
			minkowski() // main body
			{
				cube([xadj,yadj,lid_height],center=true);
				cylinder(r=corner_radius,h=lid_height);
			}

			translate([0,0,thickness]) minkowski() // inside area
			{
				cube([xadj-(thickness-snugfit),yadj-(thickness-snugfit),lid_height],center=true);
				cylinder(r=corner_radius,h=lid_height);
			}

			// Speaker
			knob(z, speaker_hole_dim, speaker_hole_pos);
			
			// Mic (electrilet)
			knob(z, mic_hole_dim, mic_hole_pos);
		}
	}
};
