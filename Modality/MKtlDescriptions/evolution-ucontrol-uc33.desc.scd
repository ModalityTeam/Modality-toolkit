(
deviceName: "UC-33 USB MIDI Controller",
protocol: \midi,
deviceType: \faderbox,
\elementTypes: [\slider, \knob, \button],
status: (
	linux: "unknown",
	osx: "tested desc, looks ok. 2016-03-24, adc. transport buttons can be added when cc numbers are known.",
	win: "unknown"),

idInfo: "UC-33 USB MIDI Controller",

deviceInfo: (
	// vendorURI: "",
	// manualURI: "",
	// description: "",
	// features: (),
	notes: "desc is for preset3 only",
	longName: "Evolution U-Control UC33"
),

// preset 3 only, transport buttons missing:
elementsDesc: (
	shared: (midiMsgType: \cc, midiChan: 0,  ioType: \in),
	elements: [
		(
			key: \kn,
			shared: (elementType: \knob, spec: \midiCC),
			elements: #[
				[45, 46, 47,  5, 80, 81, 82, 83],
				[50, 51, 55, 87, 75, 76, 77, 78],
				[20, 21, 40, 43, 70, 71, 72, 73]
			].collect { |row|
				(
					elements: row.collect {|num, i| (midiNum: num) }
				)
			}
		),
		(
			key: \sl,
			shared: ( elementType: \slider, spec: \midiCC),
			elements: #[105, 106, 107, 108, 110, 111, 112, 116, 26]
			.collect {|num, i| (midiNum: num) }
		),
		(
			key: \bt,
			shared: (elementType: \button, mode: \toggle, spec: \midiBut),
			elements: #[57, 52, 53, 54, 41, 42, 44, 22, 23, 24].collect {|num, i|
				(midiNum: num)
			}
		),
		// (
		// 	key: \tr,
		// 	shared: (elementType: \button, mode: \toggle, spec: \midiBut),
		// 	elements: [
		// 		(key: \stop, midiNum: ?),
		// 		(key: \play, midiNum: ?),
		// 		(key: \fwd, midiNum: ?),
		// 		(key: \rew, midiNum: ?)
		// 	]
		// )
	]
)
)
