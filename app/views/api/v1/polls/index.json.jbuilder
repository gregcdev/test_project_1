json.array!(@polls) do |poll|
  json.extract! poll, :id, :title, :created_at
  json.options poll.options do |option|
  	json.extract! option, :id, :name
  	json.votes option.votes.count
    json.user @user
	end
end
