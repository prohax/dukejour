class Track < ActiveRecord::Base

  public_resource_for :read, :index

  belongs_to :library
  validates_presence_of :persistent_id, :library_id
  validates_uniqueness_of :persistent_id, :scope => :library_id

  def self.import source, library
    returning find_or_create_with({
      :persistent_id => source.persistent_id,
      :library_id => library.id
    }, {
      :artist => source.artist,
      :album => source.album,
      :name => source.name,
      :year => source.year
    }, true) do |track|
      if track.new_or_deleted_before_save?
        puts "Added #{library.name}/#{source.persistent_id}: #{source.name}"
      end
    end
  end

  def self.persistent_ids_for library
    ActiveRecord::Base.connection.execute(
      "SELECT persistent_id FROM tracks WHERE library_id = #{library.id}"
    ).map {|i|
      i['persistent_id']
    }
  end

  def source
    library.source.search(name).detect {|t|
      t.persistent_id == persistent_id
    }
  end

  def play!
    iTunes.play source
  end

end
