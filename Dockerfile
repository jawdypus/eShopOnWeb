FROM mcr.microsoft.com/dotnet/sdk:6.0-alpine3.15

RUN mkdir -p /usr/work
WORKDIR /usr/work

COPY . /usr/work

CMD date >> /var/log/date.log