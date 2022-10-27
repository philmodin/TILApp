FROM swift:5.6

WORKDIR /package
COPY . ./
CMD ["swift", "test"]
