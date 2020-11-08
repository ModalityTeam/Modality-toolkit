/**** Faderfox PC12 desc file. superpeachman 2020_11_08

// General Info:

PC12 as successor of the PC44 is a universal controller for all kinds of Midi controllable hard- and software.


****/

(
deviceName: "PC12",
protocol: \midi,
deviceType: \faderbox,
elementTypes: [\button, \knob],
status: (
	linux: "unknown",
	osx: "unknown",
	win: "tested and working, 01.12.2020 by superpeachman"),

idInfo: "Faderfox PC12",

deviceInfo: (
	vendorURI: "http://faderfox.de/pc12.html",
	manualURI: "http://www.faderfox.de/PDF/PC12%20Manual%20V04.pdf",
	hardwarePages: (1..31),
	longName: "Faderfox PC12",
),

elementsDesc: (
	elements: 31.collect { |chan|
		(
			key: ("B" ++ chan).asSymbol,
			shared: ('midiChan': chan, \page: chan),
			elements: [
				(
					key: \kn,
					shared: (
						'midiMsgType': \cc,
						'midiChan': chan,
						'elementType': \knob,
						'spec': \midiCC

					),
					elements: (1..72).clump(12).collect { |list, gr_i|
						(
							key: (["A","B","C","D","E","F"].at(gr_i)).asSymbol,
							elements: list.collect { |num, i|
								(
									// key: i,
									midiNum: num,
									\style: ( \row: gr_i, \column: i, height: 0)
								)
							}
						)
					}
				),
				(
					key: \bt,
					shared: (
						'midiMsgType': \cc,
						'midiChan': chan,
						'elementType': \button,
						'spec': \midiCC

					),
					elements: (73..84).collect{|num, i|
						(
							midiNum: num,
							label: i + 1,
							style: (
								row: 6,
								column: i
							)
						)
					}
				),
				(
					key: \vkn,
					shared: (
						'midiMsgType': \cc,
						'midiChan': chan,
						'elementType': \knob,
						'spec': \midiCC

					),
					elements: [(
						midiNum: 85,
						label: "Val Knob",
						style: (
							row: 3,
							column: 12
						)
					)]

				),
				(
					key: \vbt,
					shared: (
						'midiMsgType': \cc,
						'midiChan': chan,
						'elementType': \pad,
						'spec': \midiCC

					),
					elements: [(
						midiNum: 86,
						label: "Click Knob",
						style: (
							row: 2,
							column: 12
						)
					)]

				)
			] // elements:
		)
	};

)
)
