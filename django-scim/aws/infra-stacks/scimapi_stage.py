from pathlib import Path
from aws_cdk import (
    aws_ec2 as ec2,
    aws_ecs as ecs,
    aws_ecs_patterns as ecs_patterns,
    CfnOutput,
    Stack,
)
from constructs import Construct


class SimApiStack(Stack):

    def __init__(self, scope: Construct, construct_id: str, vpc: ec2.Vpc, cluster: ecs.Cluster, **kwargs) -> None:
        super().__init__(scope, construct_id, **kwargs)
        
        src_path = Path(__file__).parents[2].joinpath("api")
        if not src_path.exists():
            print(f"path {src_path} does not exist")
            
        self.service = ecs_patterns.ApplicationLoadBalancedFargateService(
            self,
            "service",
            cluster=cluster,
            task_image_options= ecs_patterns.ApplicationLoadBalancedTaskImageOptions(
                 image=ecs.ContainerImage.from_asset(str(src_path)),
                container_name="scim-api",
                container_port=8000,
            ),
            task_subnets=ec2.SubnetSelection(subnet_type=ec2.SubnetType.PRIVATE_WITH_NAT)
        )
        
        self.service.target_group.configure_health_check(path="/admin/")  # TODO: Change to health check route
        
        CfnOutput(self, "admin-output", value=f"http://{self.service.load_balancer.load_balancer_dns_name}/admin") #TODO change to hhealth check endpoint


