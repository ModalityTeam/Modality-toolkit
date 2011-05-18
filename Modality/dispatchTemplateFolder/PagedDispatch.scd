{ |source, previousSceneKey, nextSceneKey, n = 10, elementKeys, sourceKey|
	var d = Dispatch.new;
	
	if( elementKeys.isNil ) {
		d.mapAll(source,sourceKey)
	} {
		elementKeys.do{ |elemKey| d.mapToElem(source,elemKey,sourceKey)}
	};
	
	// initialize the scene
	d.envir[\scene] = 0;
	d.envir[\numOfScenes] = n;
	d.envir[\values] = n.collect{ 
		Dictionary.new.putPairs(source.elementNames.collect{ |name| 
			[name, source.defaultValueFor(name) ? 0] 
		}) 
	};
	n.collect{ |i| source.elementNames.collect{ |name| d.createOutput(("/page"++(i+1)++"/"++name).asSymbol) } };
	d.addToProc( \processEvents, {  |dis,e|
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
	d
}