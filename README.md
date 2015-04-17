# Optional validations for ActiveModel

This gem provides ability to exclude certain fields from validation process

Example:

```ruby
class User < ActiveRecord::Base
    validates_presence_of :email, :name, :address
end
```

```ruby
user = User.new(params)     #suppose params contain only email
user.valid?                 #false

user.validate_only :email
user.valid?                 #true
```

Thus every instance of ```ActiveModel::Validations``` now has the following methods:

1. ```validate_only(*fields)``` — change the set of fields that are validated
2. ```validate_except(*fields)``` — validate all fields except for specified ones
3. ```validate_all()``` — skip to the original mode when all validations are active

