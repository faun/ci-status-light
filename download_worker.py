import json
import requests


class DownloadWorker():
    def __init__(self, api_token):
        if not api_token:
            raise Exception("Missing api token")
        self.api_token = api_token

    def make_request(self, url):
        token = "Bearer {token}".format(token=self.api_token)
        auth_header = {"Authorization": token}
        return requests.get(url=url, headers=auth_header,)

    def get_json(self, url):
        json.loads(self.make_request(url).content)

    def fetch_first_eight_build_states(self, url):
        try:
            response = self.get_json(url)
            return [build['state'] for build in response][:8]
        except:
            return ['error' for _ in range(8)]
