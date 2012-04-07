(
//one controller
MIDIMKtl.find;
//with nanokontrol
k = MKtl('nnkn0');		
k.reset;
//change to this if you don't have a nanokontrol
//k =  MKtl.make('nnkn0', 'nanoKONTROL'); 
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
		.fold([],{ |state,x|
			//("knob "++x++" selected for exchange").postln;
			if(state.size ==0 or: { x != state.last}) {
				state++[x]
			} {
				state
			}				
		}).select{ |x| x.size == 2};
	} {	
		//exit remap mode
		"exiting remap mode 1".postln;			
		~nothing	
	}
};
~exchange.do{ |x| ("Exchanging knob connected to action "++x[0]++" with knob connected to action "++x[1]).postln };

//index i of this array is the knob that will go into action i;
~startState = [0,1,2,3]; //which knobs go to which action

//~exchange = EventSource();
~sel = ~exchange.fold(~startState, { |state, exchangePair|
		var indexA = state.indexOf(exchangePair[0]);
		var indexB = state.indexOf(exchangePair[1]);	
		//("Exchange pair: "++exchangePair).postln;	
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

~actions = 4.collect{ |i| g.(i) };

~actions.do{ |es,i| es.do{ |x| ("action "++i++" got a "++x).postln } };
~synths = [
	{ |freq=400| SinOsc.ar(freq)*0.2 }.play,
	{ |freq=400| Saw.ar(freq)*0.2 }.play,
	{ |freq=400| LFNoise0.ar(freq)*0.2 }.play,
	{ |freq=400| Blip.ar(freq)*0.2 }.play
];
[~actions, ~synths].flopWith{ |es, synth|
	es.do{ |v|
		synth.set(\freq, v.linlin(0.0,1.0,200.0,2000.0))
	}
};
)