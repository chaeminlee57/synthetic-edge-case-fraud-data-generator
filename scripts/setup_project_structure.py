import os
from pathlib import Path

def create_project_structure():
    """Create all necessary directories and placeholder files."""
    
    # Define directory structure
    directories = [
        # API directories
        "api/routes",
        "api/schemas",
        "api/middleware",
        "api/dependencies",
        
        # Core modules
        "core",
        
        # Model directories
        "models/ctgan",
        "models/timegan",
        "models/graphrnn",
        "models/ensemble",
        
        # Validation directories
        "validation/privacy",
        "validation/quality",
        
        # Monitoring directories
        "monitoring/drift_detection",
        "monitoring/dashboard",
        "monitoring/alerts",
        
        # Data directories
        "data/taxonomies",
        "data/processors",
        "data/raw",
        "data/processed",
        "data/generated",
        "data/examples",
        
        # Scripts
        "scripts",
        
        # Testing directories
        "tests/unit",
        "tests/integration",
        "tests/performance",
        "tests/fixtures",
        
        # MLflow
        "mlflow/experiments",
        "mlflow/models",
        
        # Docker
        "docker",
        
        # Config
        "config",
        
        # Logs
        "logs",
        
        # Documentation
        "docs",
        
        # Notebooks (for experimentation)
        "notebooks"
    ]
    
    # Create directories
    for directory in directories:
        Path(directory).mkdir(parents=True, exist_ok=True)
        print(f"✓ Created directory: {directory}")
    
    # Create __init__.py files for Python packages
    python_packages = [
        "api", "api/routes", "api/schemas", "api/middleware", "api/dependencies",
        "core",
        "models", "models/ctgan", "models/timegan", "models/graphrnn", "models/ensemble",
        "validation", "validation/privacy", "validation/quality",
        "monitoring", "monitoring/drift_detection", "monitoring/dashboard",
        "data", "data/processors",
        "tests"
    ]
    
    for package in python_packages:
        init_file = Path(package) / "__init__.py"
        init_file.touch(exist_ok=True)
        print(f"✓ Created __init__.py in: {package}")
    
    print("\n✅ Project structure created successfully!")

if __name__ == "__main__":
    create_project_structure()
