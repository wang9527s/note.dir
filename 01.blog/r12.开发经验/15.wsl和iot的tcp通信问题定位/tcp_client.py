# tcp_client_debug.py
import socket
import sys
import datetime

def log(info_type, msg):
    print(f"[{datetime.datetime.now().strftime('%H:%M:%S')}] [{info_type}] {msg}")

if len(sys.argv) != 3:
    log("ERROR", f"Usage: python {sys.argv[0]} <IP> <PORT>")
    sys.exit(1)

HOST = sys.argv[1]
PORT = int(sys.argv[2])

log("INFO", f"TCP Client starting. Target: {HOST}:{PORT}")

with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    try:
        log("INFO", "Attempting to connect...")
        s.connect((HOST, PORT))
        log("INFO", f"Connected to {HOST}:{PORT}")

        while True:
            msg = input("Enter message (or 'exit' to quit): ")
            if msg.lower() == "exit":
                log("INFO", "Exiting client...")
                break

            data_bytes = msg.encode()
            s.sendall(data_bytes)
            log("DEBUG", f"Sent {len(data_bytes)} bytes: {msg}")

            data = s.recv(1024)
            if not data:
                log("WARNING", "No response from server, connection may be closed")
                break
            log("DEBUG", f"Received {len(data)} bytes: {data.decode(errors='ignore')}")

    except ConnectionRefusedError:
        log("ERROR", f"Connection refused by server {HOST}:{PORT}")
    except TimeoutError:
        log("ERROR", f"Connection timed out to {HOST}:{PORT}")
    except Exception as e:
        log("ERROR", f"Unexpected error: {e}")
