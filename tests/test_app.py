import pytest
import werkzeug
from app import app

# Some werkzeug builds used by the environment may not expose __version__.
# Flask's test client expects werkzeug.__version__ to exist, so ensure it does here.
if not hasattr(werkzeug, "__version__"):
    werkzeug.__version__ = "2.3.7"


def test_index_returns_200_and_contains_html_tag():
    client = app.test_client()
    resp = client.get('/')
    assert resp.status_code == 200
    # Basic sanity: response should contain HTML
    assert b'<html' in resp.data.lower() or b'<!doctype html' in resp.data.lower()
