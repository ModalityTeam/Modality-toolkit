Dispatch{

	//	classvar <all;

	//	var <key;
	var <name;
	var <funcChain;

	var <registered; // DispatchOuts to which stuff is registered


	var <ktlToSources;
	//	var <sourcesToInputs;
	var <mappedElems;

	// this will be internal only:
	var <sources; // input state
	var <outputs; // output state
	var <envir; // internal state

	var <changedOuts; // keeps the changed outputs in order to update
	var <changedIn;

	*new{ |name|
		^super.new.init(name);
	}

	init{ |nm|
		name = nm; // name is used to register with different controls in their functiondict
		envir = ();
		funcChain = FuncChain.new;

		sources = ();
		outputs = ();
		ktlToSources = ();
		mappedElems = ();

		registered = ();

		//	this.mapSource( \me, this );
	}

	mapToElem |ktl, elem, ktlname|
		this.mapSource( ktlname, elem );
		ktl.addFunction( elem, this.name, this );
		// set a default value, should probably get this from the ktl[ctl]
		sources[ktlname].put( elem, DispatchInput( ktl.defaultElementValue( elem ) ? 0 , false ) );
		if ( mappedElems[ktlname].isNil ){
			mappedElems[ktlname] = List.new;
		};
		mappedElems[ktlname].add( elem );
	}

	changeSource{ |oldname, newsource|
		mappedElems[ oldname ].do{ |key|
			// register the 
			this.mapSource( newsource, key, this );
		};
	}

	mapSource{ |name,source|
		if ( ktlToSources.includesKey( name ) ){
			if ( (ktlToSources[name] === source).not ){
				this.changeSource( name, source );
			};
		};
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
			sources[it][key].value_( value ).changed_( true );
			changedIn = (\source: source, \key: key)
		};
	}

	getInput{ |sourcename,key|
		^sources[sourcename][key];
	}

	getOutput{ |key|
		^outputs[key];
	}

	setOutput{ |key,value|
		//	this.setInput( this, key, value );
		outputs.put( key, value );
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
		this.resetInputChanged;
	}

	resetInputChanged{
		sources.do{ |it|
			it.do{ |input|
				input.changed = false;
			}
		}
	}

	// register for output
// is the same as addFunc right now in Ktl

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
			if ( registered[key].notNil ){
				registered[key].value( outputs[key] ); // this may need to pass more info
			};
		};
	}

	addFunction{ |key,func,addAction=\addLast,target|
		funcChain.add( key, func, addAction, target );
	}
	
}

DispatchInput{
	var <>value;
	var <>changed;

	*new{ |val,change|
		^super.newCopyArgs( val, change );
	}

	printOn { arg stream;
		if (stream.atLimit, { ^this });
		stream << "DispatchInput[ " ;
		value.printOn(stream);
		stream << ",";
		changed.printOn(stream);
		stream << " ]" ;
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
