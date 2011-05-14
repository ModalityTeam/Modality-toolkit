// honouring Jeff's MKeys by keeping the M for prototyping the new Ktl
MKtl {

	classvar <all; // will hold all instances of MKtl

	var <responders;

	//	var <state; // MKtlCtls keep their own state

	var <envir;
	
	var <inputs; // all controls on the Ktl which can be moved around
	// these are key -> MKtlCtl pairs

	var <outputs; // anything that can be sent out to the Ktl
	
	init{
		envir = ();
		inputs = ();
		outputs = ();
	}
	
	recordValue{ |key,value|
		recordFunc.value( key, value );
	}
	

}

MKtlCtl {
	classvar <types;

	var <>ktl; // the Ktl it belongs to
	var <>key; // its key in Ktl

	var <funcChain; // how to keep the order?
	
	// keep value and previous value here?
	var <value;
	var <prevValue;

	*new{ |ktl,key|
		^super.newCopyArgs( ktl, key );
	}

	init{ 
		funcChain = NamedFunctionList.new;
	}


	updateState{ | newval |
		// copies the current state to:
		prevValue = value;
		// updates the state with the latest value
		value = newval;
	}

	update{ |newval|
		this.updateState( newval );
		ktl.recordValue( key, newval );
		funcChain.do{ |it,i|
			it.value( ktl, key, newval );
		}
	}

}