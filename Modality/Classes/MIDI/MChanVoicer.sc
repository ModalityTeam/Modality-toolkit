MChanVoicer {
	classvar <rollbackFuncs;

	var <chan, <noteEl, <velEl, <bendEl, <pressEl, <offVelEl;
	var <>startFunc, <>endFunc, <heldNotes, <>rollback = \last;

	*initClass {
		rollbackFuncs = (
			\last: { |mcv| mcv.heldNotes.last },
			\first: { |mcv| mcv.heldNotes.first },
			\lowest: { |mcv| mcv.heldNotes.minItem },
			\highest: { |mcv| mcv.heldNotes.maxItem }
		);
	}

	*new { |chan = 0, srcID, noteEl, velEl, bendEl, pressEl, offVelEl|
		^super.newCopyArgs(chan, noteEl, velEl, bendEl, pressEl, offVelEl).init;
	}

	init {
		noteEl = noteEl ?? { MKtlElement([\note, chan].join($_).asSymbol, (spec: \midiNum)) };
		velEl  = velEl  ?? { MKtlElement([\vel, chan].join($_).asSymbol, (spec: \midiVel))  };
		bendEl  = bendEl  ?? { MKtlElement([\bend, chan].join($_).asSymbol, (spec: \midiBend))  };
		pressEl  = pressEl  ?? { MKtlElement([\press, chan].join($_).asSymbol, (spec: \midiNum))  };
		offVelEl  = offVelEl  ?? { MKtlElement([\vel, chan].join($_).asSymbol, (spec: \midiVel))  };
		heldNotes = List[];
	}

	noteOn { |note, vel|
		if (heldNotes.isEmpty) { this.startNote(note, vel) };
		heldNotes.remove(note);
		heldNotes.add(note);
		noteEl.deviceValueAction_(note);
		velEl.deviceValueAction_(vel);
	}

	noteOff { |note, vel|
		var prevNote;
		heldNotes.remove(note);
		prevNote = rollbackFuncs[rollback].value(this);
		if (prevNote.notNil) {
			if (prevNote != noteEl.deviceValue) {
				noteEl.deviceValueAction_(prevNote);
			}
		} {
			velEl.deviceValueAction_(0);
			offVelEl.deviceValueAction_(vel);
			this.endNote(note, vel);
		}
	}

	bend { |bendVal| bendEl.deviceValueAction_(bendVal) }
	press { |pressVal| pressEl.deviceValueAction_(pressVal) }

	startNote { |note, vel| startFunc.value(this, note, vel) }
	endNote { |note, vel| endFunc.value(this, note, vel) }

}