+ HID {
	*findAvailable {
		var rawDevList;
		// start eventloop if not yet running - this needs to happen here,
		// otherwise it is not called when not using modality;
		// we are overriding an essential class method here!
		if ( running.not ) { this.initializeHID };
		rawDevList = HID.prbuildDeviceList;

		// if (rawDevList.isNil) {
		if (rawDevList == 0) {
			"HID: no devices found.".postln;
			^this
		};
		// simple sorting by vendorID, productID, on to usagePage etc.
		// sorts multiple entries for different pages of the same device together.
		// unless physical HIDs are added or removed, always keeps same order of HIDs,
		// which guarantees same ID number when connected devices are the same.
		rawDevList.sort { |a, b| a.asString <b.asString };

		// if available is accessed by numbers, available could also just be an array?

		available = IdentityDictionary.new;
		rawDevList.do { |it, i| available.put(i, HIDInfo.new( *it )) };
		"HID: found % devices.\n".postf( rawDevList.size );
		^available
	}
}