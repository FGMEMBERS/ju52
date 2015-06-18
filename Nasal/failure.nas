var looptime = 0.3;


var bendload = props.globals.getNode("sim/failure/bendload");
var breakload = props.globals.getNode("sim/failure/breakload");
var breakspeed = props.globals.getNode("sim/failure/breakspeed");
var maxpermrpm = props.globals.getNode("sim/failure/max-permiss-rpm");
var maxpermboost = props.globals.getNode("sim/failure/max-permiss-boost");
var flapoverspeed = props.globals.getNode("sim/failure/flapoverspeed");
var emptyweight = props.globals.getNode("sim/failure/emptyweight");
var airspeed = props.globals.getNode("velocities/airspeed-kt");
var aileron = props.globals.getNode("controls/flight/aileron");
var rstrain = props.globals.getNode("sim/failure/engines/engine[0]/rev-strain");
var oboost = props.globals.getNode("sim/failure/engines/engine[0]/boost-strain");
var nofuel = props.globals.getNode("engines/engine[0]/out-of-fuel",1 );
var gload = props.globals.getNode("accelerations/pilot-g",1);
var weight = props.globals.getNode("yasim/gross-weight-lbs",1);
var turn = props.globals.getNode("instrumentation/turn-indicator/indicated-turn-rate");
var fail_r = props.globals.getNode("sim/failure/controls/flight/aileron/fail-norm");
var flappos = props.globals.getNode("controls/flight/flaps",1);


var main_loop = func {
	check_airframe();
  settimer(main_loop, looptime);
}

var check_airframe = func {
	var gl = gload.getValue();
	var gw = weight.getValue();
	var as = airspeed.getValue();
	var slip = turn.getValue();
	var fail = fail_r.getValue();
	var ow = gw - emptyweight.getValue();

# check flap deployment and failure due to overspeed
	if ( flappos.getValue() > 0 ) {

				if (as > flapoverspeed.getValue()) {
						print ("flaps overspeed!");
						var load = as - flapoverspeed.getValue();
						print (load*flappos.getValue());
						if (load * flappos.getValue() > 20 ) {
								if (flappos.getValue() >= 0.5 ) {
										flappos.setValue(0);
										flappos.setAttribute("writable",0);
										setprop ("/sim/failure/flaps", "1");
								}
						flappos.setValue(0);
						}
				}
		}

# check for excessive g-load or overspeed
		#print(gl, breakload - 0.0004 * ow );
	if (gl > (breakload.getValue() - 0.0003 * ow) or (as > breakspeed.getValue())) {
		print ("break");
		aileron.setAttribute("writable",0);
		if (slip < 0) {
			setprop ("sim/failure/left-wing-torn", "1");
			fail_r.setValue(1);
		} else {
			setprop ("sim/failure/right-wing-torn", "1");
			fail_r.setValue(-1);
		}
	}
	if (gl > (bendload.getValue() - 0.0004 * ow)) {
		print ("bend");
		if (slip < 0) {
			flappos.setAttribute("writable",0);
	#	} else {
	#		gear1.setAttribute("writable",0);
		}
	}		
}


var kill_engine = func {
		nofuel.setValue(1);
		nofuel.setAttribute("writable", 0);
		interpolate ("/engines/engine[0]/fuel-press", 0, 1);
		interpolate ("/engines/engine[0]/mp-osi", 0, 1.5);
}

var init = func {

		print ("Los gehts!");
 	 }  
 	 settimer(main_loop, looptime);

setlistener("/sim/signals/fdm-initialized",init);
