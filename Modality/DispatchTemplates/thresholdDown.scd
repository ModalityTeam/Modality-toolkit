(
func:{ |disp,source, thresh = 0.5, elemKeys, sourceKey|
	
	disp.map(source, elemKeys);	
	disp.createOutputsFromInputs;
	
	disp.envir.put(\prevValues,
		disp.sources.collect{ |keysDict|
			keysDict.collect{0}
		}
	);
	
	disp.addToProc( \calc, { |dis|
		var key = ~changedIn[\key];
		var source = ~changedIn[\source];
		var value = ~changedIn[\val];
		
		if( (value <= thresh) && (~prevValues[source][key] > thresh) ) {
			dis.setOutput(key, \down );
		};
		~prevValues[source][key] = value;
	
	} );
   disp
},
desc: "trigger on passing threshold going down",
name: "thresholdDown",
type: "creator"
)
