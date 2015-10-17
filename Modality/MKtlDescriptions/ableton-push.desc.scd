(
deviceName: "Ableton Push",
protocol: \midi,
deviceType: \push,
elementTypes: [\pad, \button, \encoder, \display, \bend],
status: (
	linux: "unknown",
	osx: "tested",
	win: "unknown"),

idInfo: "Ableton Push",

deviceInfo: (
	vendorURI: "https://www.ableton.com/en/push/",
	manualURI: "https://www.ableton.com/en/manual/using-push/",
	description: "Official Ableton Live controller.",
	features: [
		"64 velocity and pressure-sensitive pads",
		"RGB backlighting",
		"11 touch-sensitive encoders",
		"4-line LCD alphanumeric display",
		"17 cm touch strip for pitch bend/scrolling",
		"24 LEDs for navigation",
	],
	notes:
		"Currently only ```User-mode``` supported.\n"
		"Usage:\n"
		"\n"
		"```\n"
		"m = MKtl('push', \"ableton*\", multiIndex: 1);\n"
		"```\n"
		"\n"
		"Helper class: ```MPushHelper```",
	hasScribble: true
),

	// display still missing because SysEx and different MIDI port...
description: (

//------ pads -------------
	\pad: (
		\on: (36..99).collect { |num|
			(midiMsgType: \noteOn,  elementType: \pad, midiChan: 0, midiNum: num, spec: \midiNote, ioType: \inout)
		}.clump(8),
		\off: (36..99).collect { |num|
			(midiMsgType: \noteOff, elementType: \pad, midiChan: 0, midiNum: num, spec: \midiNote, ioType: \inout)
		}.clump(8),
		\poly: (36..99).collect { |num|
			(midiMsgType: 'polyTouch', elementType: 'keytouch', midiChan: 0, midiNum: num,            spec: 'midiCC', ioType: \in)
		}.clump(8)
	),


	//------ ribbon -----------
	ribbon: (
		touch: (midiMsgType: 'noteOnOff', elementType: 'button', midiChan: 0, midiNum: 12,   spec: 'midiNote'),
		bend:  (midiMsgType: 'bend',      elementType: 'ribbon', midiChan: 0,                spec: 'midiBend')
	),


//------ encoderTopRow
	kn: (
		touch: ( 0.. 8).collect { |num|
			(midiMsgType: \noteOnOff, elementType: 'button', midiChan: 0, midiNum: num, spec: \midiVel)
		},
		turn:  (71..79).collect { |num|
			(midiMsgType: \cc, elementType: \encoder, midiChan: 0, midiNum: num, spec: \midiCC)
		}
	),

	//------ left encoders (not in a group because very different in experience)
	knLeft: (
		touch: (midiMsgType: \noteOnOff, elementType: \button,  midiChan: 0, midiNum: 10, spec: \midiVel),
		turn:  (midiMsgType: \cc,        elementType: \encoder, midiChan: 0, midiNum: 14, spec: \midiBut)
	),
	knRight: (
		touch: (midiMsgType: \noteOnOff, elementType: \button,  midiChan: 0, midiNum:  9, spec: \midiVel),
		turn:  (midiMsgType: \cc,        elementType: \encoder, midiChan: 0, midiNum: 15, spec: \midiBut)
	),

	//------ color button rows
	bt: [
		(20..27).collect { |num|
			(midiMsgType: 'cc', elementType: 'button', midiChan: 0, midiNum: num,  spec: 'midiCC', ioType: \inout)
		},
		(102..109).collect { |num|
			(midiMsgType: 'cc', elementType: 'button', midiChan: 0, midiNum: num,  spec: 'midiCC', ioType: \inout)
		}
	],
	btLen: (
		//------ note lentgh buttons
		'132t':			 (midiMsgType: 'cc', elementType: 'button', midiChan: 0, midiNum:    43, spec: 'midiCC', ioType: \inout),
		'132':			 (midiMsgType: 'cc', elementType: 'button', midiChan: 0, midiNum:    42, spec: 'midiCC', ioType: \inout),
		'116t':			 (midiMsgType: 'cc', elementType: 'button', midiChan: 0, midiNum:    41, spec: 'midiCC', ioType: \inout),
		'116':			 (midiMsgType: 'cc', elementType: 'button', midiChan: 0, midiNum:    40, spec: 'midiCC', ioType: \inout),
		'18t':			 (midiMsgType: 'cc', elementType: 'button', midiChan: 0, midiNum:    39, spec: 'midiCC', ioType: \inout),
		'18':			 (midiMsgType: 'cc', elementType: 'button', midiChan: 0, midiNum:    38, spec: 'midiCC', ioType: \inout),
		'14t':			 (midiMsgType: 'cc', elementType: 'button', midiChan: 0, midiNum:    37, spec: 'midiCC', ioType: \inout),
		'14':			 (midiMsgType: 'cc', elementType: 'button', midiChan: 0, midiNum:    36, spec: 'midiCC', ioType: \inout),
	),
	btCtl: (
		//------ ctl buttons
		\tapTempo:		 (midiMsgType: 'cc', elementType: 'button', midiChan: 0, midiNum:     3, spec: 'midiCC', ioType: \inout),
		\metronome:		 (midiMsgType: 'cc', elementType: 'button', midiChan: 0, midiNum: 	  9, spec: 'midiCC', ioType: \inout),
		\undo:			 (midiMsgType: 'cc', elementType: 'button', midiChan: 0, midiNum: 	119, spec: 'midiCC', ioType: \inout),
		\delete:		 (midiMsgType: 'cc', elementType: 'button', midiChan: 0, midiNum: 	118, spec: 'midiCC', ioType: \inout),
		\double:		 (midiMsgType: 'cc', elementType: 'button', midiChan: 0, midiNum: 	117, spec: 'midiCC', ioType: \inout),
		\quantize:		 (midiMsgType: 'cc', elementType: 'button', midiChan: 0, midiNum: 	116, spec: 'midiCC', ioType: \inout),
		\fixedLength:	 (midiMsgType: 'cc', elementType: 'button', midiChan: 0, midiNum: 	 90, spec: 'midiCC', ioType: \inout),
		\automation:	 (midiMsgType: 'cc', elementType: 'button', midiChan: 0, midiNum: 	 89, spec: 'midiCC', ioType: \inout),
		\duplicate:		 (midiMsgType: 'cc', elementType: 'button', midiChan: 0, midiNum: 	 88, spec: 'midiCC', ioType: \inout),
		\new:			 (midiMsgType: 'cc', elementType: 'button', midiChan: 0, midiNum: 	 87, spec: 'midiCC', ioType: \inout),
		\record:		 (midiMsgType: 'cc', elementType: 'button', midiChan: 0, midiNum: 	 86, spec: 'midiCC', ioType: \inout),
		\play:			 (midiMsgType: 'cc', elementType: 'button', midiChan: 0, midiNum: 	 85, spec: 'midiCC', ioType: \inout),
		\master:		 (midiMsgType: 'cc', elementType: 'button', midiChan: 0, midiNum: 	 28, spec: 'midiCC', ioType: \inout),
		\stop:			 (midiMsgType: 'cc', elementType: 'button', midiChan: 0, midiNum: 	 29, spec: 'midiCC', ioType: \inout),
		\volume:		 (midiMsgType: 'cc', elementType: 'button', midiChan: 0, midiNum: 	114, spec: 'midiCC', ioType: \inout),
		\track:			 (midiMsgType: 'cc', elementType: 'button', midiChan: 0, midiNum: 	112, spec: 'midiCC', ioType: \inout),
		\device:		 (midiMsgType: 'cc', elementType: 'button', midiChan: 0, midiNum: 	110, spec: 'midiCC', ioType: \inout),
		\in:			 (midiMsgType: 'cc', elementType: 'button', midiChan: 0, midiNum: 	 62, spec: 'midiCC', ioType: \inout),
		\mute:			 (midiMsgType: 'cc', elementType: 'button', midiChan: 0, midiNum: 	 60, spec: 'midiCC', ioType: \inout),
		\scales:		 (midiMsgType: 'cc', elementType: 'button', midiChan: 0, midiNum: 	 58, spec: 'midiCC', ioType: \inout),
		\repeat:		 (midiMsgType: 'cc', elementType: 'button', midiChan: 0, midiNum: 	 56, spec: 'midiCC', ioType: \inout),
		\octaveDown:	 (midiMsgType: 'cc', elementType: 'button', midiChan: 0, midiNum: 	 54, spec: 'midiCC', ioType: \inout),
		\addEffect:		 (midiMsgType: 'cc', elementType: 'button', midiChan: 0, midiNum: 	 52, spec: 'midiCC', ioType: \inout),
		\note:			 (midiMsgType: 'cc', elementType: 'button', midiChan: 0, midiNum: 	 50, spec: 'midiCC', ioType: \inout),
		\select:		 (midiMsgType: 'cc', elementType: 'button', midiChan: 0, midiNum: 	 48, spec: 'midiCC', ioType: \inout),
		\panSend:		 (midiMsgType: 'cc', elementType: 'button', midiChan: 0, midiNum: 	115, spec: 'midiCC', ioType: \inout),
		\clip:			 (midiMsgType: 'cc', elementType: 'button', midiChan: 0, midiNum: 	113, spec: 'midiCC', ioType: \inout),
		\browse:		 (midiMsgType: 'cc', elementType: 'button', midiChan: 0, midiNum: 	111, spec: 'midiCC', ioType: \inout),
		\out:			 (midiMsgType: 'cc', elementType: 'button', midiChan: 0, midiNum: 	 63, spec: 'midiCC', ioType: \inout),
		\solo:			 (midiMsgType: 'cc', elementType: 'button', midiChan: 0, midiNum: 	 61, spec: 'midiCC', ioType: \inout),
		\user:			 (midiMsgType: 'cc', elementType: 'button', midiChan: 0, midiNum: 	 59, spec: 'midiCC', ioType: \inout),
		\accent:		 (midiMsgType: 'cc', elementType: 'button', midiChan: 0, midiNum: 	 57, spec: 'midiCC', ioType: \inout),
		\octaveUp:		 (midiMsgType: 'cc', elementType: 'button', midiChan: 0, midiNum: 	 55, spec: 'midiCC', ioType: \inout),
		\addTrack:		 (midiMsgType: 'cc', elementType: 'button', midiChan: 0, midiNum: 	 53, spec: 'midiCC', ioType: \inout),
		\session:		 (midiMsgType: 'cc', elementType: 'button', midiChan: 0, midiNum: 	 51, spec: 'midiCC', ioType: \inout),
		\shift:			 (midiMsgType: 'cc', elementType: 'button', midiChan: 0, midiNum: 	 49, spec: 'midiCC', ioType: \inout),
		\left:			 (midiMsgType: 'cc', elementType: 'button', midiChan: 0, midiNum: 	 44, spec: 'midiCC', ioType: \inout),
		\right:			 (midiMsgType: 'cc', elementType: 'button', midiChan: 0, midiNum: 	 45, spec: 'midiCC', ioType: \inout),
		\up:			 (midiMsgType: 'cc', elementType: 'button', midiChan: 0, midiNum: 	 46, spec: 'midiCC', ioType: \inout),
		\down:			 (midiMsgType: 'cc', elementType: 'button', midiChan: 0, midiNum:	 47, spec: 'midiCC', ioType: \inout)
	)
)
)