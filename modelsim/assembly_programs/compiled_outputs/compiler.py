# Opcode Table for Accumulator Designs
# Accumulator can accumulate up to 3 values, opcode with run the corresponding command

opcodes = {
    "li": "00000",
    "ld": "00001",       # reg-destination, reg w/ source_mem, __      accum -> reg -> mem -> reg
    "st": "00010",       # __, reg w/ dest address, source_reg         accum -> reg 1,2 -> mem
    "add": "00011",      # dest_reg, source_reg, source_reg            accum -> reg 1,2 -> alu -> reg 0
    "sub": "00100",
    "xor": "00101",
    "or": "00110",
    "and": "00111",
    "j": "01000",
    "beq": "01001",
    "blt": "01010",
    "bgt": "01011",
    "lsf": "01100",
    "rsf": "01101",
    "usub": "01110",
    "sblt": "01111",
    "sbgt": "10000"
}


def read_file(file_name):
    f = open(file_name, "r")
    program_code = f.read().split("\n")
    f.close()
    return program_code

def parse_instruction(instruction):
    parts = instruction.split(" ")
    instr = parts[0]
    args = parts[1:] if len(parts) > 1 else []
    return instr, args
    
def convert_line(line, tag_to_id):
    mach_line = ""
    instr, args = parse_instruction(line)

    if len(args) > 0 and args[0] in tag_to_id:
        mach_line += str(bin(int(tag_to_id[args[0]]))[2:].zfill(8))    
    elif len(args) > 0:
        if int(args[0]) < 0:
            mach_line += str(bin((int(args[0]) + (1 << 8)) & 0xff)[2:].zfill(8))
        else:
            mach_line += str(bin(int(args[0]) & 0xff)[2:].zfill(8))
    
    if instr == "put":
        mach_line += "1"
    elif instr in opcodes:
        mach_line += f"000{opcodes[instr]}0"

    return mach_line


def convert_assembly(tag_to_id, program_code):
    mach_code = []

    for line in program_code:
        mach_code.append(convert_line(line, tag_to_id))

    return "\n".join(mach_code)


def find_all_tags(file_name):
    program_code = read_file(file_name)
    new_program_code = []
    tag_to_id = {}
    id_to_line = []
    prog_ctr = 0
    numTags = 0
    for line in program_code:
        if len(line) != 0:
            if "//" in line:
                pass
            elif ":" in line:
                tag_to_id[line[:-1]] = numTags
                id_to_line.append(str(prog_ctr))
                numTags += 1
            else:
                new_program_code.append(line)
                prog_ctr += 1
    
    return tag_to_id, id_to_line, new_program_code

def convertfile(file_name):

    tag_to_id, id_to_line, new_program_code = find_all_tags(file_name + ".txt")
    mach_code = convert_assembly(tag_to_id, new_program_code)

    f = open(f"{file_name}_machcode.txt", "w")
    f.write(mach_code)
    f.close()

    # f = open(f"{file_name}_tag_to_instruction.txt", "w")
    # f.write("\n".join(id_to_line))
    # f.close()

# program_file = "basic_aluops/overflow"
# convertfile(program_file)