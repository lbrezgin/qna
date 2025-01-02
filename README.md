### Quaestio is a web application that allows users to ask questions and receive answers.
The project was developed from June 2024 to December 2024. The main goals of this project are to enhance expertise in the Rails framework by delving into its more advanced technologies. The project provides users with the following functionality:
* Registration using Gmail or via GitHub/Twitter.
* The ability to create a question and add additional information in the form of links or attachments.
* The ability to post answers to any questions.
* The author of a question can mark one of the answers as the best.
* Users can vote for their favorite questions and answers, thereby increasing their rating.
* Users can comment on both answers and questions.
* The application implements an API that allows using Quaestio as an authenticator for third-party applications, as well as retrieving questions and answers.
* Users can subscribe to questions they like in order to receive email notifications when new answers are posted.
* Users receive a daily digest once a day, which contains information about newly created questions.
### Technologies used in Quaestio:
* **Action Controller**, **Action View**, **Active Record**, **Action Mailer**.
* **Git Flow**.
* TDD/BDD approach, using **RSpec**, **Shoulda-Matchers**, and **Capybara**.
* **AJAJ**, **AJAX**.
* **Active Storage**.
* Nested forms and polymorphic associations.
* Using WebSockets through the **Action Cable** library.
* OAuth protocol: authentication via GitHub and Twitter.
* Authorization in Rails using **gem CanCanCan**.
* REST API: retrieving website resources (questions, answers), as well as using **Doorkeeper**, in order to make the application a provider.
* **Active Job**, **Sidekiq**, **Redis**.
* Full-text search using **gem thinking-sphinx**.
* Usage of view caching using Russian-doll caching.
* Deployment of the application using **Capistrano**, **Phusion Passenger**, **Unicorn**.
 
