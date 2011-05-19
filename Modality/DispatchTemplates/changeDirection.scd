(
func:{ |disp, source,elemKeys, sourceKey|
	disp.map(source, elemKeys);	
	disp.createOutputsFromInputs;
	disp.sources.pairsDo{ |sourceKey,keysDict|
		disp.envir.put(sourceKey,keysDict.collect{0})
	};
	elemKeys = elemKeys ? source.elementNames;
	disp.sources.pairsDo{ |sourceKey,keysDict|
		disp.envir.put(sourceKey,keysDict.collect{0})
	};
	disp.envir[\oldValues]= Dictionary.new.putPairs(elemKeys.collect{ |name| 
		[name, 0] 
	}.flat);
	disp.envir[\oldDirections]= Dictionary.new.putPairs(elemKeys.collect{ |name| 
       [name, 1] 
    }.flat);
	
	disp.addToProc( \threshCalc, { |dis,e|
		var in = dis.changedIn;
		var key = in[\key];
		var source = in[\source];
		var value = in[\val];
		var direction = (e[source][key] - value).sign;
		
		if ( direction != e[\oldDirections][key] ) {
			dis.setOutput(key, if( direction < e[\oldDirections][key] ) {\up}{\down} );
		};
		e[\oldDirections][key] = direction;
		e[source][key] = value;
	
	});
   disp
},
desc: "check if value is different then previous one",
name: "changeDirection",
type: "creator"
)
