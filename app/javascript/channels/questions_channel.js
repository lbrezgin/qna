import consumer from "./consumer"

$(document).on('turbolinks:load', function () {
    consumer.subscriptions.create('QuestionsChannel', {
        connected() {
            console.log('Connected!');
            this.perform('follow');
        },
        received(data) {
            $('#questions').append(`<h2><a href="questions/${data.id}">${data.title}</a></h2>`);
        }
    });
});

