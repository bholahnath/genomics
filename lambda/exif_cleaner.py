import boto3
import os
import tempfile
from PIL import Image

s3 = boto3.client('s3')

def strip_exif(input_path, output_path):
    img = Image.open(input_path)
    data = list(img.getdata())
    img_no_exif = Image.new(img.mode, img.size)
    img_no_exif.putdata(data)
    img_no_exif.save(output_path, "JPEG")

def lambda_handler(event, context):
    source_bucket = event['Records'][0]['s3']['bucket']['name']
    object_key = event['Records'][0]['s3']['object']['key']
    dest_bucket = os.environ['DEST_BUCKET']

    with tempfile.TemporaryDirectory() as tmpdir:
        input_path = os.path.join(tmpdir, 'input.jpg')
        output_path = os.path.join(tmpdir, 'output.jpg')

        s3.download_file(source_bucket, object_key, input_path)
        strip_exif(input_path, output_path)
        s3.upload_file(output_path, dest_bucket, object_key)

    return {'status': 'success'}