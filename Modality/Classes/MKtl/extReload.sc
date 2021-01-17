/*
x = MKtl(\x, "*trol2");
x.desc.openFile; // add post message to desc file ...
x.desc.reload;   // msg should get posted ... and did.
x.reload;        // ... and here too.
*/

+ MKtl {
	reload { |lookAgain = false|
		desc.reload;
		this.rebuild(lookAgain: lookAgain);
	}
}
+ MKtlDesc {
	reload {
		// path is known, should still work
		var newDesc = path.load;
		if (MKtlDesc.isValidDescDict(newDesc).not) {
			warn("% : reloaded desc is not a valid dict."
				"at path: \n%".format(thisMethod, path));
			^this
		};
		this.fullDesc_(newDesc);
		^this
	}
}