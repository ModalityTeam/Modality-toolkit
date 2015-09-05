
PagedMKtl {
	classvar <all;
	var <name, <mktlDict, <>pageNames;
	var <currPage;

	*initClass { all = () }

	*new { |name, mktlNames, pageNames|
		var mktlDict;
		if (all[name].notNil) {
			^all[name]
		};

		^super.newCopyArgs(name).init(mktlNames, pageNames);
	}

	init { |mktlNames, argPageNames|
		mktlDict = ();
		mktlNames.do { |mkname| mktlDict.put(mkname, MKtl(mkname)) };
		pageNames = argPageNames ? mktlNames;
		all.put(name, this);
	}

	currIndex { ^pageNames.indexOf(currPage) }
	currMktl { ^mktlDict[currPage] }

	allOff { mktlDict.do(_.disable) }

	page { |nameOrIndex|
		if (nameOrIndex.isKindOf(Symbol)) {
			this.pageByName(nameOrIndex)
		} {
			this.pageByIndex(nameOrIndex)
		};
	}

	pageByName { |pageKey|
		if (mktlDict[pageKey].notNil) {
			mktlDict.keysValuesDo { |key, mk|
				if (key == pageKey) { mk.enable } { mk.disable };
				currPage = pageKey;
			};
		};
	}

	pageByIndex { |index, wrap = true|
		if (wrap) { index = index.wrap(0, mktlDict.size - 1) };
		this.pageByName(pageNames[index]);
	}

	up { this.pageByIndex(this.currIndex + 1) }
	down { this.pageByIndex(this.currIndex - 1) }
}