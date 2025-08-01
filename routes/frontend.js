const express = require("express");
const router = express.Router();
const { chromium } = require("playwright");

router.get("/trending-cards", async (req, res) => {
  console.log("🚀 Starting YouTube trending videos scraping...");

  const browser = await chromium.launch({ headless: true });
  console.log("✅ Browser launched successfully");

  const page = await browser.newPage();
  console.log("✅ New page created");

  try {
    console.log("📡 Navigating to YouTube trending page...");
    await page.goto("https://www.youtube.com/results?search_query=trending+video", { waitUntil: "networkidle" });
    console.log("✅ Successfully loaded YouTube trending page");

    console.log("⏳ Waiting for page to fully load...");
    await page.waitForTimeout(3000);
    console.log("✅ Page load wait completed");

    console.log("🔍 Locating video elements...");
    const videoItems = await page.locator("ytd-video-renderer").elementHandles();
    console.log(`📊 Found ${videoItems.length} video elements on page`);

    const videos = [];
    const maxVideos = Math.min(10, videoItems.length);
    console.log(`🎯 Processing first ${maxVideos} videos...`);

    for (let i = 0; i < maxVideos; i++) {
      const video = videoItems[i];
      console.log(`📹 Processing video ${i + 1}/${maxVideos}...`);

      const titleEl = await video.$("#video-title");
      const viewsEl = await video.$("span.inline-metadata-item");
      const imgEl = await video.$("img");

      const title = titleEl ? await titleEl.getAttribute("title") : "N/A";
      const url = titleEl ? "https://youtube.com" + (await titleEl.getAttribute("href")) : "N/A";
      const views = viewsEl ? await viewsEl.textContent() : "N/A";
      const thumbnail = imgEl ? await imgEl.getAttribute("src") : "N/A";

      console.log(`  📝 Title: ${title.substring(0, 50)}${title.length > 50 ? '...' : ''}`);
      console.log(`  👁️ Views: ${views}`);
      console.log(`  🖼️ Thumbnail: ${thumbnail !== "N/A" ? "Found" : "Not found"}`);

      videos.push({ title, views, thumbnail, url });
    }

    console.log(`✅ Successfully processed ${videos.length} videos`);
    console.log("🔒 Closing browser...");
    await browser.close();
    console.log("✅ Browser closed successfully");

    console.log("📤 Sending response to client...");
    res.json({ platform: "YouTube", total: videos.length, data: videos });
    console.log("🎉 Request completed successfully!");

  } catch (err) {
    console.error("❌ YouTube scraping error:", err.message);
    console.error("🔍 Error details:", err);

    console.log("🔒 Closing browser due to error...");
    await browser.close();
    console.log("✅ Browser closed after error");

    res.status(500).json({ error: "Failed to fetch trending data" });
    console.log("📤 Error response sent to client");
  }
});

module.exports = router;
