//With EventSource
(
k = MIDIMKtl('bcr20000'); //change to your own controller
k.reset; //reset controller to a clean state
~button = k.esFor(\pr_2_1); //change to your own controller
~knob = k.esFor(\kn_7_1); //change to your own controller

//start synth
~synth = { |freq=400| LFNoise0.ar(freq)*0.2 }.play;

//an event source that emits nothing
~emitsNothing = NothingES();

~result = ~button.flatCollect{ |v|
		if( v == 1.0 ) {
		~knob
	} {
		~emitsNothing
	}
};
//associate each result EventSource with a synth
~result.do{ |v| ~synth.set(\freq, v.linlin(0.0,1.0,100.0,4000.0) ) };

//gui for visualization
~guiKnob = Knob();
~guiResult = Knob();
~guiButton = Button().states_([
	["0", Color.white, Color.black],
	["1", Color.black, Color.red],
]);
w = Window(bounds:Rect(200,200,200,100)).layout_(
	 VLayout(
Ê Ê 	HLayout( ~guiKnob, ~guiResult  ),
		HLayout( ~guiButton ),
	)
).front;
~knob.connect(~guiKnob);
~result.connect(~guiResult);
~button.connect(~guiButton);
)

//with signal
(
k = MIDIMKtl('bcr20000'); //change to your own controller
k.reset; //reset controller to a clean state
~button = k.signalFor(\pr_2_1); //change to your own controller
~knob = k.signalFor(\kn_7_1); //change to your own controller

//start synth
~synth = { |freq=400| LFNoise0.ar(freq)*0.2 }.play;

//an signal that emits nothing (because we will never change it)
~emitsNothing = Var(400);

~result = ~button.flatCollect{ |v|
		if( v == 1.0 ) {
		~knob
	} {
		~emitsNothing
	}
};


//associate each result EventSource with a synth
~result.do{ |v| ~synth.set(\freq, v.linlin(0.0,1.0,100.0,4000.0) ) };

//gui for visualization
~guiKnob = Knob();
~guiResult = Knob();
~guiButton = Button().states_([
	["0", Color.white, Color.black],
	["1", Color.black, Color.red],
]);
w = Window(bounds:Rect(200,200,200,100)).layout_(
	 VLayout(
Ê Ê 	HLayout( ~guiKnob, ~guiResult  ),
		HLayout( ~guiButton ),
	)
).front;
~knob.connect(~guiKnob);
~result.connect(~guiResult);
~button.connect(~guiButton);
)
