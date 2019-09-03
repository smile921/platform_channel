#!/bin/python
path = '/Users/macbook/Downloads/element-2.9.1/packages/theme-chalk/src/icon.scss'
template = """static const IconData {0} =
      IconData(0xe{1}, fontFamily: ElementIcon.fontFamily);"""
lines = []
prefix = '.el-icon-'
suffix = ':before {'
index = 0 
with open(path,'r') as f:
    content = [line.strip() for line in f]
    print(type(content))
    for line in content:
        index = index + 1
        if (prefix in line) and (suffix in line) :
            name = line.replace(prefix,'',1)
            name = name.replace(suffix,'',1)
            name = name.replace('-','_')
            # print name
            # content: "\e6af";
            nextLine = content[index]
            # print(nextLine)
            val = nextLine.replace('content: "\e','',1)
            val = val.replace('";','',1)
            code = "{0} {1}".format(name,val)
            print(template.format(name,val))
            # print(code)
            lines.append(code)
        #end if
    #end for
    # print(content[0])
#end 
