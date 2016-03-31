/*
According to Manual,
Port 1 is for pd->comp, comp->pd: pads do noteOn/off, noteNum, velocity.
Port 2 is for pd>comp, buttons (shift, curveSetup, 4velmode, browse)
	and rot knob; browse can be sent back
Port 3 is apparently unused (i.e. reserved for company-only uses).

pads and 4velmode also send sysex on port 2;
4velmode button toggles its light, but sends noteOn/off on touch/release.
(state likely sent in sysex.)

--- velocity value for pads is always 16!
--- in 4velmode the same note is on buts 1,5,9,13 etc;
	and vel changes between the four buttons from 31, 63, 95, 127.

- shift button is used to switch between note combinations on the pads:
- shift1, pads 1-16:
1: [35, 36, 38, 40,   39,44,42,46,   41,45,47,48,  51,55,49,56],
2: (4..19),
3: (20..35),
4: (36..51),
5: (52..67),
6: (68..83),
7: (84..99),
8: (100..115),
// 9: (4..19), 9-15 seem identical to 2-8
// 10: (20..35),
// 11: (36..51),
// 12: (52..67),
// 13: (68..83),
// 14: (84..99),
// 15: (100..115),
// 16: all sysex messages // not document what these are

*/
(
deviceName: "Steinberg CMC-PD",
protocol: \midi,
deviceType: \drumpad,
elementTypes: [\pad, \button],
numPorts: 3,

deviceInfo: (
	vendorURI: "http://www.steinberg.net/en/products/controllers/cmc_series/models/cmc_pd.html",
	// manualURI: "",
	// description: "",
	// features: "",
	longName: "Steinberg CMC-PD"
	)
);