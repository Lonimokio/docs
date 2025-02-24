import os
import shutil
import pygit2

def clone_repo(repo_url, clone_path):
    if os.path.exists(clone_path):
        shutil.rmtree(clone_path)
    pygit2.clone_repository(repo_url, clone_path)

def fetch_docs_from_repo(repo_path, output_path):
    for root, dirs, files in os.walk(repo_path):
        if 'docs' in dirs:
            docs_path = os.path.join(root, 'docs')
            relative_path = os.path.relpath(docs_path, repo_path)
            dest_path = os.path.join(output_path, relative_path)
            if os.path.exists(dest_path):
                shutil.rmtree(dest_path)
            shutil.copytree(docs_path, dest_path)
            print(f"Copied docs from {docs_path} to {dest_path}")

def fetch_docs_from_submodules(repo_path, output_path):
    repo = pygit2.Repository(repo_path)
    for submodule in repo.listall_submodules():
        submodule_path = os.path.join(repo_path, submodule)
        submodule_name = os.path.basename(submodule_path)
        submodule_repo_path = os.path.join(repo_path, submodule_name)
        if os.path.exists(submodule_repo_path):
            fetch_docs_from_repo(submodule_repo_path, os.path.join(output_path, submodule_name))
            fetch_docs_from_submodules(submodule_repo_path, os.path.join(output_path, submodule_name))

def main():
    repo_url = "https://github.com/pvarki/docker-rasenmaeher-integration.git"
    clone_path = "fetched_docs"
    output_path = "fetched_docs"
    
    print(f"Cloning repository from {repo_url} to {clone_path}")
    clone_repo(repo_url, clone_path)
    print(f"Repository cloned to {clone_path}")
    
    print(f"Fetching docs from repository at {clone_path} to {output_path}")
    fetch_docs_from_repo(clone_path, output_path)
    
    print(f"Fetching docs from submodules in repository at {clone_path} to {output_path}")
    fetch_docs_from_submodules(clone_path, output_path)
    print("Fetching completed")

if __name__ == "__main__":
    main()