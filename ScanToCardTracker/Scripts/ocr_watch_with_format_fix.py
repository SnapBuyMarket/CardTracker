# ocr_watch_with_format_fix.py

from PIL import Image

def process_image(image_path):
    try:
        # Open the image
        img = Image.open(image_path)
        
        # Convert to RGB to ensure it's in a supported format
        img = img.convert('RGB')
        
        # Optional: Save as PNG to standardize format
        img.save("temp_image.png", "PNG")
        text = pytesseract.image_to_string(img)
        return text
    except Exception as e:
        print(f"Error processing image {image_path}: {e}")
        return None
