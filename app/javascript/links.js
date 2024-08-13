$(document).on('turbolinks:load', function(){
    function checkGists() {
        var elements = document.getElementsByClassName("gist-content");

        for (var i = 0; i < elements.length; i++) {
            var gistId = elements[i].getAttribute('data-gist-id');

            (function(element) {
                fetch(`https://api.github.com/gists/${gistId}`)
                    .then(response => response.json())
                    .then(data => {
                        element.innerHTML = `<pre>${data.files[Object.keys(data.files)[0]].content}</pre>`;
                    })
                    .catch(error => {
                        console.error('Error fetching gist:', error);
                    });
            })(elements[i]);
        }
    }
    window.checkGists = checkGists;
    checkGists();
});
