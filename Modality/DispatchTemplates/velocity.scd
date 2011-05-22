(
func:{ |disp, source, waitTime = 0.5, elemKeys, sourceKey|
	
	disp.map(source, elemKeys);	
	disp.createOutputsFromInputs;
	
	disp.envir.put(\prevValues,
		disp.sources.collect{ |keysDict|
			keysDict.collect{0}
		}
	);
	
	disp.envir.put(\prevTimes,
		disp.sources.collect{ |keysDict|
			keysDict.collect{Process.elapsedTime}
		}
	);
	
	disp.envir.put(\tasks,
		disp.sources.collect{ |keysDict|
			keysDict.collect{nil}
		}
	);	
	
	disp.addToProc( \calc, { |dis|
		var key = ~changedIn[\key];
		var source = ~changedIn[\source];
		var value = ~changedIn[\val];
		var currentTime = Process.elapsedTime;
		
		if( ~tasks[source][key].isPlaying ) {
			~tasks[source][key].stop;
		};
		
		dis.setOutput(key, 
			abs( (value - ~prevValues[source][key]) / ( currentTime - ~prevTimes[source][key] ) ) ) ;
			
		~prevValues[source][key] = value;
		~prevTimes[source][key] = currentTime;	
		~tasks[source][key] = Task({ 
			waitTime.wait;
			disp.elements[key].value_(0).doAction
		}).start;	
	
	} );
   disp
},
desc: "returns the velocity of each controlElement",
name: "velocity",
type: "creator" //can be creator, modyfier 
)
