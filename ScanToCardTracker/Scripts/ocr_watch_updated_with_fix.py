import os
import time
import pytesseract
from PIL import Image
import shutil
import csv

# Define directories
incoming_dir = r"C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker\Scans\Incoming"
processed_dir = r"C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker\Scans\Processed"
ocr_output = r"C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker\Output\ocr_results.csv"

# Function to process images
def process_image(image_path):
    try:
        # Open image
        img = Image.open(image_path)
        # Use pytesseract to get the text from image
        text = pytesseract.image_to_string(img)
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

# Start of the script
print("OCR Watcher is running...")

# Watch the Incoming folder for new files
while True:
    print("Checking Incoming folder...")  # Add this line for debugging
    for filename in os.listdir(incoming_dir):
        print(f"Checking file: '{filename}'")  # This will show the exact name of the file
        if filename.lower().endswith(".jpg") or filename.lower().endswith(".jpeg"):  # Process image files
            print(f"Found image: {filename}")

            file_path = os.path.join(incoming_dir, filename)  # Define file_path here

            # Process the image
            text = process_image(file_path)

            if text:
                # Append the OCR result to CSV
                with open(ocr_output, mode='a', newline='', encoding='utf-8') as file:
                    writer = csv.writer(file)
                    writer.writerow([filename, text])

                # Move image to Processed folder after processing
                move_file(file_path, processed_dir)

    # Wait for a few seconds before checking again
    time.sleep(5)
