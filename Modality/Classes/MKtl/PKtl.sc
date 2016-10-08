// pattern wrapper for MKtls
PKtl : Pattern {
	var <namePat, <elPats;
	*new { |namePat ... elPats|
		^super.newCopyArgs(namePat, elPats);
	}

	embedInStream { arg inval;
		var nameStream = namePat.asStream;
		var elStreams = elPats.collect(_.asStream);
		var nameVal, elVals, mktl, item;
		inf.do {
			nameVal = nameStream.next(inval);
			mktl = MKtl.all[nameVal].postln;
			if (mktl.isNil) { ^inval };
			elVals = elStreams.collect { |stream|
				stream.next(inval);
			};
			item = mktl.postln.elAt(*elVals.postln);
			item.embedInStream(inval);
		};
		^inval;
	}
}
