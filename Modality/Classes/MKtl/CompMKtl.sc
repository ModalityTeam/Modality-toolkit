// /*

CompMKtl {
	classvar <all;
	var <name, <mktlNames, <mktlDict;
	var <elementGroup;

	*initClass { all = (); }

	*new { |name, mktlNames|
		if (all[name].notNil) { ^all[name] };
		^super.newCopyArgs(name, mktlNames).init;
	}

	storeArgs { ^[name] }

	printOn { |stream| this.storeOn(stream) }

	init {
		all.put(name, this);
		mktlDict = ();
		mktlNames.do { |mktlName|
			mktlDict.put(mktlName, MKtl(mktlName));
		};

		MKtlElement.addGroupsAsParent = true;
		elementGroup = MKtlElementGroup(name,
			this,
			mktlNames.collect ({ |mktlName|
				mktlName -> MKtl(mktlName).elementGroup
		}, Array));
		MKtlElement.addGroupsAsParent = false;
		// elementGroup.canFlatten.postln;
	}

	flattenElementGroup {
		if (elementGroup.canFlatten) {
			elementGroup.flatten
		}
	}

	elementAt { |...args|
		^elementGroup.deepAt(*args)
	}

	elAt { |...args|
		^elementGroup.deepAt2(*args)
	}

}
