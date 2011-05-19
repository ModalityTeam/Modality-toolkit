// 
+ IdentityDictionary {
	atKeys { |keys|
		if (keys.isKindOf(Collection)) { 
			^keys.collect (this.at(_))
		};
		^this.at(keys);
	}
}