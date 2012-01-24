FuncChain  	a named FunctionList 

FuncChain is an ordered list of functions that 
can be accessed, added and removed by name. 

adding with a new name adds to the end of the list; 
adding with an existing name replaces the func at that name.
one can add before or after an existing name, 
and one can add at the head or end of the list.

	// one can make a FuncChain with pairs of name, func: 	 
(
a = FuncChain([
	\ada, { "ada" }, 
	\bob, { "bob" }
]);
)
	// or make an empty one: 
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
		// add allows redirection by flags; 
		// if no flags are given, behaves like put.

a.add(\x, {10}); 
a.add(\y, {20});
a.add(\z, {30});
a.add(\w, {40});

	addLast(name, func)
		// if name is used, removes func at name;
		// adds new func to the end of the list
a.addLast(\x, {3});
a.addLast(\y, {3});

	addFirst(name, func) 
		// if name is used, removes func at name;
		// adds new func to the head of the list
a.addFirst(\z, {5});
a.addFirst(\x, {5});
a.addFirst(\y, {5});


		// adding relative to another name

	addBefore(name, func, otherName)
		// if name is not present, warns and adds to head 
a.addBefore(\abc, { 1234 }, \x);
a.addBefore(\abc, { 1234 }, \y);
a.addBefore(\abc, { 1234 }, \z);
a.addBefore(\abc, { 1234 }, \tralala);

	addAfter(name, func, otherName)
		// if name is not present, warns and adds to end 
a.addAfter(\abc, { 1234 }, \x);
a.addAfter(\abc, { 1234 }, \y);
a.addAfter(\abc, { 1234 }, \z);
a.addAfter(\abc, { 1234 }, \x);
a.addAfter(\xyz, { 1234 }, \tralala);
a.addAfter(\rst, { 1234 }, \tralala);


		// returns the func at name, or nil if name is not present
	removeAt(name)
a.removeAt(\a)
a.removeAt(\x); a
a.removeAt(\y); a
a.removeAt(\xyz); a
a.removeAt(\rst); a

	replaceAt(name, func, othername)

a.replaceAt(\rst, { 987 }, \a); a
a.replaceAt(\x, { 123 }, \z); a

	// internal methods
removeAtIndex(index) // fails if out of range
replaceAtIndex(index, name, func)
putAtIndex(index, name, func)


		// questions:
*  semantically, maybe addBefore and addAfter should rather be 
	addBefore(othername, name, func) 
	- or do we need that order for something?

* maybe implement valueAt(name, ... args) to get at just some of the functions?

		// todo: 
* write examples that check .value method

implement moving:	

	move( name, addAction, otherName )
	moveLast(name)
	moveFirst(name)
	moveAfter(name)
	moveBefore(name)

