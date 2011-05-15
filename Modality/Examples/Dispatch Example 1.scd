k = MidiKtl.new
k.name == \nanoKtl1 //true
d = Dispatcher.new

k.addFunction(\slider1,\sendToDispath1Func, d)
k.addFunction(\slider2,\sendToDispath1Func, d)
k.addFunction(\slider3,\sendToDispath1Func, d)

d.addFunction(\addSliderValue, { |origin,key,value,dis|
	if(origin == \nanoKtl1) {
		if( [\slider1, \slider2, \slider3].contains(key) ) {
			envir.put( (key++"old").asSymbol, envir.get(key) )
			envir.put( key, val)
		}
	}	
}

d.addFunction(\calculateActivity, { |origin,key,value, envir, dis|

		val activityValue = [
			[envir.get(\slider1),envir.get(\slider2),envir.get(\slider3)],
			[envir.get(\slider1_old),envir.get(\slider2_old),envir.get(\slider3_old)]
		].flop.collect{ |innerArray| abs(innerArray[1] - innerArray[0]) }.sum;
		
		dis.setOuput(\activity,activityValue)
}

~d2 = Dispatcher.new

d.register(\activity, ~d2)

~d2.addFunctionForKey(\activityFunc2, \activity, { |originName, val|
	
	println("the previous dispatcher was "++originName++"the activity level is "++val) 

})







	
