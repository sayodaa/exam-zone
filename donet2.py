import pandas as pd

# البيانات الخام من المستخدم
raw_data = [
    # Scenario, Category, Operations, Unit Cost ($) [مضروبة بالخطأ], Estimated Monthly Cost ($) [مضروبة بالخطأ]
    ("5000 Users - Medium Usage", "Firestore Reads", 100000, 0.001, 100),
    ("5000 Users - Medium Usage", "Firestore Writes", 50000, 0.001, 50),
    ("5000 Users - Medium Usage", "Cloud Functions", 20000, 0.0015, 30),
    ("5000 Users - Medium Usage", "Storage", 1000, 0.02, 20),
    ("5000 Users - Heavy Usage", "Firestore Reads", 200000, 0.001, 200),
    ("5000 Users - Heavy Usage", "Firestore Writes", 100000, 0.001, 100),
    ("5000 Users - Heavy Usage", "Cloud Functions", 40000, 0.0015, 60),
    ("5000 Users - Heavy Usage", "Storage", 2000, 0.02, 40),
    ("10000 Users - Medium Usage", "Firestore Reads", 200000, 0.001, 200),
    ("10000 Users - Medium Usage", "Firestore Writes", 100000, 0.001, 100),
    ("10000 Users - Medium Usage", "Cloud Functions", 40000, 0.0015, 60),
    ("10000 Users - Medium Usage", "Storage", 2000, 0.02, 40),
    ("10000 Users - Heavy Usage", "Firestore Reads", 400000, 0.001, 400),
    ("10000 Users - Heavy Usage", "Firestore Writes", 200000, 0.001, 200),
    ("10000 Users - Heavy Usage", "Cloud Functions", 80000, 0.0015, 120),
    ("10000 Users - Heavy Usage", "Storage", 4000, 0.02, 80),
]

# التسعير الحقيقي (لـ 100,000 عملية أو حسب الجيجا)
true_unit_cost = {
    "Firestore Reads": 0.06 / 100000,  # $0.0000006
    "Firestore Writes": 0.18 / 100000,  # $0.0000018
    "Cloud Functions": 0.40 / 1000000,  # $0.0000004
    "Storage": 0.026  # نفترض أنها لكل جيجا، وليس "لكل عملية"
}

# معالجة البيانات
rows = []
for scenario, category, ops, old_unit, old_total in raw_data:
    true_cost_per_unit = true_unit_cost[category]
    corrected_total = round(ops * true_cost_per_unit, 4)
    rows.append({
        "Scenario": scenario,
        "Category": category,
        "Operations": ops,
        "Wrong Unit Cost ($)": old_unit,
        "Wrong Total ($)": old_total,
        "True Unit Cost ($)": true_cost_per_unit,
        "Corrected Monthly Cost ($)": corrected_total
    })

# إنشاء الداتا فريم
corrected_df = pd.DataFrame(rows)

# حساب الإجماليات لكل سيناريو
totals = corrected_df.groupby("Scenario")["Corrected Monthly Cost ($)"].sum().reset_index()
totals["Category"] = "Total Cost"
totals["Operations"] = ""
totals["Wrong Unit Cost ($)"] = ""
totals["Wrong Total ($)"] = ""
totals["True Unit Cost ($)"] = ""
totals = totals[corrected_df.columns]  # ترتيب الأعمدة

# دمجهم
corrected_df = pd.concat([corrected_df, totals], ignore_index=True)

# تصدير لملف Excel
excel_path = "/mnt/data/firebase_corrected_costs.xlsx"
corrected_df.to_excel(excel_path, index=False)
excel_path
