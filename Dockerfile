# Этап сборки
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build

# Устанавливаем рабочую директорию в контейнере
WORKDIR /src

# Копируем .csproj файл и восстанавливаем зависимости
COPY ["ProductWebTest/ProductWebTest.csproj", "ProductWebTest/"]
RUN dotnet restore "ProductWebTest/ProductWebTest.csproj"

# Копируем остальные файлы проекта
COPY . .

# Строим проект и публикуем в папку /out
RUN dotnet publish "ProductWebTest/ProductWebTest.csproj" -c Release -o /app/out --no-restore

# Этап запуска
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS runtime

# Устанавливаем рабочую директорию для запуска
WORKDIR /app

# Копируем файлы из этапа сборки
COPY --from=build /app/out .

# Открываем порт 80
EXPOSE 80

# Команда для запуска приложения
ENTRYPOINT ["dotnet", "ProductWebTest.dll"]
