FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 5200

ENV ASPNETCORE_URLS=http://+:5200

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG configuration=Release
WORKDIR /src
COPY ["api_getaway/api_getaway.csproj", "api_getaway/"]
RUN dotnet restore "api_getaway\api_getaway.csproj"
COPY . .
WORKDIR "/src/api_getaway"
RUN dotnet build "api_getaway.csproj" -c $configuration -o /app/build

FROM build AS publish
ARG configuration=Release
RUN dotnet publish "api_getaway.csproj" -c $configuration -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "api_getaway.dll"]
