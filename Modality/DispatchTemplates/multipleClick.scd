(
func:{ |disp, source, numClicks = 2, elemKeys, sourceKey|

	disp.map(source, elemKeys);	
	disp.createOutputsFromInputs;
	
	disp.envir.put(\clicks,
		disp.sources.collect{ |keysDict|
			keysDict.collect{0}
		}
	);	

	
	disp.addToProc( \multiClick, { |dis,e|
		var key = ~changedIn[\key];
		var source = ~changedIn[\source];
		
		if( (~changedIn[\val] == 1) ) {
			~clicks[source][key] = ~clicks[source][key] + 1;
			
			if( ~clicks[source][key] == (numClicks-1) ) { 
				dis.setOutput(key, 1);
				~clicks[source][key] = 0;
			} 
		}
	});
  	disp
},
desc: "only trigger actions on multiple triggers",
name: "multipleClick",
type: "creator"
)
