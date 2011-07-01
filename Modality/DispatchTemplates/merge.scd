(
func:{ |disp,dispatchs|
	
	dispatchs.do{ |arr|
		var dispatch,elemKeys;
		#dispatch, elemKeys = arr;
		disp.map(dispatch, elemKeys)
	};
	
	disp.createOutputsFromInputs;
	
	disp.addToProc( \calc, { |dis|
		dis.setOutput(~changedIn[\key], ~changedIn[\val] );
	});
  	disp
},
desc: "merges multiple sources into just one MDispatch",
name: "merge",
type: "creator"
)