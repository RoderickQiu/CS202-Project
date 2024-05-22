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

    for note in notes:
        if note == "do_low":
            print("0001", end="")
        elif note == "re_low":
            print("0010", end="")
        elif note == "me_low":
            print("0011", end="")
        elif note == "fa_low":
            print("0100", end="")
        elif note == "so_low":
            print("0101", end="")
        elif note == "la_low":
            print("0110", end="")
        elif note == "si_low":
            print("0111", end="")
        elif note == "do":
            print("1000", end="")
        elif note == "re":
            print("1001", end="")
        elif note == "me":
            print("1010", end="")
        elif note == "fa":
            print("1011", end="")
        elif note == "so":
            print("1100", end="")
        elif note == "la":
            print("1101", end="")
        elif note == "si":
            print("1110", end="")
        else:
            print("0000", end="")

    print("\\000")


if __name__ == "__main__":
    main()
