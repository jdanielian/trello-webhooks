// want to have number of days a story has been in a particular status

var getBadges = function(t){
    return t.get('card','shared','date_entered_list')
        .then(function(data){
            console.log('here is shared date in scope: ' + data);

            return [{
                // dynamic badges can have their function rerun after a set number
                // of seconds defined by refresh. Minimum of 10 seconds.
                dynamic: function(){
                    // we could also return a Promise that resolves to this as well if we needed to do something async first
                    return {
                        title: 'Detail Badge', // for detail badges only
                        text: 'Dynamic ' + (Math.random() * 100).toFixed(0).toString(),
                        refresh: 10 // in seconds
                    };
                }
            }];
        });
};

var attachments = function(t){
    return t.card('attachments')
        .get('attachments')
        .filter(function(attachment){
            return attachment.url.indexOf('peaceful-savannah-58277') > 0;
        });
};


TrelloPowerUp.initialize({
    'card-badges': function(t, options){
        attachments = attachments(t);
        console.log(attachments);
        
        var date_chunk;
        var existing_list_date = t.get('card','shared','date_entered_list');
        
        if(attachments && attachments.length > 0){
            var chunks = attachments[0].url.split("date=");
            date_chunk = chunks[1];
            var date_entered_list = new Date(date_chunk);
            t.remove('card', 'shared', 'date_entered_list');
            t.set('card', 'shared', 'date_entered_list', date_entered_list);
        }
        

        return getBadges(t);
    }
};