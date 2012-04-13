(
	var withGui = true;
//one controller
MIDIMKtl.find;
//with nanokontrol
k = MKtl('nnkn0');
k.reset;
~synths !? { |x| x.do(_.free) };
/*
change to this if you don't have a nanokontrol
k =  MKtl.make('nnkn0', 'nanoKONTROL'); 
*/

//some controls that control some synthesis process
~knobs = k.esFor((1..4).collect{ |i| [\kn,i,1] });

//the button that enters selection mode
~but = k.esFor(\bu_1_1);
~nothing = EventSource(); 

//selection mode is entered when ~but is set to 1
//it is exited when two different knobs are moved
~but.do{ |x| if(x == 1){ "entering remap mode".postln } };
~exchange = ~but.flatCollect{ |y|
	var selection;
	//enter remap mode
	if( y == 1) {
		//two different knobs are moved
		selection = ~knobs.collect{ |x,i| x.collect{i} }.reduce('|')
		.inject([false],{ |state,x|
			//("knob "++x++" selected for exchange").postln;
			(switch(state.size) 
				{1} { [false,x] }
				{2} { if(x != state.last) { [true,state.last,x] } { state} }
				{3} { [false,0,0] });
		}).select{ |x| x[0] == true}.collect{ |array| [array[1],array[2]] };
	} {	
		//exit remap mode
		"exiting remap mode 1".postln;			
		~nothing	
	}
};
~exchange.do{ |x| ("Exchanging actions of knobs "++x).postln };

//index i of this array is the knob that will go into action i;
~startState = [0,1,2,3]; //which knobs go to which action

//~exchange = EventSource();
~sel = ~exchange.inject(~startState, { |state, exchangePair|
		var indexA = state.indexOf(exchangePair[0]);
		var indexB = state.indexOf(exchangePair[1]);	
		//("Exchange pair: "++exchangePair).postln;	
		//postln("state :" ++state);
		state.swap(indexA, indexB);	
});

f = { |i| { |state|
	~knobs[state[i]]	
}};

//between receiving 1 on ~but and ~receiving a zero, or receiving something from ~exchange do nothing.
g = { |i| (~but | ~exchange).flatCollect({ |x|
	if(x == 1) {
		~nothing
	} {
		~sel.flatCollect(f.(i),~knobs[~selSignal.now[i]]);
	} },~knobs[i]);
};

~selSignal = ~sel.hold([0,1,2,3]);

~outputs = 4.collect{ |i| g.(i) };

~synths = [
	{ |freq=400| Pan2.ar( SinOsc.ar(freq)*0.2, -1.0) }.play,
	{ |freq=400| Pan2.ar( Saw.ar(freq)*0.2, -0.2) }.play,
	{ |freq=400| Pan2.ar( LFNoise0.ar(freq)*0.2, 0.6) }.play,
	{ |freq=400| Pan2.ar( LPF.ar( WhiteNoise.ar, freq)*0.6, 1.0) }.play
];
[~outputs, ~synths].flopWith{ |es, synth|
	es.do{ |v|
		synth.set(\freq, v.linlin(0.0,1.0,200.0,2000.0))
	}
};

//GUI
if( withGui ) {
w !? _.close;
~guiKnobs = 4.collect{ Knob() };
~labels = ["SinOsc","Saw","LFNoise","WhiteNoise"];

~guiTV = ~labels.collect{ |st| TextView().string_(st) };
w = Window(bounds:Rect(200,200,200,100)).layout_(
	 VLayout(
		HLayout( *~guiKnobs ),
		HLayout( *~guiTV ),
	)
		
).front;
[~knobs, ~guiKnobs].flopWith{ |knob,gui|
	knob.connect(gui)
};
~sel.do{ |array|
	array.postln;
	[array, ~labels].flopWith{ |i, label|
		defer{ ~guiTV[i].string_(  label ) }
	}
}
} {
	~outputs.do{ |es,i| es.do{ |x| ("action "++i++" got a "++x).postln } };
}
)
