// incomplete, but what is there works

(
deviceName: "iCON iControls_Pro V1.02",
protocol: \midi,
deviceType: \faderbox,
elementTypes: [\fader, \button],
status: (
	linux: "unknown",
	osx: "unknown",
	win: "unknown"),

idInfo: "iCON iControls_Pro V1.02",

deviceInfo: (
	// vendorURI: "",
	// manualURI: "",
	// description: "",
	// features: [],
	// notes: "",

	// hasScribble: false
),
elementsDesc: (
	elements: [
		(
			key: \bt,
			shared: (midiMsgType: \noteOnOff, elementType: \button,
				ioType: \inout, midiChan: 0, spec: \midiBut, mode: \push ),
			elements: [
				(
					key: \rec,
					elements: (0..7).collect { |num| (midiNum: num) }
				),
				(
					key: \solo,
					elements: (8..15).collect { |num| (midiNum: num) }
				),
				(
					key: \mute,
					elements: (16..23).collect { |num| (midiNum: num) }
				),
				(
					key: \select,
					// assuming this is 24-31? was 16-23, copy paste error?
					elements: (24..31).collect { |num| (midiNum: num) }
				)
			]
		),
		(
			key: \kn,
			shared: (midiMsgType: \cc, elementType: \encoder,
				ioType: \inout, midiChan: 0, spec: \midiCC, mode: \mackie ),
			elements: (16..23).collect { |num, i| (midiNum: num) }
		),
		(
			key: \sl,
			shared: (midiMsgType: \bend, elementType: \slider,
				ioType: \inout, spec: \midiBend),
			elements: 9.collect { |i| (midiChan: i) }
		)
	]
)
)