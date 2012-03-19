require "inherits_many/version"

class ActiveRecord::Base

  @@passes_on_to = {}
  def self.passes_on_to(target, params)
    unless @@passes_on_to.has_key? self.name
      @@passes_on_to[self.name] = []
    end
    @@passes_on_to[self.name] << {target: target}.merge(params)
  end

  after_save :process_passes_on_to
  def process_passes_on_to

    concrete_class = self.class

    while concrete_class.name != 'ActiveRecord::Base' do

      unless @@passes_on_to[concrete_class.name].nil?

        @@passes_on_to[concrete_class.name].each do |tt|

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


  @@inherits_many = {}
  def self.inherits_many(source, params)
    unless @@inherits_many.has_key? self.name
      @@inherits_many[self.name] = []
    end
    @@inherits_many[self.name] << {source: source}.merge(params)
  end

  after_save :process_inherits_many
  def process_inherits_many

    concrete_class = self.class

    while concrete_class.name != 'ActiveRecord::Base' do

      unless @@inherits_many[concrete_class.name].nil?

        @@inherits_many[concrete_class.name].each do |tt|

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
