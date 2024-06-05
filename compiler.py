opcodes = {
    "li": "0000",
    "ld": "0001",
    "st": "0010",
    "add": "0011",
    "sub": "0100",
    "xor": "0101",
    "or": "0110",
    "and": "0111",
    "j": "1000",
    "beq": "1001",
    "blt": "1010",
    "bgt": "1011",
    "lsf": "1100",
    "rsf": "1101"
}

def parse_instruction(instruction):
    parts = instruction.split(" ")
    instr = parts[0]
    args = parts[1:] if len(parts) > 1 else []
    return instr, args
    
def convertline(line):
    mach_line = ""
    instr, args = parse_instruction(line)
    if len(args) > 0:
        mach_line += bin(int(args[0]))[2:].zfill(8)
    
    if instr == "put":
        mach_line += "1"
    else:
        mach_line += f"0000{opcodes[instr]}0"

def convertfile(file_name):
    f = open(file_name, "r")
    program_code = f.read().split("\n")
    f.close()
    mach_code = ""
    for l in program_code:
        if len(l) != 0:
            mach_code += convertline(l) + "\n"

    f = open(file_name + "_machcode", "w")
    f.write(mach_code)
    f.close()

program_file = "prog3"
convertfile(program_file)