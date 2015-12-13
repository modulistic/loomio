class Events::CommentRepliedTo < Event
  def self.publish!(comment)
    return unless comment.parent.present?
    create!(kind: 'comment_replied_to',
            eventable: comment,
            created_at: comment.created_at).tap { |e| EventBus.broadcast('comment_replied_to_event', e, comment.parent.author) }
  end
  EventBus.listen('new_comment') { |comment| publish!(comment) if comment.is_reply? }

  def group_key
    comment.group.key
  end

  def discussion_key
    eventable.discussion.key
  end

  def comment
    eventable
  end
end
