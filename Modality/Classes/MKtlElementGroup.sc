MKtlAbstractElementGroup : MAbstractElement {
	
	var <elements;

	*new { |source, name|
		^super.newCopyArgs( source, name ).init;
	}

	init { 
		elements.do(_.parent_(this));
	}
	
	elements_ { |newElements|
		elements = newElements;
		this.init;
	}
	
	at { |index| ^elements[index] }
	
	put { |index, element|
		this.elements = this.elements.put( index, element );
	}
	
	add { |element|
		this.elements = this.elements.add( element );
	}
	
	remove { |element| ^this.elements.remove( element ); }
	
	indexOf { |element| ^this.elements.indexOf( element ); }

	value { ^elements.collect(_.value) }

	addAction { |argAction|
		action = action.addFunc(argAction);
	}

	removeAction { |argAction|
		action = action.removeFunc(argAction);
	}

	reset {
		action = nil
	}

	// assuming that something setting the element's value will first set the value and then call doAction (like in Dispatch)
	doAction { |...children|
		children = children.add( this );
		action.value( *children );
		parent !? _.doAction( *children );
	}

}

MKtlElementArray : MKtlAbstractElementGroup {
	
	elements_ { |newElements|
		elements = newElements.asArray;
		this.init;
	}

}

MKtlElementDict : MKtlAbstractElementGroup {
	
	var <>keys;
	
	init { 
		elements = elements ?? {()};
		keys = keys ? [];
		if( elements.size < keys.size ) {
			elements.keys.asArray.do({ |key|
				if( keys.includes( key ).not ) {
					keys = keys.add( key );
				};
			});
		};
		elements.do(_.parent_(this));
	}
	
	elements_ { |newElements|
		elements = newElements; // this should be made into a dictionary somehow
		this.init;
	}
	
	at { |index| 
		if( index.isNumber ) { index = keys[ index ] };
		^elements[index] 
	}
	
	put { |key, element|
		if( keys.includes( key ).not ) {
			keys = keys.add( key );
		};
		this.elements = this.elements.put( key, element );
	}

	add { |association|
		this.put( association.key, association.value );
	}

}