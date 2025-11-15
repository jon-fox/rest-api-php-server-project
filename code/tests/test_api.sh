#!/bin/bash

BASE_URL="http://localhost:8000"
TOKEN="test_token_12345abcdef67890"
FAILED_TESTS=0
PASSED_TESTS=0

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

test_result() {
    local test_name=$1
    local expected_code=$2
    local actual_code=$3
    
    if [ "$actual_code" -eq "$expected_code" ]; then
        echo -e "${GREEN}[PASS]${NC} $test_name (HTTP $actual_code)"
        ((PASSED_TESTS++))
    else
        echo -e "${RED}[FAIL]${NC} $test_name (Expected: $expected_code, Got: $actual_code)"
        ((FAILED_TESTS++))
    fi
}

echo "========================================="
echo "AI Agent Management API Test Suite"
echo "========================================="
echo ""

echo "[1/14] Testing GET /agents"
response=$(curl -s -w "\n%{http_code}" "$BASE_URL/agents")
http_code=$(echo "$response" | tail -n 1)
body=$(echo "$response" | sed '$d')
test_result "GET /agents" 200 "$http_code"
echo "Response: $body" | head -c 100
echo "..."
echo ""

# Get an existing agent ID for later tests
EXISTING_AGENT_ID=$(echo "$body" | grep -o '"id":[0-9]*' | head -1 | grep -o '[0-9]*')
if [ -z "$EXISTING_AGENT_ID" ]; then
    echo "No agents found, creating seed agent..."
    seed_response=$(curl -s -X POST "$BASE_URL/agents" \
      -H "Authorization: Bearer $TOKEN" \
      -H "Content-Type: application/json" \
      -d '{"name":"Seed Agent","description":"Created for testing","status":"idle"}')
    EXISTING_AGENT_ID=$(echo "$seed_response" | grep -o '"id":"[0-9]*"' | grep -o '[0-9]*')
fi

echo "[2/14] Testing GET /agents/{id}"
response=$(curl -s -w "\n%{http_code}" "$BASE_URL/agents/$EXISTING_AGENT_ID")
http_code=$(echo "$response" | tail -n 1)
body=$(echo "$response" | sed '$d')
test_result "GET /agents/$EXISTING_AGENT_ID" 200 "$http_code"
echo "Response: $body"
echo ""

echo "[3/14] Testing POST /agents"
response=$(curl -s -w "\n%{http_code}" -X POST "$BASE_URL/agents" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"name":"Test Agent","description":"Created by test script","status":"idle"}')
http_code=$(echo "$response" | tail -n 1)
body=$(echo "$response" | sed '$d')
test_result "POST /agents" 201 "$http_code"
NEW_AGENT_ID=$(echo "$body" | grep -o '"id":"[0-9]*"' | grep -o '[0-9]*')
echo "Response: $body"
echo "Created agent ID: $NEW_AGENT_ID"
echo ""

echo "[4/14] Testing PUT /agents/$NEW_AGENT_ID"
response=$(curl -s -w "\n%{http_code}" -X PUT "$BASE_URL/agents/$NEW_AGENT_ID" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"status":"running","description":"Updated by test script"}')
http_code=$(echo "$response" | tail -n 1)
body=$(echo "$response" | sed '$d')
test_result "PUT /agents/$NEW_AGENT_ID" 200 "$http_code"
echo "Response: $body"
echo ""

echo "[5/14] Testing POST /agents/$NEW_AGENT_ID/execute"
response=$(curl -s -w "\n%{http_code}" -X POST "$BASE_URL/agents/$NEW_AGENT_ID/execute" \
  -H "Authorization: Bearer $TOKEN")
http_code=$(echo "$response" | tail -n 1)
body=$(echo "$response" | sed '$d')
test_result "POST /agents/$NEW_AGENT_ID/execute" 200 "$http_code"
echo "Response: $body"
echo ""

echo "[6/14] Testing GET /tasks"
response=$(curl -s -w "\n%{http_code}" "$BASE_URL/tasks")
http_code=$(echo "$response" | tail -n 1)
body=$(echo "$response" | sed '$d')
test_result "GET /tasks" 200 "$http_code"
echo "Response: $body" | head -c 100
echo "..."
echo ""

EXISTING_TASK_ID=$(echo "$body" | grep -o '"id":[0-9]*' | head -1 | grep -o '[0-9]*')
if [ -z "$EXISTING_TASK_ID" ]; then
    echo "No tasks found, creating seed task..."
    seed_response=$(curl -s -X POST "$BASE_URL/tasks" \
      -H "Authorization: Bearer $TOKEN" \
      -H "Content-Type: application/json" \
      -d "{\"title\":\"Seed Task\",\"description\":\"Created for testing\",\"agent_id\":$EXISTING_AGENT_ID,\"priority\":5,\"status\":\"pending\"}")
    EXISTING_TASK_ID=$(echo "$seed_response" | grep -o '"id":"[0-9]*"' | grep -o '[0-9]*')
