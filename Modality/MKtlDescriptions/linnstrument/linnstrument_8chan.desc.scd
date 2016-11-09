/****
desc file for Roger Linn Design LinnStrument

this is for a layout of 8 rows as string-like monophonic streams.

The LinnStrument consists of a grid of 25 x 8 touch-sensitive fields,
with each key having noteOn, noteOff and polyTouch.
it y-position on the pad can be sent per channel,
and touch can be switched from poly to channel pressure.

For some examples, see "DeviceExamples/linnstrument_8chan.scd":

~here = thisProcess.nowExecutingPath;
(~here.dirname.dirname.dirname +/+ "DeviceExamples/linnstrument_8chan.scd").openOS;

d = MKtlDesc.loadDescs("linn*").first;
d.elementsDict.size;
m.free; m = MKtl(\linn, "linn*");
m.gui;
****/
(
deviceName: "LinnStrument MIDI",
protocol: 'midi',
deviceType: 'surface',
elementTypes: [  ],
status: (
	linux: "unknown",
	osx: "tested and working, 2016-03-16, adc",
	win: "unknown"),

idInfo: "LinnStrument MIDI",

deviceInfo: (
	vendorURI: 'http://www.rogerlinndesign.com/linnstrument.html',
	manualURI: 'http://www.rogerlinndesign.com/linnstrument-support.html',
	features: [],
	notes: "In ```Per-split``` settings,\n"
	"turn ```MIDI MODE``` to ```ChPerRow```,\n"
	"and ```LOUDNESS/Z``` to ```CHAN PRES```.",
	longName: "LinnStrument"
),

elementsDesc: (

	elements: [
		(
			key: \vol,
			shared: (midiNum: 7, midiMsgType: \cc, 'spec': 'midiCC', 'elementType': \slider),
			elements: [
				(key: \L, midiChan: 0, style: (row: 9, column: 2, height: 1, width: 6)),
				(key: \R, midiChan: 14, style: (row: 9, column: 8, height: 1, width: 6))
			]
		),
		// sw_2 does nothing - only on my linnstrument?
		(
			key: \sw,
			shared: (midiChan: 0, midiMsgType: \cc, 'spec': 'midiBut', 'elementType': \button),
			elements: [
				(midiNum: 64, style: (row: 5, column: 0)),
				(midiNum: 0, style: (row: 6, column: 0))
			]
		)
	] ++
		// the grid of pads + controls:
	(30, 35..65).collect { |lownum, rowi|
		var notenums = lownum + (0..24); // 2 octaves
		(
			key: ((rowi + 1)).asSymbol,
			shared: (midiChan: rowi),
			elements: [
				(
					key: \pad,
					shared: (elementType: \pad, groupType: \noteOnOffTouch),
					elements: notenums.collect { |num, coli|
						(
							key: coli, midiNum: num,

							shared: (
								style: (column: coli + 1, row: rowi,
									width: 1.2, height: 1.2,
									label: [rowi, num].join,
									)
							)
						)
					}
				),
				(
					key: \bnd, midiChan: rowi, 'midiMsgType': 'bend',
					'elementType': 'padX', 'spec': 'midiBend',
					style: (row: rowi, column: 26, width: 2, height: 0.6)
				),
				// channel touch, has to be activated
				(
					key: \tch, midiChan: rowi, 'midiMsgType': 'touch',
					'elementType': 'chanTouch', 'spec': 'midiCC',
					style: (row: rowi + 0.3, column: 26, width: 2, height: 0.6)
				),
				(
					key: \pdY, midiNum: 74, midiChan: rowi, midiMsgType: \cc,
					'spec': 'midiCC', 'elementType': \padY,
					style: (row: rowi + 0.6, column: 26, width: 2, height: 0.6)
				)
			]
		)
	}
)
);
