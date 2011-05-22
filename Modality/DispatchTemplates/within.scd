(
func:{ |disp, source, waitTime = 1, elemKeys, sourceKey|
	
	disp.map(source, elemKeys);		
	disp.createOutputsFromInputs;
	
	disp.envir.put(\tasks,
		disp.sources.collect{ |keysDict|
			keysDict.collect{0}
		}
	);	

	disp.addToProc( \calc, { |dis|
		var key = ~changedIn[\key];
		var source = ~changedIn[\source];
		var value = ~changedIn[\val];
		
		if( ~tasks[source][key].isPlaying.not ) {
			~tasks[source][key] = Task({ waitTime.wait; }).start;			
		} {
			~tasks[source][key].stop;
			~tasks[source][key] = nil;
			dis.setOutput(key, value );			
		}
	
	});
   disp
},
desc: "only let value pass if it comes in within  s",
name: "wait",
type: "creator"
)