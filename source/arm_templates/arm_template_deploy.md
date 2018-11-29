# ARM Template을 이용한 배포

ARM Template을 이용하여 Wordpress를 배포해 본다. 여기서는 Azure Cloud Shell을 이용하여 Azure UI를 이용하지 않고 직접 배포한다.

## 리소스 그룹 만들기

1. [Azure 웹 콘솔 (https://portal.azure.com)](https://portal.azure.com)에 접속한다.

2. 우측 상단에 Cloud Shell 아이콘을 클릭한다.
    > [!메모]
    >
    > Bash로 실행한다. Cloud Shell이 없다면 새로 생성한다.

3. 다음 명령어를 사용하여 Resource Group을 생성한다.
    ```Azurecli
    az group create -g <Resource_group_name> -l southeastasia
    ```

4. 다음 명령어를 사용하여 ARM Template과 Parameter를 받는다.
    ```bash
    curl -O https://raw.githubusercontent.com/krazure/workshop-itpro-101/master/source/arm_templates/azure_template.json
    curl -O https://raw.githubusercontent.com/krazure/workshop-itpro-101/master/source/arm_templates/parameters.json
    ```

5. 다음 명령어를 사용하여 리소스를 배포한다.
    ```Azurecli
    az group deployment create -g <Resource_group_name> --name deploy_wordpress_on_mysql --template-file azure_template.json --parameters parameters.json
    ```

6. Azure UI에서 생성힌 리소스 그룹을 선택한 후 오른쪽에 **Deployments**를 클릭하여 현재 배포 상태를 확인한다.
    > [!메모]
    >
    > 배포가 완료되는데 약 7~8분 정도가 소요된다.

7. 배포가 완료되면 새로운 브라우저 창을 실행하여 VM의 **Public IP address**로 접속하여 Wordpress가 정상적으로 실행되는지 확인한다.

8. 생성된 Resource Group을 삭제한다.
    ```Azurecli
    az group delete -g <Resource_group_name> -y
    ```