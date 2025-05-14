# ���� ������
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build

WORKDIR /src

# �������� .csproj ���� � ��������������� �����������
COPY ProductWebTest.csproj ./
RUN dotnet restore ProductWebTest.csproj

# �������� ��������� �����
COPY . .

# ��������� ������
RUN dotnet publish ProductWebTest.csproj -c Release -o /app/out --no-restore

# ���� ����������
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS runtime

WORKDIR /app

COPY --from=build /app/out .

EXPOSE 80

ENTRYPOINT ["dotnet", "ProductWebTest.dll"]
