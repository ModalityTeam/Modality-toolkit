SFunction {

   var <>envir;
   var <>function;

   *new{ |func|
      ^super.new.function_( func ).init;
   }

   init{
      envir = Environment.new;
   }

   value{ arg ...args;
      ^function.inEnvir( envir ).value( *args );
   }

   valueArray{ arg ...args;
        ^function.inEnvir( envir ).value( *(args.unbubble) );
    }

   put{ |key,value|
      envir.put( key, value );
   }

   at{ |key|
      ^envir.at( key );
   }

}