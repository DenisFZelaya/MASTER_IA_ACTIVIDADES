import http.server
import socketserver

# Define el puerto en el que deseas ejecutar el servidor
puerto = 8000

# Configura el manejador del servidor
manejador = http.server.SimpleHTTPRequestHandler

# Crea el servidor
with socketserver.TCPServer(("", puerto), manejador) as httpd:
    print(f"El servidor está en ejecución en el puerto {puerto}")
    # Mantén el servidor en ejecución
    httpd.serve_forever()
