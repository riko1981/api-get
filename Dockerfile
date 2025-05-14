# ���� ������
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build

# ������������� ������� ���������� � ����������
WORKDIR /src

# �������� .csproj ���� � ��������������� �����������
COPY ["ProductWebTest/ProductWebTest.csproj", "ProductWebTest/"]
RUN dotnet restore "ProductWebTest/ProductWebTest.csproj"

# �������� ��������� ����� �������
COPY . .

# ������ ������ � ��������� � ����� /out
RUN dotnet publish "ProductWebTest/ProductWebTest.csproj" -c Release -o /app/out --no-restore

# ���� �������
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS runtime

# ������������� ������� ���������� ��� �������
WORKDIR /app

# �������� ����� �� ����� ������
COPY --from=build /app/out .

# ��������� ���� 80
EXPOSE 80

# ������� ��� ������� ����������
ENTRYPOINT ["dotnet", "ProductWebTest.dll"]
