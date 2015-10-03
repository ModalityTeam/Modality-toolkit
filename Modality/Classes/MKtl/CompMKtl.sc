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

	init {
		all.put(name, this);
		mktlDict = ();
		mktlNames.do { |mkname|
			mktlDict.put(mkname, MKtl(mkname));
		};
		MKtlElement.addGroupsAsParent = true;
		elementGroup = MKtlElementGroup(name, this,
			mktlDict.collectAs(_.elements, Array));
		MKtlElement.addGroupsAsParent = false;
		// elementGroup.canFlatten.postln;
	}

	flattenElements {
		if (elementGroup.canFlatten) {
			elementGroup.flatten
		}
	}

	elementAt { |...args|
		^elementGroup.deepAt(*args)
	}
}
