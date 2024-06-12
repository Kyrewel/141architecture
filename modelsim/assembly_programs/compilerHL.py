import re
cmds = {
    "li": "li",
    "ld": "ld",
    "st": "st",
    "add":"add",
    "sub":"sub",
    "xor":"xor",
    "or":"or",
    "and":"and",
    "j":"j",
    "beq":"beq",
    "blt":"blt",
    "bgt":"bgt",
    "ls":"lsf",
    "rs":"rsf"
}

javaLOL = []
jumps = []
jumpDict = {}

def translate(line):
    if '//' in line:
        return
    
    if ':' in line:
        label = line[:-1]
        jumpDict[label] = len(javaLOL)
        jumps.append(len(javaLOL))
        return
    
    parts = re.split(r'[(),]', line)
    parts = [part.strip() for part in parts if part.strip()]
    cmd = parts[0]
    args = parts[1:]
    # print(f"Command: {cmd}\nArgs: {args}:")
    if (cmd == "store"):
        javaLOL.append(f"put 0 // placeholder")
    for i in args:
            javaLOL.append(f"put {i}")
    javaLOL.append(f"{cmds[cmd]}")
    

def readFile(filename):
    with open(filename, 'r') as file:
        lines = file.readlines()
        lines = [line.strip() for line in lines if line.strip()]
    return lines

lines = readFile('input_file.txt')
for line in lines:
    translate(line)

with open('output_file.txt', 'w') as output_file:
    for item in javaLOL:
        parts = item.split(" ")
        if len(parts) > 1:
            if parts[1] in jumpDict:
                output_file.write(f"put {jumpDict[parts[1]]}\n")
            else:
                output_file.write(f"{item}\n")
        else:
            output_file.write(f"{item}\n")

with open('jumps_output.txt', 'w') as jump_file:
    for jump in jumps:
        jump_file.write(f"{jump}\n")