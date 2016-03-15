(
deviceName: "Steinberg CMC-FD",
protocol: \midi,
deviceType: \controller,
elementTypes: [\fader, \button],
status: (
	linux: "unknown",
	osx: "tested and working",
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
		// the buttons
		(
			key: \bt,
			elements: MKtlDesc.notePairs([
				['bankL', 46],
				['bankR', 47],
				['chanL', 48],
				['chanR', 49]
			])
		),
		MKtlDesc.notePair(\shift, 70),
		// fader touched or not
		(
			key: 'faderTouch',
			shared: ('elementType': 'button', 'spec': 'midiBut'),
			elements: MKtlDesc.notePairs(
				(104..107).collect { |num, i| [(i+1).asSymbol, num] }
			)
		),
		// fader touched when shift is down sends channel mute
		(
			key: 'faderMute',
			shared: ('elementType': 'key',
			'midiChan': 0, 'spec': 'midiNote'),
			elements: (8..11).collect { |note, i|
				MKtlDesc.notePair((i+1).asSymbol, note)
			}
		),
		// bend : high res fader values (10 bit )
		(
			key: 'fader',
			shared: ('midiMsgType': 'bend', 'elementType': 'fader',
				'midiChan': 0, 'spec': 'midiBend'),
			elements: (0..3).collect { |chan|
				('midiChan': chan,'spec': 'midiBend')
			}
		)
	]
);
)

