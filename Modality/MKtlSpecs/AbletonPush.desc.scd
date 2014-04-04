// display still missing...
(
//------ pads -------------
\padOn: (36..99).collect{|num|
	('midiMsgType': 'noteOn', 'type': 'pad', 'midiChan': 0, 'midiNum': num,  'spec': 'midiNote')
}.clump(8),
\padOff: (36..99).collect{|num|
	('midiMsgType': 'noteOff', 'type': 'pad', 'midiChan': 0, 'midiNum': num, 'spec': 'midiNote')
}.clump(8),
\poly: (36..99).collect{|num|
	('midiMsgType': 'polyTouch', 'type': 'keytouch', 'midiChan': 0, 'midiNum': num,'spec': 'midiCC')
}.clump(8),


//------ ribbon -----------
\ribbonOn: ('midiMsgType': 'noteOn', 'type': 'ribbon', 'midiChan': 0, 'midiNum': 12,  'spec': 'midiNote'),
\ribbonOff: ('midiMsgType': 'noteOff', 'type': 'ribbon', 'midiChan': 0, 'midiNum': 12,  'spec': 'midiNote'),
\ribbon: ('midiMsgType': 'bend', 'type': 'ribbon', 'midiChan': 0, 'spec': 'midiBend'),


//------ encoderTopRow
\encHatOn: (0..8).collect{|num|
	(midiMsgType: \noteOn, type: 'button', midiChan: 0, midiNum: num, spec: \midiVel)
},
\encHatOff: (0..8).collect{|num|
	(midiMsgType: \noteOff, type: 'button', midiChan: 0, midiNum: num, spec: \midiVel)
},
\enc: (71..79).collect{|num|
	(midiMsgType: \cc, type: \encoder, midiChan: 0, midiNum: num, spec: \midiCC)
},

//------ left encoders (not in a group because very different in experience)
lEncHatOn: (midiMsgType: \noteOn, type: \button, midiChan: 0, midiNum: 10, spec: \midiVel),
lEncHatOff: (midiMsgType: \noteOff, type: \button, midiChan: 0, midiNum: 10, spec: \midiVel),
lEnc: (midiMsgType: \cc, type: \encoder, midiChan: 0, midiNum: 14, spec: \midiBut),

rEncHatOn: (midiMsgType: \noteOn, type: \button, midiChan: 0, midiNum: 9, spec: \midiVel),
rEncHatOff: (midiMsgType: \noteOff, type: \button, midiChan: 0, midiNum: 9, spec: \midiVel),
rEnc: (midiMsgType: \cc, type: \encoder, midiChan: 0, midiNum: 15, spec: \midiBut),

//------ color button rows
\colorBut: [
	(20..27).collect{|num|
		('midiMsgType': 'cc', 'type': 'button', 'midiChan': 0, 'midiNum':    num, 'spec': 'midiCC')
},
	(102..109).collect{|num|
		('midiMsgType': 'cc', 'type': 'button', 'midiChan': 0, 'midiNum':    num, 'spec': 'midiCC')
}
],

//------ buttons
\tapTempo:		 ('midiMsgType': 'cc', 'type': 'button', 'midiChan': 0, 'midiNum':    3,'spec': 'midiCC'),
\metronome:		 ('midiMsgType': 'cc', 'type': 'button', 'midiChan': 0, 'midiNum': 	  9,'spec': 'midiCC'),
\undo:			 ('midiMsgType': 'cc', 'type': 'button', 'midiChan': 0, 'midiNum': 	119,'spec': 'midiCC'),
\delete:		 ('midiMsgType': 'cc', 'type': 'button', 'midiChan': 0, 'midiNum': 	118,'spec': 'midiCC'),
\double:		 ('midiMsgType': 'cc', 'type': 'button', 'midiChan': 0, 'midiNum': 	117,'spec': 'midiCC'),
\quantize:		 ('midiMsgType': 'cc', 'type': 'button', 'midiChan': 0, 'midiNum': 	116,'spec': 'midiCC'),
\fixedLength:	 ('midiMsgType': 'cc', 'type': 'button', 'midiChan': 0, 'midiNum': 	 90,'spec': 'midiCC'),
\automation:	 ('midiMsgType': 'cc', 'type': 'button', 'midiChan': 0, 'midiNum': 	 89,'spec': 'midiCC'),
\duplicate:		 ('midiMsgType': 'cc', 'type': 'button', 'midiChan': 0, 'midiNum': 	 88,'spec': 'midiCC'),
\new:			 ('midiMsgType': 'cc', 'type': 'button', 'midiChan': 0, 'midiNum': 	 87,'spec': 'midiCC'),
\record:		 ('midiMsgType': 'cc', 'type': 'button', 'midiChan': 0, 'midiNum': 	 86,'spec': 'midiCC'),
\play:			 ('midiMsgType': 'cc', 'type': 'button', 'midiChan': 0, 'midiNum': 	 85,'spec': 'midiCC'),
\master:		 ('midiMsgType': 'cc', 'type': 'button', 'midiChan': 0, 'midiNum': 	 28,'spec': 'midiCC'),
\stop:			 ('midiMsgType': 'cc', 'type': 'button', 'midiChan': 0, 'midiNum': 	 29,'spec': 'midiCC'),
'132t':			 ('midiMsgType': 'cc', 'type': 'button', 'midiChan': 0, 'midiNum':   43,'spec': 'midiCC'),
'132':			 ('midiMsgType': 'cc', 'type': 'button', 'midiChan': 0, 'midiNum':   42,'spec': 'midiCC'),
'116t':			 ('midiMsgType': 'cc', 'type': 'button', 'midiChan': 0, 'midiNum':   41,'spec': 'midiCC'),
'116':			 ('midiMsgType': 'cc', 'type': 'button', 'midiChan': 0, 'midiNum':   40,'spec': 'midiCC'),
'18t':			 ('midiMsgType': 'cc', 'type': 'button', 'midiChan': 0, 'midiNum':   39,'spec': 'midiCC'),
'18':			 ('midiMsgType': 'cc', 'type': 'button', 'midiChan': 0, 'midiNum':   38,'spec': 'midiCC'),
'14t':			 ('midiMsgType': 'cc', 'type': 'button', 'midiChan': 0, 'midiNum':   37,'spec': 'midiCC'),
'14':			 ('midiMsgType': 'cc', 'type': 'button', 'midiChan': 0, 'midiNum':   36,'spec': 'midiCC'),
\volume:		 ('midiMsgType': 'cc', 'type': 'button', 'midiChan': 0, 'midiNum': 	114,'spec': 'midiCC'),
\track:			 ('midiMsgType': 'cc', 'type': 'button', 'midiChan': 0, 'midiNum': 	112,'spec': 'midiCC'),
\device:		 ('midiMsgType': 'cc', 'type': 'button', 'midiChan': 0, 'midiNum': 	110,'spec': 'midiCC'),
\in:			 ('midiMsgType': 'cc', 'type': 'button', 'midiChan': 0, 'midiNum': 	 62,'spec': 'midiCC'),
\mute:			 ('midiMsgType': 'cc', 'type': 'button', 'midiChan': 0, 'midiNum': 	 60,'spec': 'midiCC'),
\scales:		 ('midiMsgType': 'cc', 'type': 'button', 'midiChan': 0, 'midiNum': 	 58,'spec': 'midiCC'),
\repeat:		 ('midiMsgType': 'cc', 'type': 'button', 'midiChan': 0, 'midiNum': 	 56,'spec': 'midiCC'),
\octaveDown:	 ('midiMsgType': 'cc', 'type': 'button', 'midiChan': 0, 'midiNum': 	 54,'spec': 'midiCC'),
\addEffect:		 ('midiMsgType': 'cc', 'type': 'button', 'midiChan': 0, 'midiNum': 	 52,'spec': 'midiCC'),
\note:			 ('midiMsgType': 'cc', 'type': 'button', 'midiChan': 0, 'midiNum': 	 50,'spec': 'midiCC'),
\select:		 ('midiMsgType': 'cc', 'type': 'button', 'midiChan': 0, 'midiNum': 	 48,'spec': 'midiCC'),
\panSend:		 ('midiMsgType': 'cc', 'type': 'button', 'midiChan': 0, 'midiNum': 	115,'spec': 'midiCC'),
\clip:			 ('midiMsgType': 'cc', 'type': 'button', 'midiChan': 0, 'midiNum': 	113,'spec': 'midiCC'),
\browse:		 ('midiMsgType': 'cc', 'type': 'button', 'midiChan': 0, 'midiNum': 	111,'spec': 'midiCC'),
\out:			 ('midiMsgType': 'cc', 'type': 'button', 'midiChan': 0, 'midiNum': 	 63,'spec': 'midiCC'),
\solo:			 ('midiMsgType': 'cc', 'type': 'button', 'midiChan': 0, 'midiNum': 	 61,'spec': 'midiCC'),
\user:			 ('midiMsgType': 'cc', 'type': 'button', 'midiChan': 0, 'midiNum': 	 59,'spec': 'midiCC'),
\accent:		 ('midiMsgType': 'cc', 'type': 'button', 'midiChan': 0, 'midiNum': 	 57,'spec': 'midiCC'),
\octaveUp:		 ('midiMsgType': 'cc', 'type': 'button', 'midiChan': 0, 'midiNum': 	 55,'spec': 'midiCC'),
\addTrack:		 ('midiMsgType': 'cc', 'type': 'button', 'midiChan': 0, 'midiNum': 	 53,'spec': 'midiCC'),
\session:		 ('midiMsgType': 'cc', 'type': 'button', 'midiChan': 0, 'midiNum': 	 51,'spec': 'midiCC'),
\shift:			 ('midiMsgType': 'cc', 'type': 'button', 'midiChan': 0, 'midiNum': 	 49,'spec': 'midiCC'),
\left:			 ('midiMsgType': 'cc', 'type': 'button', 'midiChan': 0, 'midiNum': 	 44,'spec': 'midiCC'),
\right:			 ('midiMsgType': 'cc', 'type': 'button', 'midiChan': 0, 'midiNum': 	 45,'spec': 'midiCC'),
\up:			 ('midiMsgType': 'cc', 'type': 'button', 'midiChan': 0, 'midiNum': 	 46,'spec': 'midiCC'),
\down:			 ('midiMsgType': 'cc', 'type': 'button', 'midiChan': 0, 'midiNum':	 47,'spec': 'midiCC')
)