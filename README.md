# Rails Lite!

## Description

Rails Lite mimics the basic functionality found in Ruby on Rails! This is done
by using the WEBrick gem as a method to mount a server. Specifically,
the basic functionalities created in this project are ApplicationController::Base,
the Router, as well as the fundamental params and session behaviors.  


#### Router Method
Router#draw takes a block. For example:

```ruby
router = Router.new
router.draw do
  get Regexp.new("^/users/?$"), UsersController, :index
  get Regexp.new("^/users/(?<user_id>\\d+)/posts/?$"), PostsController, :index
end
```
Allows the block to contain a series of method calls to create the four HTTP
methods.

#### Param Method
Params#parse_www_encoded_form(www_encoded_form)

Takes in a query string from the address bars and parses the string to create
a deeply nested hash. Utilizes the URI method to first split the query into
arrays before converting it to a hash.

Example:

Query String:
  user`[address][street]=main&user[address][zip]=89436`
URI Decoder:
  `[["user[address][street]", "main"], ["user[address][zip]", "89436"]]`
Returns:
  { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
