// src/index.js
const express = require('express');
const app = express();

app.get('/', (req, res) => {
    res.send('¡Hola desde Node.js en Podman!');
});

const PORT = 3000;
app.listen(PORT, () => {
    console.log(`Servidor escuchando en http://localhost:${PORT}`);
});
