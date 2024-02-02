# Association in Ruby on Rails

## Using Polymorphic Association

If a Comment can belong to all Post, and Event models, a polymorphic association is a suitable and flexible solution. Here's how you can set it up:
```ruby
# app/models/post.rb
class Post < ApplicationRecord
  has_many :comments, as: :commentable
end

# app/models/event.rb
class Event < ApplicationRecord
  has_many :comments, as: :commentable
end

# app/models/comment.rb
class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
end

```

#### Rails Console
```ruby
# create post and event
post = Post.create()
event = Event.create()

# create comment
comment1 = post.comments.create()
comment2 = event.comments.create()

# Access
post_comments = post.comments
event_comments = events.comments
```

Now, with the polymorphic association, a Comment can be associated with any model that accepts comments through the commentable association. This provides a more flexible and scalable solution compared to creating separate join models for each association.
