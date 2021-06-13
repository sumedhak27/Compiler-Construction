# Pass 1 implementation of 2 pass Macroprocessor
# Author - Sumedh A. Kulkarni <sumedh.17u150@viit.ac.in> 

import re

class MNTentry:
    def __init__(self, name, num_args, start, end = 0):
        self.name = name
        self.num_args = num_args
        self.start_index = start
        self.end_index = end
    
    def printEntry(self):
        print("%s\t\t%s\t\t%s\t\t%s" %
              (self.name,
              self.num_args,
              self.start_index,
              self.end_index))

class MacroProcessor:
    def __init__(self, inpfile, outfile):
        self.input_file = inpfile
        self.output_file = outfile
        self.intermidiate_file = None
        self.lines = []
        self.mnt = []     # Macro Name Table
        self.mdt =[]      # Macro Defination Table
        self.mdt_index = 0
        self.error_flag = False
        self.error_msg = ""


    def passOne(self):
        line_num = 0
        with open(self.input_file, 'r') as infile:
            with open("intermidiate_file.asm", 'w') as self.intermidiate_file:
                self.lines = infile.readlines()
                while line_num < len(self.lines):
                    line =  self.lines[line_num].strip
                    cmd = self.lines[line_num].strip().split()

                    if cmd[0] == "END":
                        break
                    elif cmd[0] != "MACRO":
                        self.intermidiate_file.write(self.lines[line_num])
                        line_num+=1
                    else:
                        line_num = self.processMacro(line_num)
                        if self.error_flag:
                            break

                
                if not self.error_flag:
                    print("SUCCESS!!")
                    print("Intermidiate file is generated.")
                    self.printMNT()
                    self.printMDT()
                else:
                    print("ERROR!!\n", self.error_msg)

    def printMNT(self):
        print("===== MNT =====")
        print("Macro Name\tNo. Args\tStart Index\tEnd Index")
        for entry in self.mnt:
            entry.printEntry()
        print()        

    def printMDT(self):
        ind = 0
        print("===== MDT ======")
        for cmd in self.mdt:
            print(ind, cmd)
            ind+=1
        print()
    
    def processMacro(self, line_num) -> int:
        try:
            cmd = re.split(' |,', self.lines[line_num].strip())
            m_name = cmd[1]
            n_args = 0
            formal_t_positional = {}
            if len(cmd) > 2:
                n_args = len(cmd)-2
                position = 1
                for arg in cmd[2:]:
                    formal_t_positional[arg] = f"#{position}"
                    position+=1

            self.mnt.append(MNTentry(m_name, n_args, self.mdt_index))      
            line_num+=1

            while line_num < len(self.lines):
                cmd = re.split(' |,', self.lines[line_num].strip())
                
                if(cmd[0] == "MEND"):
                    self.mnt[-1].end_index = self.mdt_index-1
                    # self.mdt_index+=1
                    line_num+=1
                    break
                elif(cmd[0] == "MACRO"):
                    self.processMacro(line_num)
                else:
                    for i in range(len(cmd)):
                        if cmd[i] in formal_t_positional.keys():
                            cmd[i] = formal_t_positional[cmd[i]]
                    self.mdt.append(cmd[0]+" "+",".join(cmd[1:]))
                    self.mdt_index+=1
                
                line_num+=1
            
            return line_num
        except Exception as e:
            self.error_flag = True
            self.error_msg = e
            return -1


if __name__ == "__main__":
    mp = MacroProcessor("macro.asm", "macro_out.asm")
    mp.passOne()
        

                        
