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

## Many to Many Association

### 1. Using has_and_belong_to_many
In Ruby on Rails, the has_and_belongs_to_many association is used to model a many-to-many relationship between two models. This association is appropriate when each record in one model can be associated with multiple records in another model, and vice versa. In your example, let's consider a Student model and a Course model.

```ruby
# rails generate model Student
class Student < ApplicationRecord
  has_and_belongs_to_many :course
end
```

```ruby
# rails generate model Comment student:references
class Course < ApplicationRecord
  has_and_belongs_to_many :students
end
```

#### Rails Console
```ruby
# creating students and courses
student1 = Student.create()
course1 = Course.create()
student1.courses << course1 #course1 aded to student1 courses

course2 = student1.courses.create() #course 2 created and added to student1

# access
student1 = Student.first
courses = student1.courses

course1 = Course.first
students = course1.students
```
### 2. Using has_many: through
The has_many :through association is used to establish a many-to-many relationship between two models with the help of a third model, often referred to as a "join" or "through" model.
let's create a has_many :through association between Author, Book, and Authorship. In this example, Authorship will serve as the join model connecting Author and Book.

```ruby
# rails generate model Author
class Author < ApplicationRecord
  has_many :authorships
  has_many :books, through: :authorships
end
```

```ruby
# rails generate model Book
class Book < ApplicationRecord
  has_many :authorships
  has_many :authors, through: :authorships
end
```

```ruby
# rails generate model Authorship author:references book:references
class Authorship < ApplicationRecord
  belongs_to :author
  belongs_to :book
end
```

#### Rails Console
```ruby
# creating authors and books
author1 = Author.create()
book1 = Book.create()
authorship1 = Authorship.create(author: author1, book: book1)

book2 = author1.books.create() # creates book2 and associates with author1
author2 = book1.authors.create() # creates author2 and associates with book1

# access
book1 = Book.first
authors = book1.authors

author1 = Author.first
books = author1.books
```
Both has_and_belongs_to_many (HABTM) and has_many :through are used to model many-to-many relationships in Ruby on Rails, but they differ in the level of control and flexibility they provide over the join table.

## Many to Many Association
### Polymorphic Association
Polymorphic association enables flexible and dynamic relationship between models that allows an instance of one model to be associated with multiple other models through a single association.
In a polymorphic association, a model can belong to more than one other type of model, sharing the same association name. This versatile setup is particularly useful when multiple models in an application need to be associated with a common model, promoting code reusability and adaptability

I will try to explain polymorphic association using a 'Comment' model which can be associated with 'Post' model and 'Event' model where a comment can belong to both Post and Event model.

#### 1. Without using Polymorphic association
Lets try to create association between Comment, Post and Event without using polymorphic association so that we can fully understand the need of polymorphic association.

```ruby
# rails generate model Event title:string
# rails generate model Post title:string
# rails generate model CommentForPost post:references
# rails generate model CommentForEvent event:references

# app/models/comment_for_post.rb
class CommentForPost < ApplicationRecord
  belongs_to :post
end

# app/models/comment_for_event.rb
class CommentForEvent < ApplicationRecord
  belongs_to :event
end

# app/models/post.rb
class Post < ApplicationRecord
  has_many :comments, class_name: 'CommentForPost', dependent: :destroy
end

# app/models/event.rb
class Event < ApplicationRecord
  has_many :comments, class_name: 'CommentForEvent', dependent: :destroy
end
```

#### Rails Console
```ruby
# Create posts, news, events, and comments
post = Post.create()
event = Event.create()

# Create comments associated with a post, or event
post_comment = CommentForPost.create(post: post)
event_comment = CommentForEvent.create(event: event)

# access
post_comments = post.comments
event_comments = event.comments
```
Here we can see that we need to create separate model for post comments and event comments which is not covenant.

We can also create a common comment model that is shared between the post and event. But we need to change alter the
migrate file and convert the foreign keys in the comment to integer and should disable null constraint. So that we allow the one of the foreign key to
be nil. 
```ruby
# rails generate model Event 
# rails generate model Post 
# rails generate model Comment post:references event:references

# app/models/post.rb
class Post < ApplicationRecord
  has_many :comments
end

# app/models/event.rb
class Event < ApplicationRecord
  has_many :comments
end

# app/models/comment.rb
class Comment < ApplicationRecord
  belongs_to :post, optional: true # allow nil
  belongs_to :event, optional: true # allow nil
end

# db/migrate/20240202102018_create_comments.rb 
class CreateComments < ActiveRecord::Migration[7.0] 
  def change
    create_table :comments do |t|
      t.integer :post_id # remove foreign key and null constraint 
      t.integer :event_id # remove foreign key and null constraint 

      t.timestamps
    end
  end
end
```

#### Rails Console
```ruby
# Create posts, events, and comments
post = Post.create()
event = Event.create()

# Create comments associated with a post, or event
comment1 = post.comments.create()
comment2 = event.comments.create()

# access
post_comments = post.comments
event_comments = event.comments
```

However the issue with the above database is that when creating the comment for post the foreign key of the event will be nil and vice versa. Hence the above one is not preferable.




#### 2. Polymorphic association

