const express = require("express");
const app = express();
const PORT = 3000;


app.get("/api/rabbit", async (req, res) => {
    try {
        const response = await fetch(
            "https://rabbit-api-two.vercel.app/api/random"
        );

        if (!response.ok) {
            throw new Error(`Rabbit API returned ${response.status}`);
        }

        const data = await response.json();

        res.json(data);
    } catch (error) {
        console.error(error);

        res.status(500).json({
            error: "Failed to fetch rabbit"
        });
    }
});

app.get("/api/health", (req, res) => {
    res.json({
        status: "ok"
    });
});

app.listen(PORT, () => {
    console.log(`Server running at http://localhost:${PORT}`);
});
