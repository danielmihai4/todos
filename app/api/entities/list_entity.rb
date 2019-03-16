module Entities
  class ListEntity < Grape::Entity
    expose :id
    expose :name
    expose :created_at
    expose :items, using: Entities::ItemEntity
  end
end