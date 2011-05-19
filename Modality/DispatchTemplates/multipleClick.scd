(
func:{ |disp,source,elemKeys, sourceKey, numClicks = 2|
	disp.map(source, elemKeys);	
	disp.createOutputsFromInputs;
	source.elementNames.do{ |elemKey| disp.envir.put(elemKey,0) };
	disp.addToProc( \multiClick, { |dis,e|
		var in = dis.changedIn;
		var key = in[\key];
		
		if( (in[\val] == 1) ) {
			e[key] = e[key] + 1;
			
			if( e[key] == numClicks) { 
				dis.setOutput(key, 1);
				e[key] = 0;
			} 
		}
	});
  	disp
},
desc: "only trigger actions on multiple triggers",
name: "multipleClick",
type: "creator"
)
