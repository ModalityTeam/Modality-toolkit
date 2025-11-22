d = (
	deviceName: "Faderfox PC4",
	protocol: 'midi',
	deviceType: 'knobbox',
	elementTypes: [\knob],
	status: (
		linux: "working 22.11.2025 - bgola",
		osx: "unknown",
		win: "unknown"),

	idInfo: "Faderfox PC4",

	hardwarePages: (1..16),

	deviceInfo: (
		vendorURI: "http://faderfox.de/pc4.html",
		manualURI: "http://www.faderfox.de/PDF/PC4%20Manual%20V03.PDF",
		features: ["Compact design with metal faceplate",
			"24 pots",
			"16 pages"
		],
		longName: "FaderFox UC4",
		notes: "PC4 is a universal controller for all kinds of midi controllable hard- and software.

The device has 24 standard pots with rubber knobs designed in a 4 x 6 matrix. Various kinds of midi commands like control change, pitchbend and program change are possible.

Of course you can assign the pots to any of these commands by learning incoming midi commands like software it does. The pots work with standard resolution of 7 bit to have full compatibility to any software and hardware instruments, effects and DAW’s. Use the internal 16 setups to save your individual settings. Backup and restore of all settings by sysex dumps is possible too."
	),

	elementsDesc: (
		shared: (ioType: \inout, 'midiMsgType': \cc, 'elementType': \knob, spec: \midiCC),
		elements: [
			(
				key: \pg,
				elements: 16.collect { arg page;
					(
						shared: (midiChan: page),
						elements: [
							(
								key: \kn,
								elements: 24.collect { arg i;
									(
										midiNum:  i+1,
										style: (
											row: i div: 4,
											column: i % 4,
											showLabel: true,
										),
										page: page
									)
								}
							)
						]
					)
				}
			)
		]
	)
);