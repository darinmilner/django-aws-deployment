import subprocess 
 
def create_dependencies_layer(project_name, function_name):
    requirements_file = "requirements.txt"  # requirements.txt
    output_dir = "./build/"  # temporary directory to store dependencies
        
    subprocess.check_call(f"pip install -r {requirements_file} -t {output_dir}/python".split())
        
    layer_id = f"{project_name}-{function_name}-dependencies"
    
    print(layer_id)