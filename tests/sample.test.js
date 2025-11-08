const fs = require('fs');
const path = require('path');

test('frontend/index.html exists and contains a <title>', () => {
  const p = path.join(__dirname, '..', 'frontend', 'index.html');
  const html = fs.readFileSync(p, 'utf8');
  expect(html).toMatch(/<title>.*<\/title>/i);
});
