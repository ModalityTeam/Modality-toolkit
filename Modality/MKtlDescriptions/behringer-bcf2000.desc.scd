// Behringer BCF2000 specs:
/*

pr_u_l
pr_u_r
pr_d_l
pr_d_r
tr[page][row][column]
kn[page][row][column]
bt[row][column]
sl[row][column]


*/


(

deviceName: "BCF2000",
protocol: \midi,
deviceType: \faderbox,
elementTypes: [\fader, \button, \encoder],
status: (
	linux: "unknown",
	osx: "unknown",
	win: "unknown"),

idInfo: "BCF2000",

hardwarePages: [1, 2, 3, 4],


deviceInfo: (
	vendorURI: "http://www.behringer.com/EN/Products/BCR2000.aspx",
	manualURI: "http://www.behringer.com/assets/BCF2000_BCR2000_M_EN.pdf",
	// description: "",
	// features: [],
	// notes: "",
	hasScribble: true
),
elementsDesc: (
	elements: [
	//buttons at bottom right
		(
			key: \pr,
			shared: (\midiMsgType: \cc, elementType: \button, midiChan: 0,
				spec: \midiBut, mode: \toggle, ioType: \inout),
			elements: [
				(
					key: \up,
					elements: [
						(key: \l, midiNum: 89),
						(key: \r, midiNum: 90),
					]
				),
				(
					key: \down,
					elements: [
						(key: \l, midiNum: 89),
						(key: \r, midiNum: 90),
					]
				)
			]
		),

		//upper row of encoders when pressed, 4 pages, 8 rows
		(
			key: \tr,
			shared: (\midiMsgType: \cc, elementType: \encoder, midiChan: 0,
				spec: \midiCC, ioType: \in),
			elements: 4.collect { |j|
				(
					elements: 8.collect { |i|
						// top knob push mode
						(midiNum: 33+(8*j)+i, page: j + 1)
					}
				)
			}
		),
		//upper row of encoders, 4 pages, 8 rows
		(
			key: \kn,
			shared: (\midiMsgType: \cc, elementType: \encoder, midiChan: 0,
				spec: \midiCC, ioType: \in),
			elements: 4.collect { |j|
				(
					elements: 8.collect { |i|
						// top knob push mode
						(midiNum: 1+(8*j)+i, page: j + 1)
					}
				)
			}
		),
	//buttons
		(
			key: \bt,
			shared: (\midiMsgType: \cc, elementType: \midiBut, midiChan: 0,
				spec: \midiCC, ioType: \inout),
			elements: [65,73].collect { |ccStart|
				(
					elements: 8.collect { |i|
						(midiNum: ccStart+i)
					}
				)
			}
		),
	//sliders
		(
			key: \sl,
			shared: (\midiMsgType: \cc, elementType: \encoder, midiChan: 0,
				spec: \midiCC, ioType: \inout),
			elements: 8.collect { |i| (midiNum: 81+i) }
		)
	]
)
)