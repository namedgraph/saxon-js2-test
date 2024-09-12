import os
from http.server import BaseHTTPRequestHandler, HTTPServer
import pathlib
import mimetypes

# Define a mapping of file extensions to Content-Type
CONTENT_TYPE_MAPPING = {
    ".html": "text/html",
    ".json": "application/json",
    ".js": "text/javascript",
    ".xml": "text/xml",
    ".xsl": "text/xsl",
    ".txt": "text/plain"
}

class CustomHTTPRequestHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        # Get the requested file path
        requested_path = self.path.strip("/")
        
        # Define the parent directory of the script
        parent_dir = pathlib.Path(__file__).parent.parent
        
        # Construct the full file path by joining the parent directory and the requested file
        file_path = parent_dir / requested_path
        print(f"file_path: {file_path}")

        # Check if the file exists and is a file (not a directory)
        if file_path.exists() and file_path.is_file():
            # Get the file extension
            file_extension = file_path.suffix
            
            # Determine the Content-Type based on the file extension
            content_type = CONTENT_TYPE_MAPPING.get(file_extension, "application/octet-stream")
            
            # Serve the file
            self.send_response(200)
            self.send_header('Content-Type', content_type)
            
            # Send multiple response headers of the same name
            self.send_header('Link', '<https://example.com/page1>; rel="next"')
            self.send_header('Link', '<https://example.com/page2>; rel="prev"')
            self.end_headers()
            
            # Open and read the file content
            with open(file_path, 'rb') as file:
                self.wfile.write(file.read())
        else:
            # File not found, return 404
            self.send_response(404)
            self.send_header('Content-Type', 'text/plain')
            self.end_headers()
            self.wfile.write(b"404 Not Found")

# Set up the HTTP server
def run(server_class=HTTPServer, handler_class=CustomHTTPRequestHandler, port=8000):
    server_address = ('', port)
    httpd = server_class(server_address, handler_class)
    print(f'Serving files from parent folder on port {port}...')
    httpd.serve_forever()

if __name__ == "__main__":
    run()
