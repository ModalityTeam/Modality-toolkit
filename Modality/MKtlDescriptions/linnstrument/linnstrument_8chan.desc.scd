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
deviceType: '___',
elementTypes: [  ],
status: (
	linux: "unknown",
	osx: "tested and working, 2016-03-16, adc",
	win: "unknown"),

idInfo: "LinnStrument MIDI",

deviceInfo: (
	vendorURI: 'http://www.rogerlinndesign.com/linnstrument.html',
	manualURI: 'http://www.rogerlinndesign.com/linnstrument-support.html',
	description: "",
	features: [],
	notes: "For this setup, go to Per-split settings,\n"
	"turn MIDI MODE to ChPerRow,\n"
	"and LOUDNESS/Z TO CHAN PRES.",
	hasScribble: false
),

elementsDesc: (

	elements: [
		(
			key: \vol,
			shared: (midiNum: 7, midiMsgType: \cc, 'spec': 'midiCC', 'elementType': \slider),
			elements: [
				(key: \L, midiChan: 0),
				(key: \R, midiChan: 14)
			]
		),
		// sends on channels 0-7, only making it for the first:
		(
			key: \switch1, midiNum: 64, midiChan: 0, midiMsgType: \cc, 'spec': 'midiBut',
			'elementType': \button
		),
		// does nothing - only on my linnstrument?
		(
			key: \switch2, midiNum: 0, midiChan: 0, midiMsgType: \cc, 'spec': 'midiBut',
			'elementType': \button
		),

		// the grid of pads:
		(
			key: \row,
			elements: (30,35..65).collect { |lownum, coli|
				var notenums = lownum + (0..24); // 2 octaves
				// "coli: %\n".postf(coli);
				(
					shared: (midiChan: coli),
					elements: [
						(
							key: \pad,

							elements: notenums.collect { |num, rowi|
								(
									shared: (midiNum: num),
									elements: [
										(key: \on, 'midiMsgType': 'noteOn', 'spec': 'midiVel'),
										(key: \off, 'midiMsgType': 'noteOff', 'spec': 'midiVel'),
										(key: \touch, 'midiMsgType': 'polytouch', 'spec': 'midiCC'),
									]
								)
							}
						),
						(
							key: \bend, midiChan: coli, 'midiMsgType': 'bend',
							'elementType': 'padX', 'spec': 'midiBend'
						),
						// channel touch, has to be activated
						(
							key: \touch, midiChan: coli, 'midiMsgType': 'touch',
							'elementType': 'touch', 'spec': 'midiCC'
						),
						(
							key: \padY, midiNum: 74, midiChan: coli, midiMsgType: \cc,
							'spec': 'midiCC', 'elementType': \padY
						)
					]
				)
			}
		)
	]
)
);
