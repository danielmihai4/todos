module Entities
  class ItemEntity < Grape::Entity
    expose :id
    expose :name
    expose :due_date
    expose :list_id
    expose :is_done
    expose :completed_by
    expose :info do |item, options|
      item.info
    end
  end
end