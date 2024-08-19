$(document).on('turbolinks:load', function(){
    $('a.voting').on('ajax:success', function(e) {
        var resource = $(this).data('resource');
        var id =  $(this).data('id');

        if (e.detail[0]["error"]) {
            $('#'+resource +'-error-'+id).html('<p>' + e.detail[0]["error"] + '</p>');
        } else {
            $('#'+resource +'-rating-'+id).html('<p>' + e.detail[0] + '</p>');
        }
    })

    $('a.voting').on('ajax:error', function(e) {
        $('.question-errors').empty();
        $('.question-errors').append('<p>' + e.detail[0]["error"] + '</p>');
    })
});
