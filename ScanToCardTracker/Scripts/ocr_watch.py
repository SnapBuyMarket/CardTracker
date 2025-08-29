import os
import time
import shutil
from PIL import Image
import pytesseract

# Define directories based on your folder structure
scanned_dir = r"C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker\Scans\Scanned"
processed_dir = r"C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker\Scans\Processed"
error_dir = r"C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker\Scans\Errors"
incoming_dir = r"C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker\Scans\Incoming"
processing_dir = r"C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker\Scans\Processing"

# Function to process images
def process_image(image_path):
    try:
        # Open image
        img = Image.open(image_path)
        # Use pytesseract to extract text
        text = pytesseract.image_to_string(img)
        print(f"Processed {image_path}: {text}")
        return text
    except Exception as e:
        print(f"Error processing image {image_path}: {e}")
        return None

# Function to move files to different directories
def move_file(src, dest):
    try:
        shutil.move(src, dest)
        print(f"Moved {src} to {dest}")
    except Exception as e:
        print(f"Error moving {src} to {dest}: {e}")

# Watch the Incoming folder for new files
while True:
    for filename in os.listdir(incoming_dir):
        file_path = os.path.join(incoming_dir, filename)
        
        if filename.endswith(".jpg") or filename.endswith(".jpeg"):  # Process image files
            print(f"Found image: {filename}")

            # Move image to Processing folder before processing
            move_file(file_path, processing_dir)

            # Process the image
            if process_image(file_path):
                # Move the image to Processed folder after successful processing
                move_file(file_path, processed_dir)
            else:
                # Move the image to Errors folder if processing fails
                move_file(file_path, error_dir)

    time.sleep(1)  # Wait for 1 second before checking again
