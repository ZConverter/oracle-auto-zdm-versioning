# oracle-zdm-install
**ZConverter Cloud DR enables you to minimize business data loss by configuring instantaneous recovery systems to the cloud in the event of a disaster or disaster. This article is a manual on how to make it easy for customers to install zdm through the web console.**


## Contents
> **[PREPARE](#prepare)**
> 
> **[ZDM IMAGE](#zdm-iamge)**
> 
> **[ZDM INSTALL](#zdm-install)**
---

## Prepare
1. Oracle cloud account that allows you to create an instance
2. [ZDM Image](#zdm-iamge) url you want to use

## ZDM Iamge

현재 지원되는 ZDM Image는 아래와 같습니다.

<table>
  <tr>
    <th style="text-align:center">OS</th>
    <th style="text-align:center">Version</th>
    <th style="text-align:center">ZDMVersion</th>
    <th style="text-align:center">Image 주소</th>
  </tr>
  <tr>
    <td style="text-align:center">Ubuntu</td>
    <td style="text-align:center">20.04</td>
    <td style="text-align:center">latest</td>
    <td style="text-align:center" colspan="2">
    <a href="https://objectstorage.ap-seoul-1.oraclecloud.com/p/ppovzltxdd7c00VBfLiDOppOmQzr5vAy7sIOF41_WPJFC6eQfUGAcd8quGx6PZfM/n/idffti7li8cs/b/_image/o/ZDM/ubuntu/20.04/zdm_latest">(SEOUL REGION) zdm_img_ubuntu2004_latest</a>
    <a href="https://objectstorage.ap-seoul-1.oraclecloud.com/p/ppovzltxdd7c00VBfLiDOppOmQzr5vAy7sIOF41_WPJFC6eQfUGAcd8quGx6PZfM/n/idffti7li8cs/b/_image/o/ZDM/ubuntu/20.04/zdm_latest">(ASHBURN REGION) zdm_img_ubuntu2004_latest</a>
    </td>
  </tr>
<tr>
    <td style="text-align:center">Ubuntu</td>
    <td style="text-align:center">20.04</td>
    <td style="text-align:center">latest</td>
    <td style="text-align:center"><a href="https://objectstorage.ap-seoul-1.oraclecloud.com/p/ppovzltxdd7c00VBfLiDOppOmQzr5vAy7sIOF41_WPJFC6eQfUGAcd8quGx6PZfM/n/idffti7li8cs/b/_image/o/ZDM/ubuntu/20.04/zdm_v0">zdm_img_ubuntu2004_v0</a></td>
  </tr>
</table>

### Create API-Key
   If you created API keys for the Terraform Set Up Resource Discovery tutorial, then skip this step.

   Create RSA keys for API signing into your **Oracle Cloud Infrastructure account**.

   1. **Log in to the Oracle Cloud site and access the user portal.**

      ![Login](https://raw.githubusercontent.com/ZConverter/oracle-auto-zdm-versioning/createKey/images/login.png) 

