MDispatch : MAbstractKtl {
	classvar <dispatchTemplateFolders;

	classvar <>tempNamePrefix = "MDispatch_";
	classvar tempDefCount = 0;
	classvar <>maxTempDefNames = 512;
	
	//	classvar <all;

	var <funcChain;

	var <sourceKeyToSource;
	//	var <sourcesToInputs;
	var <mappedElems;

	// this will be internal only:
	var <sources; // input state
	var <envir; // internal state

	var <changedOuts; // keeps the changed outputs in order to update

	*initClass{
		dispatchTemplateFolders =
			[this.filenameSymbol.asString.dirname.dirname +/+ "DispatchTemplates",
			Platform.userAppSupportDir++"/Extensions/DispatchTemplates/"];
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

	*getTemplateFilePaths{ |templateName|
		var cleanTemplateName = this.cleanTemplateName(templateName);
		^dispatchTemplateFolders.collect({|x| x +/+ cleanTemplateName ++ ".scd"});
	}
	
	*getMDispatchTemplate{ arg name;
		var path;
		this.getTemplateFilePaths(name).do{ |testpath|
			if( File.exists(testpath) ) {
				path = testpath;
			}
		};
		^if( name.notNil and: path.notNil ) {
			path.load
		} {
			"//" + this.class ++ ": - no dispatch template found for %: please make them!\n"
			.postf( this.cleanTemplateName(name) );
			("Templates should be placed at "++Platform.userAppSupportDir++"/Extensions/DispatchTemplates/").postln;
			nil
		}
	}
	
	*availableTemplates{
		^MDispatch.dispatchTemplateFolders.collect{ |x| 
			x.getPathsInDirectory.collect{ |y| 
				y.removeExtension
			} 
		}.flatten
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
			oldSource.removeFuncElem(elem, this.name);
			// register with new Ktl
			this.mapToElem( newSource, elem, sourceKey );
		};
	}
	
	//sourceKey is an abstract name for the source, source is either a Ktl or a MDispatch
	prMapSourceToKey{ |source, sourceKey | 		
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
		source.addFuncElem( elemKey, this.name, this );
		sources[sourceKey].put( elemKey, source.defaultValueFor( elemKey ) ? 0);
		if ( mappedElems[sourceKey].isNil ){
			mappedElems[sourceKey] = List.new;
		};
		mappedElems[sourceKey].add( elemKey );
	}

	map{ |source, elemKeys, sourceKey|
		sourceKey = (sourceKey ? source.name).asSymbol;
		
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
		sourceKey = (sourceKey ? source.name).asSymbol;
		this.prMapSourceToKey(source, sourceKey);
		this.prRegisterInputWithSource(source, elemKey.asSymbol, sourceKey)
	}

	lookupSources{ |source|
		^sourceKeyToSource.findKeysForValue( source );
	}	
	
	valueArray{ arg args;
		var element = args[0];
		this.setInput( element.source, element.name, element.value );
		this.prProcessChain;
	}

	setInput{ | source, elemKey, value|
		var srcKeys = this.lookupSources( source );
		srcKeys.do{ |sourceKey|
			sources[sourceKey].put(elemKey, value);
			envir[\changedIn] = (\source: sourceKey, \key: elemKey, \val: value)
		};
	}

	getInput{ | sourceKey, elemKey|
		^sources[sourceKey][elemKey.asSymbol]
	}
	
	createOutput{ |elemkey|
		elemkey = elemkey.asSymbol;
		elements[elemkey] = MDispatchOut.new( this, elemkey );
	}
	
	createOutputsFromInputs{
		mappedElems.pairsDo{ |sourceKey,elemKeys|
			elemKeys.do{ |elemKey|
				this.createOutput(elemKey.asSymbol)
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
	
	//addToOutput -> addFuncElem	
	//removeFromOutput -> removeFuncElem	
	//removeAllFromOutput -> removeAllFromElems
	
	prProcessChain{
		changedOuts = List.new;
		envir.use({ funcChain.value( this ) });
		changedOuts.do{ |key|
			if ( elements[key].notNil ){
				elements[key].doAction; // this may need to pass more info
			};
		};
	}

	addToProc{ |funcName, function, addAction=\addLast, target|
		funcName = funcName.asSymbol;
		funcChain.add( funcName, function, addAction, target );
	}
	
	remove{
		sources.keys.do{ |sourceKey|
			var source = sourceKeyToSource[sourceKey];
			mappedElems[ sourceKey ].do{ |elem|
				source.removeFuncElem(elem, this.name);
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
					source.removeFuncElem(elem, this.name);
				}
			}
		}
			
	}
	
	defaultValueFor{ ^0 }
}

MDispatchOut : MAbstractElement {}
