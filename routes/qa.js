const express = require("express");
const router = express.Router();
const { chromium } = require("playwright");
const path = require("path");

const breakpoints = [320, 480, 768, 1024, 1280, 1440];
const SERVER_URL = process.env.SERVER_URL || `http://localhost:${process.env.PORT || 3000}`;

router.post("/layout-check", async (req, res) => {
  const { url, scrollCount = 1 } = req.body;
  if (!url) return res.status(400).json({ error: "Missing 'url' in body" });

  const browser = await chromium.launch({ headless: true, args: ["--no-sandbox"] });
  const timestamp = Date.now();
  const screenshots = {};

  try {
    await Promise.all(
      breakpoints.map(async (width) => {
        const context = await browser.newContext();
        const page = await context.newPage();
        const height = 800;

        await page.setViewportSize({ width, height });
        await page.goto(url, { waitUntil: "networkidle" });

        screenshots[width] = [];

        for (let i = 0; i < scrollCount; i++) {
          const scrollY = i * height;
          await page.evaluate((y) => window.scrollTo(0, y), scrollY);

          const filename = `screenshot-${width}-${i + 1}-${timestamp}.png`;
          const filepath = path.join(__dirname, "..", "public", "screenshots", filename);

          await page.screenshot({ path: filepath, fullPage: false });

          const fileUrl = `${SERVER_URL}/public/screenshots/${filename}`;
          screenshots[width].push(fileUrl);
        }

        await context.close();
      })
    );

    res.json({ url, scrollCount, screenshots });
  } catch (err) {
    console.error("❌ Screenshot error:", err.message);
    res.status(500).json({ error: "Screenshot capture failed." });
  } finally {
    await browser.close();
  }
});

module.exports = router;
