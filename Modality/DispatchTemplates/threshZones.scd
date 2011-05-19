(func:{ |disp,source,elemKeys, sourceKey, threshs|
	disp.map(source, elemKeys);	
	disp.createOutputsFromInputs;
	disp.sources.pairsDo{ |sourceKey,keysDict|
		disp.envir.put(sourceKey,keysDict.collect{0});
		keysDict.pairsDo{ |key|
			threshs.do{ |a,i|
				disp.createOutput((key++"_"++i).asSymbol)
			}
		};
	};
	threshs = threshs.sort;
	disp.addToProc( \calc, { |dis,e|
		var in = dis.changedIn;
		var key = in[\key];
		var source = in[\source];
		var value = in[\val];
		var prevTresh;
		var currentTresh;
		var currentTreshIndex;
		
		threshs.do{ |th,i|
			if( value > th ) {
				currentTresh = th;	
				currentTreshIndex = i;						};
			if( e[source][key] > th ) {
				prevTresh = th;								};				
		};
		
		if( prevTresh != currentTresh ) {
			if( currentTreshIndex.notNil ) {
				dis.setOutput((key++"_"++currentTreshIndex).asSymbol,  1);
			}
		};
		e[source][key] = value;
	
	} );
   disp
},
desc: "setup multiple triggers",
name: "threshZones",
type: "creator"
)