component {
    boolean function onApplicationStart() {
       Application.db_user = new model.user();
       return true;
    }

    void function onApplicationEnd(struct application) {
        //arguments.application.whatever.finalize();
     }

     boolean function onRequestStart(string targetPage) {
        //echo('<html><head><body>'); // outputs the response html header

        // reload manually
        if (StructKeyExists(URL, 'reload')) {
            onApplicationStart();
        };

        // default 
        setting showDebugOutput=true;
        param name="SESSION.user_id" default=0;

        return true;
    }    
 }