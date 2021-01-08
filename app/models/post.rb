class Post < ApplicationRecord
  has_many  :tag_relationships, dependent: :destroy
  has_many  :tags, through: :tag_relationships

  
end
