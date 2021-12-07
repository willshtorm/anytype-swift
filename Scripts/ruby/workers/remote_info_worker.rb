require_relative 'valid_worker'

# version=`curl -H "Authorization: token $token" -H "Accept: application/vnd.github.v3+json" -sL https://$GITHUB/repos/$REPO/releases | jq ".[] | select(.tag_name == \"$MIDDLEWARE_VERSION_BY_TAG_NAME\")"`
class GetRemoteInformationWorker < AlwaysValidWorker
  attr_accessor :token, :url
  def initialize(token, url)
    self.token = token
    self.url = url
  end
  def is_valid?
    (self.token || '').empty? == false
  end
  def work
    unless can_run?
      puts <<-__REASON__
      Access token does not exist. 
      Please, provide it by cli argument or environment variable. 
      Run `ruby #{$0} --help`
      __REASON__
      exit(1)
    end
    perform_work
  end
  def perform_work
    # fetch curl -H "Authorization: token Token" -H "Accept: application/vnd.github.v3+json" -sL https://api.github.com/repos/anytypeio/go-anytype-middleware/releases
    uri = URI(url)
    request = Net::HTTP::Get.new(uri)
    request["Authorization"] = "token #{token}"
    request["Accept"] = "application/vnd.github.v3+json"
    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http|
      http.request(request)
    }
    if Integer(response.code) >= 400
      puts "Code: #{response.code} and response: #{JSON.parse(response.body)}"
      exit(1)
    end
    JSON.parse(response.body)
  end
end