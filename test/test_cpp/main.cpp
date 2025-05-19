#include <iostream>
#include <vector>

int factorial(int n) {
    if (n <= 1) return 1;
    return n * factorial(n - 1);
}

int main() {
    std::vector<int> numbers = {1, 2, 3, 4, 5};
    int sum = 0;
    
    for (int num : numbers) {
        sum += num;
        std::cout << "Current number: " << num << std::endl;
        std::cout << "Running sum: " << sum << std::endl;
    }
    
    int fact = factorial(5);
    std::cout << "Factorial of 5: " << fact << std::endl;
    
    return 0;
} 