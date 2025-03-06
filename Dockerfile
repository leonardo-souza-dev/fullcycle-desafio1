# Etapa de build
FROM golang:1.21 AS builder

# Define o diretório de trabalho
WORKDIR /app

# Copia o restante do código
COPY . .

RUN go mod init full-cycle-rocks-app && go mod tidy

# Compila o binário de forma estática e otimizada
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-s -w" -o full-cycle-rocks-app .

# Etapa final: usa a imagem mínima 'scratch'
FROM scratch

# Define o diretório de trabalho
WORKDIR /root/

# Copia o binário compilado da etapa anterior
COPY --from=builder /app/full-cycle-rocks-app .

# Define o comando de entrada do container
CMD ["/root/full-cycle-rocks-app"]
