/***
Known Problems:
* OSX often does not register it properly.
- maybe my (adc) device is broken?
- or USB firmware too old for 10.11?

( TODO - maybe when device works again )
* gui layout for ftouch, fmute is not working correctly yet
- (may go away when combined on/off gui exists)

***/

/*
// test this desc:
~filename = thisProcess.nowExecutingPath.basename.split($.).first.postcs;
d = MKtlDesc.loadDescs(~filename).first;
d.web;

MKtl.find;
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
	// features: ["4 touch faders" ],
	notes: "discontinued.",

),
elementsDesc: (
	shared: ('elementType': 'button',
		'midiChan': 0, 'spec': 'midiBut'),
	elements: [
		// the faders use bend for high res fader values (10 bit )
		(
			key: 'fader',
			shared: ('midiMsgType': 'bend', 'elementType': 'slider',
				'midiChan': 0, 'spec': 'midiBend'
			),
			elements: (0..3).collect { |chan, i|
				('midiChan': chan,'spec': 'midiBend',
					style: (height: 3, row: 0, column: i)
				)
			}
		),

		// the buttons
		MKtlDesc.notePair(\shift, 70, shared: (style: (row: 6, column: 1.5))),
		(
			key: \bt,
			elements: [
				MKtlDesc.notePair('chanL', 48, shared: (style: (row: 7, column: 0))),
				MKtlDesc.notePair('chanR', 49, shared: (style: (row: 7, column: 1))),
				MKtlDesc.notePair('bankL', 46, shared: (style: (row: 7, column: 2))),
				MKtlDesc.notePair('bankR', 47, shared: (style: (row: 7, column: 3))),
			]
		),

				// fader touched or not
		(
			key: 'ftouch',
			shared: ('elementType': 'pad', 'spec': 'midiBut'),
			elements: (104..107).collect { |num, i|
				MKtlDesc.notePair(
					(i+1).asSymbol, num,
					(shared: (style: (row: 4, column: i)))
				);
			}
		),
		// fader touched when shift is down sends channel mute
		(
			key: 'fmute',
			shared: ('elementType': 'pad',
			'midiChan': 0, 'spec': 'midiNote'),
			elements: (8..11).collect { |num, i|
				MKtlDesc.notePair(
					(i+1).asSymbol, num,
					(shared: (style: (row: 5, column: i)))
				);
			}
		),

	]
);
)

