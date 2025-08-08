const express = require('express');
const fs = require('fs');
const path = require('path');
const marked = require('marked');
const createDOMPurify = require('dompurify');
const { JSDOM } = require('jsdom');

const app = express();
const PORT = process.env.PORT || 3000;

const getSource = (string, req) => {
    const window = new JSDOM('').window;
    const DOMPurify = createDOMPurify(window);
    const protocol = req.protocol;
    const host = req.get('host');
    return DOMPurify.sanitize(string).replace(/%%URL%%/g, `${protocol}://${host}`);
};

// Set EJS as the templating engine
app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));

// Route to render Markdown securely
app.get('/', (req, res) => {
    const mdPath = path.join(__dirname, 'README.md');

    fs.readFile(mdPath, 'utf8', (err, markdown) => {
        if (err) return res.status(500).send('Error loading Markdown file');

        const html = marked.parse(getSource(markdown, req));

        res.render('index', { content: html });
    });
});

app.get('/setup.sh', (req, res) => {
    const scriptPath = path.join(__dirname, 'setup.sh');
    fs.readFile(scriptPath, 'utf8', (err, data) => {
        if (err) return res.status(404).send('Script not found');
        res.type('text/plain').send(getSource(data,req));
    });
});

app.listen(PORT, () => {
    console.log(`✅ Server running at http://localhost:${PORT}`);
});
