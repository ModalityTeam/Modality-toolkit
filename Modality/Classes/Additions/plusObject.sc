+ Object {
	// could be made safer by returning nil if not found
	deepAt { |...args|
		^args.inject(this, {|state,x|
			state.at(x)
		})
	}
}