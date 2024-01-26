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
# rails generate model Post
class Student < ApplicationRecord
  has_and_belongs_to_many :course
end
```

```ruby
# rails generate model Comment post:references
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

Both has_and_belongs_to_many (HABTM) and has_many :through are used to model many-to-many relationships in Ruby on Rails, but they differ in the level of control and flexibility they provide over the join table.

