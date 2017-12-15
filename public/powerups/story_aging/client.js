// want to have number of days a story has been in a particular status/*

/*
this is working in sandbox
var success = function(successMsg) {
  asyncOutput(successMsg);
};

var error = function(errorMsg) {
  asyncOutput(errorMsg);
};

Trello.cards.get('5a1ecaf11221968e51b5c0c3', success, error);

Trello.get('/cards/5a1ecaf11221968e51b5c0c3/attachments', success, error);

 */

var Promise = TrelloPowerUp.Promise;

function debugPrint(obj){
    console.log(JSON.stringify(obj));
    //for (var property in obj){
        //if(obj.hasOwnProperty(property)){

        //console.log(property + ": " + obj[property]);
        //}
    //}
}

var attachments = function(t){
    return t.card('attachments')
        .get('attachments')
        .filter(function(attachment){
            return attachment.url.indexOf('peaceful-savannah-58277') > 0;
        });
};

var getBadges = function(t){


            return [{
                // dynamic badges can have their function rerun after a set number
                // of seconds defined by refresh. Minimum of 10 seconds.
                dynamic: function(){
                    // we could also return a Promise that resolves to this as well if we needed to do something async first
                    attachments(t).then(function(data){

                        //console.log("inside attachments promise return.");

                        debugPrint(data);
                        var attachedItems = data;
                        if(attachedItems && attachedItems.length > 0){
                            console.log("doing stuff to attachments");

                            //var existing_list_date = t.get('card','shared','date_entered_list');

                            if(attachedItems && attachedItems.length > 0){
                                var chunks = attachedItems[0].url.split("date=");
                                var date_chunk = chunks[1];
                                var date_entered_list = new Date(date_chunk);
                                console.log("inside attachedItems if block");
                                //t.remove('card', 'shared', 'date_entered_list');
                                //t.set('card', 'shared', 'date_entered_list', date_entered_list);
                                console.log("done removing and setting data");
                            }


                        }


                    });

                    return {
                        text: 'Dynamic ', // + (Math.random() * 100).toFixed(0).toString(),
                        color: null,
                        refresh: 30  // in seconds
                    };
                }
            }];

};




TrelloPowerUp.initialize({
    'card-badges': function(t, options){
        console.log("I initialized!!");

        return getBadges(t);
    }
});
