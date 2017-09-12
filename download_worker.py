import json
import requests

class DownloadWorker():
    def __init__(self, api_token):
        if not api_token:
            raise Exception("Missing api token")
        self.api_token = api_token

    def make_request(self, url):
        token = "Bearer {token}".format(token=self.api_token)
        auth_header = { "Authorization": token }
        return requests.get(url=url, headers=auth_header,)

    def fetch_first_eight_build_states(self, url):
        response = json.loads(self.make_request(url).content)
        return [build['state'] for build in response][:8]
