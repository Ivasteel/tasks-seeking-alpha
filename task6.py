import numpy as np
import pandas as pd

def find_missing_number_pure(nums):
    """
    Finds the missing number using a mathematical sum approach.

    Complexity: O(N).
    In conclusion, the best pure Python approach. Uses mathematical sum formula. No extra storage required.

    Parameters:
    nums (list): The input list of integers.

    Returns:
    int: The missing number.
    """
    expected_sum = sum(range(10))  # Sum of numbers from 0 to 9
    actual_sum = sum(nums)  # Sum of given numbers
    return expected_sum - actual_sum  # Missing number


def find_missing_number_numpy(nums):
    """
    Finds the missing number using NumPy sum operations.

    Complexity: O(N). NumPy sum operations are vectorized and optimized.
    In conclusion, efficient with NumPy, leveraging vectorized operations. Slight overhead for small data.

    Parameters:
    nums (list): The input list of integers.

    Returns:
    int: The missing number.
    """
    nums = np.array(nums)
    return np.sum(np.arange(10)) - np.sum(nums)


def find_missing_number_series(series):
    """
    Finds the missing number using Pandas Series.

    Complexity: O(N). The sum operation is optimized internally in Pandas.
    In conclusion, uses Pandas Series. Good if the data is already in Pandas but not the fastest.

    Parameters:
    series (pd.Series): Pandas Series of integers.

    Returns:
    int: The missing number.
    """
    return sum(range(10)) - series.sum()


def find_missing_number_dataframe(df, column):
    """
    Finds the missing number in a specific column of a Pandas DataFrame.

    Complexity: O(N). Uses the Pandas Series method internally.
    In conclusion, similar to Series but operates on a DataFrame. Useful in structured data scenarios.

    Parameters:
    df (pd.DataFrame): Input DataFrame.
    column (str): Column name to find the missing number.

    Returns:
    int: The missing number.
    """
    return find_missing_number_series(df[column])

# Example usage
example_nums = [5, 3, 7, 8, 2, 4, 9, 6, 0]  # Missing number is 1

print("\n" + "-" * 50)
print("Pure Python Function (O(N)):")
print(find_missing_number_pure(example_nums))
print("-" * 50)

print("NumPy Function (O(N)):")
print(find_missing_number_numpy(example_nums))
print("-" * 50)

# Example with Pandas Series
series = pd.Series(example_nums)
print("Pandas Series Function (O(N), with index):")
print(find_missing_number_series(series))
print("-" * 50)

# Example with Pandas DataFrame
df = pd.DataFrame({"values": example_nums})
print("Pandas DataFrame Function (O(N), without indexes and header):")
print(find_missing_number_dataframe(df, "values"))
print("-" * 50)