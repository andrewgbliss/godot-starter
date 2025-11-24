#!/usr/bin/env python3
import argparse
import shutil
from pathlib import Path
import sys

TEMPLATE_PATH = Path("D:/Code/Code/andrewgbliss/godot-starter")
GODOT_PROJECT_ROOT_PATH = Path("D:/Code/Code/andrewgbliss")
CURRENT_PROJECT_PATH = Path("D:/Code/Code/andrewgbliss/tom-gobbler")


# python3 godot_sync.py --godot=input-map,autoloads
# python3 godot_sync.py --folders=blisscode,assets,addons,data,scenes,scripts,theme
# python3 godot_sync.py --files=export_presets.cfg
# python3 godot_sync.py --files=project.godot
# python3 godot_sync.py --name="My New Game"


def read_text(path: Path) -> str:
    try:
        return path.read_text(encoding="utf-8")
    except FileNotFoundError:
        print(f"[ERROR] File not found: {path}", file=sys.stderr)
        sys.exit(1)


def write_text(path: Path, content: str) -> None:
    path.write_text(content, encoding="utf-8")


def find_section_bounds(text: str, section_name: str):
    """
    Find the start/end indices of a [section_name] block in a Godot project.godot-like file.
    Returns (start_idx, end_idx) or (None, None) if not found.
    """
    lines = text.splitlines(keepends=True)
    start_idx = None
    end_idx = None

    header = f"[{section_name}]"

    line_start = None
    for i, line in enumerate(lines):
        if line.strip() == header:
            line_start = i
            break

    if line_start is None:
        return None, None

    start_idx = sum(len(l) for l in lines[:line_start])

    line_end = len(lines)
    for i in range(line_start + 1, len(lines)):
        stripped = lines[i].lstrip()
        if stripped.startswith("[") and "]" in stripped:
            line_end = i
            break

    end_idx = sum(len(l) for l in lines[:line_end])
    return start_idx, end_idx


def replace_or_append_section(target_text: str, src_text: str, section_name: str) -> str:
    """
    Replace the entire [section_name] section in target_text with the section
    from src_text. If the section doesn't exist in target, append it to the end.
    """
    src_start, src_end = find_section_bounds(src_text, section_name)
    if src_start is None:
        print(f"[WARN] Section [{section_name}] not found in source project.godot, skipping.")
        return target_text

    src_section = src_text[src_start:src_end]

    tgt_start, tgt_end = find_section_bounds(target_text, section_name)

    if tgt_start is None:
        if not target_text.endswith("\n"):
            target_text += "\n"
        target_text += "\n" + src_section.strip("\n") + "\n"
        print(f"[INFO] Added new section [{section_name}] to target project.godot.")
    else:
        target_text = target_text[:tgt_start] + src_section + target_text[tgt_end:]
        print(f"[INFO] Replaced section [{section_name}] in target project.godot.")

    return target_text


def copy_folder(src_root: Path, dst_root: Path, folder_name: str):
    src_dir = src_root / folder_name
    dst_dir = dst_root / folder_name

    if not src_dir.exists():
        print(f"[WARN] Folder '{folder_name}' does not exist in source project: {src_dir}")
        return

    dst_dir.parent.mkdir(parents=True, exist_ok=True)

    print(f"[INFO] Copying folder '{folder_name}' from\n       {src_dir}\n    →  {dst_dir}")
    shutil.copytree(src_dir, dst_dir, dirs_exist_ok=True)


def sync_godot_config(src_root: Path, dst_root: Path, godot_items: list):
    """
    Sync Godot config sections (input-map, autoloads) from source to destination project.
    """
    src_project = src_root / "project.godot"
    dst_project = dst_root / "project.godot"
    
    if not src_project.exists():
        print(f"[ERROR] Source project.godot not found at: {src_project}", file=sys.stderr)
        sys.exit(1)
    
    if not dst_project.exists():
        print(f"[ERROR] Target project.godot not found at: {dst_project}", file=sys.stderr)
        sys.exit(1)

    src_text = read_text(src_project)
    dst_text = read_text(dst_project)

    # Map godot items to section names
    section_map = {
        "input-map": "input",
        "autoloads": "autoload",
    }

    for item in godot_items:
        section_name = section_map.get(item)
        if section_name:
            print(f"[INFO] Syncing {item} ([{section_name}] section)…")
            dst_text = replace_or_append_section(dst_text, src_text, section_name)
        else:
            print(f"[WARN] Unknown Godot config item: {item}, skipping.")

    # Save project.godot
    write_text(dst_project, dst_text)
    print(f"[INFO] Updated target project.godot at: {dst_project}")


