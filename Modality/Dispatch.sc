Dispatch{

	//	classvar <all;

	//	var <key;
	var <name;
	var <funcChain;

	var <registered; // DispatchOuts to which stuff is registered


	var <ktlToSources;
	//	var <sourcesToInputs;
	var <mappedCtls;

	// this will be internal only:
	var <sources; // input state
	var <outputs; // output state
	var <envir; // internal state

	var <changedOuts; // keeps the changed outputs in order to update
	var <changedIns;

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
		mappedCtls = ();

		registered = ();

		//	this.mapSource( \me, this );
	}

	mapToCtl{ |ktl,ctl,ktlname|
		this.mapSource( ktlname, ktl );
		ktl.addFunction( ctl, this.name, this );
		// set a default value, should probably get this from the ktl[ctl]
		sources[ktlname].put( ctl, DispatchInput( ktl.defaultElementValue( ctl ) ? 0 , false ) );
		if ( mappedCtls[ktlname].isNil ){
			mappedCtls[ktlname] = List.new;
		};
		mappedCtls[ktlname].add( ctl );
	}

	changeSource{ |oldname, newsource|
		mappedCtls[ oldname ].do{ |key|
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
				registered[key].value( outputs[key] );
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
