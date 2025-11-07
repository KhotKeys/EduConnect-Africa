"""
Minimal Flask app that serves the static frontend located in ./frontend
This keeps the example simple and enables local testing and containerization.
"""
from flask import Flask, send_from_directory
import os

app = Flask(__name__, static_folder='frontend', static_url_path='')


@app.route('/')
def index():
    index_path = os.path.join(app.static_folder, 'index.html')
    if os.path.exists(index_path):
        return send_from_directory(app.static_folder, 'index.html')
    return 'Index not found', 404


@app.route('/<path:path>')
def static_files(path):
    # Let Flask serve other static assets from frontend/
    return send_from_directory(app.static_folder, path)


if __name__ == '__main__':
    # Default to port 80 per Formative 2 requirement (can be overridden via PORT env var)
    port = int(os.environ.get('PORT', 80))
    app.run(host='0.0.0.0', port=port)
