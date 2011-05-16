// honouring Jeff's MKeys by keeping the M for prototyping the new Ktl


// TODO:
//	default deviceDescription files in quarks, custom ones in userAppSupportDir
//		(Platform.userAppSupportDir +/+ "MKtlSpecs").standardizePath, 
//		if (deviceDescriptionFolders[0].pathMatch.isEmpty) { 
//			unixCmd("mkdir \"" ++ deviceDescriptionFolder ++ "\"");
//		};

MKtl { // abstract class
	classvar <deviceDescriptionFolder;

	classvar <all; // will hold all instances of MKtl

	var <responders;
	var <name;	// a user-given unique name
	
	// an array of keys and values with a description of all the elements on the device.
	// is read in from an external file.
	var <deviceDescription; 

	// all control elements (MKtlElement) on the device you may want to listen or talk to
	var <elements;

	//var <>recordFunc; // what to do to record incoming control changes
	
	*initClass {
		all = ();	
		Spec.add(\midiCC, [0, 127, \lin, 1, 0]); 
		Spec.add(\midiVel, [0, 127, \lin, 1, 0]); 
		Spec.add(\midiBut, [0, 127, \lin, 127, 0]); 

		deviceDescriptionFolder = this.filenameSymbol.asString.dirname +/+ "MKtlSpecs";
	}
	
		// abstract class - new returns existing instances 
		// of subclasses that exist in .all
	*new { |name|
		^all[name]	
	}
	
	*basicNew { 
		^super.new.init;
	}
	
	*find {
		this.allSubclasses.do(_.find);	
	}

	init {
		//envir = ();
		elements = ();
	}

	findDeviceDescription { |deviceName| 
		
		var cleanDeviceName = deviceName.collect { |char| if (char.isAlphaNum, char, $_) }.postcs;
		var path = deviceDescriptionFolder +/+ cleanDeviceName ++ ".scd";
		deviceDescription = try { 
			path.load;
		} { 
			"//" + this.class ++ ": - no device description found for %: please make them!\n".postf(cleanDeviceName);
		//	this.class.openTester(this);
		};
		
		// create specs
		deviceDescription.pairsDo{|key, elem|
			elem[\spec] = elem[\spec].asSpec
		};
		
	}

	postDeviceDescription { deviceDescription.printcsAll; }
	
	deviceDescriptionFor { |elname| ^deviceDescription[deviceDescription.indexOf(elname) + 1] }
	
			// convenience methods
	defaultElementValue { |elName| 
		^this.deviceDescriptionFor(elName).spec.default
	}
	

	
	elNames { 
		^(0, 2 .. deviceDescription.size - 2).collect (deviceDescription[_])
	}
	
	addFunc { |elementKey, funcName, function, addAction=\addToTail, target|
		elements[elementKey].addFunc( funcName, function, addAction, target );
	}
	
//	recordValue { |key,value|
//		recordFunc.value( key, value );
//	}

	
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

	var <ktl; // the Ktl it belongs to
	var <name; // its name in Ktl.elements
	var <type; // its type. 
	
	var <deviceDescription, <spec; 
	var <funcChain; //
	
	// keep value and previous value here?
	var <>value;
	var <>prevValue;

	*initClass {
		types = (
			\slider: \x,
			\button: \x,
			\thumbStick: [\joyAxis, \joyAxis, \button],
			\joyStick: [\joyAxis, \joyAxis, \button]
		)
	}

	*new { |ktl, name, type|
		^super.newCopyArgs( ktl, name, type ).init;
	}

	init { 
		funcChain = FuncChain.new;
		deviceDescription = ktl.deviceDescriptionFor(name);
		spec = deviceDescription[\spec].asSpec;
		value = prevValue = spec.default ? 0;
	}

	addFunc { |funcName, func, addAction=\addToTail, target|
		// by default adds the action to the end of the list
		// if target is set to a function, addActions \addBefore, \addAfter, \addReplace, are valid
		// otherwise there is \addToTail or \addToHead
		
		^funcChain.addFunc(funcName, func, addAction, target);
	}
	
	replaceFunc { |funcName, func, where| 
		^funcChain.replaceAt(funcName, func, where);
	}
	
	removeFunc {|funcName| ^funcChain.removeFunc(funcName) }
	
	
	
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
		ktl.recordValue( name, newval );
		funcChain.valueAll( name, newval );
	}

}