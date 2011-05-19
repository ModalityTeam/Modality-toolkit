Dispatch{
	classvar <dispatchTemplateFolder;

	classvar <>tempNamePrefix = "Dispatch_";
	classvar tempDefCount = 0;
	classvar <>maxTempDefNames = 512;
	
	//	classvar <all;

	var <verbose = false;
	var <name;
	var <funcChain;

	var <elements; // elements to which stuff is registered


	var <sourceKeyToSource;
	//	var <sourcesToInputs;
	var <mappedElems;

	// this will be internal only:
	var <sources; // input state
	var <envir; // internal state

	var <changedOuts; // keeps the changed outputs in order to update
	var <changedIn;

	*initClass{
		dispatchTemplateFolder = this.filenameSymbol.asString.dirname.dirname +/+ "DispatchTemplates";
	}
	
	*generateTempName {
		var name = tempNamePrefix ++ tempDefCount;
		tempDefCount = tempDefCount + 1 % maxTempDefNames;
		^name.asSymbol
	}
	
	*new{ arg name...args;
		^super.new.init(name ? Dispatch.generateTempName )
			.fromTemplate(name,*args)
	}
	
	fromTemplate{ arg name...args;
		var dict = Dispatch.getDispatchTemplate(name); 
		if( dict.notNil ) { 
			^dict[\func].value(this,*args)
		}		
	}

	*getDispatchTemplate { |dispatchName| 
		
		var cleanTemplateName;
		var path;
		var dispatchTemplate;

		cleanTemplateName = dispatchName.asString.collect { |char| if (char.isAlphaNum, char, $_) };
		path = dispatchTemplateFolder +/+ cleanTemplateName ++ ".scd";
		
		path.postln;
		
		if( File.exists(path) ) { 
			^path.load
		} { 
			"//" + this.class ++ ": - no dispatch template found for %: please make them!\n"
				.postf(cleanTemplateName);
			^nil
		};
	}
	
	*loadDispatchTemplate{ arg dispatchName ...args; 
		var dict = this.getDispatchTemplate(dispatchName);
		if( dict.notNil) {
			dict[\func].value(args)
		}
	}
	
	*getDispatchTemplateDesc{ |dispatchName|
		var dict = this.getDispatchTemplate(dispatchName);
		if( dict.notNil) {
			^dict[\desc]
		}
	}
	
	init{ |nm|
		name = nm; // name is used to register with different controls in their functiondict
		envir = ();
		funcChain = FuncChain.new;

		sources = ();
		sourceKeyToSource = ();
		mappedElems = ();

		elements = ();

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
	
	map{ |source, elemKeys, sourceKey|
		if(elemKeys.isNil) {
			this.mapAll(source)
		} {
			elemKeys.do{ |elemKey| this.mapToElem(source, elemKey, sourceKey)}
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
		var element = args[0];
		this.setInput( element.source, element.name, element.value );
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
		elements[elemkey] = DispatchOut.new( this, elemkey );
	}
	
	createOutputsFromInputs{
		mappedElems.pairsDo{ |sourceKey,elemKeys|
			elemKeys.do{ |elemKey|
				this.createOutput(elemKey)
			}
		}			
	}
	
	getOutput{ |elemKey|
		^elements[elemKey].value;
	}

	setOutput{ |elemKey, value|
		elemKey.postln;
		elements[elemKey].value_(value);
		changedOuts.add(elemKey);
	}
	
	//pattern matching
	//i.e.  'sl*'
	//i.e.  'sl1_?'
	//i.e.  '*'
	addToOutput { |elementKey, funcName, function, addAction, otherName| // could have order indication
		elements.do{ |elem|
			var key = elem.name;
			if( key.matchOSCAddressPattern(elementKey) ) {
				elements[key].addFunc( funcName, function );		
			}
		}
	}
	
	removeFromOutput { |elementKey, funcName| 		
		elements.do{ |elem|
			var key = elem.name;
			if( key.matchOSCAddressPattern(elementKey) ) {
				elements[key].removeFunc(funcName);
			}
		}
	}
	
	removeAllFromOutput {
		elements.do( _.reset )
	}

	processChain{
		changedOuts = List.new;
		funcChain.value( this, envir);
		changedOuts.do{ |key|
			if ( elements[key].notNil ){
				elements[key].doAction; // this may need to pass more info
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
				source. removeFromOutput(elem, this.name);
			}
		}
	}
	
	recursiveRemove{
		sources.keys.do{ |sourceKey|
			var source = sourceKeyToSource[sourceKey];
			if( source.class == Dispatch){
				source.remove
			} {
				mappedElems[ sourceKey ].do{ |elem|
					source.removeFromOutput(elem, this.name);
				}
			}
		}
			
	}
	
	elementNames{
		^elements.keys.asArray
	}
	
	defaultValueFor{ ^0 }
	
	
	
	verbose_ {|value=true|
		value.if({
			elements.do{ |item| item.funcChain.addFirst(\verbose, { |elem| 
					[elem.source, elem.name, elem.value].postln;
			})}
		}, {
			elements.do{|item| item.funcChain.removeAt(\verbose)}
		})
	}
	 
}

DispatchOut : MKtlBasicElement {}
