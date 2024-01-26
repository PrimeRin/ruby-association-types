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
