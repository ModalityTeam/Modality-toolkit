+ Object {

    collectOrApply { |f|
    	^if( this.isCollection ) {
    		this.collect(f)
    	} {
    		f.(this)
    	}
    }

}
