/****
Description file for Faderfox EC4 default setting,
where encoders only send 7bit cc messages.
For 14bit, see and use ec4.desc.scd!

For general information, see parent description file:
Document.open("faderfox_ec4.parentDesc.scd".resolveRelative);
****/

(
parentDesc: "faderfox_ec4",

status: (
	linux: "unknown",
	osx: "unknown",
	win: "unknown"
),

elementsDesc:
// ------ cc -------------
(
	shared: (ioType: \inout),

	elements: (0..15).collect{|midiChan|
		(
			key: "GR%".format((100 + midiChan+1).asString[1..]).asSymbol,
			shared: (midiChan: midiChan, page: midiChan),

			elements: [
				(
					key: \kn,   // group name
					shared: (elementType: \knob, midiMsgType: \cc, spec: \midiCC),
					elements: (0..15).collect {|midiNum, i|
						( midiNum: midiNum,
							style: (row: i div: 4 , column: (i % 4) * 2, width: 1, height: 1)
						)
					}
				),
				(
					key: \hat, // group name
					shared: (elementType: \button, groupType: \noteOnOffBut),
					elements: (0..15).collect {|midiNum, i|
						( midiNum: midiNum,
							style: (row: i div: 4 , column: (i % 4) * 2 + 1, width: 1, height: 1)
						)

					}
				)
			]
		)
	}
)
);
