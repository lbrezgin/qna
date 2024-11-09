import consumer from "./consumer"

$(document).on('turbolinks:load', function(){
    var question = document.getElementsByClassName('question')
    var questionId = question[0].getAttribute('data-question-id')

    consumer.subscriptions.create({channel: "QuestionsCommentsChannel", question_id: questionId}, {
        connected() {
            // Called when the subscriptions is ready for use on the server
        },

        disconnected() {
            // Called when the subscriptions has been terminated by the server
        },

        received(data) {
            if (gon.currentUser) {
                if (gon.currentUser['id'] !== data['user_id']) {
                    $('.question-comments').append(`<p>${data['content']}</p>`);
                }
            } else {
                $('.question-comments').append(`<p>${data['content']}</p>`);
            }
        }
    });
});
