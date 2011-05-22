(
func:{ |disp, source, elemKeys, sourceKey|

	disp.map(source, elemKeys);		
	disp.createOutputsFromInputs;	
	
	disp.envir.put(\prevValues,
		disp.sources.collect{ |keysDict|
			keysDict.collect{0}
		}
	);
	
	disp.addToProc( \calc, { |dis|
		vasr key = ~changedIn[\key];
		var source = ~changedIn[\source];
		var value = ~changedIn[\val];
		
		if( value < ~prevValues[source][key] ) {
			dis.setOutput(key, value );
		};
		~prevValues[source][key] = value;
	
	} );
   disp
},
desc: "only output when values decrease",
name: "down",
type: "creator"
)