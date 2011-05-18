v = (a: 1, b:2);
v.swapKeys(\a, \c) == ( 'c': 1, 'b': 2 );

v = (a: 1, b:2);
v.swapKeys(\a, \b) == ( 'a': 1, 'b': 2 );

v = (a: 1, b:2);
v.swapKeys(\c, \b) == ( 'a': 1, 'c': 2 );

v = (a: 1, b:2);
v.changeKeyForValue(\a, 2) == ( 'a': 2, 'b': 1 );

v = (a: 1, b:2);
v.changeKeyForValue(\c, 2) == ( 'c': 2, 'a': 1 );