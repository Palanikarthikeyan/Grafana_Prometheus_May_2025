'''
# windows
python -m pip install prometheus_client

# Linux/mac
pip3 install prometheus_client
'''

import http.server
from prometheus_client import start_http_server


class mybox(http.server.BaseHTTPRequestHandler):
	def f1(self):
		self.send_response(200)
		self.end_headers()
		self.wfile.write(b'test code python')

if __name__ == '__main__':
	start_http_server(8000)
	server=http.server.HTTPServer(('localhost',8001),mybox)
	server.serve_forever()