// for composite MKtls, join the two element groups if possible

+ MKtlElementGroup {

	// see if top level of names can be dropped:
	// if no name overlaps between second levels, ok.
	canFlatten { |post = true|
		var ok, allNames, dupes;
		if (elements.any { |el| el.respondsTo(\collect).not }) {
			if (post) {
				inform("Cannot flatten elements because some are not groups.".format(dupes));
			};
			ok = false;
			^ok
		};

		allNames = this.elements.collect(_.collect(_.name));
		dupes = allNames.flat.duplicates;
		ok = (dupes.size == 0);
		if (post and: ok.not) {
			inform("Cannot flatten elements because of duplicated names: %".format(dupes)) };
		^ok
	}

	flatten {
		var flattenedElements;
		MKtlElement.addGroupsAsParent = true;
		flattenedElements = elements.collect(_.elements).flatten(1)
		.collect { |elem| elem.name -> elem };
		this.elements =flattenedElements;
		MKtlElement.addGroupsAsParent = false;
	}
}
