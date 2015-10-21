/* MPD18 drumpad

- TODO:
* gui layout
* re-test


one slider, sends on chan 1, ccnum, 1, [0, 127, \lin, 1, 0]

channel aftertouch,sends on chan 0, [0, 127, \lin, 1, 0]

16 pads x 3 banks, pad 1, ... pad 16

/****** TESTING ******/

MIDIMKtl.find;
m = MIDIMKtl('kmpd180');  // Akai MPD18
// slider
m.elements[\sl].addAction({ |...args| args.post; " slider YO!".postln; });
// touch on any pad
m.elements[\touch_0].addAction({ |...args| args.post; " touch YO !".postln; });

// pad1 noteOn direct indexing
m.elements[\pad][0][0].addAction({ |...args| args.post; "pad1 sc1 on YO !".postln; });
// pad16 scene B noteOff
m.elements[\pad][1][15].addAction({ |...args| args.post; "pad16 sc2 off YO !".postln; });

// use nicer lookup
m.elementAt(\pad, 1, 2).addAction({ |...args| args.post; "pad2 sc1 on YO !".postln; });
m.elementAt(\pad, 1, 2).addAction({ |...args| args.post; "pad2 sc1 off YO !".postln; });


/****** END TESTs ******/
*/
(
deviceName: "Akai MPD18",
protocol: \midi,
deviceType: \drumpad,
elementTypes: [\pad, \slider],
status: (
	linux: "unknown",
	osx: "unknown",
	win: "unknown"),

idInfo: "Akai MPD18",

deviceInfo: (
	vendorURI: "http://www.akaipro.com/product/mpd18",
	// manualURI: "",
	// description: "",
	features: ["16 velocity and pressure-sensitive MPC pads"],
	// notes: "",
	// hasScribble: false
),
elementsDesc: (
	elements: [
		(
			key: \sl,
			midiMsgType: \cc, elementType: \slider, midiChan: 0, midiNum: 1, spec: \midiCC
		),
		(
			key: \touch,
			midiMsgType: 'touch', elementType: 'chantouch', midiChan: 0, midiNum:  0, spec: 'midiTouch'
		),
		(
			key: \pad,
			elements: (36..83).clump(16).collect { |padNums|
				(
					elements: padNums.collect { |padNum|
						(midiMsgType: \noteOnOff, elementType: \pad,
							midiChan: 0, midiNum: padNum, spec: \midiVel)
					}
				)
			}
		)
	]
)
)