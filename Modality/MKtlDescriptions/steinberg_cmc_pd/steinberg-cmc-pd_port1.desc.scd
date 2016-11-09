/*

* TODO:
* implement and test out to device and sysex.
* make special mode or example for 4vel mode


According to Manual,
Port 1 is for pd->comp, comp->pd: pads do noteOn/off, noteNum, velocity.
Port 2 is for pd>comp, buttons (shift, curveSetup, 4velmode, browse)
and rot knob; browse can be sent back
Port 3 is apparently unused (i.e. reserved for company-only uses).

pads and 4velmode also send sysex on port 2;
4velmode button toggles light, but sends noteOn/off on touch/release.
- state is likely sent in sysex?

--- velocity value is always 16!
--- 4velmode is same note on buts 1,5,9,13 etc; vel 31, 63, 95, 127.

- shift button is used to switch between note combinations on the pads:
- shift1, pads 1-16:
1: [35, 36, 38, 40,   39,44,42,46,   41,45,47,48,  51,55,49,56],
2: (4..19),
3: (20..35),
4: (36..51),
5: (52..67),
6: (68..83),
7: (84..99),
8: (100..115),
// 9: (4..19), // 9-15 is the same as 2-8
// 10: (20..35),
// 11: (36..51),
// 12: (52..67),
// 13: (68..83),
// 14: (84..99),
// 15: (100..115),
// 16: all sysex messages // no idea what they are for

MKtlDesc.loadDescs;
m.free; m = MKtl(\pd, "*cmc-pd_port1");
m.gui;
m.postElements;

m = MKtl('pd_ctls', "*cmc-pd_port2");

*/
(
parentDesc: "steinberg-cmc-pd",

status: (
	linux: "unknown",
	osx: "sketch only. best mapping still to be figured out. 2016-11-07, adc",
	win: "unknown"),

idInfo: (deviceName: "Steinberg CMC-PD", srcPortIndex: 0, destPortIndex: 0),

// by default, all pads have vel of 16
// in 4vel mode, they are 0, 31, 63, 95, 127,
// and fewer buttons...
specs: (vel16: [0, 16, \lin, 16])

deviceInfo: (
	vendorURI: "http://www.steinberg.net/en/products/controllers/cmc_series/models/cmc_pd.html",
	// manualURI: "",
	// description: "",
	// features: "",
	// notes: "",
),
specs: (midiVel16: [0, 16, \lin, 16]),

elementsDesc: (
	shared: ('elementType': 'pad', 'midiChan': 0, 'spec': 'midiVel16'),
	elements: [
		(key: 'pad',
			// just a sketch,not working yet:
			elements: [
				(
					key: \1,
					shared: (groupType: \noteOnOffBut),
					elements: [35, 36, 38, 40,   39,44,42,46,   41,45,47,48,  51,55,49,56]
					.collect { |num, i|
						(key: i, midiNum: num, \page: 0,
							shared: (style: (row: 4 - (i div: 4), column: i % 4))
						)
					}
				),
				// \2: (4..19)   .collect { |num, i| (key: i, midiNum: num) },
				// \3: (20..35)  .collect { |num, i| (key: i, midiNum: num) },
				// \4: (36..51)  .collect { |num, i| (key: i, midiNum: num) },
				// \5: (52..67)  .collect { |num, i| (key: i, midiNum: num) },
				// \6: (68..83)  .collect { |num, i| (key: i, midiNum: num) },
				// \7: (84..99)  .collect { |num, i| (key: i, midiNum: num) },
				// \8: (100..115).collect { |num, i| (key: i, midiNum: num) }
			]
		)
	]
)
);