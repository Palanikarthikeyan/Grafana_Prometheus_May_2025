import http.server
from prometheus_client import start_http_server
from prometheus_client import Counter
from prometheus_client import Gauge

REQ = Counter('hello_world_total','hello world requested')
obj1 = Counter('my_sample_counter','sample counter world')

obj2 = Gauge('hello_world_progress','test data from gauge')

class mybox(http.server.BaseHTTPRequestHandler):
	def f1(self):
		REQ.inc()
		r=random.random()
		obj1.inc(r)
		self.send_response(200)
		self.end_headers()
		self.wfile.write(f'Hello world counter for {r} values')
		obj2.dec()

if __name__ == '__main__':
	start_http_server(8000)
	server=http.server.HTTPServer(('localhost',8001),mybox)
	server.serve_forever()