Dispatch{

	//	classvar <all;

	//	var <key;
	var <name;
	var <funcChain;

	var <registered; // DispatchOuts to which stuff is registered

	var <changedOuts; // keeps the changed outputs in order to update

	var <ktlToSources;
	//	var <sourcesToInputs;
	var <sources; // internal/external state

	var <envir;

	*new{ |name|
		^super.new.init(name);
	}

	init{ |nm|
		name = nm; // name is used to register with different controls in their functiondict
		envir = ();
		funcChain = FuncChain.new;

		sources = ();
		ktlToSources = ();

		registered = ();
	}

	mapToCtl{ |ktl,ctl,ktlname|
		this.mapSource( ktlname, ktl );
		ktl.addFunction( ctl, this.name, this );
	}

	mapSource{ |name,source|
		ktlToSources.put( name, source );
		if ( sources[name].isNil ){
			sources.put( name, () );
		};
	}

	lookupSources{ |source|
		^ktlToSources.findKeysForValue( source );
	}

	setInput{ |source,key,value|
		var srcs = this.lookupSources( source );
		srcs.do{ |it|
			sources[it].put( key, value );
		};
	}

	setOutput{ |key,value|
		this.setInput( this, key, value );
		changedOuts.add(key);
	}

	setVar{ |key,value|
		envir.put( key, value );
	}

	getVar{ |key|
		^envir.at( key );
	}

	value{ |source,key,value|
		this.setInput( source, key, value );
		this.processChain;
	}

	// register for output
	register{ |key,funcKey,func| // could have order indication
		if ( registered[key].isNil ){
			registered[key] = DispatchOut.new( this, key );
		};
		registered[key].addFunction( funcKey, func );
	}

	processChain{
		changedOuts = List.new;
		funcChain.value( this );
		changedOuts.do{ |key|
			registered[key].value( sources[\me][key] );
		};
	}

	addFunction{ |key,func,addAction=\addLast,target|
		funcChain.add( key, func, addAction, target );
	}
	
}

DispatchOut {

	var <>dispatch; // the dispatcher it belongs to
	var <>key; // its key in dispatch

	var <funcChain;

	*new { |dis,key|
		^super.newCopyArgs( dis, key );
	}

	init{ 
		funcChain = FuncChain.new;
	}

	addFunction { |key,func,addAction=\addLast,target|
		funcChain.add( key, func, addAction, target );
	}

	value{ |newval|
		funcChain.value( dispatch, key, newval );
	}


}
