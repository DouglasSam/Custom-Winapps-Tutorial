const express = require('express');
const fs = require('fs');
const path = require('path');
const marked = require('marked');
const sanitizeHtml = require('sanitize-html');

const app = express();
const PORT = process.env.PORT || 3000;

// Set EJS as the templating engine
app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));

// Route to render Markdown securely
app.get('/', (req, res) => {
    const mdPath = path.join(__dirname, 'README.md');

    fs.readFile(mdPath, 'utf8', (err, markdown) => {
        if (err) return res.status(500).send('Error loading Markdown file');

        // Convert Markdown to HTML
        const rawHtml = marked.parse(markdown);

        // Sanitize HTML to prevent XSS
        const cleanHtml = sanitizeHtml(rawHtml, {
            allowedTags: sanitizeHtml.defaults.allowedTags.concat(['img', 'h1', 'h2']),
            allowedAttributes: {
                a: ['href', 'name', 'target'],
                img: ['src', 'alt'],
                '*': ['class'] // allow classes for styling
            },
            allowedSchemes: ['http', 'https', 'mailto']
        });

        res.render('index', { content: cleanHtml });
    });
});

app.listen(PORT, () => {
    console.log(`✅ Server running at http://localhost:${PORT}`);
});
