require "inherits_many/version"

class ActiveRecord::Base

  @@transfers_to = {}
  def self.transfers_to(target, params)
    unless @@transfers_to.has_key? self.name
      @@transfers_to[self.name] = []
    end
    @@transfers_to[self.name] << {target: target}.merge(params)
  end

  after_save :process_transfers_to
  def process_transfers_to

    concrete_class = self.class

    while concrete_class.name != 'ActiveRecord::Base' do

      unless @@transfers_to[concrete_class.name].nil?

        @@transfers_to[concrete_class.name].each do |tt|

          child = tt[:target]
          parent = tt[:of]
          parent_id = "#{parent}_id"

          # if the chain has changed ..
          # if chain_id_changed?
          if self.changes.has_key? parent_id

            parent_id_was = self.changes[parent_id][0]
            parent_id_is = self.changes[parent_id][1]

            # if there was previously a chain ..
            if parent_id_was

              # remove all restaurants from the old chain.
              # self.restaurants = self.restaurants - Chain.find(chain_id_was).restaurants
              self.send("#{child}=", self.send(child) - self.class.reflect_on_association(parent).class_name.constantize.find(parent_id_was).send(child))

            end

            # if there is a new chain ..
            if parent_id_is

              # add all the menu items from the new chain to this restaurant.
              self.send("#{child}=", self.send(child) + self.send(parent).send(child))

            end

          end
        end
      end

      concrete_class = concrete_class.superclass

    end

  end


  @@inherits = {}
  def self.inherits(source, params)
    unless @@inherits.has_key? self.name
      @@inherits[self.name] = []
    end
    @@inherits[self.name] << {source: source}.merge(params)
  end

  after_save :process_inherits
  def process_inherits

    concrete_class = self.class

    while concrete_class.name != 'ActiveRecord::Base' do

      unless @@inherits[concrete_class.name].nil?

        @@inherits[concrete_class.name].each do |tt|

          child = tt[:source]
          parent = tt[:from]
          parent_id = "#{parent}_id"

          # if the chain has changed ..
          # if chain_id_changed?
          if self.changes.has_key? parent_id

            parent_id_was = self.changes[parent_id][0]
            parent_id_is = self.changes[parent_id][1]

            # if there was previously a chain ..
            if parent_id_was

              # remove all the menus from the old chain.
              self.send("#{child}=", self.send(child) - self.class.reflect_on_association(parent).class_name.constantize.find(parent_id_was).send(child))

            end

            # if there is a new chain ..
            if parent_id_is

              # add all the menu items from the new chain to this restaurant.
              self.send("#{child}=", self.send(child) + self.send(parent).send(child))

            end


            # if there was previously a chain ..
            if parent_id_was

              # remove all restaurants from the old chain.
              # self.restaurants = self.restaurants - Chain.find(chain_id_was).restaurants
              self.send("#{child}=", self.send(child) - self.class.reflect_on_association(parent).class_name.constantize.find(parent_id_was).send(child))

            end

            # if there is a new chain ..
            if parent_id_is

              # add all the menu items from the new chain to this restaurant.
              self.send("#{child}=", self.send(child) + self.send(parent).send(child))

            end

          end
        end

      end

      concrete_class = concrete_class.superclass

    end

  end

end
