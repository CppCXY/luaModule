local string_gsub=string.gsub
local unpack=unpack or table.unpack
--这种实现是有问题，但是性能较好
local function split(str,sep)
    local rt= {}
    local size=1
    string_gsub(str, '[^'..sep..']+', function(w) rt[size]=w size=size+1 end )
    return rt
end

---@class ImportImplement
local ImportImplement={}

ImportImplement.__index=ImportImplement
---@param module string | table
---@return ImportImplement
function ImportImplement:new(module,current,module_space)
    local obj={
        module=module;
        current=current;
        asTarget=nil;
        module_space=module_space;
    }
    return setmetatable(obj,self)
end
---@param module string | table
---@return ImportImplement 
function import(module)
    --这只是用来作注释的，真正有用的是__import    
    error("error: can not use import without _ENV=module()   ")
end


local function __import(module,current,env)
    return ImportImplement:new(module,current,env)
end

---@param name string
---@return void
function export(name)
    --这只是用来作注释的.    
    error("error: can not use export without _ENV=module()")    
end

__Import_Table__={}
---@param name string
---@return ImportImplement
function ImportImplement:as(name)
    self.asTarget=name
    return self
end


---@param path string
---@return table
function ImportImplement:from(path)

    local current_path=self.current

    local current_t=split(current_path,".")

    local result_path=""
    local importList={}
    if path:sub(1,1)=="." then
        local index=1
        local num=#current_t
        while path:sub(index,1)=="." do
            current_t[num-index+1]=nil
            index=index+1
        end
        current_t[num-index+2]=path:sub(index,-1)
        result_path=table.concat(current_t,".")
    else
        result_path=path
    end

    local ret=require(result_path)

    local names=split(result_path,".")
    local index=1
    local __lastNs=__Import_Table__

    while(names[index]~=nil) do
        local name=names[index]
        if rawget(__lastNs,name)==nil then
            local ns={}
            rawset(__lastNs,name,ns)
            __lastNs=ns
        else
            __lastNs=rawget(__lastNs,name)
        end
        index=index+1
    end

    if  __lastNs.__module_space__==nil then
        __lastNs.__module_space__=ret
    end
    local module_space=__lastNs.__module_space__

    local module=self.module
    local module_t=type(module)
    if module_t=="string" then
        if module=="*"  then
            local space
            if  module_space.__export_namespace__ then
                space=module_space.__export_namespace__
            else
                space=module_space
            end

            for key,_ in pairs(space) do
                table.insert(importList,{key=key,value=rawget(module_space,key)})
            end
        else
            table.insert(importList,{key=module,value=rawget(module_space,module)})
        end
    elseif module_t=="table" then
        for _,key in pairs(module) do
            table.insert(importList,{key=key,value=rawget(module_space,key)})
        end
    end

    if self.asTarget then
        local newImportList={}
        for _,kv in pairs(importList) do
            newImportList[kv.key]=kv.value
        end
        self.module_space[self.asTarget]=newImportList
        return newImportList
    else
        local result={}
        for _,kv in pairs(importList) do
            if kv.key~="import" then
                self.module_space[kv.key]=kv.value
                table.insert(result,kv.value)
            end
        end
        return unpack(result,1,#importList)
    end

end


---@param modulePath string
function module(modulePath)
    modulePath=modulePath or ""

    local names=split(modulePath,".")
    local index=1
    local lastNs=__Import_Table__

    while(names[index]~=nil) do
        local name=names[index]
        if  rawget(lastNs,name)==nil then
            local ns={}
            rawset(lastNs,name,ns)
            lastNs=ns
        else
            lastNs=rawget(lastNs,name)
        end
        index=index+1
    end

    if lastNs.__module_space__ then
        error("error: can not cover the module: "..modulePath)    
    end

    local newNs={
        __export_namespace__={}
    }
    lastNs.__module_space__=newNs
    local meta={}
    meta.__index=_G

    newNs.import=function (module)
        return __import(module,modulePath,newNs)
    end

    newNs.export=function(name)
        newNs.__export_namespace__[name]=true
    end

    setmetatable(newNs,meta)

    if _VERSION =="Lua 5.1" then
        setfenv(2,newNs)
    end
    return  newNs
end

