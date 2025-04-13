import asyncio
import os
from pathlib import Path

from azure.identity.aio import DefaultAzureCredential
from azure.storage.blob.aio import BlobServiceClient
from dotenv import find_dotenv, load_dotenv
from loguru import logger


class BlobProcessor:
    """
    Manipulate Azure Blob Storage objects
    """

    async def list_blob_flats(self, blob_service_client: BlobServiceClient, container_name: str):
        blobs = []
        i = 1
        container_client = blob_service_client.get_container_client(container=container_name)
        async for blob in container_client.list_blobs():
            logger.info(f"Blob-{i}: {blob.name}")
            blobs.append(blob.name)
            i += 1
        return blobs

    async def download_blob_to_file(
        self, blob_service_client: BlobServiceClient, container_name: str, blob_name: str, tgt_path: str
    ) -> None:
        blob_client = blob_service_client.get_blob_client(container=container_name, blob=blob_name)
        blob_name = blob_name.split("/")[-1]
        filepath = Path(f"{tgt_path}/{blob_name}")
        with filepath.open("wb") as sample_blob:
            download_stream = await blob_client.download_blob()
            data = await download_stream.readall()
            sample_blob.write(data)

    async def pdf2text(
        self, blob_service_client: BlobServiceClient, container_name: str, tgt_path: str
    ) -> None:
        all_model_files = await self.list_blob_flats(blob_service_client, container_name)
        for file in all_model_files:
            await self.download_blob_to_file(blob_service_client, container_name, file, tgt_path)

    async def upload_blob_files(
        self,
        blob_service_client: BlobServiceClient,
        tgt_container_name: str,
        blob_names: list[str],
        src_path: str,
    ) -> None:
        tgt_container_client = blob_service_client.get_container_client(container=tgt_container_name)
        for blob_name in blob_names:
            logger.info(f"Blob Name: {blob_name}")
            filepath = Path(f"{src_path}/{blob_name}")
            with filepath.open("rb") as data:
                await tgt_container_client.upload_blob(name=blob_name, data=data, overwrite=True)


async def main(base_path: str) -> None:
    account_url = "https://aistorage7xbl.blob.core.windows.net"
    container_map = {"src": "func-app-src-7xbl", "tgt": "func-app-tgt-7xbl", "model": "aiblob7xbl"}
    default_credential = DefaultAzureCredential()
    local_storage_map = {
        "src": f"{base_path}/src_files",
        "tgt": f"{base_path}/tgt_files",
        "model": f"{base_path}/SmolDocling-256M-preview",
    }
    for _, v in local_storage_map.items():
        Path(v).mkdir(parents=True, exist_ok=True)

    sample = BlobProcessor()
    async with BlobServiceClient(account_url, credential=default_credential) as blob_service_client:
        all_blobs = await sample.list_blob_flats(blob_service_client, container_map["src"])
        logger.info("Listed All Blobs in Source Container!!")

        for blob in all_blobs:
            await sample.download_blob_to_file(
                blob_service_client, container_map["src"], blob, local_storage_map["src"]
            )
        logger.info("Downloaded all blobs from src container to local storage!!")

        await sample.pdf2text(blob_service_client, container_map["model"], local_storage_map["model"])
        logger.info("Downloaded all model files from model container to local storage!!")

        await sample.upload_blob_files(
            blob_service_client, container_map["tgt"], all_blobs, local_storage_map["tgt"]
        )
        logger.info("Uploaded all blobs to tgt container from local storage!!")


if __name__ == "__main__":
    load_dotenv(find_dotenv())
    if "LOCAL" in os.environ:
        base_path = "./tmp"
    else:
        base_path = "/tmp"
    asyncio.run(main(base_path))
