# http://aspn.activestate.com/ASPN/Cookbook/Python/Recipe/336012

import SimpleHTTPServer
import BaseHTTPServer
import httplib
import os
import socket


class StoppableHttpRequestHandler(SimpleHTTPServer.SimpleHTTPRequestHandler):
    """http request handler with QUIT stopping the server"""

    def setup(self):
        SimpleHTTPServer.SimpleHTTPRequestHandler.setup(self)
        self.rfile.close()
        self.wfile.close()
        self.rfile = HttpEchoer(self.connection._sock, 'rb', self.rbufsize)
        self.wfile = HttpEchoer(self.connection._sock, 'wb', self.wbufsize)

    def do_QUIT(self):
        """send 200 OK response, and set server.stop to True"""
        self.send_response(200)
        self.end_headers()
        self.server.stop = True

    def do_POST(self):
        # We could also process paremeters here using something like below.
        # length = self.headers['Content-Length']
        # print self.rfile.read(int(length))
        self.do_GET()

    def send_head(self):
        # This is ripped directly from SimpleHTTPRequestHandler,
        # only the cookie part is added.
        """Common code for GET and HEAD commands.

        This sends the response code and MIME headers.

        Return value is either a file object (which has to be copied
        to the outputfile by the caller unless the command was HEAD,
        and must be closed by the caller under all circumstances), or
        None, in which case the caller has nothing further to do.

        """
        path = self.translate_path(self.path)
        f = None
        if os.path.isdir(path):
            if not self.path.endswith('/'):
                # redirect browser - doing basically what apache does
                self.send_response(301)
                self.send_header("Location", self.path + "/")
                self.end_headers()
                return None
            for index in "index.html", "index.htm":
                index = os.path.join(path, index)
                if os.path.exists(index):
                    path = index
                    break
            else:
                return self.list_directory(path)
        ctype = self.guess_type(path)
        if ctype.startswith('text/'):
            mode = 'r'
        else:
            mode = 'rb'
        try:
            f = open(path, mode)
        except IOError:
            self.send_error(404, "File not found")
            return None
        self.send_response(200)
        self.send_header("Content-type", ctype)
        fs = os.fstat(f.fileno())
        # chrome hangs if this server runs on windows
        # it probably waits for more data -> os.fstat() does not return correct
        # length? We are responding with HTTP 1.0 = we do not need
        # content-length header:
        # self.send_header("Content-Length", str(fs[6]))
        self.send_header("Last-Modified", self.date_time_string(fs.st_mtime))
        self.end_headers()
        return f


class StoppableHttpServer(BaseHTTPServer.HTTPServer):
    """http server that reacts to self.stop flag"""

    def serve_forever(self):
        """Handle one request at a time until stopped."""
        self.stop = False
        while not self.stop:
            self.handle_request()


class HttpEchoer(socket._fileobject):
    # echoes all HTTP traffic to a file if
    # the server output is set to a file in run_tests.py
    def read(self, size=-1):
        data = super(HttpEchoer, self).read(size)
        sys.stdout.write("-->: %s" % data)
        sys.stdout.flush()
        return data

    def readline(self, size=-1):
        data = super(HttpEchoer, self).readline(size)
        sys.stdout.write("-->: %s" % data)
        sys.stdout.flush()
        return data

    def readlines(self, sizehint=0):
        data = super(HttpEchoer, self).readlines(sizehint)
        sys.stdout.write("-->: %s" % data)
        sys.stdout.flush()
        return data

    def write(self, data):
        sys.stdout.write("<--: %s" % data)
        sys.stdout.flush()
        super(HttpEchoer, self).write(data)


def stop_server(port=7000):
    """send QUIT request to http server running on localhost:<port>"""
    conn = httplib.HTTPConnection("localhost:%d" % port)
    conn.request("QUIT", "/")
    conn.getresponse()


def start_server(port=7000):
    import os
    os.chdir(os.path.join(os.path.dirname(os.path.abspath(sys.argv[0])), '..'))
    server = StoppableHttpServer(('', port), StoppableHttpRequestHandler)
    server.serve_forever()

if __name__ == '__main__':
    import sys
    if len(sys.argv) != 2 or sys.argv[1] not in ['start', 'stop']:
        print('usage: %s start|stop' % sys.argv[0])
        sys.exit(1)
    if sys.argv[1] == 'start':
        start_server()
    else:
        stop_server()
