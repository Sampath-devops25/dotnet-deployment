# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy everything into the container
COPY . .

# Restore dependencies
RUN dotnet restore "AspireApp1/AspireApp1.Web/AspireApp1.Web.csproj"

# Publish the app
RUN dotnet publish "AspireApp1/AspireApp1.Web/AspireApp1.Web.csproj" -c Release -o /app/publish

# Stage 2: Runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app

COPY --from=build /app/publish .

EXPOSE 80
ENTRYPOINT ["dotnet", "AspireApp1.Web.dll"]
