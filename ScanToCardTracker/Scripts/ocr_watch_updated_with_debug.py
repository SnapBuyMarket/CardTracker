
import os
import time
import pytesseract
from PIL import Image
import shutil

# Define directories
incoming_dir = r"C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker\Scans\Incoming"
processed_dir = r"C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker\Scans\Processed"
processing_dir = r"C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker\Scans\Processing"  # Added Processing
error_dir = r"C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker\Scans\Error"  # Added Error
ocr_output = r"C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker\Output\ocr_results.csv"

# Function to process images with OCR
def process_image(image_path):
    try:
        # Open image
        img = Image.open(image_path)
        # Use pytesseract to get the text
        text = pytesseract.image_to_string(img)
        print(f"OCR text for {image_path}: {text}")  # Debug: Check OCR text
        return text
    except Exception as e:
        print(f"Error processing image {image_path}: {e}")
        return None

# Function to move processed files
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
            ocr_text = process_image(os.path.join(processing_dir, filename))

            if ocr_text:
                # Save OCR output to CSV (or handle it as needed)
                print(f"Writing OCR output for {filename} to CSV")  # Debug: Confirm writing to CSV
                with open(ocr_output, "a") as f:
                  f.write(f"{filename}, {ocr_text}\n")

")

                # After processing, move image to the Processed folder
                move_file(os.path.join(processing_dir, filename), processed_dir)
            else:
                # If OCR failed, move image to Error folder
                move_file(os.path.join(processing_dir, filename), error_dir)

    # Sleep for a few seconds before checking the folder again
    time.sleep(5)
