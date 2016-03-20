/* Example for a custom-made MIDI hardware device and its elements.

	The joybox is made from a Doepfer pocket electronics kit,
	which can send 16 midi controls,
	and 8 XY joysticks in a 4x2 layout (see gui).

// basic example:
// make an Mktl for it - will say that this is virtual only
MKtl(\jbx, "decampo-joybox"); MKtl(\jbx).gui;

// MKtl has as idInfo : "EXTERNAL", which is not an existing port name.
MKtl(\jbx).desc.fullDesc.at(\idInfo);

// So we need to tell it which midi hardware interface we connect it to.

// See which MIDI sources are available:
MIDIClient.sources;

// figure out which one you want to use,
// and open it via the port name as idInfo:
MKtl(\jbx).openDeviceVia("IAC Driver");

*/

(

deviceName: "joybox",
protocol: \midi,
deviceType: \faderbox,
elementTypes: [\fader],
status: (
	linux: "unknown",
	osx: "tested and working. 2016-03-16, adc",
	win: "unknown"),

idInfo: "EXTERNAL",

deviceInfo: (
	vendorURI: "http://www.doepfer.de/pe.htm",
	manualURI: "http://www.doepfer.de/pdf/PE_manual.pdf",
	description: "Controller box with 8 XY joysticks, made w doepfer pocket-electronics kit.",
	features: ["8 XY joysticks"],
	longName: "de Campo's JoyBox"
),

elementsDesc: (
	key: \joy,
	shared: (elementType: \joyAxis, midiMsgType: \control,
			spec: \midiCC, midiChan: 0, ioType: \in),
	elements: (0..7).collect { |i|
		(
			key: (i+1).asSymbol,
			elements: [
				(key: \x, midiNum: i * 2,
					style: (height: 2, row: i div: 4 * 2, column: i % 4 * 2)),
				(key: \y, midiNum: i * 2 + 1,
					style: (height: 2, row: i div: 4 * 2, column: i % 4 * 2 + 0.85))
			]
		);
	}
)
);
