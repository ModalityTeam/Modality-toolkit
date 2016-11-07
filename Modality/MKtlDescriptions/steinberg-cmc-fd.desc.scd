
/*
// test this desc:
~filename = thisProcess.nowExecutingPath.basename.split($.).first.postcs;
d = MKtlDesc.loadDescs(~filename).first;
// close old m, open new one, make gui:
m.free; m = MKtl(\fd, "*cmc-fd"); m.gui;
m.trace;
m.elementsDict.size;
m.postElements;
*/

(
deviceName: "Steinberg CMC-FD",
protocol: \midi,
deviceType: \controller,
elementTypes: [\fader, \button],
status: (
	linux: "unknown",
	osx: "tested, code seems ok, my device broken. 2016-03-15, adc",
	win: "unknown"),

idInfo:"Steinberg CMC-FD",

deviceInfo: (
	vendorURI: "http://www.steinberg.net/en/products/controllers/cmc_series/models/cmc_fd.html",
	// manualURI: "",
	// description: "",
	features: ["4 touch faders" ],
	longName: "Steinberg CMC-FD",
	notes: "discontinued.",

),
elementsDesc: (
	shared: ('elementType': 'pad',
		'midiChan': 0, 'spec': 'midiVel'),
	elements: [
		// the faders use bend for high res fader values (10 bit )
		(
			key: 'fader',
			shared: ('midiMsgType': 'bend', 'elementType': 'slider',
				'midiChan': 0, 'spec': 'midiBend'
			),
			elements: (0..3).collect { |chan, i|
				('midiChan': chan,'spec': 'midiBend',
					style: (height: 4, row: 0, column: i)
				)
			}
		),

		// the buttons
		(
			key: \shift, midiNum: 70, groupType: \noteOnOffBut,
			shared: (groupType: \noteOnOffBut, style: (row: 6, column: 1.5))
		),
		(
			key: \bt,
			elements: [
				(key: 'chanL', midiNum: 48, shared: (style: (row: 7, column: 0))),
				(key: 'chanR', midiNum: 49, shared: (style: (row: 7, column: 1))),
				(key: 'bankL', midiNum: 46, shared: (style: (row: 7, column: 2))),
				(key: 'bankR', midiNum: 47, shared: (style: (row: 7, column: 3))),
			]
		),

				// fader touched or not
		(
			key: 'ftouch',
			// shared: ('elementType': 'button', 'spec': 'midiVel'),
			elements: (104..107).collect { |num, i|
				(key: (i+1).asSymbol, midiNum: num,
					shared: (style: (row: 3.9, column: i))
				);
			}
		),
		// fader touched when shift is down sends channel mute
		(
			key: 'fmute',
			// shared: ('elementType': 'button', 'midiChan': 0, 'spec': 'midiBut'),
			elements: (8..11).collect { |num, i|
				(
					key: (i+1).asSymbol, midiNum: num,
					shared: (style: (row: 4.8, column: i))
				);
			}
		),

	]
);
)

