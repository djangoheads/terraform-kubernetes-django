from constructs import Construct
from cdktf import App, TerraformStack
from cdktf_cdktf_provider_kubernetes import job, deployment, provider, service
import dotenv


class MyStack(TerraformStack):
    def __init__(self, scope: Construct, id: str):
        super().__init__(scope, id)

        import yaml
        with open('docker-compose.yml', 'r') as yaml_file:
            resources = yaml.safe_load(yaml_file)

        provider.KubernetesProvider(self, 'k8s-provider',
                                    config_context="minikube",
                                    config_path="~/.kube/config")

        init_status_service_map = {}
        counter_depends_service_map = {}

        for resource_name, resource_data in resources['services'].items():
            init_status_service_map[resource_name] = None

            counter_depends = 0
            if resource_data.get('depends_on'):
                counter_depends = len(resource_data.get('depends_on'))

            counter_depends_service_map[resource_name] = counter_depends

        service_sorted_map = dict(sorted(counter_depends_service_map.items(), key=lambda x: x[1]))
        self.init_resources(resources['services'], init_status_service_map, service_sorted_map)

    def init_resources(self, resources: any, init_status_service_map: dict, counter_depends_service_map: dict):
        for name, counter in counter_depends_service_map.items():
            service_res = resources[name]
            depends_on = []

            if service_res.get('x-depends'):
                depends_on.append(init_status_service_map[service_res.get('x-depends')])

            if service_res.get('x-type') == 'job':
                job_inst = job.Job(self, f"job-{name}",
                                   metadata={
                                       'name': name,
                                       'namespace': 'default',
                                   },
                                   depends_on=depends_on,
                                   spec={
                                       'template': {
                                           'metadata': {
                                               'labels': {
                                                   'app': name,
                                               },
                                           },
                                           'spec': {
                                               'container': [
                                                   {
                                                       'image': service_res.get('image'),
                                                       'name': 'main',
                                                       'command': ["/home/app/bin/entrypoint.sh"],
                                                       'args': [service_res.get('command')]
                                                   },
                                               ],
                                           },
                                       }
                                   })
                init_status_service_map[name] = job_inst

            elif service_res.get('x-type') == 'service':
                env_vars = dotenv.dotenv_values("docker-compose.env")
                env_var_objects = [{"name": key, "value": env_vars[key]} for key in env_vars]
                container_config = {
                    'image': service_res.get('image'),
                    'name': 'main',
                    'env': env_var_objects
                } | ({'command': ["/home/app/bin/entrypoint.sh"], 'args': [service_res.get('command')]} if service_res.get('command') else {})
                deployment_service = deployment.Deployment(self, f"deployment-{name}",
                                                           metadata={
                                                               'labels': {
                                                                   'app': name
                                                               },
                                                               'name': name
                                                           },
                                                           depends_on=depends_on,
                                                           spec={
                                                               'replicas': "1",
                                                               'selector': {
                                                                   'match_labels': {
                                                                       'app': name
                                                                   }
                                                               },
                                                               'template': {
                                                                   'metadata': {
                                                                       'labels': {
                                                                           'app': name
                                                                       }
                                                                   },
                                                                   'spec': {
                                                                       'container': [
                                                                           container_config,
                                                                       ]
                                                                   }
                                                               }
                                                           }
                                                           )
                depends_on.append(deployment_service)
                init_status_service_map[name] = deployment_service
                service.Service(self, f"service-{name}",
                                metadata={
                                    'name': name,
                                    'namespace': 'default'
                                },
                                depends_on=depends_on,
                                spec={
                                    'port': [{
                                        'port': int(service_res.get('x-port')),
                                        'target_port': int(service_res.get('x-port'))
                                    }],
                                    'selector': {
                                        'app': name
                                    }
                                }
                                )


app = App()
MyStack(app, "cdltf")

app.synth()
