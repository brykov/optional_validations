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

user.validate_only :email do
    user.valid?             #true
end
```

Thus every instance of ```ActiveModel::Validations``` now has the following methods:

1. ```validate_only(*fields)``` — change the set of fields that are validated
2. ```validate_except(*fields)``` — validate all fields except for specified ones

## Release notes

### 0.1.1
Make ```validate_except``` and ```validate_only``` return the value from passed blocks

### 0.1.0
Please note that this release introduces a major API change.

```validate_all``` method removed

```validate_only``` and ```validate_except``` now expect a block to be passed and will only 
affect the behavior of the block. Object's validations are restored after the block is processed. 
