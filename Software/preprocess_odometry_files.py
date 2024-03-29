import pandas as pd
import os, glob

TESTS_DIR = './Tests/20240118/01_raw/'
PREPROCESSED_DIR = './Tests/20240118/02_preprocessing/'

for d in ('ortogonal','parallel'):
    for l in range(50,250,50):
        for test in glob.glob(os.path.join(TESTS_DIR, f'{d}/{l}/POSE_DATA__2024_01_18*.csv')):
            df = pd.read_csv(test, index_col=False)
            if len(df) == 0:
                continue
            df.to_csv(os.path.join(PREPROCESSED_DIR, f'{d}/{l}/' ,os.path.split(test)[-1]),index=False)