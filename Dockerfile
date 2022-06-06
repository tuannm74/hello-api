#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 5000

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["hello3/hello3.csproj", "hello3/"]
RUN dotnet restore "hello3/hello3.csproj"
COPY . .
WORKDIR "/src/hello3"
RUN dotnet build "hello3.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "hello3.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "hello3.dll"]
