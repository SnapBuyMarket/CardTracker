import os
import shutil
import time

# Folder paths (make sure they are correct)
incoming_dir = r"C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker\Scans\Incoming"
processing_dir = r"C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker\Scans\Processing"
processed_dir = r"C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker\Scans\Processed"

# Function to move files from Incoming to Processing folder
def move_files_from_incoming():
    for filename in os.listdir(incoming_dir):
        if filename.endswith(".jpg") or filename.endswith(".jpeg"):
            src = os.path.join(incoming_dir, filename)
            dest = os.path.join(processing_dir, filename)
            print(f"Attempting to move: {filename} from Incoming to Processing")  # Debug log
            try:
                shutil.move(src, dest)
                print(f"Moved {filename} to Processing.")  # Success log
            except Exception as e:
                print(f"Error moving {filename}: {e}")  # Error log

# Function to move files from Processing to Processed folder
def move_files_from_processing():
    for filename in os.listdir(processing_dir):
        if filename.endswith(".jpg") or filename.endswith(".jpeg"):
            src = os.path.join(processing_dir, filename)
            dest = os.path.join(processed_dir, filename)
            print(f"Attempting to move: {filename} from Processing to Processed")  # Debug log
            try:
                shutil.move(src, dest)
                print(f"Moved {filename} to Processed.")  # Success log
            except Exception as e:
                print(f"Error moving {filename}: {e}")  # Error log

# Run the move functions every 5 seconds
while True:
    move_files_from_incoming()  # Move files from Incoming to Processing
    move_files_from_processing()  # Move files from Processing to Processed
    time.sleep(5)
