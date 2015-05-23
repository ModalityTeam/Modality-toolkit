// user: channel 0
// factory: channel 8

(
idInfo: "Launch Control XL",
protocol: \midi,
description:
[

'knSndA' -> 16.collect{|chan| (13..20).collect{|num|
          ('midiMsgType': 'cc',        'type': 'knob',   'midiChan': chan, 'midiNum':  num, 'spec': 'midiCC', \ioType: \inout, \page: chan)
}},

'knSndB' -> 16.collect{|chan| (29..36).collect{|num|
          ('midiMsgType': 'cc',        'type': 'knob',   'midiChan': chan, 'midiNum':  num, 'spec': 'midiCC', \ioType: \inout, \page: chan)
}},

'knPan' ->  16.collect{|chan| (49..56).collect{|num|
          ('midiMsgType': 'cc',        'type': 'knob',   'midiChan': chan, 'midiNum':  num, 'spec': 'midiCC', \ioType: \inout, \page: chan)
}},

\sl ->  16.collect{|chan| (77..84).collect{|num|
		('midiMsgType': 'cc',        'type': 'slider', 'midiChan': chan, 'midiNum':  num, 'spec': 'midiCC', \ioType: \inout, \page: chan, \style: ( height: 4 ))
}},

'btFcs' -> 16.collect{|chan| ((41..44) ++ (57..60)).collect{|num|
          ('midiMsgType': 'noteOnOff', 'type': 'button', 'midiChan': chan, 'midiNum':  num,'spec': 'midiNote', \ioType: \inout, \page: chan)
}},

'btCtl' -> 16.collect{|chan| ((73..76) ++ (89..92)).collect{|num|
          ('midiMsgType': 'noteOnOff', 'type': 'button', 'midiChan': chan, 'midiNum':  num,'spec': 'midiNote', \ioType: \inout, \page: chan)
}},

'device' -> 16.collect{|chan|
		('midiMsgType': 'noteOnOff', 'type': 'button', 'midiChan': chan, 'midiNum':  105,'spec': 'midiNote', \ioType: \inout, \page: chan, \style: (row: 3, column: 8.5, showLabel: true))
},
'mute' ->  16.collect{|chan|
	      ('midiMsgType': 'noteOnOff', 'type': 'button', 'midiChan': chan, 'midiNum':  106,'spec': 'midiNote', \ioType: \inout, \page: chan, \style: (row: 4, column: 8.5, showLabel: true))
},
'solo' ->  16.collect{|chan|
	      ('midiMsgType': 'noteOnOff', 'type': 'button', 'midiChan': chan, 'midiNum':  107,'spec': 'midiNote', \ioType: \inout, \page: chan, \style: (row: 5, column: 8.5, showLabel: true))
},
'arm' ->   16.collect{|chan|
	      ('midiMsgType': 'noteOnOff', 'type': 'button', 'midiChan': chan, 'midiNum':  108,'spec': 'midiNote', \ioType: \inout, \page: chan, \style: (row: 6, column: 8.5, showLabel: true))
},

\up ->     16.collect{|chan|
	      ('midiMsgType': 'cc',        'type': 'button', 'midiChan': chan, 'midiNum':  104, 'spec': 'midiCC', \ioType: \inout, \page: chan, \style: (row: 1, column: 8, showLabel: true))
},
\down ->   16.collect{|chan|
	      ('midiMsgType': 'cc',        'type': 'button', 'midiChan': chan, 'midiNum':  105, 'spec': 'midiCC', \ioType: \inout, \page: chan, \style: (row: 1, column: 9, showLabel: true))
},
\left ->   16.collect{|chan|
	      ('midiMsgType': 'cc',        'type': 'button', 'midiChan': chan, 'midiNum':  106, 'spec': 'midiCC', \ioType: \inout, \page: chan, \style: (row: 2, column: 8, showLabel: true))
},
\right ->   16.collect{|chan|
	      ('midiMsgType': 'cc',        'type': 'button', 'midiChan': chan, 'midiNum':  107, 'spec': 'midiCC', \ioType: \inout, \page: chan, \style: (row: 2, column: 9, showLabel: true))
},
]);

