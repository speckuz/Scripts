-- locate servant structure information in ce data
local locate_servant = function(sevant_ce_line)
    local scanner = createMemScan()
    scanner.OnlyOneResult = true
    scanner.firstScan(soExactValue, vtGrouped, rtTruncated, sevant_ce_line, "", 0, 0x00000001ffffffff, "",
        fsmNotAligned,
        "", true
        , false, false, false)
    scanner.waitTillDone()
    -- if not found, result is nil
    return scanner.getOnlyResult()
end

local write = function(address, new_value)
    writeInteger(address, new_value)
end

local lock = function(address, hint)
    local address_list = getAddressList()
    local ce_record = address_list.createMemoryRecord();
    ce_record.setDescription(hint)
    ce_record.Address = address;
    ce_record.Active = true;
end

local increase = function(name, atk_address, hp_address, np_address)
    write(atk_address, 200000)
    lock(hp_address, string.format(name).."生命值")
    write(np_address, 10000)
    lock(np_address, string.format(name).."能量")
end

local decrease = function(hp_address)
    write(hp_address, 1)
end

local increase_servant = function(servant_table)
    local seravnt_address = locate_servant(servant_table[2])
    if seravnt_address == nil then
        print(servant_table[1] .. "信息不存在,不能increase")
    else
        local atkAddress = seravnt_address + 0x4 --攻击力偏移地址
        local hpAddress = seravnt_address + 0x10 --生命值偏移地址
        local npAddress = seravnt_address + 0x28 --NP值偏移地址
        increase(servant_table[1], atkAddress, hpAddress, npAddress)
    end
end

local decrease_servant = function(servant_table)
    local seravnt_address = locate_servant(servant_table[2])
    if seravnt_address == nil then
        print(servant_table[1] .. "信息不存在, 不能decrease")
    else
        local hpAddress = seravnt_address + 0x10 --生命值偏移地址
        decrease(hpAddress)
    end
end

-- servants' details
local atk_team={}
atk_team["强化解除"] = { "天草四郎", "4:90 4p:12758 4p:* 4p:* 4p:15107" }
atk_team["弱化解除"] = { "两仪式", "4:100 4p:12736 4p:* 4p:* 4p:19428" }
increase_servant(atk_team["强化解除"])
increase_servant(atk_team["弱化解除"])

