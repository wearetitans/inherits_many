inherits_many
=============

An individual restaurant can have many menu items, but a restaurant that belongs to a chain inherits all it's menu items from the chain it belongs to.

 * When a restaurant joins a chain, it gets a copy of all the menu items from that chain.
 * When a restaurant leaves a chain, all those menu items go away.
 * When a menu item is added to a chain, it is added to all the restaurants in that chain.
 * When a menu item is removed from a chain, it is removed from all restaurants in that chain.

The ActiveRecord associations and `inherits_many` definition look like this:
 
    class Chain < ActiveRecord::Base
      has_many :restaurants
      has_many :menu_items
    end

    class MenuItem < ActiveRecord::Base
      has_many :restaurant_menu_items
      has_many :restaurants, through: :restaurant_menu_items
      belongs_to :chain

      passes_on_to :restaurants, of: :chain
    end

    class Restaurant < ActiveRecord::Base
      has_many :restaurant_menu_items
      has_many :menu_items, through: :restaurant_menu_items
      belongs_to :chain

      inherits_many :menu_items, from: :chain
    end
