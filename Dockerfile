# FROM nginx:alpine
# COPY . /usr/share/nginx/html

FROM golang:alpine AS builder

# set necessary environtment needed for our image
ENV GO111MODULE=on \
  CGO_ENABLED=0 \
  GOOS=linux \
  GOARCH=amd64

# move to working directory /build
WORKDIR /build

# copy and download dependency using go mod
COPY go.mod .
COPY go.sum .
RUN go mod download

# copy the code into the container
COPY . .

# build the application
RUN go build -o main .

# move to /dist folder, location of binary file build bu go
WORKDIR /dist

# copy bynary from /dist to main folder
RUN cp /build/main .

# # export necessary port
# EXPOSE 3000

# # command to run when starting the container
# CMD ["/dist/main"]

# ----------------------
# build a small image
FROM scratch
COPY --from=builder /dist/main /

# command to run
ENTRYPOINT [ "/main" ]


