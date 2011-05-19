(
func:{ |disp, source, previousSceneKey, nextSceneKey, n = 10, elementKeys, sourceKey|
	
	if( elementKeys.isNil ) {
		disp.mapAll(source,sourceKey)
	} {
		elementKeys.do{ |elemKey| disp.mapToElem(source,elemKey,sourceKey)}
	};
	
	// initialize the scene
	disp.envir[\scene] = 0;
	disp.envir[\numOfScenes] = n;
	disp.envir[\values] = n.collect{ 
		Dictionary.new.putPairs(source.elementNames.collect{ |name| 
			[name, source.defaultValueFor(name) ? 0] 
		}) 
	};
	n.collect{ |i| source.elementNames.collect{ |name| disp.createOutput(("/page"++(i+1)++"/"++name).asSymbol) } };
	disp.addToProc( \processEvents, {  |dis,e|
		var in = d.changedIn;
		var key = in[\key];
		var val = in[\val];
		var scene = e[\scene];
	
		e[\values][scene][key] = val;
		d.setOutput(("/page"++(scene+1)++"/"++key).asSymbol,val)
	
	});
	d.addToProc( \changeScene, {  |dis,e|
		var in = d.changedIn;
	
		if( (in[\key] == previousSceneKey) && ( in[\val] == 127 )) {
			e[\scene] = (e[\scene] - 1).min(n);
			postln("Scene is "++e[\scene])	
	
		};
		if( (in[\key] == nextSceneKey) && ( in[\val] == 127 )) {
			e[\scene] = (e[\scene] + 1).max(0);
			postln("Scene is "++e[\scene])
		};	
	});
	disp
},
desc: "makes a virtual scene system for the source",
name: "paged",
type: "creator"
)
