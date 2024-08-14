import os
import glob

# Đường dẫn đến thư mục chứa các file cần xóa
directory = "results"

# Tên chung của các file cần xóa (phần đầu của tên file)
file_prefix = "template_report_kinh_doanh.xlsx"

# Tìm tất cả các file bắt đầu với prefix
files = glob.glob(os.path.join(directory, file_prefix + "*"))

# Xóa các file tìm thấy
for file in files:
    try:
        os.remove(file)
        print(f"Deleted: {file}")
    except Exception as e:
        print(f"Failed to delete {file}: {e}")
