#############################################################
#
# General Functions
#
#############################################################

#Extend encodeURI to work on Dicts
function encodeURI(dict_of_parameters::Dict)
    for (k, v) in dict_of_parameters
        if typeof(v) <: String
            dict_of_parameters["$k"] = encodeURI(v)
        else
            dict_of_parameters["$k"] = v
        end
    end
    return dict_of_parameters
end

#Function that builds global variable to hold authentication keys
#TODO: Figure out how to do OAuth authentication directly, rather than user putting in credentials directly
function twitterauth(consumer_key::String, consumer_secret::String, oauth_token::String, oauth_secret::String)
    #Create a global variable to hold return from this function
    global twittercred
            
    return twittercred = TWCRED(consumer_key, consumer_secret, oauth_token, oauth_secret)
    
end

#Use this function to build the header for every OAuth call
#This function assumes that options Dict has already been run through encodeURI
function oauthheader(httpmethod::String, baseurl::String, options::Dict)                
    
    #Format non-parameter strings
    #baseurl = encodeURI(baseurl)
    httpmethod = uppercase(httpmethod)
    oauth_consumer_secret = twittercred.consumer_secret
    oauth_token_secret = twittercred.oauth_secret
    
    #keys for parameter string
    options["oauth_consumer_key"] = twittercred.consumer_key
    options["oauth_nonce"] = randstring(32) #32 random alphanumeric characters
    options["oauth_signature_method"] = "HMAC-SHA1"
    options["oauth_timestamp"] = @sprintf("%.0f", time()) #timestamp in seconds
    options["oauth_token"] = twittercred.oauth_token
    options["oauth_version"] = "1.0"
    
    #options encoded
    originalkeys = collect(keys(options))

    for key in originalkeys
        options[encodeURI("$key")] = encodeURI(options["$key"])
            if encodeURI("$key") != key
                delete!(options, "$key")
            end
    end

    #Sort percent-encoded keys
    keyssorted = sort!(collect(keys(options)))

    #Build query string, remove trailing &
    parameterstring = ""
    for key in keyssorted
        parameterstring *= "$key=$(options["$key"])&"
    end

    parameterstring = chop(parameterstring)
    
    #signature_base_string
    signature_base_string = "$(httpmethod)&$(encodeURI(baseurl))&$(encodeURI(parameterstring))"
    
    #Signing key
    signing_key = "$(oauth_consumer_secret)&$(oauth_token_secret)"
    
    #Calculate OAuth signature
    h = HMACState(SHA1, signing_key)
	update!(h, signature_base_string)
	oauth_sig = encodeURI(base64(digest!(h)))
    
    return "OAuth oauth_consumer_key=\"$(options["oauth_consumer_key"])\", oauth_nonce=\"$(options["oauth_nonce"])\", oauth_signature=\"$(oauth_sig)\", oauth_signature_method=\"$(options["oauth_signature_method"])\", oauth_timestamp=\"$(options["oauth_timestamp"])\", oauth_token=\"$(options["oauth_token"])\", oauth_version=\"$(options["oauth_version"])\""
    
end

#General function for OAuth authenticated GET request
function get_oauth(endpoint::String, options::Dict)

    #URI encode values for all keys in Dict
    #encodeURI(options)

    #Build query string
    query_str = Requests.format_query_str(options)
    
    #Build oauth_header
    oauth_header_val = oauthheader("GET", endpoint, options)
    
    return Requests.get(URI("$(endpoint)?$query_str"); 
                    headers = {"Content-Type" => "application/x-www-form-urlencoded",
                    "Authorization" => oauth_header_val,
                    "Accept" => "*/*"})

end

#General function for OAuth authenticated POST request
function post_oauth(endpoint::String, options::Dict)
    
    #URI encode values for all keys in Dict
    #encodeURI(options)

    #Build query string
    query_str = Requests.format_query_str(options)
    
    #Build oauth_header
    oauth_header_val = oauthheader("POST", endpoint, options)
    
    return Requests.post(URI(endpoint), 
                    query_str; 
                    headers =  
                    {"Content-Type" => "application/x-www-form-urlencoded",
                    "Authorization" => oauth_header_val,
                    "Accept" => "*/*"})
    
end