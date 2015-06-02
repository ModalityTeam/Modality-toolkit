/* to do:

***** COMPILES, BUT NOT WORKING CORRECTLY YET ***
adapt to using MKtlDesc, then test again

if identical devices, do not merge;
make it two elementGroups,
or merge at a lower level to get
e.g. 8 + 8 = 16 sliders etc.
*/

+ MKtl {
	*composite { |name, devDesc|
		^super.new.initComp(name, devDesc);
	}
	initComp { |argName, devDesc|
		var componentMKtls, allCompElements;
		name = argName;

		if (MKtlDesc.allDescs.isNil) { this.class.loadDescs };

		if (devDesc.isKindOf(String)) {
			devDesc = this.class.loadCompDesc(devDesc);
		} {
			if (devDesc.isKindOf(Symbol)) {
				devDesc = MKtlDesc.allDescs[devDesc];
			}
		};
		devDesc.postcs;

		all.put(name, this);
		elementsDict = ();

		componentMKtls = devDesc[\components].postcs.collect { |desc, i|
			var compName, lookupName, compMKtl;

			lookupName = MKtl.makeLookupName(desc.asString);
			compName = [name.asString, lookupName, i].join($_).asSymbol;

			if (desc.isKindOf(Symbol)) {
				desc = MKtlDesc.allDescs[desc]
			};

			compMKtl = MKtl(compName, desc);
			elementsDict.put(compName, compMKtl).postln;
			compMKtl;
		};

		allCompElements = componentMKtls.collect(_.elements).postln;

		// hierarchical joining
		// elements = MKtlElementGroup("", allCompElements);

		"compElements.merge here:".postln;
		elements = allCompElements[0];
		allCompElements.drop(1).do { |elem2|
			elements = elements.merge(elem2)
		};

		elements.fillDict(elementsDict);
	}
}

+ MKtlDesc {

	// model on loadDescs
	*loadComps { |filename = "*", folderIndex|
		// // should complain if not now
		// ^(MKtlDesc.descFolders.collect { |p|
		// 	(p +/+ filename ++ compExt).load.unbubble;
		// 	};
	}
}

+ MKtlElementGroup {

	merge { |group, name=""|
		var mynames = this.elements.collect(_.name);
		var othernames = group.elements.collect(_.name);
		var sharedNames = mynames.sect(othernames).postln;
		if (sharedNames.size > 0) {
			warn("Overlapping names: %\n".format(sharedNames))
			};
		^MKtlElementGroup(name, this.elements ++ group.elements)

	}

	fillDict { |argDict|
		elements.do { |el|
			el.postln;
			if (el.isKindOf(this.class)) {
				el.fillDict(argDict)
			} {
				// it is an element
				argDict.put(el.name, el);
			}
		};
		^argDict
	}
}
