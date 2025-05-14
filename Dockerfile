# Этап сборки
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build

WORKDIR /src

# Копируем .csproj файл и восстанавливаем зависимости
COPY ProductWebTest.csproj ./
RUN dotnet restore ProductWebTest.csproj

# Копируем остальные файлы
COPY . .

# Публикуем сборку
RUN dotnet publish ProductWebTest.csproj -c Release -o /app/out --no-restore

# Этап выполнения
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS runtime

WORKDIR /app

COPY --from=build /app/out .

EXPOSE 80

ENTRYPOINT ["dotnet", "ProductWebTest.dll"]
