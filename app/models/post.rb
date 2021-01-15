class Post < ApplicationRecord
  has_many  :tag_relationships, dependent: :destroy
  has_many  :tags, through: :tag_relationships

  belongs_to :user

  def save_tags(savepost_tags)
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    old_tags = current_tags - savepost_tags
    new_tags = savepost_tags - current_tags

    old_tags.each do |old_name|
      self.tags.delete Tag.find_by(name: old_name)
    end

    new_tags.each do |new_name|
      @tag = Tag.where(name: new_name).first_or_initialize
      unless TagRelationship.where(post_id: id,tag_id: @tag).exists? 
        post_tag = Tag.find_or_create_by(name: new_name)
        self.tags << post_tag
      end
    end
  end
end
