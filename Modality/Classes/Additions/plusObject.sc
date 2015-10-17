+ Object {
	// could be made safer by returning nil if not found
	deepAt { |...args|
		^args.inject(this, {|state,x|
			state.at(x)
		})
	}
	//
	deepAt2 { |...args|
		var res;
		if (this.respondsTo(\at)) {
			res = this.at(args[0]);
			if (args.size < 2) {
				^res
			} {
				^res.deepAt2(*args.drop(1))
			}
		};
		^nil
	}

		//
	deepAt3 { |first ... rest|
		var res;
		[first, rest].postln;
		if (first.isNil or: { first == \all }) {
			"%: wildcard %\n".postf(thisMethod, first);
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
				"recur here.".postln;
				"res.deepAt % \n".postf(rest);
				^res.deepAt3(*rest)
			};
		};
		^nil
	}

}
