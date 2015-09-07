// for composite MKtls, join the two element groups if possible

+ MKtlElementGroup {

	canFlatten {
		// see if top level of names can be dropped:
		// if there are any name overlaps between the second level, we can!
		var allNames = this.at.collect(_.name).postln.flat;
		var uniqueNames = allNames.asSet.postln;
		^uniqueNames.size < allNames.size;
	}

	tryFlatten {
		if (this.canFlatten) {
			elements = elements.collect(_.elements).flatten(1);
		} {
			inform("Cannot flatten elements because of non-unique names:");
			this.at.collect(_.name).flat.sort.postln;
		};
	}
}
