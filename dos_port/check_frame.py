import sys

def main():
    with open('FRAME.BIN', 'rb') as f:
        data = f.read()
    
    print("Top-left 10x10 pixels:")
    for y in range(10):
        row = []
        for x in range(10):
            pixel = data[y * 320 + x]
            row.append(f"{pixel:02X}")
        print(" ".join(row))

if __name__ == '__main__':
    main()
