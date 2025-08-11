@echo off
REM API Testing Script for Scraping Workshop (Windows)
REM Make sure your server is running on localhost:3600

set BASE_URL=http://localhost:3600
set NGROK_URL=https://9b5d976e6484.ngrok-free.app

echo 🚀 Starting API Tests...
echo ==================================

REM Test 1: YouTube Trending Videos
echo 📺 Testing YouTube Trending Videos API...
echo GET %BASE_URL%/trending-cards
echo ----------------------------------
curl -X GET "%BASE_URL%/trending-cards" -H "Content-Type: application/json" -o youtube_response.json
echo Response saved to youtube_response.json
echo.

REM Test 2: Nike Shoes - Default limit
echo 👟 Testing Nike Shoes API (Default limit)...
echo GET %BASE_URL%/nike/shoes
echo ----------------------------------
curl -X GET "%BASE_URL%/nike/shoes" -H "Content-Type: application/json" -o nike_default_response.json
echo Response saved to nike_default_response.json
echo.

REM Test 3: Nike Shoes - Custom limit
echo 👟 Testing Nike Shoes API (Custom limit: 5)...
echo GET %BASE_URL%/nike/shoes?limit=5
echo ----------------------------------
curl -X GET "%BASE_URL%/nike/shoes?limit=5" -H "Content-Type: application/json" -o nike_custom_response.json
echo Response saved to nike_custom_response.json
echo.

REM Test 4: Layout Check
echo 📸 Testing Layout Check API...
echo POST %BASE_URL%/layout-check
echo ----------------------------------
curl -X POST "%BASE_URL%/layout-check" -H "Content-Type: application/json" -d "{\"url\": \"https://www.google.com\", \"scrollCount\": 1}" -o layout_response.json
echo Response saved to layout_response.json
echo.

REM Test 5: Layout Check with multiple scrolls
echo 📸 Testing Layout Check API (Multiple scrolls)...
echo POST %BASE_URL%/layout-check
echo ----------------------------------
curl -X POST "%BASE_URL%/layout-check" -H "Content-Type: application/json" -d "{\"url\": \"https://www.github.com\", \"scrollCount\": 2}" -o layout_multiple_response.json
echo Response saved to layout_multiple_response.json
echo.

REM Test 6: Layout Check - Error case
echo ❌ Testing Layout Check API (Missing URL - Error case)...
echo POST %BASE_URL%/layout-check
echo ----------------------------------
curl -X POST "%BASE_URL%/layout-check" -H "Content-Type: application/json" -d "{\"scrollCount\": 1}" -o layout_error_response.json
echo Response saved to layout_error_response.json
echo.

REM Test 7: ngrok URL test
echo 🌐 Testing with ngrok URL...
echo GET %NGROK_URL%/trending-cards
echo ----------------------------------
curl -X GET "%NGROK_URL%/trending-cards" -H "Content-Type: application/json" -o ngrok_response.json
echo Response saved to ngrok_response.json
echo.

REM Test 8: Lovable frontend origin test
echo 🌐 Testing with Lovable frontend origin...
echo GET %BASE_URL%/trending-cards
echo ----------------------------------
curl -X GET "%BASE_URL%/trending-cards" -H "Content-Type: application/json" -H "Origin: https://scrape-view-ui.lovable.app" -o lovable_response.json
echo Response saved to lovable_response.json
echo.

echo ==================================
echo ✅ All API tests completed!
echo.
echo 📁 Response files saved to current directory:
echo    - youtube_response.json
echo    - nike_default_response.json
echo    - nike_custom_response.json
echo    - layout_response.json
echo    - layout_multiple_response.json
echo    - layout_error_response.json
echo    - lovable_response.json
echo    - ngrok_response.json
echo.
echo 🔍 To view a response: type filename.json
echo 🧹 To clean up: del *_response.json
pause 