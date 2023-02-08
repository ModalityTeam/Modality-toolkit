/****

Description file for Faderfox EC4.

For general information, see parent description file
MKtlDesc.findFile(MKtlDesc.at(\faderfox_ec4).fullDesc[\parentDesc], fileExt: MKtlDesc.parentExt).first.openDocument

This implements 14bit mode for all 16 groups of the Faderfox EC4 as it is set for "Setup 01" in the sysex file "SE01-allGroupsCCAh.syx" next to this document.
Load the SE01 of the sysex file to a setup of your choosing on your EC4 via
   https://www.privatepublic.de/faderfox-editor/ec4/
   https://github.com/privatepublic-de/faderfox-editor
and make sure to select it on the EC4.

Also, it implements hat presses that can be set on the EC4 by "Setup">"Push:Note".



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
			shared: (midiChan: midiChan),


			elements: [
				(
					key: \kn,   // group name
					shared: (elementType: \knob, midiMsgType: \cc14, spec: \midiCC14),
					elements: (0..15).collect {|midiNum, i|
						( midiNum: midiNum,
							style: (row: i div: 4 , column: (i % 4) * 2, width: 0.5, height: 1)
						)
					}
				),
				(
					key: \hat, // group name
					shared: (elementType: \button, groupType: \noteOnOffBut),
					elements: (0..15).collect {|midiNum, i|
						( midiNum: midiNum,
							style: (row: i div: 4 , column: (i % 4) * 2 + 1, width: 0.5, height: 1)
						)

					}
				)
			]
		)
	}
)
);

