(
func:{ |disp, source, waitTime = 1, elemKeys, sourceKey|
	
	disp.map(source, elemKeys);
	disp.createOutputsFromInputs;
	
	disp.envir.put(\prevValues,
		disp.sources.collect{ |keysDict|
			keysDict.collect{0}
		}
	);
	
	disp.envir.put(\tasks,
		disp.sources.collect{ |keysDict|
			keysDict.collect{ nil }
		}
	);

	disp.addToProc( \calc, { |dis|
		var key = ~changedIn[\key];
		var source = ~changedIn[\source];
		var value = ~changedIn[\val];
		~prevValues[source][key] = value;
		
		if( ~tasks[source][key].isPlaying.not ) {
			dis.setOutput(key, value );
			~tasks[source][key] = Task({ 
				waitTime.wait;
				dis.elements[key].value_(~prevValues[source][key]).doAction
			}).start;
		} {
			
		}
	
	});
   disp
},
desc: "only let value pass again after waitTime, but get the latest value",
name: "delay",
type: "creator"
)