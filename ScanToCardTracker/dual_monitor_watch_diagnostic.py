import os
import time
import shutil
from PIL import Image
import pytesseract

# Correct OneDrive folder path
onedrive_dir = r"C:\Users\cwall\OneDrive\AAAScanned Cards"
local_dir = r"C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker\Scans\Incoming"
processing_dir = r"C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker\Scans\Processing"
processed_dir = r"C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker\Scans\Processed"

# Check if the OneDrive folder exists
if not os.path.exists(onedrive_dir):
    print(f"Error: The OneDrive folder at {onedrive_dir} does not exist.")
else:
    print(f"OneDrive folder found: {onedrive_dir}")

def move_file(src, dest):
    try:
        shutil.move(src, dest)
        print(f"Moved {src} to {dest}")  # Log successful move
    except Exception as e:
        print(f"Error moving {src} to {dest}: {e}")  # Log failure

def process_image(image_path):
    try:
        # Open image
        img = Image.open(image_path)
        # Use pytesseract to get the text
        text = pytesseract.image_to_string(img)
        print(f"Processed: {image_path}")  # Log processing
        return text
    except Exception as e:
        print(f"Error processing image {image_path}: {e}")
        return None

def watch_folder(folder):
    print(f"Watching {folder}...")
    while True:
        try:
            for filename in os.listdir(folder):
                if filename.lower().endswith(('.jpg', '.jpeg', '.png')):  # Process image files
                    file_path = os.path.join(folder, filename)
                    process_image(file_path)  # Process the image
                    move_file(file_path, processing_dir)  # Move to Processing folder
            time.sleep(5)
        except Exception as e:
            print(f"Error watching {folder}: {e}")
            time.sleep(5)

# Process and move files from Processing to Processed
def process_and_move():
    for filename in os.listdir(processing_dir):
        file_path = os.path.join(processing_dir, filename)
        if filename.endswith((".jpg", ".jpeg", ".png")):
            print(f"Processing {filename}...")  # Log file being processed
            process_image(file_path)  # Process the file
            move_file(file_path, processed_dir)  # Move to Processed folder

if __name__ == "__main__":
    # Start watching both OneDrive and local Incoming folder
    watch_folder(local_dir)
    # Process and move files from Processing to Processed
    process_and_move()
