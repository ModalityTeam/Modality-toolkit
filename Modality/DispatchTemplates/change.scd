(
func:{ |disp, source,elemKeys, sourceKey|
	
	disp.map(source, elemKeys);
	disp.createOutputsFromInputs;	
	
	disp.envir.put(\prevValues,
		disp.sources.collect{ |keysDict|
			keysDict.collect{0}
		}
	);
	
	disp.addToProc( \threshCalc, { |dis|
		var key = ~changedIn[\key];
		var source = ~changedIn[\source];
		var value = ~changedIn[\val];

		if( value != ~prevValues[source][key]) {
			dis.setOutput(key, true );
		};
		
		~prevValues[source][key] = value;
	
	} );
	
   disp
},
desc: "check if value is different then previous one",
name: "change",
type: "creator"
)
