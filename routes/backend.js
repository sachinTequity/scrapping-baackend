const express = require("express");
const router = express.Router();
const puppeteer = require("puppeteer");

// Nike Shoe Scraper
router.get("/nike/shoes", async (req, res) => {
  const limit = parseInt(req.query.limit, 10) || 20;

  try {
    const browser = await puppeteer.launch({ headless: "new" });
    const page = await browser.newPage();
    await page.goto("https://www.nike.com/in/w/mens-shoes-nik1zy7ok", { waitUntil: "networkidle2" });

    await page.waitForSelector(".product-card__body");

    const shoes = await page.$$eval(".product-card__body", (cards, limit) => {
      const data = [];

      for (let i = 0; i < cards.length && data.length < limit; i++) {
        const card = cards[i];
        const title = card.querySelector(".product-card__title")?.innerText.trim() || "No title";
        const subtitle = card.querySelector(".product-card__subtitle")?.innerText.trim() || "No subtitle";
        const price = card.querySelector(".product-price")?.innerText.trim() || "No price";
        const url = card.closest("a")?.href || null;
        const img = card.closest(".product-card")?.querySelector("img")?.src || null;

        data.push({ title, subtitle, price, url, image: img });
      }

      return data;
    }, limit);

    await browser.close();
    res.json({ limit, results: shoes });
  } catch (err) {
    console.error("❌ Nike scraping error:", err.message);
    res.status(500).json({ error: "Failed to scrape Nike shoes" });
  }
});

module.exports = router;
