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

   - **The ZDM images currently supported are as follows.**
   - **Check [ZDM Install](#zdm-install) for instructions on how to use the address below.**

        <table>
        <tr>
            <th style="text-align:center">OS</th>
            <th style="text-align:center">Version</th>
            <th style="text-align:center">ZDMVersion</th>
            <th style="text-align:center">Image url</th>
        </tr>
        <tr>
            <td style="text-align:center">Ubuntu</td>
            <td style="text-align:center">20.04</td>
            <td style="text-align:center">latest</td>
            <td style="text-align:center" rowspan="2">
            <a href="https://objectstorage.ap-seoul-1.oraclecloud.com/p/ppovzltxdd7c00VBfLiDOppOmQzr5vAy7sIOF41_WPJFC6eQfUGAcd8quGx6PZfM/n/idffti7li8cs/b/_image/o/ZDM/ubuntu/20.04/zdm_latest">(ASHBURN REGION) ZDM IMAGE Ubuntu 20.04 Latest<br></a>
            <a href="https://objectstorage.us-ashburn-1.oraclecloud.com/p/fe4t-3LPvsmHCHwV1TMvQGkqELC_pmuTjVVcXuw-9ed4ZoqxMx1ADhqfDejXiEUN/n/idffti7li8cs/b/_image/o/ZDM/ubuntu/20.04/zdm_latest">(SEOUL REGION) ZDM IMAGE Ubuntu 20.04 Latest</a>
            </td>
        </tr>
        <tr></tr>
        <tr>
            <td style="text-align:center">Ubuntu</td>
            <td style="text-align:center">20.04</td>
            <td style="text-align:center">v0</td>
            <td style="text-align:center" rowspan="2">
            <a href="https://objectstorage.ap-seoul-1.oraclecloud.com/p/ppovzltxdd7c00VBfLiDOppOmQzr5vAy7sIOF41_WPJFC6eQfUGAcd8quGx6PZfM/n/idffti7li8cs/b/_image/o/ZDM/ubuntu/20.04/zdm_v0">(ASHBURN REGION) ZDM IMAGE Ubuntu 20.04 v0<br></a>
            <a href="https://objectstorage.us-ashburn-1.oraclecloud.com/p/fe4t-3LPvsmHCHwV1TMvQGkqELC_pmuTjVVcXuw-9ed4ZoqxMx1ADhqfDejXiEUN/n/idffti7li8cs/b/_image/o/ZDM/ubuntu/20.04/zdm_v0">(SEOUL REGION) ZDM IMAGE Ubuntu 20.04 v0</a>
            </td>
        </tr>
        <tr></tr>
        </table>

## ZDM Install
   이 스텝은 ZDM이 설치되어 있는 이미지를 임포트한 뒤 생성하는 방법을 설명합니다. 기본적으로 Oracle Cloud에 로그인이 되어있다는 전제하에 해당 가이드를 작성하였습니다.

   Create RSA keys for API signing into your **Oracle Cloud Infrastructure account**.

   1. **Log in to the Oracle Cloud site and access the user portal.**

      ![Login](https://raw.githubusercontent.com/ZConverter/oracle-auto-zdm-versioning/createKey/images/login.png) 