def copy_file(src_root: Path, dst_root: Path, file_name: str):
    src_file = src_root / file_name
    dst_file = dst_root / file_name

    if not src_file.exists():
        print(f"[WARN] File '{file_name}' does not exist in source project: {src_file}")
        return

    dst_file.parent.mkdir(parents=True, exist_ok=True)

    print(f"[INFO] Copying file '{file_name}' from\n       {src_file}\n    →  {dst_file}")
    shutil.copy2(src_file, dst_file)


def sync_folders(src_root: Path, dst_root: Path, folder_names: list):
    """
    Sync folders from source to destination project.
    """
    for folder_name in folder_names:
        copy_folder(src_root, dst_root, folder_name)


def sync_files(src_root: Path, dst_root: Path, file_names: list):
    """
    Sync individual files from source to destination project.
    """
    for file_name in file_names:
        copy_file(src_root, dst_root, file_name)


def replace_game_name(dst_root: Path, game_name: str):
    """
    Replace $GAME_NAME with the provided game name in specific project files.
    """
    files_to_replace = ["export_presets.cfg", "project.godot", "README.md"]
    
    replaced_count = 0
    
    for file_name in files_to_replace:
        file_path = dst_root / file_name
        
        if not file_path.exists():
            print(f"[WARN] File '{file_name}' does not exist, skipping.")
            continue
        
        try:
            content = file_path.read_text(encoding='utf-8')
            
            if '$GAME_NAME' in content:
                new_content = content.replace('$GAME_NAME', game_name)
                file_path.write_text(new_content, encoding='utf-8')
                print(f"[INFO] Replaced $GAME_NAME with '{game_name}' in: {file_name}")
                replaced_count += 1
            else:
                print(f"[INFO] No $GAME_NAME found in: {file_name}")
        except (UnicodeDecodeError, PermissionError) as e:
            print(f"[WARN] Could not process '{file_name}': {e}")
            continue
    
    if replaced_count > 0:
        print(f"[INFO] Replaced $GAME_NAME in {replaced_count} file(s).")
    else:
        print(f"[WARN] No files containing $GAME_NAME were found.")


def main():
    parser = argparse.ArgumentParser(
        description="Sync Godot project config and folders from template to current project."
    )
    parser.add_argument(
        "--godot",
        help="Comma-separated list of Godot config sections to sync. "
             "Options: input-map,autoloads",
    )
    parser.add_argument(
        "--folders",
        help="Comma-separated list of folders to sync from template to current project.",
    )
    parser.add_argument(
        "--files",
        help="Comma-separated list of files to sync from template to current project.",
    )
    parser.add_argument(
        "--name",
        help="Replace $GAME_NAME with the provided name in all project files.",
    )

    args = parser.parse_args()

    # Use constants for paths
    src_root = TEMPLATE_PATH.resolve()
    dst_root = CURRENT_PROJECT_PATH.resolve()

    if not src_root.exists():
        print(f"[ERROR] Template path does not exist: {src_root}", file=sys.stderr)
        sys.exit(1)

    if not dst_root.exists():
        print(f"[ERROR] Current project path does not exist: {dst_root}", file=sys.stderr)
        sys.exit(1)

    print(f"[INFO] Syncing from template: {src_root}")
    print(f"[INFO] Syncing to project: {dst_root}\n")

    # Sync Godot config sections
    if args.godot:
        godot_items = [item.strip() for item in args.godot.split(",") if item.strip()]
        if godot_items:
            sync_godot_config(src_root, dst_root, godot_items)
            print()

    # Sync folders
    if args.folders:
        folder_names = [item.strip() for item in args.folders.split(",") if item.strip()]
        if folder_names:
            sync_folders(src_root, dst_root, folder_names)
            print()

    # Sync files
    if args.files:
        file_names = [item.strip() for item in args.files.split(",") if item.strip()]
        if file_names:
            sync_files(src_root, dst_root, file_names)
            print()

    # Replace $GAME_NAME
    if args.name:
        replace_game_name(dst_root, args.name)
        print()

    if not args.godot and not args.folders and not args.files and not args.name:
        print("[WARN] No sync operations specified. Use --godot, --folders, --files, and/or --name.", file=sys.stderr)
        sys.exit(1)

    print("[DONE] Sync complete.")


if __name__ == "__main__":
    main()
