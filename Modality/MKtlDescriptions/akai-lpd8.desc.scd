/* AKAI LPD8 Laptop Pad controller */
// no support for pad cc mode because it uses
// the same cc numbers then as the knobs...
// so just use pads as note on/offs.

// todo: gui layout of pads ... how?

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
	// key: \lpd8,
	'shared': (key: \shared, \ioType: \inout, midiChan: 0),

	elements: [
		(
			key: \kn,
			shared: (\elementType: \knob, \midiMsgType: \cc,
				\spec: \midiCC),
			elements: (1..8).collect { |num, i|
				(key: num.asSymbol, \midiNum: num,
					style: (row: i div: 4, column: i % 4 + 4)
				)
			}
		),
		(
			key: \pad,
			shared: (\elementType: \pad, \spec: \midiVel),
		 	elements: (36..43).collect { |num, i|
				var dict = MKtlDesc.notePair((i+1).asSymbol, num);
				dict.elements.do { |el, j|
					el.put(\style, (
						row: i div: 4 + (j * 0.45),
						column: i % 4,
						height: 0.6
					));
				};
				dict;
			}
		)
	]
)
);

/*
// A small example how to make this MKtl,
// and how to play something with it.

MKtl.find; // find all MDIDI devices and list them
MKtl('lpd').clear;
MKtl('lpd', "*lpd8"); // make an MKtl for LPD8.
MKtl('lpd').trace;

// make a gui for it
MKtl('lpd').gui;

// a synthdef
(
SynthDef(\test, {
	var sound = (SinOsc.ar( \freq.kr(400) ) * \amp.kr(1) ).softclip;
	var env = EnvGen.ar(Env.adsr,\gate.kr(1));
	Out.ar(0, sound * env * 0.25)
}).add
)

// a little voicer that keeps running synths
(
~lpdSynths = ();
MKtl('lpd').elAt(\pad, \all, \on).do { |el, i|
	el.action_({ |v|
		~lpdSynths.at(i).release;
		~lpdSynths[i] =
			Synth(\test, [\amp, v.value*30, \freq, 400+(100*i)].postln)
	})
};

MKtl('lpd').elAt(\pad, \all, \off).do { |el,i|
	el.action_({ |v|
		~lpdSynths.removeAt(i).release;
	});
};

MKtl('lpd').elAt(\kn).do { |knob, i|
	knob.action = { [knob.name, knob.value].postln };
};
)

MKtl('lpd').trace(false);
*/
