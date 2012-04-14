(
k = MIDIMKtl('bcr20000'); //change to your own controller
k.reset; //reset controller to a clean state
~button = k.esFor(\pr_2_1); //change to your own controller
~knob = k.esFor(\kn_7_1); //change to your own controller

//start synths
~synths = [
	{ |freq=400| SinOsc.ar(freq)*0.2 }.play,
	{ |freq=400| Saw.ar(freq)*0.2 }.play,
	{ |freq=400| LFNoise0.ar(freq)*0.2 }.play,
	{ |freq=400| Blip.ar(freq)*0.2 }.play
];

//iterate though all 4 actions by pressing one button
~selector = ~button.toggle(~synths.size);
~selector.do{ |i| postln("Selector : "++[\sine, \saw, \noise, \blip][i]) };

//an event source that emits nothing (because we will never fire it)
~emitsNothing = EventSource();

//create 4 EventSources, one that only fires when selector is 0, another when it is 1, etc.
~actions = ~synths.size.collect{ |i|
	~selector.flatCollect{ |v|
		if( v == i ) {
			~knob
		} {
			~emitsNothing
		}
	}
};

//associate each result EventSource with a synth
[~actions, ~synths].flopWith{ |es,synth|
	es.do{ |v| synth.set(\freq, v.linlin(0.0,1.0,100.0,4000.0) ) }
};
//initialize selector
~selector.fire(0);

//gui for visualization
~guiSynths = ~synths.collect{ Knob() };
~guiKnob = Knob();
w = Window(bounds:Rect(200,200,200,100)).layout_(
	 VLayout(
Ê Ê 	HLayout( ~guiKnob ),
		HLayout( *~guiSynths ),
	)
).front;
~knob.connect(~guiKnob);
[~guiSynths,~actions].flopWith{ |a,b|
	b.connect(a)
};
)
	

//there is a template for this: route

//route( numberOfResults, selectorEventSource )

(
k = MIDIMKtl('bcr20000');
k.reset;

~synths = [
	{ |freq=400| SinOsc.ar(freq)*0.2 }.play,
	{ |freq=400| Saw.ar(freq)*0.2 }.play,
	{ |freq=400| LFNoise0.ar(freq)*0.2 }.play,
	{ |freq=400| Blip.ar(freq)*0.2 }.play
];

//iterate though all 4 actions by pressing one button
~selector = k.esFor(\pr_2_1).toggle(~synths.size);
~selector.do{ |i| postln("Selector : "++[\sine, \saw, \noise, \blip][i]) };

~actions = k.esFor(\kn_7_1).route(~synths.size, ~selector);
//associate each result EventSource with a synth
[~actions, ~synths].flopWith{ |es,synth|
	es.do{ |v| synth.set(\freq, v.linlin(0.0,1.0,100.0,4000.0) ) }
};
~selector.fire(0);
//gui for visualization
~guiSynths = ~synths.collect{ Knob() };
~guiKnob = Knob();
w = Window(bounds:Rect(200,200,200,100)).layout_(
	 VLayout(
Ê Ê 	HLayout( ~guiKnob ),
		HLayout( *~guiSynths ),
	)
).front;
~knob.connect(~guiKnob);
[~guiSynths,~actions].flopWith{ |a,b|
	b.connect(a)
};
)
