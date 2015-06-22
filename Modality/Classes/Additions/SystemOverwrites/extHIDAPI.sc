+ HID {
	*findAvailable {
		var rawDevList = HID.prbuildDeviceList;
		if (rawDevList.isNil) {
			"HID: no devices found.".postln;
			^this
		};
		// really crude sorting by vendorID, productID, on to usagePage etc.
		// sorts multiple entries for different pages of the same device together.
		// unless physical HIDs are added or removed, always keeps same order of HIDs!
		rawDevList.sort { |a, b| a.asString <b.asString };

		// if available is accessed by numbers, could also just be an array:
		// available = rawDevList.collect { |it, i| HIDInfo(it) };

		// keep as it is now
		available = IdentityDictionary.new;
		rawDevList.do { |it, i| available.put(i, HIDInfo.new( *it )) };
		"HID: found % devices.\n".postf( rawDevList.size );
		^available
	}
}