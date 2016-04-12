
MIDISim {
	classvar methodNames = #[ 'action', 'noteOn', 'noteOff', 'polytouch', 'control', 'program', 'touch', 'bend', 'sysex', 'sysexPacket', 'sysrt', 'smpte', 'invalid', 'noteOnList', 'noteOffList', 'polyList', 'controlList', 'programList', 'touchList', 'bendList' ];

	*value { |ev|
		var list = ev[\numbers].collect (_.value);
		var msgType = ev[\midiMsgType];
		if (msgType.isKindOf(Symbol).not
			or: { MIDIIn.respondsTo(msgType).not }) {
			"MIDISim: % is not a midiMsgType.\n".postf(msgType);
			^this
		};
		"// MIDISim sends: %, %.\n".postf(msgType, list);
		this.perform(msgType, *list);
		^ev
	}

	// per chan and midinum
	*status { arg src, status, a, b, c;
		MIDIIn.doAction(src, status, a, b, c);
	}
	*noteOn { arg src, chan, num, vel;
		MIDIIn.doNoteOnAction(src, chan, num, vel);
	}
	*noteOff { arg src, chan, num, vel;
		MIDIIn.doNoteOffAction(src, chan, num, vel);
	}
	*polytouch { arg src, chan, num, val;
		MIDIIn.doPolyTouchAction(src, chan, num, val);
	}
	*control { arg src, chan, num, val;
		MIDIIn.doControlAction(src, chan, num, val);
	}
	// per channel
	*program { arg src, chan, val;
		MIDIIn.doProgramAction(src, chan, val);
	}
	*touch { arg src, chan, val;
		MIDIIn.doTouchAction(src, chan, val);
	}
	*bend { arg src, chan, val;
		MIDIIn.doBendAction(src, chan, val);
	}

	// special ones
	// *doSysexAction { arg src,  packet;
	// 	sysexPacket = sysexPacket ++ packet;
	// 	if (packet.last == -9, {
	// 		MIDIIn.sysex.value(src, sysexPacket);
	// 		sysexPacket = nil
	// 	});
	// }
	// *doInvalidSysexAction { arg src, packet;
	// 	MIDIIn.invalid.value(src, packet);
	// }
	//
	// *doSysrtAction { arg src, index, val;
	// 	sysrt.value(src, index, val);
	// }
	//
	// *doSMPTEaction { arg src, frameRate, timecode;
	// 	smpte.value(src, frameRate, timecode);
	// }
}
