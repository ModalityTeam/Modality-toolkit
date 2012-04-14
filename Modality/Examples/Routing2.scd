
//select from multiple knobs to one synth:

(
k = MIDIMKtl('bcr20000'); //change to your own controller
k.reset; //reset controller to a clean state
~button = k.esFor(\pr_2_1); //change to your own controller
~knobs = k.esFor( (1..8).collect{ |i| [\kn,7,i] }); //change to your own controller

//start synth
~synth = { |freq=400| LFNoise0.ar(freq)*0.2 }.play;

//an event source that emits nothing (because we will never fire it)
~emitsNothing = EventSource();

~selector = ~button.toggle(8);
~selector.do{ |i| postln( "Using knob "++(i+1) ) };
~result = ~selector.flatCollect{ |i|
		~knobs[i]
};
//associate each result EventSource with a synth
~result.do{ |v| ~synth.set(\freq, v.linlin(0.0,1.0,100.0,4000.0) ) };
//initialize selector


//gui for visualization
~guiKnobs = ~knobs.collect{ Knob() };
~guiSynth = Knob();
~tfield = TextField();
w = Window(bounds:Rect(200,200,200,100)).layout_(
	 VLayout(
Ê Ê 	HLayout( *~guiKnobs ),
		HLayout( ~guiSynth, ~tfield   ),
	)
).front;
~result.connect(~guiSynth);
~selector.collect{|i| "knob "++(i+1) }.connect(~tfield); 
[~guiKnobs,~knobs].flopWith{ |a,b|
	b.connect(a)
};

~selector.fire(0);
)