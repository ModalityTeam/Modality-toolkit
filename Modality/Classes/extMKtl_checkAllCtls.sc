+ MKtl {
	checkAllCtls {
		if(mktlDevice.notNil) { mktlDevice.checkAllCtls }
	}
}

+ MIDIMKtlDevice {
	checkAllCtls {
		var allElKeys = this.midiKeyToElemDict.keys;
		var keysToRemove = allElKeys.copy;
		var missingKeys = Set.new;
		"MIDIMKtlDevice:checkAllCtls - are all MKtlElements accessible?\n"
		"Please wiggle every control element once until DONE.".postln;

		this.midiRawAction = { |... msg|
			var lookupKey = msg[0].switch(
				'control', { this.makeCCKey(msg[2], msg[3]); }
			);
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
		};

	}
}

+ OSCMKtlDevice {
	checkAllCtls {"not done yet.".inform }
}

+ HIDMKtlDevice {
	checkAllCtls {"not done yet.".inform }
}
