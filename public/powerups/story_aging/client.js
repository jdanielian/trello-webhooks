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
}

function workingDaysBetweenDates(startDate, endDate) {

    // Validate input
    if (endDate < startDate)
        return 0;

    // Calculate days between dates
    var millisecondsPerDay = 86400 * 1000; // Day in milliseconds
    startDate.setHours(0,0,0,1);  // Start just after midnight
    endDate.setHours(23,59,59,999);  // End just before midnight
    var diff = endDate - startDate;  // Milliseconds between datetime objects
    var days = Math.ceil(diff / millisecondsPerDay);

    // Subtract two weekend days for every week in between
    var weeks = Math.floor(days / 7);
    days = days - (weeks * 2);

    // Handle special cases
    var startDay = startDate.getDay();
    var endDay = endDate.getDay();

    // Remove weekend not previously removed.
    if (startDay - endDay > 1)
        days = days - 2;

    // Remove start day if span starts on Sunday but ends before Saturday
    if (startDay == 0 && endDay != 6)
        days = days - 1

    // Remove end day if span ends on Saturday but starts after Sunday
    if (endDay == 6 && startDay != 0)
        days = days - 1

    return days;
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
                    var text = null;
                    return attachments(t).then(function(data){

                        var attachedItems = data;

                        if(attachedItems && attachedItems.length > 0){
                            console.log("doing stuff to attachments");

                            var chunks = attachedItems[0].url.split("date=");
                            if(chunks.length === 2){
                                var date_chunk = chunks[1];
                                var date_entered_list = new Date(date_chunk);
                                console.log("inside attachedItems if block");

                                var workingDays = workingDaysBetweenDates(date_entered_list, new Date());

                                console.log("done removing and setting data");
                                text = "Age: " + workingDays.toString();
                                console.log("working days: " + workingDays.toString());
                                //t.set('card', 'shared', 'date_entered_list', date_entered_list);
                                return { text: text, color: null, refresh: 360};
                            }
                            //t.remove('card', 'shared', 'date_entered_list');
                            //t.set('card', 'shared', 'date_entered_list', date_entered_list);
                        }

                        return {
                            text: text,
                            color: null,
                            refresh: 360  // in seconds
                        };


                    });


                }
            }];

};




TrelloPowerUp.initialize({
    'card-badges': function(t, options){
        return getBadges(t);
    }
});
