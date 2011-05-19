(
func:{ |disp, source, elemKeys, sourceKey|
	disp.map(source, elemKeys);	
	disp.createOutputsFromInputs;
	disp.sources.pairsDo{ |sourceKey,keysDict|
		disp.envir.put(sourceKey,keysDict.collect{0})
	};
	
	disp.addToProc( \calc, { |dis,e|
		var in = dis.changedIn;
		var key = in[\key];
		var source = in[\source];
		var value = in[\val];
		
		if( value > e[source][key] ) {
			dis.setOutput(key, value );
		};
		e[source][key] = value;
	
	} );
   disp
},
desc: "only output when values increase",
name: "up",
type: "creator"
)