import sys


def main():
    if len(sys.argv) != 2:
        print("Usage: python music-gen.py <input_file>")
        return

    input_file = sys.argv[1]

    with open(input_file, "r") as f:
        lines = f.readlines()

    notes = []
    for line in lines:
        notes.append(line.strip())

    output = ""
    for note in notes:
        if note == "do_low":
            output += "1, "
        elif note == "re_low":
            output += "2, "
        elif note == "mi_low":
            output += "3, "
        elif note == "fa_low":
            output += "4, "
        elif note == "so_low":
            output += "5, "
        elif note == "la_low":
            output += "6, "
        elif note == "si_low":
            output += "7, "
        elif note == "do":
            output += "8, "
        elif note == "re":
            output += "9, "
        elif note == "mi":
            output += "10, "
        elif note == "fa":
            output += "11, "
        elif note == "so":
            output += "12, "
        elif note == "la":
            output += "13, "
        elif note == "si":
            output += "14, "
        else:
            output += "0, "

        output += "0, "  # Add a delay

    print(output + "15")  # Add 15 as the ending signal

    print("Size of notes:", len(notes), "notes.")


if __name__ == "__main__":
    main()
