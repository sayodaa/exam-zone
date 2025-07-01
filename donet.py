import pandas as pd

# بيانات التشغيل
scenarios = [
    ("5000 Users - Medium Usage", 100_000, 50_000, 20_000, 1),   # 1 GB تقريبًا
    ("5000 Users - Heavy Usage", 200_000, 100_000, 40_000, 2),
    ("10000 Users - Medium Usage", 200_000, 100_000, 40_000, 2),
    ("10000 Users - Heavy Usage", 400_000, 200_000, 80_000, 4)
]

# أسعار Firebase الحقيقية (لكل عملية)
FIRESTORE_READ_COST = 0.06 / 100_000      # = 0.0000006
FIRESTORE_WRITE_COST = 0.18 / 100_000     # = 0.0000018
FUNCTION_CALL_COST = 0.40 / 1_000_000     # = 0.0000004
STORAGE_COST_PER_GB = 0.026               # لكل جيجابايت

# إنشاء البيانات المحسوبة
data = []
for scenario, reads, writes, functions, storage_gb in scenarios:
    read_cost = reads * FIRESTORE_READ_COST
    write_cost = writes * FIRESTORE_WRITE_COST
    function_cost = functions * FUNCTION_CALL_COST
    storage_cost = storage_gb * STORAGE_COST_PER_GB

    data.append([scenario, "Firestore Reads", reads, FIRESTORE_READ_COST, round(read_cost, 4)])
    data.append([scenario, "Firestore Writes", writes, FIRESTORE_WRITE_COST, round(write_cost, 4)])
    data.append([scenario, "Cloud Functions", functions, FUNCTION_CALL_COST, round(function_cost, 4)])
    data.append([scenario, "Storage (GB)", storage_gb, STORAGE_COST_PER_GB, round(storage_cost, 4)])

    total = round(read_cost + write_cost + function_cost + storage_cost, 4)
    data.append([scenario, "Total Cost", "", "", total])

# تحويل لـ DataFrame
df = pd.DataFrame(data, columns=["Scenario", "Category", "Operations", "Unit Cost ($)", "Estimated Monthly Cost ($)"])

# حفظه في ملف Excel
df.to_excel("firebase_cost_realistic_estimate.xlsx", index=False)

print("✅ تم إنشاء ملف التكاليف المحسوبة بدقة: firebase_cost_realistic_estimate.xlsx")
