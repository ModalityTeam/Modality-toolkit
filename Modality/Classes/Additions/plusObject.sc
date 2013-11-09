+ Object {

	deepAt1 { |...args|
		^args.inject(this, {|state,x|
			if( state.isKindOf(Dictionary) ) {
				state.at(x)
			}{
				state.at1(x)
			}
		})
	}
}