![Evolution X](https://github.com/Evolution-X/manifest/raw/tiramisu/EvoBanner.png)

[![Download Evolution X](https://img.shields.io/sourceforge/dt/evolution-x.svg)](https://sourceforge.net/projects/evolution-x/files/latest/download)

### Adding/Updating a device listing in devices.json

To add a new device to the list of officially supported devices in `devices.json`, follow these steps:

1. Open the `devices.json` file and locate the appropriate location based on alphabetical order by brand and codename.

2. If the listing for your device is already present and you are taking over as the new maintainer, overwrite the existing entry with your details. If not, add a new entry for your device.

3. Fill in the JSON properties with the relevant information for your device. Below is the JSON template with the properties explained:

```json
{
   "brand": "Your_Devices_Brand",
   "codename": "Your_Devices_Codename",
   "name": "Your_Devices_Full_Name",
   "supported_versions": [
      {
         "maintainer_name": "Your_Name",
         "maintainer_url": "Your_Maintainer_Profile_URL",
         "version_code": "Version_Code",
         "version_name": "Version_Name",
         "xda_thread": "Your_XDA_Thread_URL",
         "device_group": "Device_Group"
      }
   ]
}
```

Replace the placeholders with the appropriate values for your device:

- `"Your_Device_Brand"`: The brand or manufacturer of your device (e.g., Google, Samsung, OnePlus, etc.).

- `"Your_Device_Codename"`: The unique codename of your device (e.g., cheetah, star2lte, dumpling, etc.).

- `"Your_Device_Full_Name"`: The name or model name of your device (e.g., Pixel 7 Pro, Galaxy S7, 5T, etc.).

- `"Your_Name"`: The maintainers name (you) for this device.

- `"Your_Maintainer_Profile_URL"`: The URL to your maintainer profile or contact page.

- `"Version_Code"`: The version code for the initial supported version of the ROM for your device (E.g thirteen, fourteen, etc).

- `"Version_Name"`: The version name for the initial supported version of the ROM (E.g Thirteen, Fourteen, etc.).

- `"Your_XDA_Thread_URL"`: The URL to your XDA Developers forum thread of Evolution X.

- `"Device_Group"`: The telegram device specific group (without the @ sign).

Save the changes to `devices.json`.


### Adding your builds/codename.json

Every successful Evolution X build also outputs a `out/target/product/codename/build.zip.json` file. This file contains information specific to the build that is required for OTA (Over-The-Air) updates to work successfully. 

Example:

```json
{
   "datetime": 1688939964,
   "filehash": "2dcbad67de1795861872a286fdddfbfe",
   "filename": "evolution_codename-ota-tq3a.230705.001.b4-07091846-unsigned.zip",
   "id": "f3cedcfef3bbd4edaf699861634bb2ed343b41b96de6dca7124cdbbaef0b5c46",
   "size": 2587033654
}
```

- `datetime`: Unix timestamp representing the date and time when the build was created. It is the number of seconds that have elapsed since January 1, 1970, 00:00:00 UTC.

- `hash`: The hash value (MD5) of the build ZIP file. This helps ensure data integrity and can be used to verify the file's authenticity.

- `filename`: The name of the build's ZIP file, including its extension.

- `id`: The SHA-256 of the build ZIP file. This helps ensure data integrity and can be used to verify the file's authenticity.

- `size`: The size of the build ZIP file in bytes.

Please ensure that you replace the placeholders (datetime, filehash, filename, id, and size) in the second JSON block with the actual values corresponding to your Evolution X build. Additionally, don't forget to include the filename in the URL property. The remaining information is relatively straightforward and self-explanatory.

```json
{
   "datetime": ,
   "donate_url": "",
   "error": false,
   "filehash": ,
   "filename": "",
   "forum_url": "",
   "id": ,
   "maintainer": "",
   "maintainer_url": "",
   "news_url": "https://t.me/EvolutionXOfficial",
   "size": ,
   "telegram_username": "",
   "url": "https://sourceforge.net/projects/evolution-x/files/codename/13/filename/download",
   "version": "Thirteen",
   "website_url": "https://evolution-x.org"
}
```

### Adding your changelogs/codename/build.zip.txt

For every build, a changelog is required to document the changes and updates made in that specific build. This changelog should be saved as changelogs/codename/filename.zip.txt, where codename represents the device codename and filename is the name of the corresponding ZIP file.

### Automating Subsequent Updates with `json_ota_helper.sh`

To simplify the process of updating build-specific information for each release, we've developed a convenient script called `json_ota_helper.sh`. This script automates the task of editing the necessary details in the JSON files for Over-The-Air (OTA) updates.

Here's how to use the `json_ota_helper.sh` script:

1. Execute the script with the following command:
```
./json_ota_helper.sh <input_json>
```

Ensure you replace `<input_json>` with the path to your input JSON file. This JSON file should contain the following properties:

- `datetime`: Unix timestamp of the build.
- `filehash`: MD5 checksum of the build.zip.
- `filename`: Name of the build.zip.
- `id`: SHA-256 checksum of the build.zip.
- `size`: Size of the build.zip in bytes.

2. The script will automatically compare the new JSON data with the existing one stored in `builds/<codename>.json`.

3. If there are any differences, the script will automatically update the relevant fields, including `datetime`, `filehash`, `id`, `size`, `url`, and `filename`.

4. The script will display a comparison of the old and new values for each property, allowing you to review the changes.

5. Additionally, the script will prompt you to add a changelog. You can select an editor to create the changelog, such as Nano, Vim, Gedit, Emacs, VSCode, or enter your own command to open the file.

6. Once the changelog is added, the script will automatically commit the changes, allowing you to push and submit a pull request.


- Example:

![example](https://github.com/Evolution-X-Devices/official_devices/blob/master/assets/json_ota_helper_example.gif)
