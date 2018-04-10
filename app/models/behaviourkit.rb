# this class is responsible for communication with the iminds behaviour kit.
# post to http://api.bevaviourkit.tocker.iminds.be
require "uri"
require "net/http"
require "json"

class Behaviourkit

    #static variables from application.yml
    @@url = ENV['BK_URL']    
    @@token = ENV['BK_TOKEN']

    def self.track(trackable, actor, action)

        #step 1. create header
        headers = { 'Authorization' => "Bearer: #{@@token}",
                     'Content-Type' => 'application/json',
                     'Accept' => 'application/json'}

        #step 2. create body
        params = {}
        params[:data] = trackable.to_json 
        params[:userID] = actor.email 
        params[:type] = "labs.#{trackable.class.name.downcase}/#{action}"
       
        #step 3. execute post
        uri = URI("http://#{@@url}/logs")
        http = Net::HTTP.new(uri.host)
        
        # perform this in the background, so we don't have to let the end user wait.
        # handle the case that the behaviourkit server is down (external resource)
        # TODO: background job
        begin
            #puts "posting to #{uri}, params:#{params.to_json}"
            response = http.post(uri.path, params.to_json, headers)
            #puts "bhkit response:#{response.code}: #{response.body}" #so we can see what comes back..
        rescue Errno::ECONNREFUSED
            #just log a statement about this for now.
            puts "Failed to track activity to behaviourkit: #{@@url}"
        end
    end
end
