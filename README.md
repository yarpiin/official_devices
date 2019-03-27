# evolution-x
## Official devices application

Devices repository: https://github.com/evolution-x-Devices

Before you open a pull request to add your device into our list of official devices, you should know a few simple things:

### 1. To turn into a maintainer of evolution-x:

1.2 - You must have a way to check your builds, on your own way, having the device, or send the builds for someone test. Completely blind and/or untested builds aren't allowed.

1.3 - Appliers that comproved have the device, will have the preference on taking the maintainship.

1.4 - You must have knowledge of git.

1.5 - You must do an unofficial build and make the device stable for daily usage before applying.

1.6 - You should have your device sources open for us take a look.

1.7 - You mustn't be a placeholder of another maintainer that was removed. The pull request that are considered of that kind won't be accepted.

### 2. Maintainers conduct notes:

2.1 - The maintainers should upload theirs trees on https://github.com/evolution-x-Devices

2.2 - The maintainers should test every update before upload in our OTA.

2.3 - The maintainers must keep the authorship of Git commits on everything that they'll make a change, even it's your device tree, kernel or ROM sources. Lots of git commit --amend and force-pushes are acceptable.

2.4 - Relationships fights can be done in PM on Telegram or XDA. 

2.5 - The maintainers also need to add 'export CUSTOM_BUILD_TYPE=OFFICIAL' in their build environment so OTA app will be included.

### 3. JSON params

##### devices.json
| Param | Description | Required |
|--|--|--|
| name | Device name | Yes |
| brand | Device manufacturer | Yes |
| codename | Device codename, eg: falcon | Yes |
| version_code | Version code, lowercase, eg: oreo | Yes |
| version_name | Version name, will be shown on download portal, eg: Oreo | Yes |
| maintainer_name | Your name | Yes |
| maintainer_url | Your personal URL, eg: https://github.com/jhenrique09/ or https://forum.xda-developers.com/member.php?u=6519039 | No  |
| xda_thread | XDA thread URL, eg: https://forum.xda-developers.com/g5-plus/development/rom-pixel-experience-t3704064 | No |

##### builds/your_device_codename.json
| Param | Description | Required |
|--|--|--|
| filename | Build file (.zip) name | Yes |
| filesize | Build file (.zip) size (in bytes) | Yes |
| filehash | Build file (.zip) md5 hash | Yes |
| datetime | Build file (.zip) time | Yes |
| id | Build file (.zip)  hash | Yes |
