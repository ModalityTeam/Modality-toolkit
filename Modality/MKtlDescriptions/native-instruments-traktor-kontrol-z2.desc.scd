/*

* intermediate version of desc file:
* lots of examples for gui positioning
* some elements disabled to reduce confusion

// test here:
// - this line loads changed descfile and remakes z and gui:
MKtlDesc.loadDescs( "*-z2"); z.free; z = MKtl(\z2, "*-z2"); z.gui;

z.elementsDict.size;
z.postElements
*/

(
deviceName: "Traktor Kontrol Z2 Input",
protocol: 'midi',
deviceType: \mixer,
elementTypes: [\fader, \button],
status: (
	linux: "unknown",
	osx: "tested desc only - incomplete ATM for entering gui info. 2016-03-23, adc",
	win: "unknown"),

idInfo: "Traktor Kontrol Z2 Input",

deviceInfo: (
	vendorURI: "http://www.native-instruments.com/en/products/traktor/dj-mixer/traktor-kontrol-z2/",
	// manualURI: "",
	// description: "",
	// features: [],
	// notes: "",
	longName: "Native Instruments Traktor Kontrol Z2"
),
elementsDesc: (
// ------ cc NORMAL ------
	shared: ('midiMsgType': 'cc', 'elementType': 'pad', 'midiChan': 3,
		\spec: \midiBut, \mode: \push, \ioType: \inout),
	elements: [
		(
			key: \btOn,
			elements: [2, 42].collect { |num, i|
				(midiNum: num, style: (row: 5, column: i * 8))
			}
		),
		(
			key: \btFlux,
			elements: [11, 52].collect { |num, i|
				(midiNum: num, style: (row: 12, column: i * 8, height: 0.7))
			}
		),
		(
			key: \btL,
			elements: (7..10).collect { |num, i|
				(midiNum: num, style: (row: i + 8, column: 0))
			}
		),
		(
			key: \btR,
			elements: (48..51).collect { |num, i|
				(midiNum: num, style: (row: i + 8, column: 8))
			}
		),
		(
			key: \btCA,
			elements: [5, 6].collect { |num, i|
				(midiNum: num, style:
					(row: 7, column: 0.5 * i, width: 0.5, height: 0.5))
			} ),
		(
			key: \btBD,
			elements: [46, 47].collect { |num, i|
				(midiNum: num, style:
					(row: 7, column: 0.5 * i + 8, width: 0.5, height: 0.5))
			}
		),

		// (
		// 	key: \btSQ,
		// elements: [21, 23].collect ( (midiNum: _) ) ),
		// (
		// 	key: \btLoad,
		// elements: [25, 26].collect ( (midiNum: _) ) ),
		// (
		// 	key: \btRelInt,
		// elements: [27, 28].collect ( (midiNum: _) ) ),
		// (
		// 	key: \btSync,
		// elements: [29, 30].collect ( (midiNum: _) ) ),
		// (
		// 	key: \btSQ,
		// elements: [21, 23].collect ( (midiNum: _) ) ),
		// (
		// 	key: \btFx,
		// 	elements: [17, 18, 37, 38].collect ( (midiNum: _) )
		// ),


		(
			key: \xsl, 'elementType': 'slider', 'midiNum': 31, 'spec': 'midiCC',
			style: (row: 11.5, column: 3, height: 1, width: 3)
		),
		(
			key: \sl,
			shared: ('elementType': 'slider', 'spec': 'midiCC'),
			elements: [
				(midiNum: 20, style: (row: 7.5, column: 2)),
				(midiNum: 39, style: (row: 7.5, column: 6))
			]
		),

		// (
		// 	key: \btEnc,
		// 	shared: ('elementType': 'button', 'spec': 'midiBut',
		// 	\mode: \push, itType: \in),
		// elements:  [105, 107, 109].collect ( (midiNum: _) ) ),
		//
		// (
		// 	key: \rtEnc,
		// 	shared: ('elementType': 'encoder', 'spec': 'midiBut',
		// 	\mode: \push, itType: \in),
		// elements:  [4, 24, 45].collect ( (midiNum: _) ) ),

		// dont know which three these are, so guessing ...
		(
			key: \knLL,
			shared: ('elementType': 'knob', 'spec': 'midiCC'),
			elements: [
				(midiNum: 0, style: (row: 0.5, column: 0)),
				(midiNum: 1, style: (row: 2.5, column: 0)),
				(midiNum: 3, style: (row: 3.5, column: 0)),
			]
		),
		// dont know which three these are, so guessing ...
		(
			key: \knRR,
			shared: ('elementType': 'knob', 'spec': 'midiCC'),
			elements: [
				(midiNum: 40, style: (row: 0.5, column: 8)),
				(midiNum: 41, style: (row: 2.5, column: 8)),
				(midiNum: 43, style: (row: 3.5, column: 8)),
			]
		),

		(
			key: \knL,
			shared: ('elementType': 'knob', 'spec': 'midiCC'),
			elements: (12..16).collect { |num, i|
				(midiNum: num, style: (row: i + 1, column: 2))
			}
		),
		(
			key: \knR,
			shared: ('elementType': 'knob', 'spec': 'midiCC'),
			elements: (32..36).collect { |num, i|
				(midiNum: num, style: (row: i + 1, column: 6))
			}
		),



// ------ cc SHIFT ------

		// //	maybe better have a normal and shift mode?
		//
		// (
		// 	key: \btFluxS,
		// elements: [64, 104].collect ( (midiNum: _) ) ),
		// (
		// 	key: \btOnS,
		// elements: [55, 94].collect ( (midiNum: _) ) ),
		// (
		// 	key: \btLS,
		// elements: (60..63).collect ( (midiNum: _) ) ),
		// (
		// 	key: \btRS,
		// elements: (100..103).collect ( (midiNum: _) ) ),
		// (
		// 	key: \btCAS,
		// elements: [58, 59].collect ( (midiNum: _) ) ),
		// (
		// 	key: \btBDS,
		// elements: [98, 99].collect ( (midiNum: _) ) ),
		// (
		// 	key: \btSQS,
		// elements: [73, 75].collect ( (midiNum: _) ) ),
		// (
		// 	key: \btLoadS,
		// elements: [77, 78].collect ( (midiNum: _) ) ),
		// (
		// 	key: \btRelIntS,
		// elements: [79, 80].collect ( (midiNum: _) ) ),
		// (
		// 	key: \btSyncS,
		// elements: [81, 82].collect ( (midiNum: _) ) ),
		// (
		// 	key: \btSQ,
		// elements: [21, 23].collect ( (midiNum: _) ) ),
		// (
		// 	key: \btFxS,
		// elements: [70, 71, 89, 90].collect ( (midiNum: _) ) ),
		// (
		// 	key: \xslS, 'elementType': 'slider', 'midiNum':  83,
		// 'spec': 'midiCC'),
		// (
		// 	key: \slS,
		// 	shared: ('elementType': 'slider', 'spec': 'midiCC'),
		// elements: [72, 91].collect ( (midiNum: _) ) ),
		// (
		// 	key: \btEncS,
		// 	shared: ('elementType': 'button', 'spec': 'midiBut',
		// 	\mode: \push, itType: \in),
		// elements:  [106, 108, 110].collect ( (midiNum: _) ) ),
		// (
		// 	key: \rtEncS,
		// 	shared: ('elementType': 'encoder', 'spec': 'midiBut',
		// 	\mode: \push, itType: \in),
		// elements:  [57, 76, 97].collect ( (midiNum: _) ) ),
		// (
		// 	key: \knLLS,
		// 	shared: ('elementType': 'knob', 'spec': 'midiCC'),
		// elements: [53, 54, 56].collect ( (midiNum: _) ) ),
		// (
		// 	key: \knRRS,
		// 	shared: ('elementType': 'knob', 'spec': 'midiCC'),
		// elements: [92, 93, 95].collect ( (midiNum: _) ) ),
		// (
		// 	key: \knL,
		// 	shared: ('elementType': 'knob', 'spec': 'midiCC'),
		// elements: (84..88).collect ( (midiNum: _) ) ),
		// (
		// 	key: \knR,
		// 	shared: ('elementType': 'knob', 'spec': 'midiCC'),
		// elements: (65..69).collect ( (midiNum: _) ) )
	]
)
)
