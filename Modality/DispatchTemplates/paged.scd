//needs to be fixed
(
func:{ |disp, source, previousSceneKey, nextSceneKey, n = 10, elementKeys, sourceKey|
	
	disp.map(source, elementKeys);	
	
	// initialize the scene
	disp.envir[\scene] = 0;
	disp.envir[\numOfScenes] = n;
	disp.envir[\values] = n.collect{ 
		Dictionary.newFrom(source.elementNames.collect{ |name| 
			[name, source.defaultValueFor(name) ? 0] 
		}.flat) 
	};
	
	n.collect{ |i| source.elementNames.collect{ |name| disp.createOutput(("/page"++(i+1)++"/"++name).asSymbol) } };
	
	disp.addToProc( \processEvents, {  |dis|
	    var key = ~changedIn[\key];
        var source = ~changedIn[\source];
        var value = ~changedIn[\val];

        ~values[~scene][key] = value;
        dis.setOutput(("/page"++(~scene+1)++"/"++key).asSymbol,value)
	
	});
	
	disp.addToProc( \changeScene, {  |dis|
		var key = ~changedIn[\key];
        var source = ~changedIn[\source];
        var value = ~changedIn[\val];

		if( (key == previousSceneKey) && ( value == 1.0 ) ) {
            ~scene = (~scene - 1).max(0);
            postln("Scene is "++(~scene+1))

		};
		if( (key == nextSceneKey) && ( value == 1.0 )) {
            ~scene = (~scene + 1).min(n);
            postln("Scene is "++(~scene+1))
		};	
	});
	
	disp
},
desc: "makes a virtual scene system for the source",
name: "paged",
type: "creator"
)
