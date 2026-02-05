#!/bin/bash

# Test script to verify Klaster Ilmu and Klaster Prodi APIs

echo "======================================"
echo "Testing Klaster Management APIs"
echo "======================================"

API_URL="http://localhost:3003/api/v1"

# Test 1: Get all Klaster Ilmu
echo ""
echo "✓ Test 1: Fetching all Klaster Ilmu..."
curl -s -X GET "$API_URL/master-data/klaster-ilmu" | jq '.' | head -50

# Test 2: Get all Klaster Prodi
echo ""
echo "✓ Test 2: Fetching all Klaster Prodi..."
curl -s -X GET "$API_URL/master-data/klaster-prodi" | jq '.' | head -50

# Test 3: Create new Klaster Prodi (if existing data is available)
echo ""
echo "✓ Test 3: Creating new Klaster Prodi (if Klaster Ilmu available)..."
# Get first klaster ilmu id
KLASTER_ILMU_ID=$(curl -s -X GET "$API_URL/master-data/klaster-ilmu" | jq '.data[0].id' 2>/dev/null)

if [ ! -z "$KLASTER_ILMU_ID" ] && [ "$KLASTER_ILMU_ID" != "null" ]; then
  echo "Using Klaster Ilmu ID: $KLASTER_ILMU_ID"
  
  curl -s -X POST "$API_URL/master-data/klaster-prodi" \
    -H "Content-Type: application/json" \
    -d "{
      \"kodeKlaster\": \"TT\",
      \"namaKlaster\": \"Teknik Test\",
      \"deskripsi\": \"Klaster program studi untuk testing\",
      \"klasterIlmuId\": $KLASTER_ILMU_ID,
      \"isActive\": true
    }" | jq '.'
else
  echo "No Klaster Ilmu found, skipping create test"
fi

echo ""
echo "======================================"
echo "API Tests Complete"
echo "======================================"
