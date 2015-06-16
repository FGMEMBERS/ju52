var looptime = 0.3;


toggle_ldoor = func {
  if(getprop("/controls/gear/ldoor-pos-norm") > 0) {
    interpolate("/controls/gear/ldoor-pos-norm", 0, 3);
  } else {
    interpolate("/controls/gear/ldoor-pos-norm", 1, 3);
  }
}


toggle_rdoor = func {
  if(getprop("/controls/gear/rdoor-pos-norm") > 0) {
    interpolate("/controls/gear/rdoor-pos-norm", 0, 3);
  } else {
    interpolate("/controls/gear/rdoor-pos-norm", 1, 3);
  }
}


var update_mp_props = func {
	# print ("updating...");
	setprop("sim/multiplay/generic/int[0]", getprop ("/sim/model/variant"));


	var state = 0;
	if (getprop ("sim/failure-manager/burning")) {
			state = state +1;
	}
	if (getprop ("sim/failure-manager/smoking")) {
			state = state +2;
	}
	setprop ("sim/failure-manager/fail-type",state);
	# print ("State: ", state);
	setprop("sim/multiplay/generic/int[10]", getprop ("/sim/failure-manager/fail-type"));

 	settimer(update_mp_props, looptime);
}

setlistener("/sim/signals/fdm-initialized",update_mp_props);

aircraft.livery.init("Aircraft/ju52/Models/Liveries");

var leftdoor = aircraft.door.new ("/controls/doors/doorL/",1.5);

var rightdoor = aircraft.door.new ("/controls/doors/doorR/",1.5);
