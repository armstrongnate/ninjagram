# NinjaGram

An Instagram-ish app to demonstrate using Carrierwave to upload files in Rails.

## How It's Made

This readme does not explain how to _use_ this app but rather how to _create_ this app yourself starting from ground zero.


#### New Project

```
$ rails new NinjaGram
```

#### Add Carrierwave to Gemfile

```ruby
# Gemfile
gem 'carrierwave'
```

```
bundle install
```

#### Generate Models

```
rails g model Post attachment:string
rails g uploader Attachment
rake db:migrate
```

#### Update Post class to use attachment attribute as an uploader

```ruby
# app/models/post.rb
class Post < ActiveRecord::Base
  mount_uploader :attachment, AttachmentUploader
end
```

#### Posts routes and controller

```ruby
# config/routes.rb
resources :posts

# app/controllers/posts_controller.rb
class PostsController < ApplicationController
  before_filter :load_posts
  respond_to :html

  def index
  end

  def create
    @post = Post.new(safe_params)
    @post.save
    respond_with @post, location: posts_url, action: :index
  end


  private

  def load_posts
    @posts = Post.all
  end

  def safe_params
    params.require(:post).permit(:attachment)
  end
end
```

```html+erb
<!-- app/views/posts/index.html.erb -->
<% @posts.each do |post| %>
  <div class='post'>
    <%= image_tag post.attachment_url %>
  </div>
<% end %>

<%= form_for Post.new, html: { multipart: true } do |f| %>
  <%= f.file_field :attachment %>
  <%= f.submit 'Submit' %>
<% end %>
```

#### If you're getting errors in the console

Rails was not requiring my uploads directory so I had to tell it to do so manually.

```ruby
# config/application.rb
config.autoload_paths += ["#{Rails.root}/app/uploaders"]
```
