module Dev::FakeDataHelper
  def saved(obj)
    obj.tap(&:save!)
  end

  # only return new'd objects

  def fake_user(args = {})
    User.new({
      name: Faker::Name.name,
      email: Faker::Internet.email,
      password: Faker::Internet.password,
      detected_locale: 'en'
    }.merge(args))
  end

  def fake_group(args = {})
    Group.new({name: Faker::Company.name,
      features: {use_polls: true}}.merge(args))
  end

  def fake_discussion(args = {})
    Discussion.new({title: Faker::Friends.quote.first(150),
                    private: true,
                    group: fake_group,
                    author: fake_user}.merge(args))
  end

  def fake_poll(args = {})
    option_names = {
      poll: 3.times.map{ Faker::Food.ingredient },
      proposal: %w[agree abstain disagree block],
      yes_no: %w[accept decline]
    }.with_indifferent_access

    options = {
      author: fake_user,
      discussion: fake_discussion,
      poll_type: 'poll',
      title: Faker::Superhero.name,
      poll_option_names: option_names[args.fetch(:poll_type, :poll)],
      closing_at: 3.days.from_now,
      multiple_choice: false,
      details: Faker::Hipster.paragraph
    }.merge args

    Poll.new(options)
  end

  def fake_stance(args = {})
    poll = args[:poll] || saved(fake_poll)
    Stance.new({
      poll: poll,
      participant: fake_user,
      reason: Faker::Hacker.say_something_smart,
      stance_choices_attributes: [{poll_option_id: poll.poll_options.first.id}]
    }.merge(args))
  end

  def fake_comment(args = {})
    Comment.new({
      discussion: fake_discussion,
      body: Faker::ChuckNorris.fact,
      author: fake_user
    }.merge(args))
  end

  def fake_outcome(args = {})
    poll = fake_poll
    Outcome.new({poll: poll,
                author: poll.author,
                statement: Faker::Hipster.sentence}.merge(args))
  end

end