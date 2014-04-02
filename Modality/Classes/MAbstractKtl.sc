
//defines a common interface for Mktl and MDispatch, where outputs, called Elements are can be registered with for notifications.

MAbstractKtl {

	var <verbose = false;
	var <name;

	var <elementsDict; //of type: ('elementName':MKtlElement, ...) -> elements to which stuff is registered
	var <elements;

	prMatchedElements { |elementKey|
		if ( Main.versionAtLeast( 3.5 ) ){
			^elementsDict.asArray.select{ |elem| elem.name.matchOSCAddressPattern(elementKey) }
		}{
			^elementsDict.asArray.select{ |elem| elementKey.asString.matchRegexp( elem.name.asString ) };
		}
	}

	prMatchDo{ |match, elementKey, func|
		if( match ) {
			//match only works on dev versions at the moment.
			this.prMatchedElements(elementKey).do{ |element|
				func.value(element)
			}
		} {
			func.value(elementsDict[elementKey])
		}
	}

	removeAllFromElems {
		elementsDict.do( _.reset )
	}

	elementNames{
		^elementsDict.keys.asArray
	}

	printElementNames{

		(
			"\nElements available for %:\n".format(this.name)
			++ elementsDict.keys.as(Array).sort
			.collect{ |s| s.asString.padRight(14) }
			.clump(4)
			.collect{ |xs| xs.reduce('++') ++ "\n" }
			.reduce('++')
			++ "\n"
		).postln
	}

	recordRawValue { |key,value|
	//		recordFunc.value( key, value );
	}

	rawValueAt { |elName|
		if (elName.isKindOf(Collection).not) {
			^elementsDict.at(elName).rawValue;
		};
		^elName.collect { |name| this.rawValueAt(name) }
	}

	valueAt { |elName|
		if (elName.isKindOf(Collection).not) {
			^elementsDict.at(elName).value;
		};
		^elName.collect { |name| this.valueAt(name) }
	}

	setRawValueAt { |elName, val|
		if (elName.isKindOf(Collection).not) {
			^this.at(elName).rawValue_(val);
		};
		[elName, val].flop.do { |pair|
			elementsDict[pair[0].postcs].rawValue_(pair[1].postcs)
		};
	}

	setValueAt { |elName, val|
		if (elName.isKindOf(Collection).not) {
			^this.at(elName).value_(val);
		};
		[elName, val].flop.do { |pair|
			elementsDict[pair[0].postcs].value_(pair[1].postcs)
		};
	}

	reset{
		elementsDict.do( _.reset )
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
	}

	//also can be used to simulate a non present hardware
	receive { |key, val|
		elementsDict[ key ].update( val )
	}

	send { |key, val|

	}

	fromTemplate{ arg name ...args;
	    ^MDispatch.make(name, *([this]++args))
	}

}