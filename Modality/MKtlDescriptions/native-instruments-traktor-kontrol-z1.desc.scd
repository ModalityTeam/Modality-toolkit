/**** desc file for Traktor Kontrol Z1

k = MKtl(\z1, "native-instruments-traktor-kontrol-z1");
k.gui
k.elementAt(\sl, 0).action = { "yo".postln; };
k.elementAt(\sl, 1).action = { 1.postcs; };

****/

(
deviceName: "Traktor Kontrol Z1 Input",
protocol: 'midi',
deviceType: 'mixer',
elementTypes: [\fader, \button],
status: (
	linux: "unknown",
	osx: "tested",
	win: "unknown"),

idInfo: "Traktor Kontrol Z1 Input",

deviceInfo: (
	vendorURI: "http://www.native-instruments.com/en/products/traktor/dj-mixer/traktor-kontrol-z1/",
	manualURI: 'https://www.native-instruments.com/fileadmin/ni_media/downloads/manuals/TraktorKontrolZ1_Manual_English.zip',
	description: "Ultra-portable DJ controller, knobs, faders, and backlit buttons. Mixing interface with 3-band EQ, built-in 24-bit soundcard.",
	// features: [],
	// notes: "",
	hasScribble: false
),
elementsDesc: (
	shared: ('midiMsgType': 'cc', \ioType: \in),

	 elements: [
		// Xfader
		(
			key: \xsl, 'elementType': 'slider', 'midiChan': 2,'midiNum': 5, 'spec': 'midiCC',
			style: (row: 9, column: 1.1, height: 0.75, width: 3)
		),
		// cue mix
		(
			key: \knCue, 'elementType': 'knob', 'midiChan': 2,'midiNum': 0, 'spec': 'midiCC',
			style: (row: 2.5, column: 2, width: 0.75, height: 0.75)
		),
		// headphone
		(
			key: \btH,
			shared: ('elementType': 'button', 'midiChan': 2, 'spec': 'midiCC'),
			elements: [
				(midiNum: 1, style: (row: 3.5, column: 1.5, width: 0.75, height: 0.75)),
				(midiNum: 2, style: (row: 3.5, column: 2.5, width: 0.75, height: 0.75))
			]
		),
		// gain sliders
		(
			key: \sl,
			shared: ('elementType': 'slider', 'midiNum': 6, 'spec': 'midiCC'),
			elements: [
				(midiChan: 0, style: (row: 6, column: 0.1)),
				(midiChan: 1, style: (row: 6, column: 4.1))
			]
		),
		(
			key: \kn,
			shared: ('elementType': 'knob', 'spec': 'midiCC'),
			elements: [
				// knobs A (left)
				(
					shared: ('midiChan': 0),
					key: \a,
					elements: [
						(midiNum: 0, style: (row: 0, column: 0.225, width: 0.75, height: 0.75)), // gain
						(midiNum: 1, style: (row: 1, column: 0.1)), // hi
						(midiNum: 2, style: (row: 2, column: 0.1)), // mid
						(midiNum: 3, style: (row: 3, column: 0.1)), // low
						(midiNum: 4, style: (row: 4, column: 0, width: 1.2, height: 1.2))  // filter
					]
				),
				// knobs B (right)
				(
					shared: ('midiChan': 1),
					key: \b,
					elements: [
						(midiNum: 0, style: (row: 0, column: 4.225, width: 0.75, height: 0.75)),
						(midiNum: 1, style: (row: 1, column: 4.1)),
						(midiNum: 2, style: (row: 2, column: 4.1)),
						(midiNum: 3, style: (row: 3, column: 4.1)),
						(midiNum: 4, style: (row: 4, column: 4, width: 1.2, height: 1.2))
					]
				)
			]
		),
		(
			// toggle buttons
			key: \btFx,
			shared: ('elementType': 'button', 'midiNum': 5, 'spec': 'midiCC'),
			elements: [
						(midiChan: 0, style: (row: 5.3, column: 0.1, height: 0.5)),
						(midiChan: 1, style: (row: 5.3, column: 4.1, height: 0.5)),
			]
		)
	]
)

);

