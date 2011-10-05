# #### _Week 04: We return with more Sinatra. Introducing templates, stylesheets and javascripts._
# #### _Part of [ITP Web Dev Workshop](http://itpwebdev.github.com)_

# Last time we introduce you to [Sinatra](http://www.sinatrarb.com),
# if you don't remember, head on over to
# [Lesson 3](http://itpwebdev.github.com/03-Intro-To-Ruby---HTTP/)

# We're on our way to a [Model View Controller](http://en.wikipedia.org/wiki/Model–view–controller)
# architecture. Last week we covered the _Controller_ last time but
# we didn't really mention it. A _Controller_ for our purposes is a
# url, and we write this with Sinatra with
#
#     get '/' do
#       # CONTROLLER CODE
#     end
#
# This week we're getting in to the other two parts, Views and Models.
# Views are what is shown. Controllers call on Views. A webpage is a
# view and the url is a representation of the controller. We'll get in
# to this more further down.

# First we need to set up the app, just like last time we tell Ruby to 
# look at our gems and then get the Sinatra gem.
require 'rubygems'
require 'sinatra'

# And our root controller `'/'`. This controller takes the user input
# and deciphers it to respond with a view.
get '/' do

  # Let's show the user the current time, for this we'll use an instance
  # variable. Instance variables are super variables. They are local to
  # Sinatra, not to a specific file so we can use them between the controller
  # and the view.
  @time = Time.now
  # Also, let's give our site a Title
  @title = "ITP Web Dev Blog"
  
  # Here we call our template with the method `erb`. Erb is a templating
  # system for Ruby. Templates allow us to have only a few pages and fill
  # them in with dynamic data.
  
  # So `erb` is the method and as an argument I'm passing in `:main` which
  # is understood to be a file named `main.erb`. (More on this later.)
  erb :main
end

# Now if we start up the application (in Terminal `cd` to the appropriate
# directory) with
#
#     $ ruby app.rb
#
# And point our browser to `http://localhost:4567/`.

# What the blazes! It looks like a webpage. What's going on?
# If you look at the `views/` folder you'll see 2 files (you might see more
# but focus on these 2): `layout.erb` and `main.erb`.

# Open up `layout.erb`, if you don't want to do that, here it is:
#
#     <!DOCTYPE html>
#     <html>
#        <head>
#          <title><%= @title %></title>
#          <link rel="stylesheet" href="style.css"/>
#        </head>
#        <body>
#          <div id="wrapper">
#            <h1><%= @title %></h1>
#            <%= yield %>
#          </div>
#        </body>
#      </html>
#
# It looks mostly like HTML except for the `<%= %>` bits right?
# Good, because it is just like HTML except for those bits. Inside of 
# these tags goes Ruby code. There are two varieties:
#
# **Inline Code** Ruby inside of these tags is processed but does not
# render to the page
#
#     <% %>
#
# **Rendered Code** The results of the Ruby code inside these tags is
# rendered to the document
#
#     <%= %>
#
# So with this knowledge we see that `<%= @title %>` is going to print
# out the value of the `@title` variable in the document.

# There's one other bit, `<%= yield %>`. This is a method that tells Erb
# to put the contents of whatever erb file we asked for in place of `yield`.
# So right now that means the contents of `main.erb` is getting put in place
# of `yield` since we asked for `erb :main`.

# Something I didn't explain, this file `layout.erb` is pulled up by Erb
# every time we call `erb`. So if you open up `main.erb` you'll notice there
# are none of the HTML `head` elements, just the content. Awesome.

# Look at `main.erb`, it's three lines long, one of them a long line. What I'm
# doing there is taking the `@time` variable and calling a few methods on
# it. Refer to the [Ruby-doc for Time](http://www.ruby-doc.org/core/Time.html) for
# the methods I called, and play around with your own to reformat the date.

# Alright, back to our application. It just shows the time, let's make it in 
# to a simple blog because everyone loves blogging.

# We'll make a controller called **article** for our blog article
get '/article' do
  # Using Ruby's Hash class to encapsulate the Title and Content in
  # one instance variable.
  @article = {"title" => "My first blog post", "content" => "Hello nerds, I'm starting a blog."}
  # Render the newly created `article.erb` page.
  erb :article
end

# How would I make a second article?
# Re-do everything from `/article`, this time at `/article/two`
get '/article/two' do
  @article = {"title" => "Really getting going with this whole blogging thing.",
    "content" => "Look at me right now, totally blogging up a storm. Don't you dare try to stop me."}

  erb :article
end

# This is going to get ugly, but the way to fix this is with databases and
# we aren't there yet. First we need an interface to add new articles.
# The start of the interface is a controller to get there
get '/article/new' do
  # Then we need a view with a form
  erb :new_article
end

# Let's look at the file `new_article.erb` in depth.
#
#       <article>
#       <h1>Write a new Article</h1>
#       
#       <form action="/article/create" method="post">
#         <div>
#           <label for="title">Title:</label>
#           <input name="title" type="text"/>
#         </div>
#         <div>
#           <label for="content">Content:</label>
#           <textarea name="content"></textarea>
#         </div>
#         <input type="submit"/>
#       </form>
#      
#       <p><a href="/">Home</a></p>
#       </article>


# Actually, we can skip right
# to the `form` tag. It's got two attributes:
#
#   * **action** is the url which will be requested when the form is submitted
#   * **method** here we choose the verb we want to make the request with.
#     It can be `get`, `post`, `put` or `delete`. We are using `post` because
#     we are creating something.
#
# Then we have `label` tags which when combined with the `for=` attribute are
# rather self explanatory. `input` and `textarea` are two different form fields
# with their own syntaxes, `textarea` requires a close tag but `input` does not.
# They both need a `name=` attribute, the value of this attribute will tell
# the server what the name of the inputs is.

# When you hit submit, you'll get sent to `/article/create` and it will be a _POST_
# request. Let's make that controller.
post '/article/create' do
  # The parameters sent with this HTTP request are saved by Sinatra in the `params` hash.
  # A handy trick to see what are in your params is to raise an error to see the params dump.
  #
  # raise params.inspect
  #
  @article = params
  # Ahh, the beauty of templates, reusing the same erb file.
  erb :article
end

# You'll notice that this data does not persist. If you try to go back to `/article/create`
# nothing is there. It probably will give you an error. Since this was
# a _POST_ request and not a _GET_. We need databases!

# Stay tuned.