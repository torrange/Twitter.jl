#############################################################
#
# Timelines Functions
#
#############################################################

function get_mentions_timeline(; options=Dict{String, String}())

	r = get_oauth("https://api.twitter.com/1.1/statuses/mentions_timeline.json", options)

    #Return array of type TWEETS
    #return to_TWEETS(r)
    return r.status == 200 ? to_TWEETS(JSON.parse(r.data)) : r

end

function get_user_timeline(; options=Dict{String, String}())
    
    r = get_oauth("https://api.twitter.com/1.1/statuses/user_timeline.json", options)

    #Return array of type TWEETS
    #return to_TWEETS(r)
    return r.status == 200 ? to_TWEETS(JSON.parse(r.data)) : r

end

function get_home_timeline(; options=Dict{String, String}())
    
    r = get_oauth("https://api.twitter.com/1.1/statuses/home_timeline.json", options)

    #Return array of type TWEETS
    #return to_TWEETS(r)
    return r.status == 200 ? to_TWEETS(JSON.parse(r.data)) : r

end

function get_retweets_of_me(; options=Dict{String, String}())

    r = get_oauth("https://api.twitter.com/1.1/statuses/retweets_of_me.json", options)

    #Return array of type TWEETS
    #return to_TWEETS(r)
    return r.status == 200 ? to_TWEETS(JSON.parse(r.data)) : r

end