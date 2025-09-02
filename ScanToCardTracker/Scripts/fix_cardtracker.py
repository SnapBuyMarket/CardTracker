import subprocess

folder_path = r"C:\Users\cwall\Desktop\CardTracker"
subfolder_path = r"C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker"

def run_command(cmd):
    try:
        result = subprocess.run(cmd, capture_output=True, text=True, check=True)
        print(f"Command: {' '.join(cmd)}\nOutput: {result.stdout}")
    except subprocess.CalledProcessError as e:
        print(f"Error: {e.stderr}")

# Ensure permissions
run_command(['icacls', folder_path, '/grant:r', 'cwall:F', '/t'])
run_command(['icacls', subfolder_path, '/grant:r', 'cwall:F', '/t'])
# Verify attributes and permissions
run_command(['attrib', subfolder_path + r'\*', '/s', '/d'])
run_command(['icacls', subfolder_path + r'\*', '/t'])
print("Done. Check folder properties in File Explorer.")
Traceback (most recent call last):
  File "<string>", line 14, in <module>
  File "<string>", line 8, in run_command
  File "/usr/lib/python3.12/subprocess.py", line 548, in run
    with Popen(*popenargs, **kwargs) as process:
         ^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/usr/lib/python3.12/subprocess.py", line 1026, in __init__
    self._execute_child(args, executable, preexec_fn, close_fds,
  File "/usr/lib/python3.12/subprocess.py", line 1955, in _execute_child
    raise child_exception_type(errno_num, err_msg, err_filename)
FileNotFoundError: [Errno 2] No such file or directory: 'icacls'