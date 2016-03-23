
ItemsSpec {
	var <items, <warp, <default, <spec;

	*new { |items, warp = 0, default|
		^super.newCopyArgs( items, warp, default ).init;
	}

	init {
		spec = [ -0.5, items.size - 0.5, warp, 1].asSpec;
		// default is in mapped range, not unmapped 0
		// if no default given, take first key
		if (items.includes(default).not) { default = items[0] };
	}

	// from number to item - create equal parts of the range
	map { |inval|
		^items.clipAt( spec.map( inval ).asInteger );
	}

	// from string to number
	unmap { |inval|
		var index = items.indexOfEqual( inval );
		if ( index.notNil ){
			^spec.unmap( index ).round(1/(items.size - 1));
		};
		^nil;
	}

	asSpec {
		^this;
	}

	warp_ { |argWarp| spec.warp_(argWarp) }

}