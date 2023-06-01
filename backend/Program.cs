using Backend;
using Backend.Adapters;
using Backend.ImageUploadModule;
using Backend.Implementations;
using Backend.InventoryModule;
using Backend.MockImplementations;
using Backend.ProductCatalogModule;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);
builder.WebHost.UseIISIntegration();
IConfiguration config = builder.Configuration
    .AddJsonFile("appsettings.json", optional: false, reloadOnChange: true)
    .AddEnvironmentVariables()
    .Build();
builder.Services.AddSingleton(config);
// TODO
builder.Services.AddDbContext<BackendDbContext>(opt => opt.UseInMemoryDatabase("mock"));
builder.Services.AddDatabaseDeveloperPageExceptionFilter();
builder.Services.AddScoped<IProductRepository, ProductRepository>();
builder.Services.AddScoped<IInventoryRepository, InventoryRepository>();
builder.Services.AddScoped<IImageRepository, ImageRepository>();
var app = builder.Build();

app.UseHttpsRedirection();

// When implementing Auth, uncomment this line:
// app.MapGet("/", [Authorize] () => "Hello World!");
// and comment this one
app.MapGet("/", () => "Hello World!");

MockAuthorizationService mockAuthorizationService = new();

new ProductCatalogModule()
    // TODO replace with AD Auth
    .AddModule(new AuthorizationAdapters(mockAuthorizationService.Authorize))
    .ToList()
    .ForEach(endpoint => app.MapMethods(endpoint.Path, new[] { endpoint.Method.Method }, endpoint.Handler));

new InventoryModule()
    // TODO replace with AD Auth
    .AddModule(new AuthorizationAdapters(mockAuthorizationService.Authorize))
    .ToList()
    .ForEach(endpoint => app.MapMethods(endpoint.Path, new[] { endpoint.Method.Method }, endpoint.Handler));

new ImageUploadModule()
    // TODO replace with AD Auth and Blob Storage implementation
    .AddModule(new AuthorizationAdapters(mockAuthorizationService.Authorize), new MockImageUploadService())
    .ToList()
    .ForEach(endpoint => app.MapMethods(endpoint.Path, new[] { endpoint.Method.Method }, endpoint.Handler));

app.Run();
