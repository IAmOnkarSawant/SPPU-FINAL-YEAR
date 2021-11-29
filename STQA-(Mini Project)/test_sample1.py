import pytest
import pandas as pd
@pytest.fixture()

#original dataset
def df():
  dataset = pd.read_csv('/content/winequality-red.csv')
  return dataset

#expected addCol result 
@pytest.fixture()
def df_added_col():
  dataset = pd.read_csv('/content/winequality-red.csv')
  dataset['quality_value'] = dataset['quality']
  return dataset

#expected deleteCol result
@pytest.fixture()
def df_deletedCol(df_added_col):
  df = df_added_col
  df.drop('quality_value', 1)
  return df

############################################################################

#testing of adding a column in dataset
def test_addCol(df,df_added_col):
  df['quality_value'] = df['quality']
  actual = df
  expected = df_added_col
  pd.testing.assert_frame_equal(actual, expected)

#testing of conversion of quality into its corresponding labels
def test_lableCheck(df_added_col):
  df = df_added_col
  bins = (2, 6.5, 8)
  labels = ['bad', 'good']
  df['quality'] = pd.cut(x = df['quality'], bins = bins, labels = labels)
  c=0
  ic=0
  for row in df: 
    quality_label = df[row][10]
    value = df[row][11]
    if(value>=2 and value<6.5 and quality_label == 'bad'):
      c= c+1
    elif(value>=6.5 and value<=8 and quality_label == 'good'):
      c= c+1
    else:
      ic= ic+1
  
  assert ic != 0 , "Number of tested values does not match the expected values"


#testing deletion of column in dataset 
def test_deletedCol(df_added_col,df_deletedCol):
  df = df_added_col
  df.drop('quality_value', 1)
  actual = df
  expected = df_deletedCol
  pd.testing.assert_frame_equal(actual, expected)


#testing quality of wine
def test_quality (df):
  c=0
  ic=0
  for row in df: 
    value = df[row][11]
    if(value<3 and value>8):
      ic= ic+1     
    assert ic == 0 , "Number of tested values does not match the expected values"

#testing pH of wine
def test_ph (df):
  c=0
  ic=0
  for row in df: 
    value = df[row][8]
    if(value<0 and value>14):
      ic= ic+1     
  assert ic == 0 , "Number of tested values does not match the expected values"

# !py.test