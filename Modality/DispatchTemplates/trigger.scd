(
func:{ |disp, source,elemKeys, sourceKey|
	disp.map(source, elemKeys);	
	disp.createOutputsFromInputs;
	
	disp.addToProc( \velocityCalc, { |dis,e|
		var in = dis.changedIn;
		if( in[\val] == 1 ) {
			dis.setOutput(in[\key], 1)
		}
	});
  	disp
},
desc: "trigger on a value of 1",
name: "trigger",
type: "creator"
)
