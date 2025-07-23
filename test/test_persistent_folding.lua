-- Test file for persistent folding functionality
-- This file has multiple functions to test folding

function test_function_1()
    print("This is test function 1")
    local x = 1
    local y = 2
    return x + y
end

function test_function_2()
    print("This is test function 2")
    local a = 10
    local b = 20
    return a * b
end

function test_function_3()
    print("This is test function 3")
    local result = 0
    for i = 1, 10 do
        result = result + i
    end
    return result
end

-- Main function
function main()
    local result1 = test_function_1()
    local result2 = test_function_2()
    local result3 = test_function_3()

    print("Results:", result1, result2, result3)
end

-- Call main function
main()
