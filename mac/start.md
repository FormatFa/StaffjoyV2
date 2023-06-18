在Docker Desktop中启动
- 启动minik8s
    - 启动推送容器的registry
- 安装nginx，运行脚本,修改host文件    
- 运行ci/dev-build

命令:
暴露服务到host：
用于迁移数据库
minikube service  app-mysql-service --url -n development
用于
minikube service  faraday-service  --url -n development

访问:
staffjoy-v2.local