/* 	CompassView 	-- a view for GamePad compasses. 

	// tests
w = Window("Compass").front;
z = CompassView(w.view, Rect( 200, 100,100,100));
z.action = { |comp| comp.dump };
z.nameView.string = "test";
z.value = 0; 
z.value = rrand(1, 8);
z.valueAction = 0; 
z.valueAction = rrand(1, 8).postln;

*/