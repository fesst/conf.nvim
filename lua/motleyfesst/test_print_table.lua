local print_table = require("motleyfesst.print_table")

-- Example nested table
local test_table = {
    name = "John",
    age = 30,
    address = {
        street = "123 Main St",
        city = "New York",
        zip = 10001,
        coordinates = {
            lat = 40.7128,
            long = -74.0060
        }
    },
    hobbies = {"reading", "coding", "gaming"},
    scores = {
        math = 95,
        science = 88,
        history = 92
    }
}

-- Print the table
print_table.print_table(test_table)
