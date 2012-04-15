//sum two signals
(
k = MIDIMKtl('bcr20000'); //change to your own controller
k.reset; //reset controller to a clean state
~knob1 = k.signalFor(\kn_7_1); //change to your own controller
~knob2 = k.signalFor(\kn_7_2); //change to your own controller

//make into array
r = (_+_) <%> ~knob1 <*> ~knob2;

~synth = { SinOsc.ar( \freq.kr(400) )*0.1 }.play;

r.do{ |v| ~synth.set(\freq, v.linlin(0.0,2.0,200,400.0) ) };
r.do( _.postln )
)
