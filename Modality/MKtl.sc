// honouring Jeff's MKeys by keeping the M for prototyping the new Ktl
MKtl {

	classvar <all; // will hold all instances of MKtl

	var <responders;

	//	var <state; // MKtlCtls keep their own state

	var <envir;
	
	var <inputs; // all controls on the Ktl which can be moved around
	// these are key -> MKtlCtl pairs

	var <outputs; // anything that can be sent out to the Ktl

	var <>recordFunc;

	init{
		envir = ();
		inputs = ();
		outputs = ();
	}
	
	recordValue{ |key,value|
		recordFunc.value( key, value );
	}

	addFunction{ |ctl,key,func,addAction=\addToTail,target|
		inputs[ ctl ].addFunction( key, func, addAction, target );
	}
	
	//usefull if Dispatcher also uses this class
	//also can be used to simulate a non present hardware
	receive{ |key,val|
		// is it really inputs ?
		inputs[ ctl ].update( val )
	}
	
	send{ |key,val|
			
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
		funcChain = FunctionList.new;
	}

	addFunction{ |key,func,addAction=\addToTail,target|
		// by default adds the action to the end of the list
		// if target is set to a function, addActions \addBefore, \addAfter, \addReplace, are valid
		// otherwise there is \addToTail or \addToHead
	}
	
	send{ |val|
		value = val;
		//then send to hardware 	
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
		funcChain.valueAll( ktl, key, newval );
	}

}