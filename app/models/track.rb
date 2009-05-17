class Track < ActiveRecord::Base

  belongs_to :library

  public_resource

end
