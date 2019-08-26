require "luaImport"

_ENV=module "test.mainTest"

---use relation path
import "*" :as "rt" :from ".returnTest1"
import {"IT","WORKER"} :from ".dir1.returnTest2"
import "*" :from ".dir2.moduleVariableTest"
import {"I","want","you"} :as "iwy" :from ".dir2.moduleVariableTest2"
--import standard lua lib
import "find" :from "string"
---test returnTest1
print(rt.a,rt.b,rt.c,rt.d)--1 2 3 4
print(a,b,c,d) --nil nil nil nil
---test returnTest2
print(IT,WORKER)
---test moduleVariableTest
print(var1,var2,var3)   --"this is test" "hahhhahhh" 2333333
print(_G.var1,_G.var2,_G.var3) --nil nil nil
---test moduleVariableTest3
print(I,want,you)--nil nil nil
print(iwy.I,iwy.want,iwy.you)--I want you
---test import string
print(find("123456","123")) -- 1 3

--other write method
--maybe you want to cache the table,this surpport
local io=import "*" :as "io" :from  "io"
local read,write=import {"read","write"} :from "io"
print(io)
print(read,write)

IT=nil
WORKER=nil

import "*" :from ".dir1.moduleImportTest"
--moduleImport Test
--IT,WORKER 是导入到 上面那个模块的，但是没有export，所以不会导入到这里
print(IT,WORKER)--nil nil



