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
}