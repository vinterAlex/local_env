#Depending on the operating system of the host machines(s) that will build or run the containers, the image specified in the FROM statement may need to be changed.
#For more information, please see https://aka.ms/containercompat

FROM microsoft/dotnet:2.1-aspnetcore-runtime-nanoserver-1803 AS base
WORKDIR /app
CMD ["echo","Exposing 80 and 443"]
EXPOSE 80
EXPOSE 443
CMD ["cmd","Exposed successfully!"]

FROM microsoft/dotnet:2.1-sdk-nanoserver-1803 AS build
CMD ["echo","Assigning WORKDIR..."]
WORKDIR /src
CMD ["echo","WORKDIR assigned!"]
CMD ["echo","COPYING SolutionProject and restoring it..."]
COPY ["HealthPages/HealthPages.csproj", "HealthPages/"]
RUN dotnet restore "HealthPages/HealthPages.csproj"
COPY . .
WORKDIR "/src/HealthPages"
CMD ["echo","Project Solution building..."]
RUN dotnet build "HealthPages.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "HealthPages.csproj" -c Release -o /app
CMD ["echo","Build finished..."]
FROM base AS final
WORKDIR /app
CMD ["echo","Copying from Publicsh to local..."]
COPY --from=publish /app .
CMD ["echo","Creating entry point DOTNET from HealthPages.dll..."]
ENTRYPOINT ["dotnet", "HealthPages.dll"]
CMD ["echo","Build successfully.Enjoy!!!!!"]
