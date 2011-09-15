(func:{ |disp, source, elemKeys, sourceKey, threshs|
	
	disp.map(source, elemKeys);	
	disp.createOutputsFromInputs;
	
	disp.envir.put(\prevValues,
		disp.sources.collect{ |keysDict|
			keysDict.collect{0}
		}
	);
	
	disp.sources.pairsDo{ |sourceKey,keysDict|
		keysDict.pairsDo{ |key|
			threshs.do{ |a,i|
				disp.createOutput((key++"_"++i).asSymbol)
			}
		};
	};
	
	threshs = threshs.sort;
	disp.addToProc( \calc, { |dis|
		var key = ~changedIn[\key];
		var source = ~changedIn[\source];
		var value = ~changedIn[\val];
		var prevTresh;
		var currentTresh;
		var currentTreshIndex;
		
		threshs.do{ |th,i|
			if( value > th ) {
				currentTresh = th;	
				currentTreshIndex = i;						};
			if( ~prevValues[source][key] > th ) {
				prevTresh = th;								};
		};
		
		if( prevTresh != currentTresh ) {
			if( currentTreshIndex.notNil ) {
				dis.setOutput((key++"_"++currentTreshIndex).asSymbol,  1);
			}
		};
		~prevValues[source][key] = value;
	
	} );
   disp
},
desc: "setup multiple triggers",
name: "threshZones",
type: "creator"
)