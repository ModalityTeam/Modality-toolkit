(
func:{ |disp, source,elemKeys, sourceKey, waitTime = 1|
	
	disp.map(source, elemKeys);		
	disp.createOutputsFromInputs;
	
	disp.sources.pairsDo{ |sourceKey,keysDict|
		disp.envir.put(sourceKey,keysDict.collect{0})
	};
	
	elemKeys = elemKeys ? source.elementNames;
	
	disp.sources.pairsDo{ |sourceKey,keysDict|
		disp.envir.put(sourceKey,keysDict.collect{0})
	};
	
	disp.envir[\tasks] = Dictionary.new.putPairs(elemKeys.collect{ |name| 
		[name, nil] 
	}.flat);	

	disp.addToProc( \threshCalc, { |dis,e|
		var in = dis.changedIn;
		var key = in[\key];
		var source = in[\source];
		var value = in[\val];
		
		if( e[\tasks][key].isPlaying.not ) {
			e[\tasks][key] = Task({ waitTime.wait; }).start;
			dis.setOutput(key, value );
		}
	
	});
   disp
},
desc: "only let value pass again after waitTime",
name: "wait",
type: "creator"
)