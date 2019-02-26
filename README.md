# README

* Ruby version
    - `ruby '2.5.0'`

* Configuration
    - `bundle install`

* Postgres Database setup
    - add your `username` and `password` to `database.yml`
    - create a Postgres database called `pizzeria_development`
    - `rails db:seed` to populate a table of pizzas (all pizzas cost $15!)

* How to run the test suite
    - `rspec spec`
    - for continuously run tests: `bundle exec guard` (then make some changes in watched files!)
    
* Start the server
    - `rails s`
    - point browser to `localhost:3000`
    
* Endpoints and Requests
    - `GET /api/pizzas`
        - returns an array of all available pizzas
    - `GET /api/orders`
        - returns an array of all orders with details about item orders
    - `GET /api/orders/:id`
        - returns the details of a single order
    - `POST /api/orders`
        - creates a new order
        - example JSON body:
        ```
            # if using seed data, integers 1-7 are valid values for pizza_id            
            {
              "order" : {
                  "order_items" : [
                      { "pizza_id" : 1, "quantity" : 1 }, # quantity must be integer > 0
                      { "pizza_id" : 2, "quantity" : 1 } 
                  ]
              }
            }
        ```