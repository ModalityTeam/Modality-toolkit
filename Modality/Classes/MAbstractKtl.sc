
//defines a common interface for Mktl and MDispatch, where outputs, called Elements are can be registered with for notifications. 

MAbstractKtl {
	
	var <verbose = false;
	var <name;
	
	var <elements; //of type: ('elementName':MKtlElement, ...) -> elements to which stuff is registered
	
	prMatchedElements { |elementKey|
		if ( Main.versionAtLeast( 3.5 ) ){
			^elements.asArray.select{ |elem| elem.name.matchOSCAddressPattern(elementKey) }
		}{
			^elements.asArray.select{ |elem| elementKey.asString.matchRegexp( elem.name.asString ) };
		}
	}
	
	prMatchDo{ |match, elementKey, func|
		if( match ) {
			//match only works on dev versions at the moment.
			this.prMatchedElements(elementKey).do{ |element|
				func.value(element)	
			}
		} {
			func.value(elements[elementKey])	
		}	
	}
	
	// element funcChain interface
	addFuncElem { |elementKey, funcName, function, addAction, otherName, match = false|
		this.prMatchDo(match, elementKey, _.addFunc( funcName, function , addAction, otherName) )
	}

	addFuncElemAfter { |elementKey, funcName, function, otherName, match = false|
		this.prMatchDo(match, elementKey, _.addFuncAfter(funcName, function, otherName) )
	}
	
	addFuncElemBefore { |elementKey, funcName, function, otherName, match = false|
		this.prMatchDo(match, elementKey, _.addFuncBefore( funcName, function, otherName) )
	}
	
	removeFuncElem { |elementKey, funcName, match = false|
		this.prMatchDo(match, elementKey, _.removeFunc(funcName) )
	}
	
	replaceFuncElem { |elementKey, funcName, function, otherName, match = false|
		this.prMatchDo(match, elementKey, _.replaceFunc(funcName, function, otherName) )
	}

	addFuncElemFirst { |elementKey, funcName, function, match = false|
		this.prMatchDo(match, elementKey, _.addFuncFirst(funcName, function) )
	}
	
	addFuncElemLast { |elementKey, funcName, function, match = false|
		this.prMatchDo(match, elementKey, _. addFuncLast(funcName, function) )
	}
		
	removeAllFromElems {
		elements.do( _.reset )
	}
	
	elementNames{
		^elements.keys.asArray
	}
	
	recordRawValue { |key,value|
	//		recordFunc.value( key, value );
	}
	
	rawValueAt { |elName| 
		if (elName.isKindOf(Collection).not) { 
			^elements.at(elName).rawValue;
		};
		^elName.collect { |name| this.rawValueAt(name) }
	} 

	valueAt { |elName| 
		if (elName.isKindOf(Collection).not) { 
			^elements.at(elName).value;
		};
		^elName.collect { |name| this.valueAt(name) }
	} 
	
	setRawValueAt { |elName, val| 
		if (elName.isKindOf(Collection).not) { 
			^this.at(elName).rawValue_(val);
		};
		[elName, val].flop.do { |pair| 
			elements[pair[0].postcs].rawValue_(pair[1].postcs)
		};
	}

	setValueAt { |elName, val| 
		if (elName.isKindOf(Collection).not) { 
			^this.at(elName).value_(val);
		};
		[elName, val].flop.do { |pair| 
			elements[pair[0].postcs].value_(pair[1].postcs)
		};
	}
	
	reset{
		elements.do( _.reset )
	}
	
	// element access - support polyphonic name lists.
	at { |elementKey|
		//we can't distinguis [\kn1,\kn2] from [\kn,1]
		//so [[\kn,1]] must be used instead
		^elements.atKeys( elementKey.collectOrApply( this.prArgToElementKey(_) ) )
	}

	prArgToElementKey { |argm|
		//argm is either a symbol, a string or an array
		^switch( argm.class)
			{ Symbol }{ argm }
			{ String }{ argm.asSymbol }
			{ (argm[..(argm.size-2)].inject("",{ |a,b| a++b.asString++"_"}).asSymbol ++ argm.last.asString).asSymbol }
	}
	
	verbose_ {|value=true|
		verbose = value;
		value.if({
			elements.do{ |item| item.funcChain.addFirst(\verbose, { |elem| 
					[elem.source.name, elem.name, elem.value].postln;
			})}
		}, {
			elements.do{|item| item.funcChain.removeAt(\verbose)}
		})
	}
	
	//also can be used to simulate a non present hardware
	receive { |key, val|
		elements[ key ].update( val )
	}
	
	send { |key, val|
			
	}

    // f: A -> B
	collect { |f|
	    var disp = MDispatch( (this.name.asString++"_collect").asSymbol );
        disp.map(this);
        disp.createOutputsFromInputs;

        disp.addToProc( \calc, { |dis|
            var key = ~changedIn[\key];
            var source = ~changedIn[\source];
            var value = ~changedIn[\val];

            dis.setOutput(key, f.(value) );

        });
        ^disp
	}

	// keys: Array[Symbol]
	filterKeys { |...keys|
	    var disp = MDispatch( (this.name.asString++"_filterKeys").asSymbol );
        disp.map(this, keys);
        disp.createOutputsFromInputs;

        disp.addToProc( \calc, { |dis|
            var key = ~changedIn[\key];
            var source = ~changedIn[\source];
            var value = ~changedIn[\val];
            dis.setOutput(key, value );

        });
        ^disp
	}

	// f: A -> Boolean
    select { |f|
        var disp = MDispatch( (this.name.asString++"_filter").asSymbol );
        disp.map(this);
        disp.createOutputsFromInputs;

        disp.addToProc( \calc, { |dis|
            var key = ~changedIn[\key];
            var source = ~changedIn[\source];
            var value = ~changedIn[\val];
            if( f.(value ) ) {
                dis.setOutput(key, value );
            }

        });
        ^disp
    }

	// f: State X A -> State
	fold { |initialState, f|
	    var disp = MDispatch( (this.name.asString++"_fold").asSymbol );
        disp.map(this);
        disp.createOutputsFromInputs;

        //state
        disp.envir.put(\state,
        		disp.sources.collect{ |keysDict|
        			keysDict.collect{ initialState }
        		}
        	);
        disp.addToProc( \calc, { |dis|
            var key = ~changedIn[\key];
            var source = ~changedIn[\source];
            var value = ~changedIn[\val];

            var next = f.(~state[source][key], value);
            ~state[source][key] = next;
            dis.setOutput(key, next );
        });
        ^disp
	}

	// f: A -> MDispatch
	flatCollect { |f|
	    var disp = MDispatch( (this.name.asString++"_flatMap").asSymbol );

        disp.map(this);

        //lastKtl
        disp.envir.put(\lastKtl, nil );

        disp.envir.put(\parent, this);

        disp.addToProc( \flatMapMain, { |dis|
            var key = ~changedIn[\key];
            var source = ~changedIn[\source];
            var value = ~changedIn[\val];
            var nextDispatch;

            /*
            dis.envir.postln;
            this.name.postln;
            this.hash.postln;
            dis.envir.postln;
            key.postln;
            source.postln;
            value.postln;
            */

            ~lastKtl !? { |x|
                ~lastKtl.elementNames.do{ |elemKey|
                    ~lastKtl.removeFuncElem(elemKey, dis.hash.asSymbol)
                }
            };

            ~lastKtl = f.(value);

            ~lastKtl.elementNames.do{ |elemKey|
                 dis.createOutput(elemKey.asSymbol);
                 if(dis.verbose == true) {
                    dis.elements[elemKey].funcChain.addFirst(\verbose, { |elem|
                 	    [elem.source.name, elem.name, elem.value].postln;
                 	})
                 };
            	 ~lastKtl.addFuncElem( elemKey, dis.hash.asSymbol, { |element|
            	    dis.setOutput(element.name.postln, element.value.postln );
            	    dis.elements[element.name].doAction
            	 });
            };






        });
        ^disp
	}

	// merge events
	| { |mktl|

	    var disp = MDispatch( (this.name.asString++"_merge").asSymbol );

        disp.map(this);
        disp.map(mktl);

	    //disp.createOutputsFromInputs;

        disp.addToProc( \calc, { |dis|
            dis.setOutput(~changedIn[\key], ~changedIn[\val] );
        });

        ^disp
	}


	fromTemplate{ arg name ...args;
	    ^MDispatch.make(name, *([this]++args))
	}



}