(
func:{ |disp, source,elemKeys, sourceKey, range|
	range = range ? [0.2,0.3];
	disp.map(source, elemKeys);	
	disp.createOutputsFromInputs;
	
	disp.addToProc( \threshCalc, { |dis,e|
		var in = dis.changedIn;
		var key = in[\key];
		var source = in[\source];
		var value = in[\val];
		
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
