# Evolution X
## Official Support Guidelines & Rules

[Official Support Application](https://docs.google.com/forms/d/e/1FAIpQLSe6InJeF09OMKV1G6-o9z0qhSebqvPAv4xyAuF2Ex8g7zJhiA/viewform) | [XDA Thread Template](https://pastebin.com/6F2Zgf3Z) | [Devices Repository](https://github.com/Evolution-X-Devices)

Before you submit a pull request to add your device to our list of official devices, you should know a few simple things:

### 1. To become a maintainer of Evolution X:

1.2 - You must have a way to check your builds. Either owning the device, or sending builds to a reliable/trusted person to test for you. Completely blind and/or untested builds are not permitted.

1.3 - Applicants that physically own the device, will have the preference on receiving maintainship.

1.4 - You MUST have knowledge of git.

1.5 - You MUST compile an unofficial build and make the device stable for daily usage before applying.

1.6 - You MUST have your device sources publicly available for us take a look at.

1.7 - You mustn't be a placeholder of another maintainer that was removed. Pull request's considered of that nature won't be accepted.

### 2. Maintainers code of conduct:

2.1 - Maintainers MUST import their trees to https://github.com/Evolution-X-Devices

2.2 - Maintainers MUST test every update before uploading/Pushing OTA.

2.3 - Maintainers MUST keep the authorship of Git commits, even if it's your device tree, kernel or ROM source. Lots of git commit --amend and force-pushes are acceptable.

2.4 - Relationships fights can be done in PM on Telegram or XDA. 

2.5 - Maintainers also need to Add/Execute 'export CUSTOM_BUILD_TYPE=OFFICIAL' In/Against their build environment in order to compile as official with OTA Updater.

### 3. JSON Parameters

##### devices.json
| Param | Description | Required |
|--|--|--|
| name | Device name | Yes |
| brand | Device manufacturer | Yes |
| codename | Device codename, eg: tissot | Yes |
| version_code | Version code, lowercase, eg: pie | Yes |
| version_name | Version name, will be shown on download portal, eg: pie | Yes |
| maintainer_name | Your name | Yes |
| maintainer_url | Your personal URL, eg: https://github.com/stallix or https://forum.xda-developers.com/member.php?u=4936496 | No  |4936496
| xda_thread | XDA thread URL, eg: https://forum.xda-developers.com/mi-a1/development/rom-pe-evolution-t3901369 | No |

#### Example

```

{
         "error":false,
         "filename":"EvolutionX_tissot-9.0-20190709-0928-OFFICIAL.zip",
         "datetime": 1562664466,
         "size": 858320382,
         "url":"https://sourceforge.net/projects/evolution-x/files/tissot/EvolutionX_tissot-9.0-20190709-0928-OFFICIAL.zip/download",
         "filehash":"084da69fc53c0aa1625c1775d947b615",
         "version":"Pie",
         "id":"6f4b6cdc954d878fe4f2e80628bddd19713346f57a484b43a9ff6dcc55ae2419",
         "website_url":"https://evolutionx.ml",
         "news_url":"https://t.me/EvolutionXNews",
         "donate_url":"https://www.paypal.me/joeyhuab",
         "maintainer":"Joey Huab (Stallix)",
         "maintainer_url":"https://forum.xda-developers.com/member.php?u=4936496",
         "telegram_username":"Stallix",
         "forum_url":"https://forum.xda-developers.com/mi-a1/development/rom-pe-evolution-t3901369"
}
```
