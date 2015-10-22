// Behringer BCR2000 specs:
/*

pr_u_l
pr_u_r
pr_d_l
pr_d_r
tr[page][row][column]
knUp[page][row][column]
bt[row][column]
kn[row][column]
MIDIMKtl('bcr20000').explore
MIDIMKtl('bcr20000').verbose = true
MIDIMKtl('bcr20000').verbose = false
MIDIMKtl('bcr20000').elements.kn[0][0].value_(0.5)

*/


(
deviceName: "BCR2000",
protocol: \midi,
deviceType: \mixer,
elementTypes: [\encoder, \button],
status: (
	linux: "unknown",
	osx: "unknown",
	win: "unknown"),

idInfo: "BCR2000",

hardwarePages: [1,2,3,4],

deviceInfo: (
	vendorURI: "http://www.behringer.com/EN/Products/BCR2000.aspx",
	manualURI: "http://www.behringer.com/assets/BCF2000_BCR2000_M_EN.pdf",
	// description: "",
	// features: [],
	// notes: "",
	hasScribble: false
),

elementsDesc: (
	shared: (midiMsgType: \cc, midiChan: 0, ioType: \inout),
	elements: [
	//buttons at bottom right
		(
			key: \pr,
			shared: (elementType: \button, spec: \midiBut, mode: \toggle),
			elements: [
				(midiNum: 105),
				(midiNum: 106),
				(midiNum: 107),
				(midiNum: 108)
			]
		),
	//upper row of encoders when pressed, 4 pages, 8 rows
		(
			key: \tr,
			shared: (elementType: \encoder, spec: \midiCC),
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
			key: \knUp,
			shared: (elementType: \encoder, spec: \midiCC),
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
			shared: (elementType: \midiBut, spec: \midiCC),
			elements: [65,73].collect { |ccStart|
				(elements: 8.collect { |i|
					(midiNum: ccStart+i)
				})
			}
		),
	//other encoders
		(
			key: \kn,
			shared: (elementType: \encoder, spec: \midiCC),
			elements: [81,89,97].collect { |ccStart|
				(
					elements: 8.collect { |i|
						(midiNum: ccStart+i)
					}
				)
			}
		)
	]
)
)