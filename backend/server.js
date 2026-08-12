const express = require("express");

const app = express();

const PORT = 3000;

app.get("/api/message", (req, res) => {
    res.json({
        message: "Hello from backend!"
    });
});

app.get("/health", (req, res) => {
    res.json({
        status: "healthy"
    });
});

app.listen(PORT, "0.0.0.0", () => {
    console.log(`Backend running on port ${PORT}`);
});