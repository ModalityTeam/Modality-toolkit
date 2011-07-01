(
func:{ |disp, source,elemKeys, sourceKey, range|
	range = range ? [0.2,0.3];
	
	disp.map(source, elemKeys);
	disp.createOutputsFromInputs;	
	
	disp.addToProc( \threshCalc, { |dis|
		var key = ~changedIn[\key];
		var source = ~changedIn[\source];
		var value = ~changedIn[\val];
		
		if( value.inclusivelyBetween( *range ) ) {
			dis.setOutput(key, value );
		}
	
	} );
   disp
},
desc: "pass values when in range",
name: "inRange",
type: "creator"
)
