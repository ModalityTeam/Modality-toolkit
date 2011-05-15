// honouring Jeff's MKeys by keeping the M for prototyping the new Ktl


// TODO:
//	default devSpec files in quarks, custom ones in userAppSupportDir
//		(Platform.userAppSupportDir +/+ "MKtlSpecs").standardizePath, 
//		if (devSpecsFolders[0].pathMatch.isEmpty) { 
//			unixCmd("mkdir \"" ++ devSpecsFolder ++ "\"");
//		};

MKtl { // abstract class
	
	classvar <devSpecsFolder;

	classvar <all; // will hold all instances of MKtl

	var <responders;

	//var <state; 	// MKtlElement keep their own state
	var <name;	// a user-given unique name
	// var <envir;	// maybe used for internal state
	
	// an array of keys and values with a description of all the elements on the device
	var <devSpecs; 
	
	// all control elements (MKtlElement) on the device you may want to listen or talk to
	var <elements;

	var <>recordFunc; // what to do to record incoming control changes
	
	*initClass {
		all = ();	
		devSpecsFolder = this.filenameSymbol.asString.dirname +/+ "MKtlSpecs";
	}
	
	*find {
		this.allSubclasses.do(_.find);	
	}

	init {
		//envir = ();
		elements = ();
	}
	
	addFunc { |elementKey, funcName, function, addAction=\addToTail, target|
		elements[elementKey].addFunc( funcName, function, addAction, target );
	}
	
	recordValue { |key,value|
		recordFunc.value( key, value );
	}

	
	//useful if Dispatcher also uses this class
	//also can be used to simulate a non present hardware
	receive { |key, val|
		// is it really inputs ?
		elements[ key ].update( val )
	}
	
	send { |key, val|
			
	}

}

MKtlElement {
	classvar <types;

	var <>ktl; // the Ktl it belongs to
	var <>key; // its key in Ktl
	var <>type; // its type.

	var <funcChain; // how to keep the order?
	
	// keep value and previous value here?
	var <value;
	var <prevValue;

	*initClass {
		types = (
			\slider: \x,
			\button: \x,
			\thumbStick: [\joyAxis, \joyAxis, \button],
			\joyStick: [\joyAxis, \joyAxis, \button]
		)
	}

	*new { |ktl, key, type|
		^super.newCopyArgs( ktl, key, type );
	}

	init { 
		funcChain = FuncChain.new;
	}

	addFunc { |funcName, func, addAction=\addToTail, target|
		// by default adds the action to the end of the list
		// if target is set to a function, addActions \addBefore, \addAfter, \addReplace, are valid
		// otherwise there is \addToTail or \addToHead
	}
	
	send { |val|
		value = val;
		//then send to hardware 	
	}

	updateState { | newval |
		// copies the current state to:
		prevValue = value;
		// updates the state with the latest value
		value = newval;
	}

	update { |newval|
		this.updateState( newval );
		ktl.recordValue( key, newval );
		funcChain.valueAll( key, newval );
	}

}