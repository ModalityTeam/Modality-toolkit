
//MIDIMKtl('cncn2000').elements.do{ |el| el.action_{ el.name.postln} }

(
device: "iCON iControls V2.00",
protocol: \midi,
description:(

	\but: [
		[ 16, 17, 18, 19, 20, 21, 22, 23, 48 ],
		[ 8, 9, 10, 11, 12, 13, 14, 15, 49 ]
	].collect{ |xs, row|

		xs.collect{ |note, column|
			(\midiMsgType: \noteOnOff, \type: \button, \midiChan: 0, \midiNum:  note, \spec: \midiVel)
		}
	},

	\leftbut:
	[
		[ 91, 94, 92 ],
		[ 86, 93, 95 ]
	].collect{ |xs, row|

		xs.collect{ |note, column|
			(\midiMsgType: \noteOnOff, \type: \button, \midiChan: 0, \midiNum:  note, \spec: \midiVel)
		}
	},

	\sl:
	(0..8).collect{ |i, n|
		(\midiMsgType: \cc, \type: \slider, \midiChan: i, \midiNum:  13, \spec: \midiCC)
	},

	\kn:((16..23)++[12]).collect{ |i, n|
		(\midiMsgType: \cc, \type: \slider, \midiChan: 0, \midiNum:  i, \spec: \midiCC)
	}
)
)