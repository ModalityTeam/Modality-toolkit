// Behringer BCR2000 specs:
/*

pr[row][column]
tr[page][column]
knUp[page][column]
bt[row][column]
kn[row][column]

MKtl('bcr', "behringer-bcr2000",multiIndex:0);
MKtl('bcr').gui

MKtl('bcr').elAt(\kn,0,0).value_(0.5)

*/


(
deviceName: "BCR2000",
protocol: \midi,
deviceType: \mixer,
elementTypes: [\encoder, \button],
status: (
	linux: "tested and working, 2016-03-15, Miguel Negrão",
	osx: "tested desc, looks good. 2016-03-23, adc",
	win: "unknown"),

// assuming IO is on port 1, port 2 is ext in/out, port 3 is out only
idInfo: (deviceName: "BCR2000", srcPortIndex: 0, destPortIndex: 0),

hardwarePages: [1,2,3,4],

deviceInfo: (
	vendorURI: "http://www.music-group.com/Categories/Behringer/Computer-Audio/Desktop-Controllers/BCR2000/p/P0245",
	manualURI: "https://media.music-group.com/media/PLM/data/docs/P0245/BCF2000_BCR2000_M_EN.pdf",
	description: "A midi device with many rotary encoders.",
	features: [
		"32 rotary encoders",
		"30 Buttons"
	],
	// notes: "",
	longName: "Behringer BCR2000"

),

elementsDesc: (
	shared: (midiMsgType: \cc, midiChan: 0, ioType: \inout),
	elements: [
	//buttons at bottom right
		(
			key: \pr,
			shared: (elementType: \button, spec: \midiBut, mode: \toggle),
			elements: [
				(elements: [ (\style: (row:5, column: 8), midiNum: 105), (\style: (row:5, column: 9), midiNum: 106) ] ),
				(elements: [ (\style: (row:6, column: 8), midiNum: 107), (\style: (row:6, column: 9), midiNum: 108) ] )
			]
		),
	//upper row of encoders when pressed, 4 pages, 8 rows
		(
			key: \tr,
			shared: (elementType: \button, spec: \midiCC),
			elements: 4.collect { |j|
				(
					elements: 8.collect { |i|
						// top knob push mode
						(midiNum: 33+(8*j)+i, page: j, \style: (row:0, column: i))
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
						(midiNum: 1+(8*j)+i, page: j, \style: (row:1, column: i))
					}
				)
			}
		),
	//buttons
		(
			key: \bt,
			shared: (elementType: \button, spec: \midiCC),
			elements: [65,73].collect { |ccStart, j|
				(elements: 8.collect { |i|
					(midiNum: ccStart+i, \style: (row:2+j, column: i))
				})
			}
		),
	//other encoders
		(
			key: \kn,
			shared: (elementType: \encoder, spec: \midiCC),
			elements: [81,89,97].collect { |ccStart, j|
				(
					elements: 8.collect { |i|
						(midiNum: ccStart+i, \style: (row:4+j, column: i))
					}
				)
			}
		)
	]
)
)