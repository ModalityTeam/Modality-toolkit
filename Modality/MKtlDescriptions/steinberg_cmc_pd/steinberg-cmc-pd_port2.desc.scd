/*
According to Manual,
Port 1 is for pd->comp, comp->pd: pads do noteOn/off, noteNum, velocity.
Port 2 is for pd>comp, buttons (shift, curveSetup, 4velmode, browse)
	and rot knob; browse can be sent back
Port 3 is apparently unused (i.e. reserved for company-only uses).

pads and 4velmode also send sysex on port 2;
4velmode button toggles its light, but sends noteOn/off on touch/release.
(state likely sent in sysex.)


// a little example:

m = MKtl('pd_ctls', "steinberg-cmc-pd_port2").trace;

// example for use of relative knob:
m.elementAt(\kn).action = { |el|
	var delta = el.deviceValue.fold(0, 64).wrap(-31, 32);
	[el.deviceValue, delta].postln;
};

// use it to control a parameter with RelSet
m.trace(false);
Ndef(\test, { |freq = 600| VarSaw.ar(freq) * 0.1 }).play;
Ndef(\test).gui.skipjack.dt = 0.05;

~resolution = 1;
m.elementAt(\kn).action = { |el|
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

deviceName: "Steinberg CMC-PD",
protocol: \midi,
deviceType: \drumPad,
elementTypes: [\pad, \button],

status: (
	linux: "unknown",
	osx: "tested and working, minus out and sysex",
	win: "unknown"),

idInfo: (deviceName: "Steinberg CMC-PD", sourcePortIndex: 1, destPortIndex: 1),

deviceInfo: (
	vendorURI: "http://www.steinberg.net/en/products/controllers/cmc_series/models/cmc_pd.html",
	// manualURI: "",
	// description: "",
	// features: "",
	// notes: "",
),

// hm
specs: (midiRel: [0, 127, \lin, 1]),

description:

(
// ------ noteOnOff -------------

'shift': ('midiMsgType': 'noteOnOff', 'type': 'key', 'midiChan': 0, 'midiNum':  70, 'spec': 'midiBut'),
'curveSetup': ('midiMsgType': 'noteOnOff', 'type': 'key', 'midiChan': 0, 'midiNum':  114, 'spec': 'midiNote'),
'4velMode': ('midiMsgType': 'noteOnOff', 'type': 'key', 'midiChan': 0, 'midiNum':  115, 'spec': 'midiNote'),
'browse': ('midiMsgType': 'noteOnOff', 'type': 'key', 'midiChan': 0, 'midiNum':  58, 'spec': 'midiNote'),

// ------ cc -------------
// relative: clockwise = 1, faster is 2, 3, 4; ccw is 65 .. 66, 67, 68..72

'kn': ('midiMsgType': 'cc', 'type': 'slider', 'midiChan': 0, 'midiNum':  60,'spec': 'midiRel'),
)
);