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
description: (
// ------ cc NORMAL ------
	\btFlux: [11, 52].collect{|i|('midiMsgType': 'cc', 'type': 'pad', 'midiChan': 3, 'midiNum':  i,\spec: \midiBut, \mode: \push, \ioType: \inout)},
	\btOn: [2, 42].collect{|i|('midiMsgType': 'cc', 'type': 'pad', 'midiChan': 3, 'midiNum':  i,\spec: \midiBut, \mode: \push, \ioType: \inout)},
	\btL: (7..10).collect{|i|('midiMsgType': 'cc', 'type': 'pad', 'midiChan': 3, 'midiNum':  i,\spec: \midiBut, \mode: \push, \ioType: \inout)},
	\btR: (48..51).collect{|i|('midiMsgType': 'cc', 'type': 'pad', 'midiChan': 3, 'midiNum':  i,\spec: \midiBut, \mode: \push, \ioType: \inout)},
	\btCA: [5,6].collect{|i|('midiMsgType': 'cc', 'type': 'button', 'midiChan': 3, 'midiNum':  i,\spec: \midiBut, \mode: \push, \ioType: \inout)},
	\btBD: [46, 47].collect{|i|('midiMsgType': 'cc', 'type': 'button', 'midiChan': 3, 'midiNum':  i,\spec: \midiBut, \mode: \push, \ioType: \inout)},
	\btSQ: [21, 23].collect{|i|('midiMsgType': 'cc', 'type': 'button', 'midiChan': 3, 'midiNum':  i,\spec: \midiBut, \mode: \push, \ioType: \inout)},
	\btLoad: [25, 26].collect{|i|('midiMsgType': 'cc', 'type': 'button', 'midiChan': 3, 'midiNum':  i,\spec: \midiBut, \mode: \push, \ioType: \inout)},
	\btRelInt: [27, 28].collect{|i|('midiMsgType': 'cc', 'type': 'button', 'midiChan': 3, 'midiNum':  i,\spec: \midiBut, \mode: \push, \ioType: \inout)},
	\btSync: [29, 30].collect{|i|('midiMsgType': 'cc', 'type': 'button', 'midiChan': 3, 'midiNum':  i,\spec: \midiBut, \mode: \push, \ioType: \inout)},
	\btFx: [17, 18, 37, 38].collect{|i|('midiMsgType': 'cc', 'type': 'button', 'midiChan': 3, 'midiNum':  i,\spec: \midiBut, \mode: \push, \ioType: \inout)},
	\xsl: ('midiMsgType': 'cc', 'type': 'slider', 'midiChan': 3, 'midiNum':  31,'spec': 'midiCC'),
	\sl: [20, 39].collect{|i|('midiMsgType': 'cc', 'type': 'slider', 'midiChan': 3, 'midiNum':  i,'spec': 'midiCC')},
	\btEnc: [105, 107, 109].collect{|i|('midiMsgType': 'cc', 'type': 'button', 'midiChan': 3, 'midiNum':  i,\spec: \midiBut, \mode: \push, \ioType: \in)},
	\rtEnc: [4, 24, 45].collect{|i|('midiMsgType': 'cc', 'type': 'encoder', 'midiChan': 3, 'midiNum':  i,\spec: \midiCC, \ioType: \in)},
	\knLL: [0, 1, 3].collect{|i|('midiMsgType': 'cc', 'type': 'knob', 'midiChan': 3, 'midiNum':  i,'spec': 'midiCC')},
	\knRR: [40, 41, 43].collect{|i|('midiMsgType': 'cc', 'type': 'knob', 'midiChan': 3, 'midiNum':  i,'spec': 'midiCC')},
	\knR: (32..36).collect{|i|('midiMsgType': 'cc', 'type': 'knob', 'midiChan': 3, 'midiNum':  i,'spec': 'midiCC')},
	\knL: (12..16).collect{|i|('midiMsgType': 'cc', 'type': 'knob', 'midiChan': 3, 'midiNum':  i,'spec': 'midiCC')},

// ------ cc SHIFT ------

	\btFluxS: [64, 104].collect{|i|('midiMsgType': 'cc', 'type': 'pad', 'midiChan': 3, 'midiNum':  i,\spec: \midiBut, \mode: \push, \ioType: \inout)},
	\btOnS: [55, 94].collect{|i|('midiMsgType': 'cc', 'type': 'pad', 'midiChan': 3, 'midiNum':  i,\spec: \midiBut, \mode: \push, \ioType: \inout)},
	\btLS: (60..63).collect{|i|('midiMsgType': 'cc', 'type': 'pad', 'midiChan': 3, 'midiNum':  i,\spec: \midiBut, \mode: \push, \ioType: \inout)},
	\btRS: (100..103).collect{|i|('midiMsgType': 'cc', 'type': 'pad', 'midiChan': 3, 'midiNum':  i,\spec: \midiBut, \mode: \push, \ioType: \inout)},
	\btCAS: [58, 59].collect{|i|('midiMsgType': 'cc', 'type': 'button', 'midiChan': 3, 'midiNum':  i,\spec: \midiBut, \mode: \push, \ioType: \inout)},
	\btBDS: [98, 99].collect{|i|('midiMsgType': 'cc', 'type': 'button', 'midiChan': 3, 'midiNum':  i,\spec: \midiBut, \mode: \push, \ioType: \inout)},
	\btSQS: [73, 75].collect{|i|('midiMsgType': 'cc', 'type': 'button', 'midiChan': 3, 'midiNum':  i,\spec: \midiBut, \mode: \push, \ioType: \inout)},
	\btLoadS: [77, 78].collect{|i|('midiMsgType': 'cc', 'type': 'button', 'midiChan': 3, 'midiNum':  i,\spec: \midiBut, \mode: \push, \ioType: \inout)},
	\btRelIntS: [79, 80].collect{|i|('midiMsgType': 'cc', 'type': 'button', 'midiChan': 3, 'midiNum':  i,\spec: \midiBut, \mode: \push, \ioType: \inout)},
	\btSyncS: [81, 82].collect{|i|('midiMsgType': 'cc', 'type': 'button', 'midiChan': 3, 'midiNum':  i,\spec: \midiBut, \mode: \push, \ioType: \inout)},
	\btFxS: [70, 71, 89, 90].collect{|i|('midiMsgType': 'cc', 'type': 'button', 'midiChan': 3, 'midiNum':  i,\spec: \midiBut, \mode: \push, \ioType: \inout)},
	\xslS: ('midiMsgType': 'cc', 'type': 'slider', 'midiChan': 3, 'midiNum':  83,'spec': 'midiCC'),
	\slS: [72, 91].collect{|i|('midiMsgType': 'cc', 'type': 'slider', 'midiChan': 3, 'midiNum':  i,'spec': 'midiCC')},
	\btEncS: [106, 108, 110].collect{|i|('midiMsgType': 'cc', 'type': 'button', 'midiChan': 3, 'midiNum':  i,\spec: \midiBut, \mode: \push, \ioType: \in)},
	\rtEncS: [57, 76, 97].collect{|i|('midiMsgType': 'cc', 'type': 'encoder', 'midiChan': 3, 'midiNum':  i,\spec: \midiCC, \ioType: \in)},
	\knLLS: [53, 54, 56].collect{|i|('midiMsgType': 'cc', 'type': 'knob', 'midiChan': 3, 'midiNum':  i,'spec': 'midiCC')},
	\knRRS: [92, 93, 95].collect{|i|('midiMsgType': 'cc', 'type': 'knob', 'midiChan': 3, 'midiNum':  i,'spec': 'midiCC')},
	\knRS: (65..69).collect{|i|('midiMsgType': 'cc', 'type': 'knob', 'midiChan': 3, 'midiNum':  i,'spec': 'midiCC')},
	\knLS: (84..88).collect{|i|('midiMsgType': 'cc', 'type': 'knob', 'midiChan': 3, 'midiNum':  i,'spec': 'midiCC')},
 );
)