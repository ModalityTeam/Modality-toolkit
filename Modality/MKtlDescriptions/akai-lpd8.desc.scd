/* AKAI LPD8 Laptop Pad controller */
// no support for pad cc mode because it use
// the same cc numbers then as the knobs...

(
deviceName: "LPD8",
protocol: \midi,
deviceType: \drumpad,
elementTypes: [\pad, \knob],
status: (
	osx: "tested and working",
	linux: "unkown",
	win: "unknown"
),

idInfo: "LPD8",

deviceInfo: (
	vendorURI: "http://www.akaipro.com/product/lpd8",
	manualURI: "http://www.akaipro.com/product/lpd8#downloads",
	description: "a basic drumpad controller", // one line text
	features: [
		"8 velocity-sensitive pads",
		"8 knobs",
		"4 mode-switching buttons"
	],
	notes: "use only recommended hardware mode PAD.",
),

elementsDesc: (
	key: \lpd8,
	'shared': (key: \shared, \ioType: \inout, midiChan: 0),

	elements: [
		(
			key: \kn,
			shared: (\elementType: \knob, \midiMsgType: \cc,
				\spec: \midiCC),
			elements: (1..8).collect { |num|
				(key: num.asSymbol, \midiNum: num)
			}
		),
		(
			key: \pad,
			shared: (\elementType: \pad, midiMsgType: \noteOnOff,
				\spec: \midiVel),
			elements: (36..43).collect { |num, i|
				(key: (i+1).asSymbol, midiNum: num)
			}
		)
	]
)
);

/*
// A small example how to make this MKtl,
// and how to play something with it.

MKtl.find; // find all MDIDI devices and list them
MKtl('lpd', "*lpd8"); // make an MKtl for LPD8.
MKtl('lpd').trace;

// make a gui for it
MKtl('lpd').gui;

// a synthdef
(
SynthDef(\test, {
	var sound = (SinOsc.ar( \freq.kr(400) ) * \amp.kr(1) ).clip;
	var env = EnvGen.ar(Env.adsr,\gate.kr(1));
	Out.ar(0, sound * env * 0.5)
}).add
)

// a little voicer that keeps running synths
(
~lpdSynths = ();
MKtl('lpd').elementAt(\pad, \on).do { |el, i|
	el.action_({ |v|
		~lpdSynths.at(i).release;
		~lpdSynths[i] =
			Synth(\test, [\amp, v.value*30, \freq, 400+(100*i)].postln)
	})
};

MKtl('lpd').elementAt(\pad, \off).do { |el,i|
	el.action_({ |v|
		~lpdSynths.removeAt(i).release;
	});
};

MKtl('lpd').elementAt(\kn).do { |knob, i|
	knob.action = { [knob.name, knob.value].postln };
};
)

*/
