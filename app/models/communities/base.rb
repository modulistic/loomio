class Communities::Base < ActiveRecord::Base
  extend HasCustomFields
  self.table_name = :communities
  validates :community_type, presence: true

  belongs_to :identity, foreign_key: :identity_id, class_name: "Identities::Base"
  has_many :poll_communities, foreign_key: :community_id
  has_many :polls, through: :poll_communities
  has_many :visitors, foreign_key: :community_id

  delegate :user_id, to: :identity, allow_nil: true
  delegate :user, to: :identity, allow_nil: true

  THIRD_PARTY_TYPES = %w(facebook slack).freeze

  discriminate Communities, on: :community_type

  def poll_ids=(ids)
    Array(ids).each { |id| poll_communities.build(poll_id: id) }
  end

  def self.set_community_type(type)
    after_initialize { self.community_type = type }
  end

  def includes?(member)
    raise NotImplementedError.new
  end

  def members
    raise NotImplementedError.new
  end

  def notify!(event)
    raise NotImplementedError.new
  end

end
