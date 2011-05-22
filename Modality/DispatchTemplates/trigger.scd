(
func:{ |disp, source,elemKeys, sourceKey|
	disp.map(source, elemKeys);	
	disp.createOutputsFromInputs;
	
	disp.addToProc( \calc, { |dis|
		if( ~changedIn[\val] == 1 ) {
			dis.setOutput( ~changedIn[\key], 1)
		}
	});
  	disp
},
desc: "trigger on a value of 1",
name: "trigger",
type: "creator"
)
