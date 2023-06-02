using Backend.ImageUploadModule;
using Azure.Storage.Blobs;
using Azure.Storage.Blobs.Models;

namespace Backend.MockImplementations;

public class ImageUploadService : IImageStorageService
{
    private readonly IConfiguration _config;

    public ImageUploadService(IConfiguration config) {
        _config = config;
    }
    public async Task<string> UploadImageAsync(Guid imageId, Stream imageStream)
    {
        BlobServiceClient blobServiceCLient = new BlobServiceClient(_config.GetConnectionString("storage"));

        BlobContainerClient blobContainerClient = blobServiceCLient.GetBlobContainerClient("mycoursestorageaccount2");
        await blobContainerClient.CreateIfNotExistsAsync(PublicAccessType.BlobContainer);

        BlobClient blobClient = blobContainerClient.GetBlobClient(imageId.ToString());

        await blobClient.UploadAsync(imageStream);

        string blobUrl = blobClient.Uri.ToString();

        return blobUrl;
    }
}
