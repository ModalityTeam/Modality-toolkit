GUI.cocoa

q = ();

// the launchpad
q.lnch = MIDIMKtl(\lnch0);


// the interface to set LEDs
q.lnhout = LaunchpadOut(q.lnch);
q.lnhout.reset; // reset it

// button names
q.names =  (0..63).collect{|idx| ("bu"++idx).asSymbol}; 
// arrow button names
q.arNames = (0..7).collect{|i| ("ar"++i).asSymbol};

( 
// initially set colors of the pad; 
// green buttons will play on the left  side 
// red   buttons will play on the right side 
(0..7).do{|j|
[0, 2, 4, 6].do{|i|
	q.lnhout.setColor([j, i], \green);
	q.lnhout.setColor([j, i+1], \red)
}}
)

// test is the device is actually working
MIDIMKtl(\lnch0).verbose = true;
MIDIMKtl(\lnch0).verbose = false;

// boot the soundserver
s.boot;



(
// Dispatch
q.toggleDispatch = Dispatch.new;

// create

q.toggleDispatch.map(q.lnch, q.names);
// create outputs for the inputs
q.toggleDispatch.createOutputsFromInputs;
q.toggleDispatch.envir.states = ();
q.names.do{|name|  q.toggleDispatch.envir.states.put(name, 0)};
q.toggleDispatch.addToProc( \toggle, {  |dis,env|
	var in = dis.changedIn; // the thing that changed
	var key = in[\key];
	var val = in[\val];

	if (val == 1) {
		env[\states][key] = 1-env[\states][key];
		dis.setOutput(key,env[\states][key])
	}
});
)

(
// set lights
q.names.do{|name| 
	q.toggleDispatch.addToOutput(name, \setLight, {|element|
		var idx = q.names.indexOf(element.name);
		
		q.lnhout.setColor([idx div: 8, idx % 8], [[\green, \fGreen], [\red, \fRed]][idx%2][element.value])
	})
};

q.ticker.stop;
q.ticker = SkipJack({q.lnhout.tick}, 0.25)
)

(
q.lnch.addFunc(\up, \muteGrid, {|elem|
	elem.value.booleanValue.if({
		Ndef(\murder).set(\mute, 0);
	},{
		Ndef(\murder).set(\mute, 1);
	})
});
q.lnch.addFunc(\left, \longTail, {|elem|
	elem.value.booleanValue.if({
		Ndef(\crackle).set(\tail, 0);
	},{
	})
});
q.lnch.addFunc(\right, \shortTail, {|elem|
	elem.value.booleanValue.if({
		Ndef(\crackle).set(\tail, 6);
	},{
	})
});
q.lnch.addFunc(\session, \clicky, {|elem|
	elem.value.booleanValue.if({
		Ndef(\crackle).set(\clicky, 0.0004);
	},{
	})
});
q.lnch.addFunc(\user1, \clicky, {|elem|
	elem.value.booleanValue.if({
		Ndef(\crackle).set(\clicky, 0.004);
	},{
	})
});
q.lnch.addFunc(\user2, \clicky, {|elem|
	elem.value.booleanValue.if({
		Ndef(\crackle).set(\crackle, 5);
	},{
	})
});
q.lnch.addFunc(\mixer, \clicky, {|elem|
	elem.value.booleanValue.if({
		Ndef(\crackle).set(\crackle, 30);
	},{
	})
})
)

q.toggleDispatch[\bu0].kr
s.latency = 0.05

NdefMixer(s)
(
Ndef(\murder, {|mute = 1|
	var freq;
	var ctrls = q.names.collect{|elem|
		q.toggleDispatch[elem].kr
	}.lag(0, 1);
	
	(ctrls.size.collect{|i|
		freq = 64 + (i * 2);
		(LPF.ar(
			SinOsc.ar([1, 0.5] * freq, 0.5, AmpComp.ir(freq)).sum 
			+ WhiteNoise.ar(0.25), i.linexp(0, 63, 50, 20000)
		) 
		//* LFPulse.ar(0.2 * (i+1), i/64, 0.2, mul: 0.5, add: 0.2)
		//* LFPulse.ar(0.130874 * (i+1), i/64, 0.2, mul: 0.5, add: 0.2)
		).tanh * i.linlin(0, 7, 1, 0.125)
		* SinOsc.ar(i.linlin(0, 64, 5, 1.25).round(1.25), rrand(0, 0.1)).range(0.25, 1) * mute
	} * ctrls).clump(2).sum.tanh ;
})	 
)


/*
q.lnch.verbose = true
q.lnch.verbose = false
*/
Ndef(\crackle).clear
(
Ndef(\crackle, {|tail = 3, clicky = 0.04, crackle = 30|
	var freq, src;
	var ctrls = q.arNames.collect{|elem|
		q.lnch[elem].kr
	};
	clicky = clicky.lag(10);
	(ctrls.collect{|ctrl, i|
		src = ({Dust.ar(crackle.lag(2))}!2);
		src = Decay.ar(src, 0.001) * BrownNoise.ar; 
		src = src.collect{|src|
		Ringz.ar(
			src * 0.4, 
			EnvGen.ar(Env([1000]++({exprand(500, 1700.0)}!10), ({1.0.rand}!9) ++[0]), levelScale: (i+1) * 0.2 + 2, gate: ctrl), 
			clicky
		)
		};
		src * SinOsc.ar(i+1).range(0.1, 1) * ctrl.lag(0, tail)
	}.postln ).sum.tanh ;
})	 
)
