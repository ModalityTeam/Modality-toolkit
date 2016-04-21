// Behringer BCF2000 specs:
/*

pr[row][column]
tr[page][column]
knUp[page][column]
bt[row][column]
sl[row][column]

MKtl('bcf', "behringer-bcf2000",multiIndex:0);
MKtl('bcf').gui

MKtl('bcf').elAt(\sl,0,0).value_(0.5)

*/


(

deviceName: "BCF2000",
protocol: \midi,
deviceType: \faderbox,
elementTypes: [\fader, \button, \encoder],
status: (
	linux: "unknown",
	osx: "tested and working, except midiOut has no port number. 2016-03-22, dhml&adc.",
	win: "unknown"),

// assuming IO is on port 1, port 2 is ext in/out, port 3 is out only
idInfo: (deviceName: "BCF2000", srcPortIndex: 0, destPortIndex: 0),

hardwarePages: [1, 2, 3, 4],


deviceInfo: (
	vendorURI: "http://www.music-group.com/Categories/Behringer/Computer-Audio/Desktop-Controllers/BCF2000/p/P0246",
	manualURI: "https://media.music-group.com/media/PLM/data/docs/P0246/BCF2000_BCR2000_M_EN.pdf",
	// description: "",
	features: [
		"8 motor-faders",
		"8 rotary-encoder",
		"30 Buttons"
	],
	// notes: "",
	longName: "Behringer BCF2000"
),
elementsDesc: (
	shared: (midiMsgType: \cc, midiChan: 0),
	elements: [
	//buttons at bottom right
		(
			key: \pr,
			shared: (elementType: \button, spec: \midiBut, mode: \toggle),
			elements: [
				(elements: [
					( midiNum: 89, \style: (row:4, column: 8)),
					( midiNum: 90, \style: (row:4, column: 9)) ] ),
				(elements: [
					( midiNum: 91, \style: (row:5, column: 8)),
					( midiNum: 92, \style: (row:5, column: 9)) ] )
			]
		),

		//upper row of encoders when pressed, 4 pages, 8 rows
		(
			key: \tr,
			shared: (elementType: \button, spec: \midiBut, ioType: \in),
			elements: 4.collect { |j|
				(
					elements: 8.collect { |i|
						// top knob push mode
						( midiNum: 33+(8*j)+i, page: j, \style: (row:0, column: i))
					}
				)
			}
		),
		//upper row of encoders, 4 pages, 8 rows
		(
			key: \kn,
			shared: (elementType: \encoder, spec: \midiCC, ioType: \in),
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
			shared: (elementType: \button, spec: \midiCC, ioType: \inout),
			elements: [65,73].collect { |ccStart,j|
				(
					elements: 8.collect { |i|
						(midiNum: ccStart+i, \style: (row:2+j, column: i))
					}
				)
			}
		),
	//sliders
		(
			key: \sl,
			shared: (elementType: \slider, spec: \midiCC, ioType: \inout),
			elements: 8.collect { |i| (midiNum: 81+i, \style: (row:4, column: i)) }
		)
	]
)
)