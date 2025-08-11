#!/bin/bash

# API Testing Script for Scraping Workshop
# Make sure your server is running on localhost:3600

BASE_URL="http://localhost:3600"
NGROK_URL="https://9b5d976e6484.ngrok-free.app"  # Replace with your actual ngrok URL

echo "🚀 Starting API Tests..."
echo "=================================="

# Test 1: YouTube Trending Videos (Frontend Route)
echo "📺 Testing YouTube Trending Videos API..."
echo "GET $BASE_URL/trending-cards"
echo "----------------------------------"
curl -X GET "$BASE_URL/trending-cards" \
  -H "Content-Type: application/json" \
  -w "\n\nStatus: %{http_code}\nTime: %{time_total}s\n" \
  -o /tmp/youtube_response.json

echo "Response saved to /tmp/youtube_response.json"
echo ""

# Test 2: Nike Shoes (Backend Route) - Default limit
echo "👟 Testing Nike Shoes API (Default limit)..."
echo "GET $BASE_URL/nike/shoes"
echo "----------------------------------"
curl -X GET "$BASE_URL/nike/shoes" \
  -H "Content-Type: application/json" \
  -w "\n\nStatus: %{http_code}\nTime: %{time_total}s\n" \
  -o /tmp/nike_default_response.json

echo "Response saved to /tmp/nike_default_response.json"
echo ""

# Test 3: Nike Shoes (Backend Route) - Custom limit
echo "👟 Testing Nike Shoes API (Custom limit: 5)..."
echo "GET $BASE_URL/nike/shoes?limit=5"
echo "----------------------------------"
curl -X GET "$BASE_URL/nike/shoes?limit=5" \
  -H "Content-Type: application/json" \
  -w "\n\nStatus: %{http_code}\nTime: %{time_total}s\n" \
  -o /tmp/nike_custom_response.json

echo "Response saved to /tmp/nike_custom_response.json"
echo ""

# Test 4: Layout Check (QA Route) - Screenshot testing
echo "📸 Testing Layout Check API..."
echo "POST $BASE_URL/layout-check"
echo "----------------------------------"
curl -X POST "$BASE_URL/layout-check" \
  -H "Content-Type: application/json" \
  -d '{
    "url": "https://www.google.com",
    "scrollCount": 1
  }' \
  -w "\n\nStatus: %{http_code}\nTime: %{time_total}s\n" \
  -o /tmp/layout_response.json

echo "Response saved to /tmp/layout_response.json"
echo ""

# Test 5: Layout Check with multiple scrolls
echo "📸 Testing Layout Check API (Multiple scrolls)..."
echo "POST $BASE_URL/layout-check"
echo "----------------------------------"
curl -X POST "$BASE_URL/layout-check" \
  -H "Content-Type: application/json" \
  -d '{
    "url": "https://www.github.com",
    "scrollCount": 2
  }' \
  -w "\n\nStatus: %{http_code}\nTime: %{time_total}s\n" \
  -o /tmp/layout_multiple_response.json

echo "Response saved to /tmp/layout_multiple_response.json"
echo ""

# Test 6: Layout Check - Missing URL (Error case)
echo "❌ Testing Layout Check API (Missing URL - Error case)..."
echo "POST $BASE_URL/layout-check"
echo "----------------------------------"
curl -X POST "$BASE_URL/layout-check" \
  -H "Content-Type: application/json" \
  -d '{
    "scrollCount": 1
  }' \
  -w "\n\nStatus: %{http_code}\nTime: %{time_total}s\n" \
  -o /tmp/layout_error_response.json

echo "Response saved to /tmp/layout_error_response.json"
echo ""

# Test 7: Using ngrok URL (if available)
if [ ! -z "$NGROK_URL" ]; then
  echo "🌐 Testing with ngrok URL..."
  echo "GET $NGROK_URL/trending-cards"
  echo "----------------------------------"
  curl -X GET "$NGROK_URL/trending-cards" \
    -H "Content-Type: application/json" \
    -w "\n\nStatus: %{http_code}\nTime: %{time_total}s\n" \
    -o /tmp/ngrok_response.json

  echo "Response saved to /tmp/ngrok_response.json"
  echo ""
fi

# Test 8: Test with Lovable frontend origin
echo "🌐 Testing with Lovable frontend origin..."
echo "GET $BASE_URL/trending-cards"
echo "----------------------------------"
curl -X GET "$BASE_URL/trending-cards" \
  -H "Content-Type: application/json" \
  -H "Origin: https://scrape-view-ui.lovable.app" \
  -w "\n\nStatus: %{http_code}\nTime: %{time_total}s\n" \
  -o /tmp/lovable_response.json

echo "Response saved to /tmp/lovable_response.json"
echo ""

# Test 9: Test OPTIONS preflight request
echo "🔍 Testing OPTIONS preflight request..."
echo "OPTIONS $BASE_URL/trending-cards"
echo "----------------------------------"
curl -X OPTIONS "$BASE_URL/trending-cards" \
  -H "Origin: https://scrape-view-ui.lovable.app" \
  -H "Access-Control-Request-Method: GET" \
  -H "Access-Control-Request-Headers: Content-Type" \
  -w "\n\nStatus: %{http_code}\nTime: %{time_total}s\n" \
  -v

echo ""
echo "=================================="
echo "✅ All API tests completed!"
echo ""
echo "📁 Response files saved to /tmp/:"
echo "   - youtube_response.json"
echo "   - nike_default_response.json"
echo "   - nike_custom_response.json"
echo "   - layout_response.json"
echo "   - layout_multiple_response.json"
echo "   - layout_error_response.json"
echo "   - lovable_response.json"
if [ ! -z "$NGROK_URL" ]; then
  echo "   - ngrok_response.json"
fi
echo ""
echo "🔍 To view a response: cat /tmp/filename.json | jq '.'"
echo "🧹 To clean up: rm /tmp/*_response.json" 