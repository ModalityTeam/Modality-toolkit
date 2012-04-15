
//Acumulate values

//as you move the knob the modulation frequency rises until it gets to a maximum and it returns to the minimum value
(
k = MIDIMKtl('bcr20000'); //change to your own controller
k.reset; //reset controller to a clean state
~knob = k.esFor(\kn_7_1); //change to your own controller

//start synth
~synth = { |freq=5| SinOsc.ar( LFNoise0.ar(freq).range(50,[200,210]) ) }.play;

//an event source that emits nothing (because we will never fire it)
~emitsNothing = EventSource();

~result = ~knob.inject(0.0, { |state,x|
	(state+0.001).mod(1.0)
});	
~result.do{ |v| postln("Current mod frequency : "++v.linlin(0.0,1.0,1,10.0) ) };
//associate each result EventSource with a synth
~result.do{ |v| ~synth.set(\freq, v.linlin(0.0,1.0,1,10.0) ) };

//gui for visualization
~guiKnob = Knob();
~guiResult = Knob();
w = Window(bounds:Rect(200,200,200,100)).layout_(
	 HLayout( ~guiKnob, ~guiResult )
).front;
~knob.connect(~guiKnob);
~result.connect(~guiResult);
)