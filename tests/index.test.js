const fs = require('fs');
const path = require('path');

test('frontend/index.html exists', () => {
  const p = path.join(__dirname, '..', 'frontend', 'index.html');
  const exists = fs.existsSync(p);
  expect(exists).toBe(true);
});
