#include <iostream>
#include <cstring>
#include <unistd.h>
#include <arpa/inet.h>

#define PORT 5016
#define BUFFER_SIZE 1024

int main() {
    int server_fd, client_fd;
    struct sockaddr_in server_addr, client_addr;
    socklen_t client_addr_len = sizeof(client_addr);
    char buffer[BUFFER_SIZE];

    // 创建套接字
    if ((server_fd = socket(AF_INET, SOCK_STREAM, 0)) == -1) {
        std::cerr << "Socket creation failed" << std::endl;
        return -1;
    }

    // 设置服务器地址
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(PORT); // 设置端口
    server_addr.sin_addr.s_addr = INADDR_ANY; // 监听所有网卡

    // 绑定套接字到指定地址
    if (bind(server_fd, (struct sockaddr*)&server_addr, sizeof(server_addr)) == -1) {
        std::cerr << "Binding failed" << std::endl;
        close(server_fd);
        return -1;
    }

    // 开始监听连接
    if (listen(server_fd, 5) == -1) {
        std::cerr << "Listen failed" << std::endl;
        close(server_fd);
        return -1;
    }

    std::cout << "Server is listening on port " << PORT << "..." << std::endl;

    // 接受客户端连接
    if ((client_fd = accept(server_fd, (struct sockaddr*)&client_addr, &client_addr_len)) == -1) {
        std::cerr << "Accept failed" << std::endl;
        close(server_fd);
        return -1;
    }

    std::cout << "Connected to client: " 
              << inet_ntoa(client_addr.sin_addr) 
              << ":" << ntohs(client_addr.sin_port) << std::endl;

    // 接收客户端数据并回显
    while (true) {
        memset(buffer, 0, BUFFER_SIZE);
        int recv_len = recv(client_fd, buffer, BUFFER_SIZE, 0);
        if (recv_len == -1) {
            std::cerr << "Receive failed" << std::endl;
            break;
        }
        if (recv_len == 0) {
            std::cout << "Client disconnected" << std::endl;
            break;
        }

        std::cout << "Received: " << buffer << std::endl;

        // 回传数据给客户端
        if (send(client_fd, buffer, recv_len, 0) == -1) {
            std::cerr << "Send failed" << std::endl;
            break;
        }
    }

    // 关闭套接字
    close(client_fd);
    close(server_fd);

    return 0;
}
