/*

ToDo:
* knob and buttons not built correctly?
- MIDIFunc.trace shows them, m.trace does not.


According to Manual,
Port 1 is for pd->comp, comp->pd: pads do noteOn/off, noteNum, velocity.
Port 2 is for pd>comp, buttons (shift, curveSetup, 4velmode, browse)
	and rot knob; browse can be sent back
Port 3 is apparently unused (i.e. reserved for company-only uses).

pads and 4velmode also send sysex on port 2;
4velmode button toggles its light, but sends noteOn/off on touch/release.
(state likely sent in sysex.)


// a little example:

MIDIFunc.trace
m = MKtl('pd_ctls', "*cmc-pd_port2");
m.trace;
m.postElements;
g = m.gui;
g.views.collect(_.view);
// example for use of relative knob:
m.elAt(\kn).action = { |el|
	var delta = el.deviceValue.fold(0, 64).wrap(-31, 32);
	[el.deviceValue, delta].postln;
};

// use it to control a parameter with RelSet
m.trace(false);
Ndef(\test, { |freq = 600| VarSaw.ar(freq) * 0.1 }).play;
Ndef(\test).gui.skipjack.dt = 0.05;

~resolution = 1;
m.elAt(\kn).action = { |el|
	var delta = el.deviceValue.fold(0, 64).wrap(-31, 32);
	// set knob relative resolution
	var uniDelta = delta / 64 * ~resolution;
	[delta, uniDelta].postln;
	RelSet(Ndef(\test), \freq, uniDelta);
};
~resolution = 0.5;
~resolution = 0.25;

*/
(
parentDesc: "steinberg-cmc-pd",
elementTypes: [\pad, \button],

status: (
	linux: "unknown",
	osx: "tested, knob and buttos not coming thru MKtl. 2016-04-16, adc",
	win: "unknown"),

idInfo: (deviceName: "Steinberg CMC-PD", srcPortIndex: 1, destPortIndex: 1),

deviceInfo: (
	vendorURI: "http://www.steinberg.net/en/products/controllers/cmc_series/models/cmc_pd.html",
	// manualURI: "",
	// description: "",
	// features: "",
	// notes: "",
),

// hm
specs: (midiRel: [0, 127, \lin, 1]),

elementsDesc:

(
// ------ noteOn Off -------------
shared: ('midiChan': 0),
elements: [
	(
		key: \bt,
		shared: ('elementType': 'pad', groupType: \noteOnOffBut, 'spec': 'midiBut'),
		elements: [
			(key: 'shift',
				shared: ( midiNum:  70, style: (row: 0, column: 1.5))),
			(key: 'curveSetup',
				shared: ( midiNum: 114, style: (row: 1, column: 0))),
			(key: '4velMode',
				shared: ( midiNum: 115, style: (row: 1, column: 1))),
			(key: 'browse',
				shared: ( midiNum:  58, style: (row: 1, column: 2)))
		]
	),
// ------ cc -------------
// relative: clockwise = 1, faster is 2, 3, 4; ccw is 65 .. 66, 67, 68..72
	(
		key: 'kn', 'midiMsgType': 'cc', 'elementType': 'knob',
		'midiChan': 0, 'midiNum':  60,'spec': 'midiRel',
		style: (row: 1, column: 3)
	)
]
)
);