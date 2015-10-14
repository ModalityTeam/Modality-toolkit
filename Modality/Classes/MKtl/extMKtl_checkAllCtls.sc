+ MKtl {
	checkAllCtls {
		if(device.notNil) { device.checkAllCtls }
	}
}

+ MIDIMKtlDevice {
	checkAllCtls {
		var allElKeys = this.midiKeyToElemDict.keys;
		var keysToRemove = allElKeys.copy;
		var missingKeys = Set.new;
		"MIDIMKtlDevice:checkAllCtls - are all % MKtlElements accessible?\n"
		.postf(allElKeys.size);
		"Please wiggle every control element once until DONE.".postln;

		this.midiRawAction = { |... msg|
			var lookupKey = msg[0].switch(
				'control', { this.makeCCKey(msg[2], msg[3]); },
				'noteOn', { this.makeNoteOnKey(msg[2], msg[3]); },
				'noteOff', { this.makeNoteOffKey(msg[2], msg[3]); },
				'polyTouch', { this.makePolyTouchKey(msg[2], msg[3]); },

				'bend', { this.makeBendKey(msg[2], msg[3]); },
				'touch', { this.makeTouchKey(msg[2], msg[3]); },
				'program', { this.makeProgramKey(msg[2], msg[3]); },

			);
			if (lookupKey.isNil) {
				"unsupported type in message % !\n.".postf(msg);
			} {
				if (allElKeys.includes(lookupKey).not and:
					{ missingKeys.includes(lookupKey).not }) {
					"missing: %.\n".postf(lookupKey);
					missingKeys.add(lookupKey);

				};
				if (keysToRemove.includes(lookupKey)) {
					keysToRemove.remove(lookupKey);
					"% down, % to go.\n".postf(lookupKey, keysToRemove.size);

					if (keysToRemove.size == 0) {
						if (missingKeys.size > 0) {
							"!!! All MKtlElements were activated,"
							"but were missing: %.\n".postf(missingKeys);
						} {
							"All MKtlElements were activated - DONE!".postln;
						};
					}
				};
			}

		};
	}
}

+ OSCMKtlDevice {
	checkAllCtls {"not done yet.".inform }
}

+ HIDMKtlDevice {
	checkAllCtls {"not done yet.".inform }
}
