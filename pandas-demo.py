import pandas as pd
import numpy as np

# For a quick intro to pandas, see:
# https://colab.research.google.com/notebooks/mlcc/intro_to_pandas.ipynb

# 1. Manually creating a Dataframe (think of it as a table):

city_names = pd.Series(['San Francisco', 'San Jose', 'Sacramento'])
population = pd.Series([852469, 1015785, 485199])

cities = pd.DataFrame({'city name': city_names, 'population': population})

print('\nPrint the whole damn dataframe:\n')
print(cities)

# 2. Importing a file as a Dataframe:

ca_housing_dataframe = pd.read_csv("https://storage.googleapis.com/mledu-datasets/california_housing_train.csv", sep=",")

print('\nCompile interesting stats on the dataframe:\n')
print(ca_housing_dataframe.describe())

print('\nShow the first few records from the dataframe:\n')
print(ca_housing_dataframe.head())

print('\nAccess data much as you would from a list or dict:\n')
population = ca_housing_dataframe['population']
print(type(population))
print(population)

# 3. Manipulating data:

print('\nYou can apply basic arithmetic operators to series:\n')
print(population / 1000)

print('\nYou can map over series with apply:\n')
big_population = population.apply(lambda pop: pop > 1000000)
print(big_population)

# 4. Exercise: create a boolean series for cities named after a saint:

named_after_saint = cities['city name'].apply(lambda name: name[0:3] == 'San')
cities['named after saint'] = named_after_saint

print("\n Cities with our new 'named after saint' series:\n")
print(cities)

# 5. Indices (primary keys) are assigned to each value in a series and dataframe:

print('\nThe index of cities:\n')
print(cities.index)

print('\nRandomizing and reshuffling the index:\n')
cities.reindex(np.random.permutation(cities.index))
print(cities)


