import pandas as pd
import numpy as np
from sklearn.metrics import r2_score, mean_squared_error, mean_absolute_error

# === USER INPUTS ===
# Change file path and column names to match your dataset
file_path = r"../6.Accurcay Assesment/LSAT/Correlation2020LSAT.csv"   # or .xlsx
reference_col = "MODIS LSAT (Reference)"                # observed values column
estimate_col = "L8 LSAT Estimates"                     # predicted values column

# === LOAD DATA ===
if file_path.endswith(".csv"):
    df = pd.read_csv(file_path)
elif file_path.endswith(".xlsx"):
    df = pd.read_excel(file_path)
else:
    raise ValueError("Unsupported file format. Use CSV or Excel.")

# Drop missing values (if any)
df = df[[reference_col, estimate_col]].dropna()

# === CALCULATE METRICS ===
y_true = df[reference_col].values
y_pred = df[estimate_col].values

r2 = r2_score(y_true, y_pred)
rmse = np.sqrt(mean_squared_error(y_true, y_pred))
mse = mean_squared_error(y_true, y_pred)
mae = mean_absolute_error(y_true, y_pred)

# === PRINT RESULTS ===
print("Accuracy Metrics")
print("----------------")
print(f"R²   : {r2:.3f}")
print(f"RMSE : {rmse:.3f}")
print(f"MSE  : {mse:.3f}")
print(f"MAE  : {mae:.3f}")