fi

echo "[7/14] Testing GET /tasks/{id}"
response=$(curl -s -w "\n%{http_code}" "$BASE_URL/tasks/$EXISTING_TASK_ID")
http_code=$(echo "$response" | tail -n 1)
body=$(echo "$response" | sed '$d')
test_result "GET /tasks/$EXISTING_TASK_ID" 200 "$http_code"
echo "Response: $body"
echo ""

echo "[8/14] Testing GET /tasks/{id}/status"
response=$(curl -s -w "\n%{http_code}" "$BASE_URL/tasks/$EXISTING_TASK_ID/status")
http_code=$(echo "$response" | tail -n 1)
body=$(echo "$response" | sed '$d')
test_result "GET /tasks/$EXISTING_TASK_ID/status" 200 "$http_code"
echo "Response: $body"
echo ""

echo "[9/14] Testing POST /tasks"
response=$(curl -s -w "\n%{http_code}" -X POST "$BASE_URL/tasks" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"title\":\"Test Task\",\"description\":\"Created by test script\",\"agent_id\":$EXISTING_AGENT_ID,\"priority\":8,\"status\":\"pending\"}")
http_code=$(echo "$response" | tail -n 1)
body=$(echo "$response" | sed '$d')
test_result "POST /tasks" 201 "$http_code"
NEW_TASK_ID=$(echo "$body" | grep -o '"id":"[0-9]*"' | grep -o '[0-9]*')
echo "Response: $body"
echo "Created task ID: $NEW_TASK_ID"
echo ""

echo "[10/14] Testing PUT /tasks/$NEW_TASK_ID"
response=$(curl -s -w "\n%{http_code}" -X PUT "$BASE_URL/tasks/$NEW_TASK_ID" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"status":"completed","priority":10}')
http_code=$(echo "$response" | tail -n 1)
body=$(echo "$response" | sed '$d')
test_result "PUT /tasks/$NEW_TASK_ID" 200 "$http_code"
echo "Response: $body"
echo ""

echo "[11/14] Testing GET /tools"
response=$(curl -s -w "\n%{http_code}" "$BASE_URL/tools")
http_code=$(echo "$response" | tail -n 1)
body=$(echo "$response" | sed '$d')
test_result "GET /tools" 200 "$http_code"
echo "Response: $body" | head -c 100
echo "..."
echo ""

echo "[12/14] Testing GET /logs"
response=$(curl -s -w "\n%{http_code}" "$BASE_URL/logs")
http_code=$(echo "$response" | tail -n 1)
body=$(echo "$response" | sed '$d')
test_result "GET /logs" 200 "$http_code"
echo "Response: $body" | head -c 100
echo "..."
echo ""

echo "[13/14] Testing DELETE /tasks/$NEW_TASK_ID"
response=$(curl -s -w "\n%{http_code}" -X DELETE "$BASE_URL/tasks/$NEW_TASK_ID" \
  -H "Authorization: Bearer $TOKEN")
http_code=$(echo "$response" | tail -n 1)
body=$(echo "$response" | sed '$d')
test_result "DELETE /tasks/$NEW_TASK_ID" 200 "$http_code"
echo "Response: $body"
echo ""

echo "[14/14] Testing DELETE /agents/$NEW_AGENT_ID"
response=$(curl -s -w "\n%{http_code}" -X DELETE "$BASE_URL/agents/$NEW_AGENT_ID" \
  -H "Authorization: Bearer $TOKEN")
http_code=$(echo "$response" | tail -n 1)
body=$(echo "$response" | sed '$d')
test_result "DELETE /agents/$NEW_AGENT_ID" 200 "$http_code"
echo "Response: $body"
echo ""

echo "========================================="
echo "Test Summary"
echo "========================================="
echo -e "Total Tests: $((PASSED_TESTS + FAILED_TESTS))"
echo -e "${GREEN}Passed: $PASSED_TESTS${NC}"
echo -e "${RED}Failed: $FAILED_TESTS${NC}"
echo ""

if [ $FAILED_TESTS -eq 0 ]; then
    echo -e "${GREEN}All tests passed successfully!${NC}"
    exit 0
else
    echo -e "${RED}Some tests failed. Please review the output above.${NC}"
    exit 1
fi
