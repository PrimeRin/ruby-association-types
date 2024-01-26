# Association in Ruby on Rails

## One to One Association

In the context of these models, the one-to-one association means that each user can have, at most, one profile, and each profile belongs to exactly one user. This relationship is expressed through the has_one association in the User model and the corresponding belongs_to association in the Profile model.

```ruby
class User < ApplicationRecord
  has_one :profile
end
```

```ruby
class Profile < ApplicationRecord
  has_one :user
end
```

#### Rails Console
```ruby
# creating user with profile
user1 = User.create()
profile1 = Profile.create(user_id: user1.id)

user2 = User.create()
profile2 = user2.create_profile()

profile3 = Profile.create()
user3 = profile3.create_user()

# access
user1 = User.find(1)
profile1 = user1.profile

profile2 = Profile.find(2)
user2 = profile2.user
```

## One to Many Association

In a one-to-many association between Post and Comment models, it means that one instance of the Post model can be associated with multiple instances of the Comment model, but each instance of the Comment model is associated with only one instance of the Post model. This is a common relationship where a post can have multiple comments, but each comment is linked to a specific post.

```ruby
# rails generate model Post
class Post < ApplicationRecord
  has_many :comments  
end
```

```ruby
# rails generate model Comment post:references
class Comment < ApplicationRecord
  has_one :post
end
```

#### Rails Console
```ruby
# creating post with comments
post1 = Post.create()
comment1 = Comment.create(post_id: post1.id)

comment2 = post1.comments.create()
comment3 = post1.comments.create()

# Access
post1 = Post.first
comments = post1.comments

comment1 = Comment.first
post1 = comment1.post
```
