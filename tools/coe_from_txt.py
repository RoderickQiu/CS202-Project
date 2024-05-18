# coe_generator.py

def generate_coe(from_file="inst.txt", to_file="inst.coe", depth=1024):
    # Open the file to read the instructions
    with open(from_file, "r") as f:
        instructions = f.readlines()

    # Open the file to write the .coe file
    with open(to_file, "w") as f:
        # Write the header
        f.write("memory_initialization_radix = 16;\n")
        f.write("memory_initialization_vector=\n")

        # Write the instructions, and if the required depth is longer than the instructions, fill the rest with 0
        for i in range(depth):
            if i != depth - 1:
                if i < len(instructions):
                    f.write(instructions[i].strip() + ",\n")
                else:
                    f.write("00000000,\n")
            else:
                if i < len(instructions):
                    f.write(instructions[i].strip() + ";\n")
                else:
                    f.write("00000000;\n")

    print(f"Generated {to_file} file.")


# Use the generate_coe function to create a .coe file
if __name__ == '__main__':
    generate_coe("inst.txt", "inst.coe", 1024)  # Example
