(
deviceName: "Traktor Kontrol Z2 Input",
protocol: 'midi',
deviceType: \mixer,
elementTypes: [\fader, \button],
status: (
	linux: "unknown",
	osx: "unknown",
	win: "unknown"),

idInfo: "Traktor Kontrol Z2 Input",

deviceInfo: (
	vendorURI: "http://www.native-instruments.com/en/products/traktor/dj-mixer/traktor-kontrol-z2/",
	// manualURI: "",
	// description: "",
	// features: [],
	// notes: "",

	// hasScribble: false
),
elementsDesc: (
// ------ cc NORMAL ------
	shared: ('midiMsgType': 'cc', 'type': 'pad', 'midiChan': 3,
		\spec: \midiBut, \mode: \push, \ioType: \inout),
	elements: [
		(
			key: \btFlux,
			elements: [11, 52].collect ( (midiNum: _) ) ),
		(
			key: \btOn,
			elements: [2, 42].collect ( (midiNum: _) ) ),
		(
			key: \btL,
			elements: (7..10).collect ( (midiNum: _) ) ),
		(
			key: \btR,
			elements: (48..51).collect ( (midiNum: _) ) ),
		(
			key: \btCA,
			elements: [5, 6].collect ( (midiNum: _) ) ),
		(
			key: \btBD,
			elements: [46, 47].collect ( (midiNum: _) ) ),
		(
			key: \btSQ,
			elements: [21, 23].collect ( (midiNum: _) ) ),
		(
			key: \btSQ,
			elements: [21, 23].collect ( (midiNum: _) ) ),
		(
			key: \btLoad,
			elements: [25, 26].collect ( (midiNum: _) ) ),
		(
			key: \btRelInt,
			elements: [27, 28].collect ( (midiNum: _) ) ),
		(
			key: \btSync,
			elements: [29, 30].collect ( (midiNum: _) ) ),
		(
			key: \btSQ,
			elements: [21, 23].collect ( (midiNum: _) ) ),
		(
			key: \btFx,
			elements: [17, 18, 37, 38].collect ( (midiNum: _) ) ),
		(
			key: \xsl, 'elementType': 'slider', 'midiNum':  31,
			'spec': 'midiCC'),
		(
			key: \sl,
			shared: ('elementType': 'slider', 'spec': 'midiCC'),
			elements: [20, 39].collect ( (midiNum: _) ) ),
		(
			key: \btEnc,
			shared: ('elementType': 'button', 'spec': 'midiBut',
				\mode: \push, itType: \in),
			elements:  [105, 107, 109].collect ( (midiNum: _) ) ),
		(
			key: \rtEnc,
			shared: ('elementType': 'encoder', 'spec': 'midiBut',
				\mode: \push, itType: \in),
			elements:  [4, 24, 45].collect ( (midiNum: _) ) ),
		(
			key: \knLL,
			shared: ('elementType': 'knob', 'spec': 'midiCC'),
			elements: [0, 1, 3].collect ( (midiNum: _) ) ),
		(
			key: \knRR,
			shared: ('elementType': 'knob', 'spec': 'midiCC'),
			elements: [40, 41, 43].collect ( (midiNum: _) ) ),
		(
			key: \knL,
			shared: ('elementType': 'knob', 'spec': 'midiCC'),
			elements: (12..16).collect ( (midiNum: _) ) ),
		(
			key: \knR,
			shared: ('elementType': 'knob', 'spec': 'midiCC'),
			elements: (32..36).collect ( (midiNum: _) ) ),

// ------ cc SHIFT ------

	//	maybe better have a normal and shift mode?

		(
			key: \btFluxS,
			elements: [64, 104].collect ( (midiNum: _) ) ),
		(
			key: \btOnS,
			elements: [55, 94].collect ( (midiNum: _) ) ),
		(
			key: \btLS,
			elements: (60..63).collect ( (midiNum: _) ) ),
		(
			key: \btRS,
			elements: (100..103).collect ( (midiNum: _) ) ),
		(
			key: \btCAS,
			elements: [58, 59].collect ( (midiNum: _) ) ),
		(
			key: \btBDS,
			elements: [98, 99].collect ( (midiNum: _) ) ),
		(
			key: \btSQS,
			elements: [73, 75].collect ( (midiNum: _) ) ),
		(
			key: \btLoadS,
			elements: [77, 78].collect ( (midiNum: _) ) ),
		(
			key: \btRelIntS,
			elements: [79, 80].collect ( (midiNum: _) ) ),
		(
			key: \btSyncS,
			elements: [81, 82].collect ( (midiNum: _) ) ),
		(
			key: \btSQ,
			elements: [21, 23].collect ( (midiNum: _) ) ),
		(
			key: \btFxS,
			elements: [70, 71, 89, 90].collect ( (midiNum: _) ) ),
		(
			key: \xslS, 'elementType': 'slider', 'midiNum':  83,
			'spec': 'midiCC'),
		(
			key: \slS,
			shared: ('elementType': 'slider', 'spec': 'midiCC'),
			elements: [72, 91].collect ( (midiNum: _) ) ),
		(
			key: \btEncS,
			shared: ('elementType': 'button', 'spec': 'midiBut',
				\mode: \push, itType: \in),
			elements:  [106, 108, 110].collect ( (midiNum: _) ) ),
		(
			key: \rtEncS,
			shared: ('elementType': 'encoder', 'spec': 'midiBut',
				\mode: \push, itType: \in),
			elements:  [57, 76, 97].collect ( (midiNum: _) ) ),
		(
			key: \knLLS,
			shared: ('elementType': 'knob', 'spec': 'midiCC'),
			elements: [53, 54, 56].collect ( (midiNum: _) ) ),
		(
			key: \knRRS,
			shared: ('elementType': 'knob', 'spec': 'midiCC'),
			elements: [92, 93, 95].collect ( (midiNum: _) ) ),
		(
			key: \knL,
			shared: ('elementType': 'knob', 'spec': 'midiCC'),
			elements: (84..88).collect ( (midiNum: _) ) ),
		(
			key: \knR,
			shared: ('elementType': 'knob', 'spec': 'midiCC'),
			elements: (65..69).collect ( (midiNum: _) ) )
	]
)
)
