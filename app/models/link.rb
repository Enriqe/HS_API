class Link < ActiveRecord::Base

  validates :title, :url, presence: true

  def self.search(value = "")
    where("title ILIKE ?", "%#{value}%") #Postgress stuff
  end

end
