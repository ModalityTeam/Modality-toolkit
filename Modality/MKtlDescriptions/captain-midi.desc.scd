/**** 

SAVE THIS FILE HERE: MKtlDesc.userFolder.openOS;

This is a simple description file for the Ornament and Crime eurorack module, which is a Teensy DAC. 

It is specifically for the alternative firmware Hemisphere OS which contains a midi-cv-converter called Captain Midi.

The module has:
- four trigger inputs
- four cv inputs
- four cv outputs

For this description file the module was setup to input 4 Mod midi signals and output 4 Mod midi signals. 

This was setup as described below:

Screen: MIDI Assign
MIDI > A 	Mod
MIDI > B 	Mod
MIDI > C 	Mod
MIDI > D 	Mod
1 > MIDI 	Mod
2 > MIDI 	Mod
3 > MIDI 	Mod
4 > MIDI 	Mod

Screen: MIDI Channel
MIDI > A 	1
MIDI > B 	2
MIDI > C 	3
MIDI > D 	4
1 > MIDI 	1
2 > MIDI 	2
3 > MIDI 	3
4 > MIDI 	4

****/

/****

// EXAMPLES

m = MKtl('captain', "captain-midi")
m.gui;

// Test outputs
Tdef(\outTester, { 
	loop{
		var out = ['a', 'b', 'c', 'd'].choose;
		var val = rrand(0.0,1.0);
		"Setting output % to %".format(out, val).postln;
		m.elAt('out', out).value_(val);
		0.125.wait;
	}
}).play;

// Manually set outputs
m.elAt('out, 'a').value_(0.2);
m.elAt('out','b').value_(0.7);
m.elAt('out', 'c').value_(0.1);
m.elAt('out', 'd').value_(0.9);

// Map cv inputs 
['1', '2', '3', '4'].do{|in, in_num|
	Ndef(in, {|freq=424, feedback=0.65, amp=0.5, pan=0| 
		Pan2.ar(SinOscFB.ar(freq, feedback, amp), pan)
	}).play;
	
	m.elAt('in', in).action_({|el|
		var value = el.value;
		Ndef(in).set(\freq, value.linexp(0.0,1.0,40.0,5000.0))
	});
};

****/

(
idInfo: "Hemisphere Suite",
protocol: 'midi',
deviceType: 'controller',
elementTypes: [  ],
status: (
	linux: "23-05-2020 - works, MK",
	osx: "unknown",
	win: "unknown"),

	idInfo: "Hemisphere Suite",

	// hardwarePages: [1, 2, 3, 4],

	deviceInfo: (
		vendorURI: 'https://ornament-and-cri.me/',
		manualURI: 'https://github.com/Chysn/O_C-HemisphereSuite/wiki/Captain-MIDI',
		description: "The Ornament and Crime Eurorack module, containing the Hemisphere OS.",
		features: [],
		notes: "",
		hasScribble: false
	),
	elementsDesc: ( 
		elements: [ 

			// ------ cc inputs ------------- 
			(
				key: \in,
				shared: ('midiNum': 1, 'midiMsgType': 'cc', 'elementType': 'slider', 'spec': 'midiCC'),
				elements: [
					( key: '1', 'midiChan': 0), 
					( key: '2', 'midiChan': 1), 
					( key: '3', 'midiChan': 2), 
					( key: '4', 'midiChan': 3), 
				]
			),

			// ------ cc outputs ------------- 
			(
				key: \out,
				shared: ('midiNum': 1, 'midiMsgType': 'cc', 'elementType': 'slider', 'spec': 'midiCC', 'ioType': \out),
				elements: [
					(key: 'a', 'midiChan': 0), 
					(key: 'b', 'midiChan': 1), 
					(key: 'c', 'midiChan': 2), 
					(key: 'd', 'midiChan': 3), 
				]
			)
		]
	)
);
