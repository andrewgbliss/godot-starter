#!/usr/bin/env python3
import argparse
import shutil
from pathlib import Path
import sys
import re
import subprocess

TEMPLATE_PATH = Path("D:/Code/Code/andrewgbliss/godot-starter")
GODOT_PROJECT_ROOT_PATH = Path("D:/Code/Code/andrewgbliss")


# python3 godot_new.py --name="My New Game"


def to_snake_case(name: str) -> str:
    """
    Convert a name to snake_case.
    Example: 'My New Game' -> 'my_new_game'
    """
    # Replace spaces and hyphens with underscores
    s = re.sub(r'[\s\-]+', '_', name.strip())
    # Convert to lowercase
    s = s.lower()
    # Remove any non-alphanumeric characters except underscores
    s = re.sub(r'[^a-z0-9_]', '', s)
    # Remove leading/trailing underscores and collapse multiple underscores
    s = re.sub(r'_+', '_', s).strip('_')
    return s or "new_game"


def replace_game_name_in_file(file_path: Path, snake_case_name: str) -> None:
    """
    Replace $GAME_NAME with snake_case_name in a file if it contains $GAME_NAME.
    """
    try:
        content = file_path.read_text(encoding="utf-8")
        if "$GAME_NAME" in content:
            new_content = content.replace("$GAME_NAME", snake_case_name)
            file_path.write_text(new_content, encoding="utf-8")
            print(f"[INFO] Replaced $GAME_NAME in: {file_path}")
    except Exception as e:
        print(f"[WARN] Could not process file {file_path}: {e}", file=sys.stderr)


def replace_game_name(directory: Path, snake_case_name: str) -> None:
    files_to_replace = ["export_presets.cfg", "project.godot", "README.md"]
    for file_name in files_to_replace:
        file_path = directory / file_name
        if file_path.exists():
            replace_game_name_in_file(file_path, snake_case_name)

def run_bash_script(script_path: Path, working_dir: Path, script_name: str, *args, success_message: str = None) -> bool:
    """
    Run a bash script with optional arguments.
    
    Args:
        script_path: Path to the bash script
        working_dir: Working directory to run the script in
        script_name: Name of the script (for logging)
        *args: Additional arguments to pass to the script
        success_message: Optional custom success message
    
    Returns:
        True if the script ran successfully, False otherwise
    """
    if not script_path.exists():
        print(f"[WARN] {script_name} not found at: {script_path}", file=sys.stderr)
        return False
    
    print(f"[INFO] Running {script_name}...")
    try:
        cmd = ["bash", str(script_path)] + list(args)
        subprocess.run(cmd, cwd=str(working_dir), check=True)
        if success_message:
            print(f"[INFO] {success_message}")
        return True
    except subprocess.CalledProcessError as e:
        print(f"[WARN] Failed to run {script_name}: {e}", file=sys.stderr)
        return False
    except FileNotFoundError:
        print(f"[WARN] bash not found. Skipping {script_name}.", file=sys.stderr)
        return False


def main():
    parser = argparse.ArgumentParser(
        description="Create a new Godot project from a template."
    )
    parser.add_argument(
        "--name",
        required=True,
        help="Name of the new game project (will be converted to snake_case for folder name and $GAME_NAME replacement)."
    )

    args = parser.parse_args()

    # Convert name to snake_case for folder name and replacement
    snake_case_name = to_snake_case(args.name)
    
    # Create destination path
    dst_root = GODOT_PROJECT_ROOT_PATH / snake_case_name

    # Check if template exists
    if not TEMPLATE_PATH.exists():
        print(f"[ERROR] Template path does not exist: {TEMPLATE_PATH}", file=sys.stderr)
        sys.exit(1)

    # Check if destination already exists
    if dst_root.exists():
        print(f"[ERROR] Destination path already exists: {dst_root}", file=sys.stderr)
        sys.exit(1)

    # Copy the entire template to the destination, excluding android and build folders
    def ignore_func(dir, names):
        ignored = set()
        # Exclude android and build folders at any level
        ignored.update(name for name in names if name in ('android', 'build', '.godot', '.git'))
        return ignored
    
    print(f"[INFO] Copying template from:\n       {TEMPLATE_PATH}\n    →  {dst_root}")
    shutil.copytree(TEMPLATE_PATH, dst_root, ignore=ignore_func)

    # Delete .git folder if it exists
    git_folder = dst_root / ".git"
    if git_folder.exists():
        print(f"[INFO] Deleting .git folder...")
        shutil.rmtree(git_folder)

    # Replace $GAME_NAME in all files
    print(f"[INFO] Replacing $GAME_NAME with '{snake_case_name}' in all files...")
    replace_game_name(dst_root, snake_case_name)

    # Run init-new.sh script
    init_new_script = TEMPLATE_PATH / "scripts" / "bash" / "init-new.sh"
    run_bash_script(init_new_script, dst_root, "init-new.sh", success_message="Build directories created.")

    # Run git-new.sh script
    git_new_script = TEMPLATE_PATH / "scripts" / "bash" / "git-new.sh"
    run_bash_script(git_new_script, dst_root, "git-new.sh", snake_case_name, success_message="Git repository initialized and pushed.")

    print(f"[DONE] New project created at: {dst_root}")


if __name__ == "__main__":
    main()
