import os
import re

# Directory containing the TDL test files
tdl_dir = "tests/tdl/"

# Old values to replace
old_arch = "<arch>x86_64</arch>"
old_url_pattern = re.compile(r"(http[s]?://download.fedoraproject.org/pub/fedora/linux/releases/\d+/Fedora/x86_64/os/)")

# New values for s390x
new_arch = "<arch>s390x</arch>"
new_url = "https://archive.fedoraproject.org/pub/archive/fedora-secondary/releases/39/Everything/s390x/os/"

# Process each TDL file in the directory
for filename in os.listdir(tdl_dir):
    if filename.endswith(".tdl"):
        file_path = os.path.join(tdl_dir, filename)

        with open(file_path, "r") as file:
            content = file.read()

        # Replace architecture and URL
        updated_content = content.replace(old_arch, new_arch)
        updated_content = old_url_pattern.sub(new_url, updated_content)

        # Write changes back to file
        with open(file_path, "w") as file:
            file.write(updated_content)

        print(f"Updated: {filename}")

print("All TDL files have been updated for s390x.")
