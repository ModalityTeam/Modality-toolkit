// incomplete, but what is there works

/*
thisProcess.nowExecutingPath.basename.split($.).first.postcs;
d = MKtlDesc.loadDescs("*icontrols-pro").first;
d.elementsDict.size;
// d.web;

m.free; m = MKtl(\ic, "*icontrols-pro");
g = m.gui;
g.views.size;
m.trace;
m.elementsDict.size;
m.postElements;
*/

(
deviceName: "iCON iControls_Pro V1.02",
protocol: \midi,
deviceType: \faderbox,
elementTypes: [\fader, \button],
status: (
	linux: "unknown",
	osx: "tested desc, looks good. 2016_03_23, adc",
	win: "unknown"),

idInfo: "iCON iControls_Pro V1.02",

deviceInfo: (
	// vendorURI: "",
	// manualURI: "",
	// description: "",
	// features: [],
	// notes: "",
	longName: "iCON iControls Pro",
	// hasScribble: false
),
elementsDesc: (
	elements: [
		(
			key: \bt,
			shared: (elementType: \pad, ioType: \inout, groupType: \noteOnOffBut,
				midiMsgType: \noteOn, midiChan: 0, spec: \midiBut, mode: \push ),
			elements: [
				(
					key: \rec,
					elements: (0..7).collect { |num, i|
						(
							key: (i+1).asSymbol,
							midiNum: num,
							shared: (style: (row: 0, column: i))
						)
					}
				),
				(
					key: \solo,
					elements: (8..15).collect { |num, i|
						(
							key: (i+1).asSymbol,
							midiNum: num,
							shared: (style: (row: 1, column: i))
						)
					}
				),
				(
					key: \mute,
					elements: (16..23).collect { |num, i|
						(
							key: (i+1).asSymbol,
							midiNum: num,
							shared: (style: (row: 2, column: i))
						)
					}
				),
				(
					key: \select,
					// assuming this is 24-31? was 16-23, copy paste error?
					elements: (24..31).collect { |num, i|
						(
							key: (i+1).asSymbol,
							midiNum: num,
							shared: (style: (row: 3, column: i))
						)
					}
				)
			]
		),
		(
			key: \kn,
			shared: (midiMsgType: \cc, elementType: \encoder,
				ioType: \inout, midiChan: 0, spec: \midiCC, mode: \mackie ),
			elements: (16..23).collect { |num, i| (midiNum: num) }
		),
		(
			key: \sl,
			shared: (midiMsgType: \bend, elementType: \slider,
				ioType: \inout, spec: \midiBend),
			elements: 9.collect { |i| (midiChan: i) }
		)
	]
)
)