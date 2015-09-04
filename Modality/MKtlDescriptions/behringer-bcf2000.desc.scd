// Behringer BCF2000 specs:
/*

pr_u_l
pr_u_r
pr_d_l
pr_d_r
tr[page][row][column]
kn[page][row][column]
bt[row][column]
sl[row][column]


*/


(
idInfo: "BCF2000",
protocol: \midi,
hardwarePages: [1,2,3,4],
deviceInfo: (
	vendorURI: "http://www.behringer.com/EN/Products/BCR2000.aspx",
	manualURI: "http://www.behringer.com/assets/BCF2000_BCR2000_M_EN.pdf",
	// description: "",
	// features: [],
	// notes: "",
	type: [\fader, \rotary],
	hasScribble: true
),
description: (
	//buttons at bottom right
	\pr_u_l: (\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum: 89, \spec: \midiBut, \mode: \toggle, \ioType: \inout),
	\pr_u_r: (\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum: 90, \spec: \midiBut, \mode: \toggle, \ioType: \inout),
	\pr_d_l: (\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum: 91, \spec: \midiBut, \mode: \toggle, \ioType: \inout),
	\pr_d_r: (\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum: 92, \spec: \midiBut, \mode: \toggle, \ioType: \inout),

	//upper row of encoders when pressed
	\tr:4.collect{ |j|
		8.collect{ |i|
			// top knob knpush mode
			(\midiMsgType: \cc, \type: \encoder, \midiChan: 0, \midiNum: 33+(8*j)+i, \spec: \midiCC, \ioType: \in)
		}
	},

	//upper row of encoders
	\kn:4.collect{ |j|
		8.collect{ |i|
			// top knob push mode
			(\midiMsgType: \cc, \type: \encoder, \midiChan: 0, \midiNum: 1+(8*j)+i, \spec: \midiCC, \ioType: \inout)
		}
	},

	//buttons
	\bt:[65,73].collect{ |ccStart|
		8.collect{ |i|
			(\midiMsgType: \cc, \type: \midiBut, \midiChan: 0, \midiNum: ccStart+i, \spec: \midiCC, \ioType: \inout)
		}
	},

	//sliders
	sl:8.collect{ |i|
		(\midiMsgType: \cc, \type: \encoder, \midiChan: 0, \midiNum: 81+i, \spec: \midiCC, \ioType: \inout)
	}
)
)