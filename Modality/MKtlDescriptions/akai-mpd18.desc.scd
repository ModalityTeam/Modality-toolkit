/* MPD18 drumpad

- TODO:


one slider, sends on chan 1, ccnum, 1, [0, 127, \lin, 1, 0]

channel aftertouch,sends on chan 0, [0, 127, \lin, 1, 0]

16 pads x 3 banks, pad 1, ... pad 16

/****** TESTING ******/

MKtl.find;
m = MKtl('mpd', "*mpd18");  // Akai MPD18
m.gui;
// slider
m.elAt(\sl).addAction({ " slider YO!".postln; });
// touch on any pad
m.elAt(\touch).addAction({ |el| [el.name, el.value.round(0.001)].postln });

// pad1 noteOn direct indexing
m.elAt(\pad,0, 0).addAction({ |...args| "pad1 sc1 on YO !".postln; });

m.elAt.action = { |el| [el.name, el.value.round(0.001)].postln };


/****** END TESTs ******/
*/
(
deviceName: "Akai MPD18",
protocol: \midi,
deviceType: \drumpad,
elementTypes: [\pad, \slider],
status: (
	linux: "unknown",
	osx: "tested and working, 2016_03_13, adc",
	win: "unknown"),

idInfo: "Akai MPD18",

deviceInfo: (
	vendorURI: "http://www.akaipro.com/product/mpd18",
	// manualURI: "",
	// description: "",
	features: [
		"16 velocity and pressure-sensitive MPC pads",
		"1 fader"
	],
	longName: "AKAI MPD18"

),
elementsDesc: (
	elements: [
		(
			key: \sl,
			midiMsgType: \cc, elementType: \slider, midiChan: 0, midiNum: 1, spec: \midiCC,
			style: (row: 1, column: 4, height: 3)
		),
		(
			key: \pad,
			shared: (elementType: \pad, midiChan: 0, spec: \midiVel, midiMsgType: \noteOn),
			elements: (36..83).clump(16).collect { |padNums, page|
				(
					shared: (page: page, groupType: \noteOnOffTouch),
					elements: padNums.collect { |num, i|
						(
							key: (i+1).asSymbol,
							shared: (
								midiNum: num,
								style: (row: 3 - (i div: 4), column: (i % 4)
								)
							)
						)
					}
				)
			}
		)
	]
)
)