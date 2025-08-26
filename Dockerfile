# Base image for runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

# Build image
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy everything to the container
COPY . .

# Restore dependencies – good for caching
RUN dotnet restore AspireApp1.WebAPI/AspireApp1.WebAPI.csproj

# Publish the application
RUN dotnet publish AspireApp1.W
