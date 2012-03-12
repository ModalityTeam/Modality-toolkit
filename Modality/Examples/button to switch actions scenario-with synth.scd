
(
//one controller
MIDIMKtl.find;
k = MKtl('nnkn0');
//some controls that control some synthesis process
~knob1 = k.elements[\kn1_1].eventSource;
~knob2 = k.elements[\kn2_1].eventSource;
~knob3 = k.elements[\kn3_1].eventSource;
~knob4 = k.elements[\kn4_1].eventSource;
~knobs = [~knob1, ~knob2, ~knob3, ~knob4];

//the button that enters selection mode
~but = k.elements[\bu1_1].eventSource;
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
	switch(state[i])
		{0}{~knob1}
		{1}{~knob2}
		{2}{~knob3}
		{3}{~knob4}	
	
} };

//between receiving 1 on ~but and ~receiving a zero, or receiving something from ~exchange do nothing.
g = { |i| (~but | ~exchange).flatCollect({ |x|
	if(x == 1) {
		~nothing
	} {
		~sel.flatCollect(f.(i),~knobs[~selSignal.now[i]]);
	} },~knobs[i]);
};

~selSignal = ~sel.hold([0,1,2,3]);

~action1 = g.(0);
~action2 = g.(1);
~action3 = g.(2);
~action4 = g.(3);

~action1.do{ |x| ("action 1 got a "++x).postln };
~action2.do{ |x| ("action 2 got a "++x).postln };
~action3.do{ |x| ("action 3 got a "++x).postln };
~action4.do{ |x| ("action 4 got a "++x).postln };
~actions = [~action1, ~action2, ~action3, ~action4];
~synths = [
	{ |freq=400| SinOsc.ar(freq)*0.2 }.play,
	{ |freq=400| Saw.ar(freq)*0.2 }.play,
	{ |freq=400| LFNoise0.ar(freq)*0.2 }.play,
	{ |freq=400| Blip.ar(freq)*0.2 }.play
];
~actions.do{ |a, i|
	a.do{ |v|
		~synths[i].set(\freq, v.linlin(0.0,1.0,200.0,2000.0))
	}
};
)