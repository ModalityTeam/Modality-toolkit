/**** Faderfox UC4 desc file. adc 2015_12_24 (merry xmas)

// General Info:

The UC4 is a compact, ultraflexible general purpose MIDI controller.
It has 9 sliders, 8 knobs with 8 pushbuttons and 8 normal buttons;
by switching between 8 groups one has 264 controls in one setup,
and 16 presets of 8 groups each allow very flexible uses.

It has multiple descs for different orderings of pages and elements:
faderfox_uc4:
\xfader
\sl [slpage][column]
\bt [slpage][column]
// and on a different page
\kn [knpage][index],
\pbt [knpage][index]

faderfox_uc4_pg has the pages in the top layer:
\xfader
slpg1 [\sl, \bt][column]
...
slpg8 [\sl, \bt][column]

knpg1 [\kn, \pbt][index]
...
knpg8 [\kn, \pbt][index]

****/

(
deviceName: "Faderfox UC4",
protocol: 'midi',
deviceType: 'faderbox',
elementTypes: [ \slider, \knob, \button, \pushbutton ],

idInfo: "Faderfox UC4",

hardwarePages: (1..8),

deviceInfo: (
	vendorURI: "http://faderfox.de/uc4.html",
	manualURI: "http://www.faderfox.de/PDF/UC4%20Manual%20V01.PDF",
	features: [
		"Compact design with metal faceplate"
		"8 push encoders without detents (resolution about 36 pulses)",
		"9 30mm faders, programmable snap function",
		"8 Buttons with LED for switchable parameters",
		"8 independent groups for encoders and faders/buttons",
		"About 264 commands per setup (33 controls x  8 groups)",
		"18 setups with backup/restore function contain all controller settings",
	],
	longName: "FaderFox UC4",
	notes: "All controls (incl. push buttons) fully programmable in the device by channel, type, number.\n"
	"Absolute and relative controller modes, and 14 bit high resolution encoder mode for sensitive parameters.\n"
	"Programmable value ranges with min/max values, and data feedback for encoders and faders avoid value jumps.\n"
	"MIDI in and out ports feature routing and merge functionality."
)
);



