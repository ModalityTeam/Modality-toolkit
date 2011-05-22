(
func:{ |disp, source, elementKeys, sourceKey|
	
	if( elementKeys.isNil ) {
		disp.map(source,nil,sourceKey)
	} {
		elementKeys.do{ |elemKey| disp.mapToElem(source,elemKey,sourceKey)}
	};
	
	disp.createOutputsFromInputs;
	
	disp.addToProc( \calc, { |dis|
		var key = ~changedIn[\key];
		var source = ~changedIn[\source];
		var value = ~changedIn[\val];
		var keyTime = (key++"time").asSymbol;
		var currentTime;
		
		if( e[source].isNil ) {
			e.put(source,Dictionary.new);
		};
		
		if(	e[source][key].isNil ) {
			e[source][key] = value;
			e[source][keyTime] = Process.elapsedTime;
		} {
			currentTime = Process.elapsedTime;
			dis.setOutput(key, abs( (value - e[source][key]) / ( currentTime - e[source][keyTime] ) ) ) ;
			e[source][key] = value;
			e[source][keyTime] = currentTime;
		}
	
	} );
   disp
},
desc: "returns the velocity of each controlElement",
name: "velocity",
type: "creator" //can be creator, modyfier 
)
