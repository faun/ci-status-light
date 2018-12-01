import unittest
from download_worker import DownloadWorker
import requests_mock


class DownloadWorkerTest(unittest.TestCase):
    @requests_mock.mock()
    def test_fetch_first_eight_build_states(self, m):
        dw = DownloadWorker('api_token')
        m.get('http://aurl.com', text='<html><body></body></html>')
        expected = ['error' for _ in range(8)]
        actual = dw.fetch_first_eight_build_states('http://aurl.com')
        self.assertEqual(actual, expected)

        m.get('http://burl.com', text='{"json": { "valid": true} }')
        expected = ['error' for _ in range(8)]
        actual = dw.fetch_first_eight_build_states('http://burl.com')
        self.assertEqual(actual, expected)

        m.get('http://curl.com', text='not html')
        actual = dw.fetch_first_eight_build_states('http://curl.com')
        expected = ['error' for _ in range(8)]
        self.assertEqual(actual, expected)

    @requests_mock.mock()
    def test_fetch_first_eight_build_states_with_invalid_json(self, m):
        url = 'http://jsonplaceholder.typicode.com/todos'
        api_token = 'foo'
        worker = DownloadWorker(api_token)
        actual = worker.fetch_first_eight_build_states(url)
        expected = ['error' for _ in range(8)]
        self.assertEqual(actual, expected)

    @requests_mock.mock()
    def test_fetch_first_eight_build_states_with_invalid_url(self, m):
        url = 'http://google.com'
        api_token = 'foo'
        worker = DownloadWorker(api_token)
        actual = worker.fetch_first_eight_build_states(url)
        expected = ['error' for _ in range(8)]
        self.assertEqual(actual, expected)

    def test_fetch_first_eight_build_states_with_valid_json(self):
        url = 'http://buildkite'
        api_token = 'foo'
        worker = DownloadWorker(api_token)
        actual = worker.fetch_first_eight_build_states(url)
        expected = ['error' for _ in range(8)]
        self.assertEqual(actual, expected)

if __name__ == "__main__":
    unittest.main()
