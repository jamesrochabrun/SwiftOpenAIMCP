#!/usr/bin/env python3
"""
Test script for SwiftOpenAI MCP Server
Sends MCP protocol messages and displays responses
"""

import json
import subprocess
import os
import sys

# Set your OpenAI API key
os.environ['OPENAI_API_KEY'] = os.environ.get('OPENAI_API_KEY', 'test-key')

def send_request(request):
    """Send a request to the MCP server and return the response"""
    # Start the server process
    process = subprocess.Popen(
        ['./.build/debug/swiftopenai-mcp'],
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True
    )
    
    # Send the request
    request_str = json.dumps(request)
    stdout, stderr = process.communicate(input=request_str + '\n')
    
    # Print stderr (logs) if any
    if stderr:
        print("Server logs:")
        print(stderr)
    
    # Parse and return response
    try:
        # The response might be mixed with log lines, try to find JSON
        for line in stdout.split('\n'):
            if line.strip() and line.strip().startswith('{'):
                return json.loads(line.strip())
    except:
        return {"error": "Failed to parse response", "stdout": stdout}

def test_initialize():
    """Test initialization"""
    print("\n=== Testing Initialize ===")
    request = {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
            "protocolVersion": "2025-06-18",
            "capabilities": {},
            "clientInfo": {
                "name": "test-client",
                "version": "1.0"
            }
        }
    }
    response = send_request(request)
    print("Response:", json.dumps(response, indent=2))
    return response

def test_list_tools():
    """Test listing tools"""
    print("\n=== Testing List Tools ===")
    # First initialize
    send_request({
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
            "protocolVersion": "2025-06-18",
            "capabilities": {},
            "clientInfo": {"name": "test", "version": "1.0"}
        }
    })
    
    # Then list tools
    request = {
        "jsonrpc": "2.0",
        "id": 2,
        "method": "tools/list",
        "params": {}
    }
    response = send_request(request)
    print("Response:", json.dumps(response, indent=2))
    return response

def test_list_models():
    """Test list_models tool"""
    print("\n=== Testing List Models ===")
    # Need real API key for this
    if os.environ.get('OPENAI_API_KEY') == 'test-key':
        print("Skipping - needs real OPENAI_API_KEY")
        return
    
    # First initialize
    send_request({
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
            "protocolVersion": "2025-06-18",
            "capabilities": {},
            "clientInfo": {"name": "test", "version": "1.0"}
        }
    })
    
    # Then call tool
    request = {
        "jsonrpc": "2.0",
        "id": 3,
        "method": "tools/call",
        "params": {
            "name": "list_models",
            "arguments": {}
        }
    }
    response = send_request(request)
    print("Response:", json.dumps(response, indent=2))
    return response

def main():
    """Run all tests"""
    print("Testing SwiftOpenAI MCP Server")
    print("==============================")
    
    # Check if binary exists
    if not os.path.exists('./.build/debug/swiftopenai-mcp'):
        print("Error: Server binary not found!")
        print("Please run 'swift build' first.")
        sys.exit(1)
    
    # Run tests
    test_initialize()
    test_list_tools()
    test_list_models()
    
    print("\n=== Manual Testing ===")
    print("To test manually, run:")
    print("./test-interactive.sh")
    print("\nThen paste these JSON messages:")
    print('{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-06-18","capabilities":{},"clientInfo":{"name":"test","version":"1.0"}}}')
    print('{"jsonrpc":"2.0","id":2,"method":"tools/list","params":{}}')

if __name__ == "__main__":
    main()