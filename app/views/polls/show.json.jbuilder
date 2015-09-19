if @poll
	json.title @poll.title
	json.options_count @poll.options.count
else
end