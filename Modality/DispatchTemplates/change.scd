(
func:{ |disp, source,elemKeys, sourceKey|
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
		
		if( value != e[source][key]) {
			dis.setOutput(key, true );
		};
		
		e[source][key] = value;
	
	} );
   disp
},
desc: "check if value is different then previous one",
name: "change",
type: "creator"
)
