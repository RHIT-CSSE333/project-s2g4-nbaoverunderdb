 
import base64 
  
sample_string = "NBAPassword123"
sample_string_bytes = sample_string.encode("ascii") 
  
base64_bytes = base64.b64encode(sample_string_bytes) 
base64_string = base64_bytes.decode("ascii") 
  

print(f"Encoded string: {base64_string}") 
