/*
TODO:

QuNexus has other modes which add tilt and poly pressure

* Add controls from Presets C and D.

Q: how to do the rotating allocation of ccs and bend?


// mini code example of global note resp + voicer:

z = MIDIMKtl('qnxs0');
// indiv element actions on lowest key
z.elementAt(\keyOn, 24).action = { |el| [el.name, el.value].postln };
z.elementAt(\keyOff, 24).action = { |el| [el.name, el.value].postln };

// add a global noteOn function:
z.global.put(\noteOn, MFunc([
	\debug, { |...args| [\noteOn, \global, args].postln }
]));

// make an NPVoicer
s.boot;
v = NPVoicer(Ndef(\piano));
v.prime(\default); // prepare with \default synthdef
v.play;

// test playing and releasing a note from code
v.put(51, [\freq, 51.midicps]);
v.release(51);

// add global noteOn function
z.global[\noteOn].add(\note1, { |chan, note, vel|
	v.put(note, [\freq, note.midicps, \amp, (vel/127).squared ].postln);
});

z.global[\noteOff] = MFunc();
z.global[\noteOff].add(\note1, { |chan, note| v.release(note.postln); });

*/



(
device: "QuNexus",
protocol: \midi,
description: (



	// Preset A mode has these:
// ------ noteOn -------------

	keyOn: (24..108).collect { |midinote|
	('midiMsgType': 'noteOn', 'type': 'key', 'midiChan': 0, 'midiNum':  midinote, 'spec': 'midiNote') },
	// ---------noteOff ----------
	keyOff: (24..108).collect { |midinote|
		('midiMsgType': 'noteOff', 'type': 'key', 'midiChan': 0, 'midiNum':  midinote, 'spec': 'midiNote')
	},

// ------- bend ------------
	'bend': ('midiMsgType': 'bend', 'type': 'bender', 'midiChan': 0, 'midiNum':  0,'spec': 'midiBend'),

// Preset B mode adds single channel pressure from all keys :

// ------- cc ------------
'monotouch': ('midiMsgType': 'cc', 'type': 'slider', 'midiChan': 0, 'midiNum':  1,'spec': 'midiCC'),
)

// Preset C mode adds Poly Pitch Bend on up to 10 channels rotating,
// plus pressure on cc1 (also rotating?)

// Preset D mode for drums and clips

);
