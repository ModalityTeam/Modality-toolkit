+ Object {
	deepAt { |...args|
		^args.inject(this, {|state,x|
			state.at(x)
		})
	}

	// expands when indexOrKey is a collection,
	// accepts nil and 'all' as wildcards,
	// returns nil on dead ends.
	deepAt2 { |first ... rest|
		var res;
		if (first.isNil or: { first == \all }) {
			if (rest.isEmpty) {
				^this;
			} {
				^this.collect(_.deepAt2(*rest));
			}
		};
		if (first.isCollection) {
			^first.collect { |idx|
				this.deepAt2(idx, *rest) };
		};
		// first is a single key or index now
		if (this.respondsTo(\at)) {
			res = this.at(first);
			if (rest.isEmpty) {
				^res
			} {
				^res.deepAt2(*rest)
			};
		};
		^nil
	}
}

+ Dictionary {
	// get this dict's keys and those of all parents
	allKeys { |species|
		var dict = this, ancestry = [];
		while { dict.notNil } {
			ancestry = ancestry.add(dict);
			dict = dict.parent;
		};
		^ancestry.collect { |dict| dict.keys(species) }
	}

	fillFromParents {
		this.allKeys.do { |keys|
			keys.do { |key|
				this.put(key, this.at(key))
			};
		}
	}
}
