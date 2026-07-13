# tcp_server_debug.py
import socket
import datetime

HOST = "0.0.0.0"  # 监听所有网卡
PORT = 5016       # 端口

def log(info_type, msg):
    print(f"[{datetime.datetime.now().strftime('%H:%M:%S')}] [{info_type}] {msg}")

log("INFO", f"Starting TCP server on {HOST}:{PORT}")

with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    s.bind((HOST, PORT))
    s.listen()
    log("INFO", "Server listening...")

    while True:
        try:
            log("INFO", "Waiting for incoming connection...")
            conn, addr = s.accept()
            log("INFO", f"Connected by {addr}")

            with conn:
                while True:
                    data = conn.recv(1024)
                    if not data:
                        log("INFO", f"Connection closed by {addr}")
                        break
                    message = data.decode(errors='ignore')
                    log("DEBUG", f"Received {len(data)} bytes from {addr}: {message}")
                    conn.sendall(data)  # 回显
                    log("DEBUG", f"Sent back {len(data)} bytes to {addr}")

        except KeyboardInterrupt:
            log("INFO", "Server shutting down...")
            break
        except Exception as e:
            log("ERROR", f"Unexpected error: {e}")
