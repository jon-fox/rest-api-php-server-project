Step by Step to Get Started (Assuming all pre reqs are installed and MySQL is available)

1. run code/database/setup.sh to setup the agents database and insert preliminary data

2. navigate to code/ and run `php -S localhost:8000`

3. Navigate to the `http://localhost:8000/docs` endpoint to view available endpoints. Built to be like swagger api, so we can run sample payloads, comes with sample curls for local.

4. use generate_token.sh to generate an auth token for use with the protected endpoints, it will auto insert the auth token into the database, then include the auth token in the swagger page.

5. We should be good to call the agent endpoints

NGINX Deployment
-----------------------------------

Alternative to PHP built-in server - use NGINX with PHP-FPM:

```bash
./deploy/start_nginx.sh    # Start NGINX on port 8000
./deploy/stop_nginx.sh     # Stop NGINX
```

Auto-generates config, starts PHP-FPM if needed, and tests deployment.

Quick local .env (required)
-----------------------------------
Create `code/.env` with these local values so PHP can connect:

```env
DB_HOST=127.0.0.1
DB_PORT=3306
DB_NAME=agent_management
DB_USER=root
DB_PASS=123456
```

Then run:

```bash
./deploy/start_nginx.sh
```

Testing
-------

### Automated Test Suite

Two test methods are available to validate all 14 API endpoints:

**1. Shell Script (Command Line):**

```bash
cd code
./tests/test_api.sh
```
- Bash script using cURL
- Runs sequentially through all endpoints
- Shows pass/fail status with HTTP codes
- Creates/cleans up test data automatically
- Outputs results to terminal
- No server required (uses localhost:8000)

**2. HTML/JavaScript (Browser):**

From the `code/` directory, open the test file in your browser:
```bash
open tests/test.html          # macOS
xdg-open tests/test.html      # Linux
```
```cmd
start tests\test.html         # Windows (Command Prompt)
```
```powershell
Invoke-Item tests\test.html   # Windows (PowerShell)
```
Or manually open the file `code/tests/test.html` in any browser

- Interactive UI in browser
- Click "Run All Tests" button to execute
- Real-time test execution with visual feedback
- Detailed request/response display
- Summary statistics with timing
