const express = require('express');
const app = express();
const port = 8080;

app.use(express.json());

app.get('/api/health', (req, res) => {
  res.send('API is running ✅');
});

app.listen(port, () => {
  console.log(`Server listening at http://localhost:8080`);
});
