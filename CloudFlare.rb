require "typhoeus"

class CloudFlare
    def self.scrape(url)
        response = Typhoeus::Request.get(url, cookiefile: ".typhoeus_cookies", cookiejar: ".typhoeus_cookies")
        body = response.response_body
        challenge = body.match(/name="jschl_vc"\s*value="([a-zA-Z0-9]+)"\/\>/).captures[0]
        math = body.match(/a\.value\s*=\s*(\d.+?);/).captures[0]
        domain = url.split("/")[2]
        answer = eval(math) + domain.length
        answer_url = domain + "/cdn-cgi/l/chk_jschl?jschl_vc=#{challenge}&jschl_answer=#{answer}"
        html = Typhoeus.get(answer_url,  followlocation: true)
        return html.response_body
    end
end
