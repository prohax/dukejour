class VoteEvent < Event
  before_validation_on_create :reject_duplicates

  def reject_duplicates
    if (other_event = entry.events.find_by_creator_id(creator_id)).nil?
      # ok
    elsif other_event.is_a? AddEvent
      errors.add "You can't vote for songs that you added."
    else
      errors.add "You can't vote for the same track twice."
    end
  end
end
