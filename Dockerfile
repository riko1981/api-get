# ���� ������
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /app

# �������� csproj � ��������������� �����������
COPY *.csproj ./
RUN dotnet restore

# �������� ��������� �����
COPY . ./
RUN dotnet publish -c Release -o /out

# ���� ��������
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS runtime
WORKDIR /app
COPY --from=build /out ./

EXPOSE 80
ENTRYPOINT ["dotnet", "ProductWebTest.dll"]
