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
				(key: \L, midiChan: 0, style: (row: 0, column: 0, height: 1, width: 6,
					showLabel: true)),
				(key: \R, midiChan: 14, style: (row: 0, column: 6, height: 1, width: 6,
					showLabel: true))
			]
		),
		// sw_2 does nothing - only on my linnstrument?
		(
			key: \sw,
			shared: (midiChan: 0, midiMsgType: \cc, 'spec': 'midiBut', 'elementType': \button),
			elements: [ (midiNum: 64), (midiNum: 0) ]
		)
	] ++
		// the grid of pads + controls:
	(30,35..65).collect { |lownum, rowi|
		var notenums = lownum + (0..24); // 2 octaves
		(
			key: ("r" ++ rowi).asSymbol,
			shared: (midiChan: rowi),
			elements: [
				(
					key: \pad,
					elements: notenums.collect { |num, coli|
						(
							shared: (midiNum: num, elementType: \pad),
							elements: [
								(key: \on, 'midiMsgType': 'noteOn', 'spec': 'midiVel',
									style: (column: coli, row: rowi * 2 + 1, width: 0.7)
								),
								(key: \off, 'midiMsgType': 'noteOff', 'spec': 'midiVel',
									style: (column: coli, row: rowi * 2 + 1 + 1, width: 0.7)
								),
								(key: \touch, 'midiMsgType': 'polytouch', 'spec': 'midiCC',
									elementType: \padTouch,
									style: (column: coli + 0.5, row: rowi * 2 + 1,
										height: 2,  width: 0.7)
								),
							]
						)
					}
				),
				(
					key: \bend, midiChan: rowi, 'midiMsgType': 'bend',
					'elementType': 'padX', 'spec': 'midiBend',
					style: (height: 2, showLabel: true)
				),
				// channel touch, has to be activated
				(
					key: \touch, midiChan: rowi, 'midiMsgType': 'touch',
					'elementType': 'chanTouch', 'spec': 'midiCC',
					style: (height: 2, showLabel: true)
				),
				(
					key: \padY, midiNum: 74, midiChan: rowi, midiMsgType: \cc,
					'spec': 'midiCC', 'elementType': \padY,
					style: (height: 2, showLabel: true)
				)
			]
		)
	}
)
);
