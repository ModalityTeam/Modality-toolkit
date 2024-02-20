(
deviceName: "XONE:K2",
protocol: 'midi',
deviceType: 'mixer',
elementTypes: [  \fader, \button, \knob ],
status: (
	linux: "tested by bgola on 08.11.2023",
	osx: "tested by bgola on 08.11.2023",
	win: "unknown"),

idInfo: "XONE:K2",
hardwarePages: [0,1,2],

deviceInfo: (
	vendorURI: 'https://www.allen-heath.com/hardware/xone-series/xonek2/',
),
elementsDesc: (
	elements: [
		(
			key: \kn,
			shared: (\midiMsgType: 'cc', \midiChan: 0, \spec: \midiCC),
			elements: 3.collect{|idx|
				((22*idx)..(22*idx+21)).collect { |midiNum, i|
					(
						elementType: if(midiNum%22 < 16 or: {midiNum % 22 > 19}) { \knob } { \slider },
						midiNum: midiNum,
						key: "cc_%".format(midiNum).asSymbol,
						style: (
							row: if (midiNum % 22 > 19) { 13 } { (i/4).floor * 2 },
							column: if (midiNum % 22 > 19) { (midiNum%22) - 19  } { i%4 },
							height: 1, width: 1),
						page: idx
					)
				}
			}.flatten,
		),
		(
			key: \bt,
			shared: (midiChan: 0, elementType: \pad,  groupType: \noteOnOffTouch),
			elements: 3.collect{|idx|
				((12..15) + (4 * idx)).collect {|midiNum, i|
					(
						midiNum: midiNum,
						style: (row:(i/4).floor + 14,  column: (i%4)),
						page: idx
					)
				} ++
				((55..24) + (32 * idx)).collect {|midiNum, i|
					(
						midiNum: midiNum,
						style: (
							//row:(i/4).floor * 2 + 1,
							row: if (i < (5*4)) { (i/4).floor * 2 + 1 } { (i/4).floor + 5 },
							column: ( ((i%4) - 3).abs )
						),
						page: idx
					)
				}
			}.flatten;
		),
	]
)
);
