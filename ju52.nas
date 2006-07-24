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


