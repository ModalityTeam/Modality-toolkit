//Connecting a synth to knob

(
k = MIDIMKtl('bcr20000'); //change to your own controller
k.reset; //reset controller to a clean state
~knob = k.esFor(\kn_7_1); //change to your own controller

//start synth
~synth = { |freq=400| LFNoise0.ar(freq)*0.2 }.play;

//associate each result EventSource with a synth
~knob.do{ |v| ~synth.set(\freq, v.linlin(0.0,1.0,100.0,4000.0) ) };
)