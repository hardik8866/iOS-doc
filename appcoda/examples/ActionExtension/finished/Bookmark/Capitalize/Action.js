//
//  Action.js
//  Capitalize
//
//  Created by Joyce Echessa on 3/12/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

var Action = function() {};

Action.prototype = {
    
    run: function(arguments) {
        
        arguments.completionFunction({"content": document.body.innerHTML});
    },
    
    finalize: function(arguments) {
        document.body.innerHTML = arguments["content"];
    }
    
};
    
var ExtensionPreprocessingJS = new Action
