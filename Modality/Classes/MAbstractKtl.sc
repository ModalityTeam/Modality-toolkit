
//defines a common interface for Mktl and MDispatch, where outputs, called Elements are can be registered with for notifications. 

MAbstractKtl {
	
	var <verbose = false;
	var <name;
	
	var <elements; // elements to which stuff is registered
	
	prMatchedElements { |elementKey|
		^elements.asArray.select{ |elem| elem.name.matchOSCAddressPattern(elementKey) }
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
	addFuncElem { |elementKey, funcName, function, addAction, otherFuncName, match = false|
		this.prMatchDo(match, elementKey, _.addFunc( funcName, function , addAction, otherFuncName) )
	}

	addFuncElemAfter { |elementKey, funcName, function, otherFuncName, match = false|
		this.prMatchDo(match, elementKey, _.addFuncAfter(funcName, function, otherFuncName) )
	}
	
	addFuncElemBefore { |elementKey, funcName, function, otherFuncName, match = false|
		this.prMatchDo(match, elementKey, _.addFuncBefore( funcName, function, otherFuncName) )
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
	at { | elementKey | ^elements.atKeys(elementKey) }
	
	verbose_ {|value=true|
		verbose = value;
		value.if({
			elements.do{ |item| item.funcChain.addFirst(\verbose, { |elem| 
					[elem.source, elem.name, elem.value].postln;
			})}
		}, {
			elements.do{|item| item.funcChain.removeAt(\verbose)}
		})
	}
}