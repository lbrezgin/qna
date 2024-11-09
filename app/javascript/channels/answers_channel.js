import consumer from "./consumer"

$(document).on('turbolinks:load', function(){
  var question = document.getElementsByClassName('question')
  var questionId = question[0].getAttribute('data-question-id')

  consumer.subscriptions.create( {channel: "AnswersChannel", question_id: questionId}, {
    connected() {
      // Called when the subscriptions is ready for use on the server
    },

    disconnected() {
      // Called when the subscriptions has been terminated by the server
    },

    received(data) {
      if (gon.currentUser) {
        if (data.answer['user_id'] !== gon.currentUser['id']) {
          $('.answers').append(this.pubAnswer(data))
        }
      } else {
        $('.answers').append(this.pubAnswer(data))
      }
      checkVoting();
      checkGists();
    },

    pubAnswer(data) {
      // check if answer contains links
      let linksHTML = '';

      if (data.links.length > 0 ) {
        linksHTML += `<h2>Links</h2>`
        linksHTML += `<ul>`
        for (let i = 0; i < data.links.length; i++) {
          linksHTML += `<li><a href="${data.links[i][1]}">${data.links[i][0]}</a></li>`;
          if (data.links[i][2] === true) {
            linksHTML += `<div class="gist-content" data-gist-id="${this.getGistId(data.links[i][1])}"></div>`
          }
        }
        linksHTML += `</ul>`
      }

      // check if answer contains files
      let filesHTML = '';

      if (data.files.length > 0 ) {
        filesHTML += `<h2>Attachments</h2>`
        filesHTML += `<ul>`
        for (let i = 0; i < data.files.length; i++) {
          filesHTML += `<li>${data.files[i]}</li>`;
        }
      }

      // check if current user is author of answer's question, to give him opportunity to mark answer like best
      let markAsBest = '';

      if (gon.currentUser) {
        if (data.question['user_id'] === gon.currentUser['id']) {
          markAsBest += `<a href="/answers/${data.answer['id']}/mark_as_best" class="link-button" data-method="patch" data-remote="true">Mark as best</a>`
        }
      }

      return `
        <div id="answer-${data.answer['id']}" class="answer">
            <div class="actions">
                ${markAsBest}
            </div>
            
            <p>${data.answer['body']}</p>
            <div class="voting-container">
                <a href="/answers/${data.answer['id']}/like" class="voting" data-method="post" data-remote="true" data-type="json" data-resource="answer" data-id="${data.answer['id']}">Like</a>
                <div class="rating" id="answer-rating-${data.answer['id']}">${data.rating}</div>
                <a href="/answers/${data.answer['id']}/dislike" class="voting" data-method="post" data-remote="true" data-type="json" data-resource="answer" data-id="${data.answer['id']}">Dislike</a>
            </div>
            
            <div class="links"> 
                ${linksHTML}               
            </div>       
            
            <div> 
                ${filesHTML}
            </div>       
        </div>
      `
    },

    getGistId(link) {
      var linkArray = link.split("/")
      return linkArray[linkArray.length - 1]
    }
  });
});







