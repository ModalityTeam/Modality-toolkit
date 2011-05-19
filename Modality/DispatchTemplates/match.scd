(
func:{ |disp, source,elemKeys, sourceKey, matchValues|
	disp.map(source, elemKeys);	
	disp.createOutputsFromInputs;
	
	disp.addToProc( \threshCalc, { |dis,e|
		var in = dis.changedIn;
		var key = in[\key];
		var source = in[\source];
		var value = in[\val];
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
