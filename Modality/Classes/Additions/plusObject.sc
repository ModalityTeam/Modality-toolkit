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
				^this.collect(_.deepAt3(*rest));
			}
		};
		if (first.isCollection) {
			^first.collect { |idx|
				this.deepAt3(idx, *rest) };
		};
		// first is a single key or index now
		if (this.respondsTo(\at)) {
			res = this.at(first);
			if (rest.isEmpty) {
				^res
			} {
				^res.deepAt3(*rest)
			};
		};
		^nil
	}
}
