// /*
//
// * composite as file only is risky
// - how to handle cases if multiple devices match,
// - multiple desc files could match etc etc.
//
// Safer and clearer to try another strategy:
// * make component MKtls first, then merge them
// - safer when multiple devices present
//
// a = MKtl(\a, ...);
// b = MKtl(\b, ...);
// c = MKtl(\c, ...);
// CompMKtl.comp(\combi, [\a, \b, \c]);
//
// * better conflict-free merging strategy:
// MKtl(\combi).elements = MKtlElementGroup(\combi,
// [a, b, c].collect(_.elements)
// );
//
//
// MKtl(\combi).elementAt(\a, \sl, 1);
// if first arg not found in top level, traverse down
// by one to lower levels
//
// Generally, check if merge is possible for dicts ...
// if identical devices, do not merge lowest dict,
// keep two elementGroups,
// or merge at a lower level to get
// e.g. 8 + 8 + 8 = 24 sliders etc.
// */
//
CompMKtl {
	classvar <all;
	var <name, <mktlNames, <mktlDict;
	var elementGroup;

	*initClass { all = (); }

	*new { |name, mktlNames|
		if (all[name].notNil) { ^all[name] };
		^super.newCopyArgs(name, mktlNames).init;
	}

	init {
		all.put(name, this);
		mktlDict = ();
		mktlNames.do { |mkname| mktlDict.put(mkname, MKtl(mkname)); };

		elementGroup = MKtlElementGroup(name, this, mktlDict.collectAs(_.elements, Array).postln);
		elementGroup.tryFlatten;
	}
}
