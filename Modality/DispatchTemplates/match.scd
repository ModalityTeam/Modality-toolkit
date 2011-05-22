(
func:{ |disp, source, matchValues, elemKeys, sourceKey|

	disp.map(source, elemKeys);	
	disp.createOutputsFromInputs;
	
	disp.addToProc( \threshCalc, { |dis,e|
		var key = ~changedIn[\key];
		var source = ~changedIn[\source];
		var value = ~changedIn[\val];
		
		var index = matchValues.indexOf( value );
		
		if( index.notNil ) {
			dis.setOutput(key, index );
		}
	
	} );
   disp
},
desc: "pass values when in range",
name: "match",
type: "creator"
)
