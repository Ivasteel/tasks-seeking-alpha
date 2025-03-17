import pandas as pd

# Function 1: Pure Python recursive approach
def print_digits_pure(n):
    """
    Prints all digits of a number recursively (left to right).

    Complexity: O(N), where N is the number of digits in the input number.
    In conclusion, the pure Python approach directly calls the recursive function for each digit.

    Parameters:
    n (int): The input positive integer.

    Returns:
    None
    """
    if n < 10:
        print(n, end="")
    else:
        print_digits_pure(n // 10)  # Recursively print the leftmost digits
        print(n % 10, end="")  # Print the last digit

# Function 2: Using string conversion (Iterative)
def print_digits_string_conversion(n):
    """
    Prints all digits of a number by converting the number to a string and iterating through it.

    Complexity: O(N), where N is the number of digits in the input number.
    In conclusion, this approach is less efficient for very large numbers due to the string conversion overhead.

    Parameters:
    n (int): The input positive integer.

    Returns:
    None
    """
    for digit in str(n):
        print(digit, end="")

# Function 3: Using Pandas Series (Recursive)
def print_digits_series(series):
    """
    Prints all digits of a number stored in a Pandas Series recursively (left to right).

    Complexity: O(N), where N is the number of digits in the input number (in the Series).
    In conclusion, this function leverages the recursive approach and applies it to each element of the Series.

    Parameters:
    series (pd.Series): A Pandas Series of integers.

    Returns:
    None
    """
    def recursive_print(index):
        if index < len(series):
            print(series.iloc[index], end="")
            recursive_print(index + 1)

    recursive_print(0)

# Function 4: Using Pandas DataFrame (Recursive)
def print_digits_dataframe(df, column):
    """
    Prints all digits of a number in a specific column of a Pandas DataFrame recursively (left to right).

    Complexity: O(N), where N is the number of digits in the column of the DataFrame.
    In conclusion, this function operates on a DataFrame and prints the digits recursively for the given column.

    Parameters:
    df (pd.DataFrame): The input DataFrame.
    column (str): The column name to print the digits from.

    Returns:
    None
    """
    series = df[column]
    print_digits_series(series)

# Example usage
example_num = 12345

print("\n" + "-" * 50)
print("Pure Python Recursive Function (O(N)):")
print_digits_pure(example_num)
print("\n" + "-" * 50)

print("String Conversion Iterative Function (O(N)):")
print_digits_string_conversion(example_num)
print("\n" + "-" * 50)

# Example with Pandas Series (representing the number as one element)
series = pd.Series([12345])  # The number as a single element in the Series
print("Pandas Series Function (O(N), with index):")
print_digits_series(series)
print("\n" + "-" * 50)

# Example with Pandas DataFrame (digits as individual elements)
df = pd.DataFrame({"values": [1, 2, 3, 4, 5]})
print("Pandas DataFrame Function (O(N), without indexes and header):")
print_digits_dataframe(df, "values")
print("\n" + "-" * 50)