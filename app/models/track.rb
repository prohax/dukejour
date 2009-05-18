class Track < ActiveRecord::Base
  include OSAHelpers

  public_resource

  belongs_to :library
  validates_presence_of :persistent_id, :library_id
  validates_uniqueness_of :persistent_id, :scope => :library_id

  def self.import source, library
    find_or_create_with({
      :persistent_id => source.persistent_id,
      :library_id => library.id
    }, {
      :artist => source.artist,
      :album => source.album,
      :name => source.name,
      :year => source.year
    }, true) do |track|
      log "Added #{library.persistent_id}/#{source.persistent_id}: #{source.name} from #{library.name}"
    end
  end

end
