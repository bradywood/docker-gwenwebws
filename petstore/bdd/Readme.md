Areas of the business:  Pets, Stores, Users

Given I am new to the petstore
 When I create a new user
 Then I will be informed of my user identifier

Given I no longer wish to belong to the pet store
When I delete my user
Then I will be unable to find my user on the system

Given I no longer wish to belong to the pet store
When I delete my user
  And I still have a pet
Then the system will not let me delete my user

Given I have an empty pet store
When I attempt to remove a pet that does not exist
Then I will be informed by the system that its not possible

Given I have an empty pet store
When I attempt to find all available pets
Then I will be shown a list containing zero pets

Given I have an empty pet store
When I create a new pet
Then the pet store will not be empty
  And I will be informed of the newly created pet identifier

Given the pet store has available pets
When I want to purchase a pet
Then the purchased pet will no longer be available

Given I no longer require a pet
When I delete a pet from the store
Then I will be unable to find that pet

Given the pet store has no available pets
When I want to purchase a pet
Then I will be informed that no pets are available

Given I want to login to the petstore
When I provide my credentials
Then I am logged on to the system



