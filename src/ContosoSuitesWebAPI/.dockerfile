# Use the official image as a parent image.
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env

# Set the working directory.
WORKDIR /app

# Copy csproj and restore dependencies.
COPY *.csproj ./
RUN dotnet restore

# Copy everything else and build the project.
COPY . ./
RUN dotnet publish -c Release -o out

# Build runtime image.
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build-env /app/out .

# Expose the port the app runs on. .net 8 defaults to 8080, and 8081 instead of 80
EXPOSE 8080

# Set the command to run when the container starts.
ENTRYPOINT ["dotnet", "ContosoSuitesWebAPI.dll"]