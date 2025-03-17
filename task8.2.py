import numpy as np
import pandas as pd

def product_except_self_pure(nums):
    """
    Computes the product of all elements except the current index using only Python lists.

    Complexity: O(N)
    Constructs left and right product arrays in O(N). Final output computation is O(N).
    In conclusion, simple and efficient, but requires extra space for left, right, and output lists.

    Parameters:
    nums (list): The input list of integers.

    Returns:
    list: The resulting list where each index contains the product of all other elements.
    """
    n = len(nums)
    left = [1] * n
    right = [1] * n
    output = [1] * n

    # Compute left products
    for i in range(1, n):
        left[i] = left[i - 1] * nums[i - 1]

    # Compute right products
    for i in range(n - 2, -1, -1):
        right[i] = right[i + 1] * nums[i + 1]

    # Compute output
    for i in range(n):
        output[i] = left[i] * right[i]

    return output

def product_except_self_numpy(nums):
    """
    Computes the product of all elements except the current index using NumPy arrays.

    Complexity: O(N). Uses NumPy’s optimized cumulative product functions for left and right passes. NumPy operations
    are vectorized, making them highly efficient.
    In conclusion, uses NumPy's vectorized operations, highly optimized and fast. Best for large datasets.

    Parameters:
    nums (list): The input list of integers.

    Returns:
    np.array: The resulting NumPy array where each index contains the product of all other elements.
    """
    nums = np.array(nums)
    n = len(nums)

    left = np.cumprod(np.insert(nums[:-1], 0, 1))  # Left product (excluding self)
    right = np.cumprod(np.insert(nums[:0:-1], 0, 1))[::-1]  # Right product (excluding self)

    return left * right  # Element-wise multiplication of left and right products

def product_except_self_n_squared_numpy(nums):
    """
    Computes the product of all elements except the current index using a brute force O(N^2) approach in NumPy.

    Complexity: O(N^2). Uses two nested loops in NumPy to compute the product of all elements except the current index.
    In conclusion, this method is inefficient for large datasets and should be avoided for performance-critical applications.

    Parameters:
    nums (list): The input list of integers.

    Returns:
    np.array: The resulting NumPy array where each index contains the product of all other elements.
    """
    nums = np.array(nums)
    n = len(nums)
    output = []

    # Iterate over all elements (O(N^2) due to nested loops)
    for i in range(n):
        product = 1
        for j in range(n):
            if i != j:  # Skip the element at index i
                product *= nums[j]
        output.append(product)

    return np.array(output)

def product_except_self_series(series):
    """
    Computes the product of all elements except self using Pandas Series.

    Complexity: O(N).
    Similar approach to the pure Python method but optimized using Pandas. Space complexity is O(N) due to additional Series
    storage. Pandas handles operations faster than Python lists but has slight overhead.
    In conclusion, works well if data is already in a Pandas Series but has slight overhead.

    Parameters:
    series (pd.Series): Pandas Series of integers.

    Returns:
    pd.Series: The resulting Series.
    """
    n = len(series)
    left = pd.Series([1] * n)
    right = pd.Series([1] * n)

    # Compute left products (O(N))
    for i in range(1, n):
        left[i] = left[i - 1] * series[i - 1]

    # Compute right products (O(N))
    for i in range(n - 2, -1, -1):
        right[i] = right[i + 1] * series[i + 1]

    return left * right

def product_except_self_dataframe(df, column):
    """
    Computes the product of all elements except self for a specific column in a Pandas DataFrame.

    Complexity: O(N).
    Uses Pandas Series internally, so the performance is equivalent to the Pandas Series function.
    In conclusion, useful for structured data in DataFrames, but not the fastest for raw computations.

    Parameters:
    df (pd.DataFrame): Input DataFrame.
    column (str): Column name to compute the result for.

    Returns:
    pd.DataFrame: New DataFrame with the modified column.
    """
    df = df.copy()  # Avoid modifying the original DataFrame
    df[column] = product_except_self_series(df[column])
    return df

# Example usage
example_nums = [2, 3, 5]

print("\n" + "-" * 50)
print("Pure Python Function (O(N)):")
print(product_except_self_pure(example_nums))
print("-" * 50)

print("NumPy Function (O(N)):")
print(product_except_self_numpy(example_nums))
print("-" * 50)

# Example O(N²) NumPy function
print("NumPy Function (O(N²)):")
print(product_except_self_n_squared_numpy(example_nums))
print("-" * 50)

# Example with Pandas Series
series = pd.Series(example_nums)
updated_series = product_except_self_series(series)

print("Pandas Series Function (O(N), with index):")
print(updated_series)
print("-" * 50)

# Example with Pandas DataFrame
df = pd.DataFrame({"values": example_nums})
updated_df = product_except_self_dataframe(df, "values")

print("Pandas DataFrame Function (O(N), without indexes and header):")
print(updated_df.to_string(index=False, header=False))
print("-" * 50)