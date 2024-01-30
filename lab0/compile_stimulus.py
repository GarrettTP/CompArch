import re

# Function to reverse text on each line and remove non-numerical characters
def process_line(line):
    # Remove comments starting with //
    line = re.sub(r'//.*', '', line)
    # Reverse the line
    reversed_line = line[::-1]
    # Remove non-numerical characters
    cleaned_line = re.sub(r'[^0-9]', '', reversed_line)

    if cleaned_line != "":
        return cleaned_line + '\n'
    else:
        return ""

# Input and output file names
input_file = 'stimulus.tv'
output_file = 'reg.tv'

# Read input file, process lines, and write to output file
with open(input_file, 'r') as f_input, open(output_file, 'w') as f_output:
    for line in f_input:
        processed_line = process_line(line)
        f_output.write(processed_line)