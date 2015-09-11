/*
According to Manual,
Port 1 is for pd->comp, comp->pd: pads do noteOn/off, noteNum, velocity.
Port 2 is for pd>comp, buttons (shift, curveSetup, 4velmode, browse)
	and rot knob; browse can be sent back
Port 3 is apparently unused (i.e. reserved for company-only uses).

pads and 4velmode also send sysex on port 2;
4velmode button toggles light, but sends noteOn/off on touch/release.
(state liekly sent in sysex.

 --- velocity value is always 16!
--- 4velmode is same note on buts 1,5,9,13 etc; vel 31, 63, 95, 127.

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
9: (4..19),
10: (20..35),
11: (36..51),
12: (52..67),
13: (68..83),
14: (84..99),
15: (100..115),
16: all sysex messages


- is browse button and note 58 the same note? clarify.
- write litte example using some controls.

y = MIDIOut(2);
y.noteOn(0, 60, 127);
MIDIFunc.trace
*/
(
idInfo:"Steinberg CMC-PD",
portIndex: 2,
protocol: \midi,
deviceType: \drumPad,

deviceInfo: (
	vendorURI: "http://www.steinberg.net/en/products/controllers/cmc_series/models/cmc_pd.html",
	// manualURI: "",
	// description: "",
	// features: "",
	// notes: "",
	elementTypes: [\pad, \button]
),
description:

(
// ------ noteOnOff -------------
'pad': (52..63).collect ({ |num| ('midiMsgType': 'noteOnOff', 'type': 'key', 'midiChan': 0, 'midiNum': num, 'spec': 'midiNote') }),

'shift': ('midiMsgType': 'noteOnOff', 'type': 'key', 'midiChan': 0, 'midiNum':  70, 'spec': 'midiBut'),
'curveSetup': ('midiMsgType': 'noteOnOff', 'type': 'key', 'midiChan': 0, 'midiNum':  114, 'spec': 'midiNote'),
'4velMode': ('midiMsgType': 'noteOnOff', 'type': 'key', 'midiChan': 0, 'midiNum':  115, 'spec': 'midiNote'),
'browse': ('midiMsgType': 'noteOnOff', 'type': 'key', 'midiChan': 0, 'midiNum':  58, 'spec': 'midiNote'),

// ------ cc -------------
// realtive: clockwise = 1, faster is 2, 3, 4; ccw is 65 .. 66, 67, 68..72

'kn': ('midiMsgType': 'cc', 'type': 'slider', 'midiChan': 0, 'midiNum':  60,'spec': 'midiCC'),
)
);