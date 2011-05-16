Dispatch{

	classvar <>tempNamePrefix = "Dispatch_";
	classvar tempDefCount = 0;
	classvar <>maxTempDefNames = 512;

	//	classvar <all;

	//	var <key;
	var <name;
	var <funcChain;

	var <dispatchOuts; // DispatchOuts to which stuff is registered


	var <sourceNameToKtl;
	//	var <sourcesToInputs;
	var <mappedElems;

	// this will be internal only:
	var <sources; // input state
	var <outputs; // output state
	var <envir; // internal state

	var <changedOuts; // keeps the changed outputs in order to update
	var <changedIn;
	
	*generateTempName {
		var name = tempNamePrefix ++ tempDefCount;
		tempDefCount = tempDefCount + 1 % maxTempDefNames;
		^name.asSymbol
	}
	
	*new{ |name|
		^super.new.init(name ? Dispatch.generateTempName );
	}

	init{ |nm|
		name = nm; // name is used to register with different controls in their functiondict
		envir = ();
		funcChain = FuncChain.new;

		sources = ();
		outputs = ();
		sourceNameToKtl = ();
		mappedElems = ();

		dispatchOuts = ();

		//	this.mapSource( \me, this );
	}

	mapToElem{ |ktl, elem, ktlname|
		this.mapSource( ktlname, ktl );
		ktl.addToOutput( elem, this.name, this );
		sources[ktlname].put( elem, ktl.defaultValueFor( elem ) ? 0);
		if ( mappedElems[ktlname].isNil ){
			mappedElems[ktlname] = List.new;
		};
		mappedElems[ktlname].add( elem );
	}

	changeSource{ |oldname, newsource|
		var oldKtl = sourceNameToKtl[oldname];
		mappedElems[ oldname ].do{ |elem|
			// unregister from old Ktl
			oldKtl.removeFunc(elem, this.name);
			// register with new Ktl
			this.mapToElem( newsource, elem, oldname );
		};
	}

	mapSource{ |name,source| //name is an abstract name for the source, source is either a Ktl or a Dispatch
		if ( sourceNameToKtl.includesKey( name ) ){
			if ( (sourceNameToKtl[name] === source).not ){
				this.changeSource( name, source );
			};
		} {
			sourceNameToKtl.put( name, source );
			if ( sources[name].isNil ){
				sources.put( name, () );
			};
		}
	}

	lookupSources{ |source|
		^sourceNameToKtl.findKeysForValue( source );
	}
	
	
	valueArray{ arg args;
		var source,key,value;
		#source,key,value = args;
		this.setInput( source, key, value );
		this.processChain;
		changedIn = nil;		
	}

	setInput{ |source,key,value|
		var srcs = this.lookupSources( source );
		srcs.do{ |it|
			sources[it].put(key, value);
			changedIn = (\source: source, \key: key, \val: value)
		};
	}

	getInput{ |sourcename,key|
		^sources[sourcename][key];
	}

	getOutput{ |key|
		^outputs[key];
	}

	setOutput{ |key,value|
		dispatchOuts[\key].value(value);
		outputs.put( key, value );
		changedOuts.add(key);
	}

	addToOutput{ |key,funcName,func,addAction, other| // could have order indication
		if ( dispatchOuts[key].isNil ){
			dispatchOuts[key] = DispatchOut.new( this, key );
		};
		dispatchOuts[key].addFunction( funcName, func );
	}

	processChain{
		changedOuts = List.new;
		funcChain.value( this, envir);
		changedOuts.do{ |key|
			if ( dispatchOuts[key].notNil ){
				dispatchOuts[key].value( outputs[key] ); // this may need to pass more info
			};
		};
	}

	addToProc{ |key,func,addAction=\addLast,target|
		funcChain.add( key, func, addAction, target );
	}
	
}

DispatchOut {

	var <>dispatch; // the dispatcher it belongs to
	var <>key; // its key in dispatch

	var <funcChain;

	*new { |dis,key|
		^super.newCopyArgs( dis, key ).init;
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
