## LuaImport

# 引入

    这是一个单文件的库，只需要在可搜索目录下require "luaImport"

# 测试

    测试用例不能单独执行，需要用vscode 打开luaImport所在文件夹为工作区，然后执行mainTest

# 使用

    想要使用import 必须在当前文件的开始写上 _ENV=module "当前模块的，从可搜索的根目录开始下来的路径" 而且只支持 "aaaa.bbbb.cccc" 这样的方式

    import 语法：
    import "*" :from "xxxxx"
    从模块xxx导出所有可导出对象，到当前模块

    import "*" :as "alias" :from "xxxxx"
    从xxxx导入所有可导入对象到一个 alias 变量中

    import {"a","b"} :from "xxxx"
    从xxxx导入 a和b两个对象

    import {"a","b"} as "c" :from "xxxxx"
    从xxxx导入a,b到表 c中

    from语法：
    from "xxxxx"中 ，xxxx应该是从可搜索的根目录开始的且只支持 dot的方式
    也支持相对路径，相对路径的语法开头必须是 "." 比如同目录下的 test
    import "*" :from ".test"
    "."代表当前目录
    ".."代表上级目录
    "..."代表上上级目录以此类推

    但是不允许层级大于可搜索的根目录，这会出错的

    export语法：
    export主要是用于 import"*"的形式，当使用这种形式的时候只会导入export指定过的变量
    例子
    --file a.lua
    export "aaaa"

    --file b.lua
    import "*" :from ".a"
    print(aaaa)

    可以访问aaaa



