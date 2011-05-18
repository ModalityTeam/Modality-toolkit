FuncChain  	a named FunctionList 

FuncChain is an ordered list of functions that 
can be accessed, added and removed by name. 

adding with a new name adds to the end of the list; 
adding with an existing name replaces the func at that name.
one can add before or after an existing name, 
and one can add at the head of the list.

	// make one: 	 
(
a = FuncChain([
	\ada, { "ada" }, 
	\bob, { "bob" }
]);
)
	// make an empty one: 
a = FuncChain.new;

	// common behavior for all add methods:
	// if name exists, func at that name is removed;
	// new func is put where indicated.

	put(name, func)
		// if name is present, put func there;
		// if not, add a at the end.
a.put(\x, {1}); 
a.put(\y, {2});
a.put(\x, {234});
a.put(\z, {567});

a.at(\z).postcs

	add(name, func, addAction, otherName)
		// allows redirction by flags; 
		// if no flags, like put.

a.add(\x, {10}); 
a.add(\y, {20});
a.add(\z, {30});
a.add(\w, {40});

	addLast(name, func)
		// if name is used, remove func;
		// add to end of list
a.addLast(\x, {3});
a.addLast(\y, {3});

	addFirst(name, func) 
		// if name is used, remove func;
		// add to head of list
a.addFirst(\z, {5});
a.addFirst(\x, {5});
a.addFirst(\y, {5});

a.names.indexOf(\x)

	addBefore(name, func, otherName)
		// add relative to another name
a.addBefore(\abc, { 1234 }, \x);
a.addBefore(\abc, { 1234 }, \y);
a.addBefore(\abc, { 1234 }, \z);
a.addBefore(\abc, { 1234 }, \tralala);

	addAfter(name, func, otherName)
a.addAfter(\abc, { 1234 }, \x);
a.addAfter(\abc, { 1234 }, \y);	// still wrgon!
a.addAfter(\abc, { 1234 }, \z);
a.addAfter(\abc, { 1234 }, \x);
a.addAfter(\xyz, { 1234 }, \tralala);
a.addAfter(\rst, { 1234 }, \tralala);

		// does nothing when name is not present
		// returns the func at name
	removeAt(name)
a.removeAt(\a)
a.removeAt(\x); a
a.removeAt(\y); a
a.removeAt(\xyz); a
a.removeAt(\rst); a

		// 
	replaceAt(name, func, othername)

a.replaceAt(\rst, { 987 }, \a); a
a.replaceAt(\rst, { 123 }, \x); a

	// internal 
removeAtIndex(index) // fails if out of range
replaceAtIndex(index, name, func)
putAtIndex(index, name, func)


		// todo: 
* write examples that check .value method
* maybe implement valueAt(name, ... args)? 


implement moving:	

	move( name, addAction, otherName )
	moveLast(name)
	moveFirst(name)
	moveAfter(name)
	moveBefore(name)

