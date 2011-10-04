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
  # Instead of just putting the time on the page, let's use the attributes
  # of the time (minutes, hours, date) to create a colored div.
  # Also, let's give our site a Title
  @title = "ITP Web Dev Presents Colored Boxes"
  
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

# 