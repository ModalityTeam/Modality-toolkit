+ CtLoop {

    list_{ |newlist|
        list = newlist;
    }

    setPlayLoop{ |index|
        if ( index <= (loops.size-1) ){
            list = loops[ index ];
        }{
            "loop with index % does not exist".postf( index );
        }
    }

}