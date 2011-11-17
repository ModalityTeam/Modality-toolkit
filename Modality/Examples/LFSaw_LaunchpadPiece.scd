/*** 

This is a piece by Till Bovermann which shows basic uses 
of the MKtl and MIDIKtl classes. 

It takes a Novation Launchpad, and configures it for everything 
needed to play that simple piece. 
(The Launchpad needs drivers from Novation installed.)

Requires SC 3.5 beta or better!

***/



(
q = ();	// a dict for various objects


// the interface to set the LEDs on the Launchpad:
q.lnch = MIDIMKtl(\lnch0);


// the interface to set LEDs
q.lnhout = LaunchpadOut(q.lnch);
q.lnhout.reset; // reset it

// button names
q.btNames =  (0..63).collect{|idx| ("bu"++idx).asSymbol}; 
// arrow button names
q.arNames = (0..7).collect{|i| ("ar"++i).asSymbol};

	// test pattern for setting the LED colors:
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
)
// check whether the device is actually working

MIDIMKtl(\lnch0).verbose = true;		// see post window

MIDIMKtl(\lnch0).verbose = false;	// shut up again

// boot the soundserver
s.boot;
s.latency = 0.05;

s.makeWindow;



(
// make a Dispatch by hand that makes all the buttons toggle:

q.toggleDispatch = MDispatch.new;

	// introduce the dispatch to a source (the launchpad), 
	/// and tell it which elemKeys to listen for: 
q.toggleDispatch.map(q.lnch, q.btNames);

	// create outputs for the inputs 
	// - and these outputs will have the same names as the inputs.
q.toggleDispatch.createOutputsFromInputs;

	// set up a place in the dispatch's envir where the toggle states 
	// can be stored and looked up; store the current state (0)
q.toggleDispatch.envir[\states] = ();
q.btNames.do{|name|  q.toggleDispatch.envir[\states].put(name, 0)};
q.toggleDispatch.addToProc( \toggle, {  |dis|
	var env = dis.envir;
	var in = env[\changedIn]; // the thing that changed
	var key = in[\key];
	var val = in[\val];

	if (val == 1) {
		env[\states][key] = 1-env[\states][key];
		dis.setOutput(key,env[\states][key])
	}
});
)


(
	// set lights according to toggle state
q.btNames.do{|name| 
	q.toggleDispatch.addFuncElem(name, \setLight, {|element|
		var idx = q.btNames.indexOf(element.name);
		
		q.lnhout.setColor([idx div: 8, idx % 8], [[\green, \fGreen], [\red, \fRed]][idx%2][element.value])
	})
};

	// ticker - LEDs can blink from remote clock, as here
q.ticker.stop;
q.ticker = SkipJack({q.lnhout.tick}, 0.25)
)


	// use one custom button on top to control the Ndef
	// that will generate the sound
(
q.lnch.addFuncElem(\up, \muteGrid, {|elem|
	elem.value.postln;
	elem.value.booleanValue.if({
		Ndef(\murder).set(\mute, 0);
	},{
		Ndef(\murder).set(\mute, 1);
	})
});
)

	// create Ndefs for the sounds
NdefMixer(s);

(
Ndef(\murder, {|mute = 1|
	var freq;
	var ctrls = q.btNames.collect{|elem|
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
);
