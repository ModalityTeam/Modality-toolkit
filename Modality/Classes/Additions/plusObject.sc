+ Object {

	deepAt { |...args|
		^args.inject(this, {|state,x|
			state.at(x)
		})
	}
}