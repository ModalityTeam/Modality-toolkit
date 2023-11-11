/****

Parent description file for Faderfox EC4 with all general information

****/


(
deviceName: "Faderfox EC4",
protocol: 'midi',
deviceType: 'controller',
elementTypes: [ \knob ],
idInfo: "Faderfox EC4",
hardwarePages: (1..16),

deviceInfo: (
	vendorURI: "http://faderfox.de/ec4.html",
	manualURI: "http://www.faderfox.de/PDF/EC4%20Manual%20V02.pdf",
	features: [
		"Universal controller for all kinds of midi controllable hard- and software",
		"iPad compatible",
		"Control surface script for Ableton Live is shipped with the controller",
		"USB interface - class compliant / bus powered / no driver necessary (consumption < 500mW)",
		"MIDI in and out ports by 3.5mm minijack sockets type B with routing and merge functionality",
		"16 gridless push encoders - resolution = 36 pulses per revolution",
		"Encoder push buttons can send separate commands",
		"4 x 20 character OLED-display to show control values (numeric/bar), names and programming data",
		"Names for encoders, groups and setups are editable (4 characters per name)",
		"14 bit high resolution encoder mode for sensitive parameters",
		"Programmable value ranges with min/max values",
		"Data feedback avoid value jumps",
		"All encoders fully programmable in the device by channel, type, number, mode, name etc.",
		"Different command types like control change (CC), pitch bend, NRPN, program change and notes",
		"Advanced programming functions like copy, paste and fill",
		"16 independent groups per setup for 16 encoders (256 commands per setup)",
		"Learn function for fast assignment to incoming MIDI commands",
		"16 setups with backup/restore function contain all controller settings incl. names",
		"Very compact design in a black casing (180x105x70 mm, 350 g)",
	],
	longName: "FaderFox EC4",
	notes: "All controls fully programmable in the device by channel, type, number.\n"
	"Absolute and relative controller modes, and 14 bit high resolution encoder mode for sensitive parameters.\n"
	"Programmable value ranges with min/max values, and data feedback for encoders and faders avoid value jumps.\n"
	"MIDI in and out ports feature routing and merge functionality."
)
);