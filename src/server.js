const express = require('express');
const fs = require('fs');
const path = require('path');
const marked = require('marked');
const createDOMPurify = require('dompurify');
const { JSDOM } = require('jsdom');

const app = express();
const PORT = process.env.PORT || 3000;

const getSource = (string, req, sanitize=true) => {
    const window = new JSDOM('').window;
    const DOMPurify = createDOMPurify(window);
    const protocol = req.protocol;
    const host = req.get('host');
    if (sanitize){
        return DOMPurify.sanitize(string).replace(/%%URL%%/g, `${protocol}://${host}`);
    }
    else {
        return string.replace(/%%URL%%/g, `${protocol}://${host}`);
    }
};

// Set EJS as the templating engine
app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));

app.use('/css', express.static(path.join(__dirname, 'views/css')));

// Route to render Markdown securely
app.get('/', (req, res) => {
    const mdPath = path.join(__dirname, 'README.md');

    fs.readFile(mdPath, 'utf8', (err, markdown) => {
        if (err) return res.status(500).send('Error loading Markdown file');

        const html = marked.parse(getSource(markdown, req)).replace('<pre><code class="language-bash">bash &amp;lt;', '<pre><code class="language-bash">bash <');

        res.render('index', { content: html });
    });
});

app.get('/setup.sh', (req, res) => {
    const scriptPath = path.join(__dirname, 'setup.sh');
    fs.readFile(scriptPath, 'utf8', (err, data) => {
        if (err) return res.status(404).send('Script not found');
        res.type('text/plain').send(getSource(data,req,false));
    });
});

app.get('/example-winapps.conf', (req, res) => {
    const scriptPath = path.join(__dirname, 'example-winapps.conf');
    fs.readFile(scriptPath, 'utf8', (err, data) => {
        if (err) return res.status(404).send('Script not found');
        res.type('text/plain').send(getSource(data,req,false));
    });
});


app.listen(PORT, () => {
    const timestamp = new Date().toISOString();
    console.log(`✅ Server running at http://localhost:${PORT} at ${timestamp}`);
});
