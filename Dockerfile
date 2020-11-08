# FROM nginx:alpine
# COPY . /usr/share/nginx/html

FROM golang:alpine

ENV GO111MODULE=on \
  CGO_ENABLED=0 \
  GOOS=linux \
  GOARCH=amd64

WORKDIR /build

COPY go.mod .
COPY go.sum .

RUN go mod download

COPY . .

RUN go build -o main .

# move to /dist folder, location of binary file build bu go
WORKDIR /dist

RUN cp /build/main .

# export necessary port
EXPOSE 3000

# command to run when starting the container
CMD ["/dist/main"]