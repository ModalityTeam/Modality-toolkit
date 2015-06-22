+ SequenceableCollection {
	asNamedList { |names|
		if (this.isAssociationArray) {
			^NamedList.fromAssocs(this, names);
		};
		if (this.first.isKindOf(Symbol)) {
			^NamedList.fromPairs(this);
		};
	}
}

+ Dictionary {
	asNamedList { |names|
		^NamedList.fromDict(this, names);
	}
}