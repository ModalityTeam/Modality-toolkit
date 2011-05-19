(
func:{ |disp,dispatchs|
	
	dispatchs.do{ |arr|
		var dispatch,elemKeys;
		#dispatch, elemKeys = arr;
		disp.map(dispatch, elemKeys)		
	};
	
	disp.createOutputsFromInputs;
	
	disp.addToProc( \velocityCalc, { |dis,e|
		var in = dis.changedIn;
		dis.setOutput(in[\key], in[\val] );
	});
  	disp
},
desc: "merges multiple sources into just one Dispatch",
name: "merge",
type: "creator"
)