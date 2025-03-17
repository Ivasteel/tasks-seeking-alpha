import re
import pandas as pd

def add_character_before_sequence_simple(text: str, character: str, sequence: str) -> str:
    """
    Inserts a specific character before every occurrence of a given substring in a string (simple method).

    Complexity: O(N), where N is the length of the text.
    The .replace() method in Python iterates through the string once to find all occurrences of the sequence and replaces them.
    If there are M occurrences of sequence, it still performs a single pass through N characters, making it O(N).
    As a result, the function only scans through N characters once, modifying as needed.
    In conclusion, the most efficient because Python’s .replace() does a single pass over the string.

    Parameters:
    text (str): The original input string.
    character (str): The character to insert before each occurrence of the sequence.
    sequence (str): The target substring where the character should be inserted before.

    Returns:
    str: A modified string with the character inserted before the specified sequence.
    """
    return text.replace(sequence, character + sequence)

def add_character_before_sequence_re(text: str, character: str, sequence: str) -> str:
    """
    Inserts a specific character before every occurrence of a given substring in a string using regex.

    Complexity: O(N) in average case, O(NM) in worst case (N = text length, M = number of matches).
    The re.sub() function scans the string and applies a regex pattern match. In the AVG case, regex engines process each character
    once, making it O(N). However, in the worst case, where backtracking occurs (e.g., complex overlapping patterns or excessive
    matches), the complexity increases to O(NM) (where M is the number of matches). Python's regex engine optimizes simple patterns
    like this one, so it remains efficient for most cases. If the regex engine needs to process each match separately, this can
    degrade performance.
    In conclusion, efficient enough in most cases but can degrade due to regex backtracking.

    Parameters:
    text (str): The original input string.
    character (str): The character to insert before each occurrence of the sequence.
    sequence (str): The target substring where the character should be inserted before.

    Returns:
    str: A modified string with the character inserted before the specified sequence.
    """
    return re.sub(f'({re.escape(sequence)})', character + r'\1', text)

def add_character_before_sequence_series(series: pd.Series, character: str, sequence: str) -> pd.Series:
    """
    Modifies a Pandas Series by inserting a character before every occurrence of a given substring in each element.

    Complexity: O(N * L), where N is the number of elements and L is the average string length.
    The .str.replace() method in Pandas applies the regex individually to each element in the Series. If the Series has N elements
    and each element has an average length of L, it results in O(N * L) complexity. Each element is processed separately, making
    complexity depend on both N (rows) and L (length of each string).
    In conclusion, less efficient because applies .str.replace() to each row in a Pandas Series.

    Parameters:
    series (pd.Series): The input Series containing text data.
    character (str): The character to insert before each occurrence of the sequence.
    sequence (str): The target substring where the character should be inserted before.

    Returns:
    pd.Series: A modified Series with updated values.
    """
    return series.str.replace(f'({re.escape(sequence)})', character + r'\1', regex=True)

def add_character_before_sequence_pandas(df: pd.DataFrame, column: str, character: str, sequence: str) -> pd.DataFrame:
    """
    Modifies a specified column of a Pandas DataFrame by inserting a character before every occurrence
    of a given substring in each row.

    Complexity: O(N * L), where N is the number of rows and L is the average string length.
    The .str.replace() method in Pandas applies the regex to a DataFrame column. Each row in the specified column undergoes O(L)
    processing, leading to O(N * L) for N rows. Pandas internally applies .str.replace() row-wise, leading to a time complexity
    dependent on both N (rows) and L (string length).
    In conclusion, least efficient because similar to Series but applied to a full DataFrame column.

    Parameters:
    df (pd.DataFrame): The input DataFrame containing text data.
    column (str): The name of the column to be modified.
    character (str): The character to insert before each occurrence of the sequence.
    sequence (str): The target substring where the character should be inserted before.

    Returns:
    pd.DataFrame: A new DataFrame with the updated column values.
    """
    df = df.copy()  # Avoid modifying the original DataFrame
    df[column] = df[column].str.replace(f'({re.escape(sequence)})', character + r'\1', regex=True)
    return df

# Example usage
example_text = "abcalphacdealphaxalph"

print("\n" + "-" * 50)
print("Simple Replace Function (O(N)):")
print(add_character_before_sequence_simple(example_text, "_", "alpha"))
print("-" * 50)

print("Regexp Replace Function (O(N) avg, O(NM) worst):")
print(add_character_before_sequence_re(example_text, "_", "alpha"))
print("-" * 50)

# Example with Pandas Series
series_data = ["abcalphacdealphaxalph"]
series = pd.Series(series_data)
updated_series = add_character_before_sequence_series(series, "_", "alpha")

print("Pandas Series Function ((O(N * L), with index):")
print(updated_series)
print("-" * 50)

# Example with Pandas DataFrame
df_data = {"text": ["abcalphacdealphaxalph", "alpha123alpha456"]}
df = pd.DataFrame(df_data)
updated_df = add_character_before_sequence_pandas(df, "text", "_", "alpha")

print("Pandas DataFrame Function (O(N * L), without indexes and header):")
print(updated_df.to_string(index=False, header=False))
print("-" * 50)