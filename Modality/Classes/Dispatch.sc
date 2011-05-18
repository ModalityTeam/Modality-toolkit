Dispatch{

	classvar <>tempNamePrefix = "Dispatch_";
	classvar tempDefCount = 0;
	classvar <>maxTempDefNames = 512;
	
	//	classvar <all;

	var <verbose = false;
	var <name;
	var <funcChain;

	var <dispatchOuts; // DispatchOuts to which stuff is registered


	var <sourceKeyToSource;
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
		sourceKeyToSource = ();
		mappedElems = ();

		dispatchOuts = ();

		//	this.mapSource( \me, this );
	}
	
	changeSource{ |sourceKey, newSource|
		var oldSource = sourceKeyToSource[sourceKey];
		mappedElems[ sourceKey ].do{ |elem|
			// unregister from old Ktl
			oldSource.removeFromOutput(elem, this.name);
			// register with new Ktl
			this.mapToElem( newSource, elem, sourceKey );
		};
	}

	mapSourceToKey{ |source, sourceKey | //name is an abstract name for the source, source is either a Ktl or a Dispatch
		if ( sourceKeyToSource.includesKey( sourceKey ) ){
			if ( (sourceKeyToSource[sourceKey] === source).not ){
				this.changeSource( sourceKey, source );
			};
		} {
			sourceKeyToSource.put( sourceKey, source );
			if ( sources[name].isNil ){
				sources.put( sourceKey, () );
			};
		}
	}
	
	prRegisterInputWithSource{ |source, elemKey, sourceKey|
		source.addToOutput( elemKey, this.name, this );
		sources[sourceKey].put( elemKey, source.defaultValueFor( elemKey ) ? 0);
		if ( mappedElems[sourceKey].isNil ){
			mappedElems[sourceKey] = List.new;
		};
		mappedElems[sourceKey].add( elemKey );		
	}
	
	//map all elements
	mapAll{ |source, sourceKey |
		sourceKey = sourceKey ? source.name;
		this.mapSourceToKey(source, sourceKey);
		source.elementNames.do{ |elemKey|
			this.prRegisterInputWithSource(source, elemKey, sourceKey)
		}
	}
	
	mapToElem{ |source, elemKey, sourceKey|
		sourceKey = sourceKey ? source.name;
		this.mapSourceToKey(source, sourceKey);
		this.prRegisterInputWithSource(source, elemKey, sourceKey)		
	}

	lookupSources{ |source|
		^sourceKeyToSource.findKeysForValue( source );
	}	
	
	valueArray{ arg args;
		var source,key,value;
		#source,key,value = args;
		this.setInput( source, key, value );
		this.processChain;
		changedIn = nil;		
	}

	setInput{ | source, elemKey, value|
		var srcKeys = this.lookupSources( source );
		srcKeys.do{ |sourceKey|
			sources[sourceKey].put(elemKey, value);
			changedIn = (\source: sourceKey, \key: elemKey, \val: value)
		};
	}

	getInput{ | sourceKey, elemKey|
		^sources[sourceKey][elemKey]
	}
	
	createOutput{ |elemkey|
		postln("creating output for"++ elemkey);
		dispatchOuts[elemkey] = DispatchOut.new( this, elemkey );
	}
	
	getOutput{ |elemKey|
		^outputs[elemKey];
	}

	setOutput{ |elemKey, value|
		dispatchOuts[elemKey].value(value);
		outputs.put( elemKey, value );
		changedOuts.add(elemKey);
	}
	
	//pattern matching
	//i.e.  'sl*'
	//i.e.  'sl1_?'
	//i.e.  '*'
	addToOutput { |elementKey, funcName, function, addAction, otherName| // could have order indication
		dispatchOuts.do{ |elem|
			var key = elem.name;
			if( key.matchOSCAddressPattern(elementKey) ) {
				dispatchOuts[key].addFunction( funcName, function );		
			}
		}
	}
	
	removeFromOutput { |elementKey, funcName| 		
		dispatchOuts.do{ |elem|
			var key = elem.name;
			if( key.matchOSCAddressPattern(elementKey) ) {
				dispatchOuts[key].removeFunc(funcName);
			}
		}
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
	
	remove{
		sources.keys.do{ |sourceKey|
			var source = sourceKeyToSource[sourceKey];
			mappedElems[ sourceKey ].do{ |elem|
				// unregister from old Ktl
				source. removeFromOutput(elem, this.name);
			}
		}
	}
	
	elementNames{
		^dispatchOuts.collect(_.name)
	}
	
	defaultValueFor{ ^0 }
	/*
	verbose_ {|value=true|
		value.if({
			dispatchOuts.do{ |item| item.addFirst(\verbose, { |ktl, elName, value| 
					[ktl, elName, value].postln;
			})}
		}, {
			funcDict.do{|item| item.removeAt(\verbose)}
		})
	}
	*/ 
}

DispatchOut {

	var <>dispatch; // the dispatcher it belongs to
	var <>name; // its key in dispatch

	var <funcChain;

	*new { |dis,name|
		^super.newCopyArgs( dis, name ).init;
	}

	init{ 
		funcChain = FuncChain.new;
	}

	addFunction { |key,func,addAction=\addLast,target|
		funcChain.add( key, func, addAction, target );
	}

	value{ |newval|
		funcChain.value( dispatch, name, newval );
	}


}
