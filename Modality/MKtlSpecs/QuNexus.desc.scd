/*
todo:
QuNexus has other modes with  tilt and poly pressure.

* add the missing controls.

* how to do rotating allocation of ccs?
* add global noteOn/Off MIDIdefs to MIDIMKtl

// mini code example:
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



	// Togl A mode has these:
// ------ noteOn -------------

	keyOn: (24..108).collect { |midinote|
	('midiMsgType': 'noteOn', 'type': 'key', 'midiChan': 0, 'midiNum':  midinote, 'spec': 'midiNote') },
	// ---------noteOff ----------
	keyOff: (24..108).collect { |midinote|
		('midiMsgType': 'noteOff', 'type': 'key', 'midiChan': 0, 'midiNum':  midinote, 'spec': 'midiNote')
	},

// ------- bend ------------
	'bend': ('midiMsgType': 'bend', 'type': 'bender', 'midiChan': 0, 'midiNum':  0,'spec': 'midiBend'),

// Velo B mode adds single channel pressure from all keys :

// ------- cc ------------
'monotouch': ('midiMsgType': 'cc', 'type': 'slider', 'midiChan': 0, 'midiNum':  1,'spec': 'midiCC'),
)
);



 