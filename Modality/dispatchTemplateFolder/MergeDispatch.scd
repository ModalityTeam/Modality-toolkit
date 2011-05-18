/*
merge several Dispatchs and or Ktls into one Dispatch
argument is of type
[
	[source, elemKeys],
	...
]
source -> a Dispatch or Ktl
elemKeys -> List of keys to map from source to output
*/

{ |dispatchs|

	d = Dispatch.new;
	
	dispatchs.do{ |arr|
		var disp,elemKeys;
		#disp, elemKeys = arr;
		d.map(disp, elemKeys)		
	};
	
	d.createOuputsFromInputs;
	
	d.addToProc( \velocityCalc, { |dis,e|
		var in = dis.changedIn;
		dis.setOutput(in[\key], in[\val] );
	});
  	d
}
