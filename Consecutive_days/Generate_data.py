import random
import csv, pandas as pd
from datetime import datetime, timedelta
data = []
users = [(f"ACC_{i}", f"USER_{i}") for i in range(1, 1001)]

for acc_id, user_id in users:
    start_date = datetime(2023, 1, 1)
    for _ in range(10):
        random_day = start_date + timedelta(days=random.randint(0, 30))
        data.append((random_day, acc_id, user_id))

# Create a DataFrame
df = pd.DataFrame(data, columns=["activity_date", "account_id", "user_id"])
df = df.to_csv("user_activity.csv")