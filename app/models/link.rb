class Link < ActiveRecord::Base
  has_many :comments, inverse_of: :link #referencia circular
  has_many :votes, inverse_of: :link
  validates :title, :url, presence: true

  def self.search(value = "")
    where("title ILIKE ?", "%#{value}%") #Postgress stuff
  end

end
