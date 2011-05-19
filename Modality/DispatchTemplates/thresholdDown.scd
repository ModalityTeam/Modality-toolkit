(
func:{ |disp,source,elemKeys, sourceKey, thresh = 0.5|
	disp.map(source, elemKeys);	
	disp.createOutputsFromInputs;
	disp.sources.pairsDo{ |sourceKey,keysDict|
		disp.envir.put(sourceKey,keysDict.collect{0})
	};
	
	disp.addToProc( \threshCalc, { |dis,e|
		var in = dis.changedIn;
		var key = in[\key];
		var source = in[\source];
		var value = in[\val];
		
		if( (value <= thresh) && (e[source][key] > thresh) ) {			dis.setOutput(key, \down );
		};
		e[source][key] = value;
	
	} );
   disp
},
desc: "trigger on passing threshold going down",
name: "thresholdDown",
type: "creator"
)
