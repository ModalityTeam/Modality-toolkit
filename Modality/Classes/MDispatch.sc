MDispatch{
	classvar <dispatchTemplateFolder;

	classvar <>tempNamePrefix = "MDispatch_";
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

	*initClass{
		dispatchTemplateFolder = this.filenameSymbol.asString.dirname.dirname +/+ "DispatchTemplates";
	}
	
	*generateTempName {
		var name = tempNamePrefix ++ tempDefCount;
		tempDefCount = tempDefCount + 1 % maxTempDefNames;
		^name.asSymbol
	}
	
	*new{ arg name;
		^super.new.init( name ? MDispatch.generateTempName )
	}
	
	*make{ arg name...args;
		var template = this.getMDispatchTemplate(name);
		if( template.notNil ) {
			^template[\func].value(super.new.init(name), *args)
		}
	}
	
	*cleanTemplateName{ |name|
		^name.asString.collect { |char| if (char.isAlphaNum, char, $_) };
	}

	*getTemplateFilePath{ |templateName| 
		var cleanTemplateName = this.cleanTemplateName(templateName);
		^dispatchTemplateFolder +/+ cleanTemplateName ++ ".scd";
	}
	
	*getMDispatchTemplate{ arg name;
		var path;
		^if( name.notNil and: {path = this.getTemplateFilePath(name); File.exists(path)} ) {
			path.load
		} {
			"//" + this.class ++ ": - no dispatch template found for %: please make them!\n"
			.postf( this.cleanTemplateName(name) );
			nil
		}				
	}
	
	init{ |nm|
		name = nm; // name is used to register with different controls in their functiondict
		envir = Environment.new;
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

	prMapSourceToKey{ |source, sourceKey | //sourceKey is an abstract name for the source, source is either a Ktl or a MDispatch
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

	map{ |source, elemKeys, sourceKey|
		sourceKey = sourceKey ? source.name;
		
		if(elemKeys.isNil) {
			//map all keys
			this.prMapSourceToKey(source, sourceKey);
			source.elementNames.do{ |elemKey|
				this.prRegisterInputWithSource(source, elemKey, sourceKey)
			}
		} {
			//map just selected keys
			elemKeys.do{ |elemKey| this.mapToElem(source, elemKey, sourceKey)}
		}			
	}
	
	mapToElem{ |source, elemKey, sourceKey|
		sourceKey = sourceKey ? source.name;
		this.prMapSourceToKey(source, sourceKey);
		this.prRegisterInputWithSource(source, elemKey, sourceKey)		
	}

	lookupSources{ |source|
		^sourceKeyToSource.findKeysForValue( source );
	}	
	
	valueArray{ arg args;
		var element = args[0];
		this.setInput( element.source, element.name, element.value );
		this.processChain;
	}

	setInput{ | source, elemKey, value|
		var srcKeys = this.lookupSources( source );
		srcKeys.do{ |sourceKey|
			sources[sourceKey].put(elemKey, value);
			envir[\changedIn] = (\source: sourceKey, \key: elemKey, \val: value)
		};
	}

	getInput{ | sourceKey, elemKey|
		^sources[sourceKey][elemKey]
	}
	
	createOutput{ |elemkey|
		elements[elemkey] = MDispatchOut.new( this, elemkey );
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
		elements[elemKey].value_(value);
		changedOuts.add(elemKey);
	}
	
	//pattern matching
	//i.e.  'sl*'
	//i.e.  'sl1_?'
	//i.e.  '*'
	addToOutput { |elementKey, funcName, function, addAction, target | 
		// could have order indication
		elements.do{ |elem|
			var key = elem.name;
			if( key.matchOSCAddressPattern(elementKey) ) {
				elements[key].addFunc( funcName, function , addAction, target);		
			}
		}
	}
	
	removeFromOutput { | elemKey, funcName| 		
		elements.do{ |elem|
			var key = elem.name;
			if( key.matchOSCAddressPattern(elemKey) ) {
				elements[key].removeFunc(funcName);
			}
		}
	}
	
	removeAllFromOutput {
		elements.do( _.reset )
	}

	processChain{
		changedOuts = List.new;
		envir.use({ funcChain.value( this ) });
		changedOuts.do{ |key|
			if ( elements[key].notNil ){
				elements[key].doAction; // this may need to pass more info
			};
		};
	}

	addToProc{ |key, function, addAction=\addLast, target|
		funcChain.add( key, function, addAction, target );
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
			if( source.class == MDispatch){
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
	recordRawValue { |key,value|
//		recordFunc.value( key, value );
	}
	defaultValueFor{ ^0 }

		// element access - support polyphonic name lists.
	at { | elemKey | ^elements.atKeys(elemKey) }	
	
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

MDispatchOut : MBasicElement {}
