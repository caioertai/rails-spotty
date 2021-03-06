class Spot < ApplicationRecord

  # Associations
  has_many :stories, dependent: :destroy
  belongs_to :category
  has_many :photos, as: :photoable
  has_many :favourites
  has_many :questions, through: :category
  # Validations
  validates :name, presence: true
  validates :location, presence: true
  validates :category, presence: true
  geocoded_by :location
  after_validation :geocode, if: :will_save_change_to_location?

  include PgSearch::Model
  pg_search_scope :search_by_name_location_and_category,
  against: [ :name, :location ],
  associated_against: {
      category: [ :name ]
    },
  using: {
      tsearch: { prefix: true } # <-- now `superman batm` will return something!
    }

  # include PgSearch::Model



  def favourited(user)
    Favourite.where("spot_id = #{id} and user_id = #{user.id}")
  end
end
