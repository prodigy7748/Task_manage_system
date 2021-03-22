ruby 2.7.2

rails 6.1.3

## Deploy the app to Heroku
1. login with Heroku account
2. Download & install Heroku CLI（MacOS user can use Homebrew command: brew install heroku/brew/heroku)
3. `$ heroku login`
4. Run `$ heroku create`
5. Run `$ git push heroku master` or run `$ git push heroku (your branch name):master` to push another branch
6. Run `$ heroku run rails db:migrate` if this is your first time pushing code
