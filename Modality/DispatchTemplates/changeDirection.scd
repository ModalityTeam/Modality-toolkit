(
func:{ |disp, source,elemKeys, sourceKey|

	disp.map(source, elemKeys);	
	disp.createOutputsFromInputs;
	
	disp.envir.put(\prevValues,
		disp.sources.collect{ |keysDict|
			keysDict.collect{0}
		}
	);
	
	disp.envir.put(\prevDirections,
		disp.sources.collect{ |keysDict|
			keysDict.collect{0}
		}
	);
	
	disp.addToProc( \threshCalc, { |dis|
		var key = ~changedIn[\key];
		var source = ~changedIn[\source];
		var value = ~changedIn[\val];
		var direction = (~prevValues[source][key] - value).sign;
		
		if ( direction != ~prevDirections[source][key] ) {
			dis.setOutput(key, if( direction < ~prevDirections[source][key] ) {\up}{\down} );
		};
		
		~prevDirections[source][key] = direction;
		~prevValues[source][key] = value;
	
	});
   disp
},
desc: "check if value is different then previous one",
name: "changeDirection",
type: "creator"
)