if @poll
	json.extract! @poll, :id, :created_at
	json.options @poll.options do |option|
		json.extract! option, :id, :name
	end
else
end