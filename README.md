# Monthly Business Ranking Analysis Report

## Table of Content:
- [1. Data Collection](#1-data-collection)
- [2. Data Modeling & ETL (Extract, Transform, Load) Processes](#2-data-preparation--transformation)
- [3. Database Connection & WinForm Integration with Python](#3-data-model)
- [4. Data Visualization](#4-data-visualization)
- [5. Demo](#5-demo)

My Goals: The project will assist you in creating overviews and monthly ranking reports, including everything from data preparation and collecting to data analysis and visualization.

<details>
    <summary id="1-data-collection">1. Data Collection 📋</summary>
    
* Choose file CSV on your desk to import data into DBeaver CE 📁 :
  
  <div align="center">
    <img src="https://github.com/user-attachments/assets/efd48115-7814-4a26-95e8-3888e5fc8bf9" alt="Choose file CSV" />
    <p><em>Choose file csv on computer</em></p>
  </div>

* Table Mapping 📊:
  
  <div align="center">
    <img src="https://github.com/user-attachments/assets/5d69790d-6fc3-44ac-906e-80bdde5722fa"/>
    <p><em>fact_kpi_month_raw_data_202402020653.csv</em></p>
  </div>

  <div align="center">
    <img src="https://github.com/user-attachments/assets/cb92c316-dc1b-4aa2-886e-8083ab18a992"/>
    <p><em>fact_txn_month_raw_data_202402020504.csv</em></p>
  </div>

  <div align="center">
    <img src="https://github.com/user-attachments/assets/d313d5aa-2bad-4330-bf86-82b124e0fde6"/>
    <p><em>dim_structure.csv</em></p>
  </div>

  <div align="center">
    <img src="https://github.com/user-attachments/assets/3fba2db3-8ae1-4d7d-a9a4-f95e7e26b6f7"/>
    <p><em>dim_pos.csv</em></p>
  </div>

   <div align="center">
    <img src="https://github.com/user-attachments/assets/c5dc163c-71a4-498b-bb16-4a219e01340c"/>
    <p><em>kpi_asm_data_202305.csv</em></p>
  </div>

<span>**Note**</span>: When querying, you can modify the target columns to the name columns of your choice. However, you must select the target type depending on the source type since it directly affects the table data in dbeaver-ce.
  
* Loading⏳:
  
<div align="center">
  <img src="https://github.com/user-attachments/assets/6e9c16ea-3cee-4a0b-824a-03db34adf42c" alt="loading file .csv" />
  <p><em>loading file .csv</em></p>
</div>

<span>**However**</span>, if there is a problem, you should remove the actual table from dbeaver-ce and restart the procedure. You can get in touch with me for assistance.

<div align="center">
  <img src="https://github.com/user-attachments/assets/2ae9e380-d3d8-450f-8b3c-2248045641b4" alt="the screen following a successful import" />
  <p><em>the screen following a successful import</em></p>
</div>

</details>


<details>
  <summary id="2-data-preparation--transformation">2. Data Modeling & ETL (Extract, Transform, Load) Processes 🗃️ </summary>
    
* You need to create physical, we will 2 folder including: summary (tổng hợp) and ranking (xếp hạng)
    * Summary(tổng hợp):
  
      - You may view the code postgres by click this [here](https://github.com/phucnguyen140502/Monthly-Business-Ranking-Report/tree/main/script/t%C3%B4ng%20h%E1%BB%A3p). After the creating the physical table for the summary, this is the query you should use:
        
      - It the query when you finish create physical table for summary:
     
        ```sql
        SELECT * FROM results r;
        ```

              
          
      <div align="center">
      <img src="https://github.com/user-attachments/assets/2cc7e639-88d1-499e-a320-ab5d39190399"/>
       <p><em>the results for summary</em></p>
     </div>

      
    * Ranking (xếp hạng):
      
      - You may view the code postgres by click this [here](https://github.com/phucnguyen140502/Monthly-Business-Ranking-Report/tree/main/script/x%E1%BA%BFp%20h%E1%BA%A1ng). After the creating the physical table for the summary, this is the query you should use:
        
      - It the query when you finish create physical table for ranking:
     
        ```sql
        SELECT * FROM xep_hang xh;
        ```
            
        
      <div align="center">
      <img src="https://github.com/user-attachments/assets/95c07a25-c261-4091-a8f7-7cf7c754fd2d"/>
       <p><em>the results for ranking</em></p>
     </div>


</details>

<details>
  <summary id="3-data-model">3. Database Connection & WinForm Integration with Python</summary>
    
* Connect With Postgres:
    ```python

    def test_connection():
        dbname = dbname_entry.get()
        user = user_entry.get()
        host = host_entry.get()
        password = password_entry.get()
        port = port_entry.get()
    
        password = urllib.parse.quote_plus(password)
        connection_string = f"postgresql://{user}:{password}@{host}:{port}/{dbname}"
        
        try:
            engine = create_engine(connection_string)
            connection = engine.connect()
            connection.close()
            connection_status.config(text="Connected successfully", foreground="green")
            messagebox.showinfo("Connection Success", "Successfully connected to the database!")
        except Exception as e:
            connection_status.config(text="Connection failed", foreground="red")
            messagebox.showerror("Connection Error", f"Failed to connect to the database:\n{str(e)}")

    def connect_postgres(query, connection_details):
        """
        Kết nối với PostgreSQL thông qua SQLAlchemy và lấy dữ liệu theo query.
        """
        engine = create_engine(connection_details)
        df = pd.read_sql_query(query, engine)
        engine.dispose()
        return df
    ```
    
* Update excel BCTH & BCXH:

    ```python
    def update_excel_BCTH_with_postgres_data(excel_file, sheet_name, query, connection_details, criteria_column='criteria'):
        """
        Kiểm tra dữ liệu trong cột A của tệp Excel và ghi dữ liệu từ PostgreSQL vào bắt đầu từ hàng 4.
        """
        # Load the Excel file and the specific sheet
        workbook = load_workbook(excel_file)
        sheet = workbook[sheet_name]
        
        # Get the criteria column from PostgreSQL
        criteria_df = connect_postgres(query, connection_details)
        # print(criteria_df)
        criteria_list = criteria_df[criteria_column].tolist()
        # print(criteria_list)
        # Iterate through each cell in column A starting from row 4
        for row in sheet.iter_rows(min_row=4, min_col=1, max_col=1):
            cell_value = row[0].value
            if cell_value in criteria_list:
                # Get the row index
                row_index = row[0].row
                # Update the cells in this row with the data from PostgreSQL
                for col_index, value in enumerate(criteria_df.loc[criteria_df[criteria_column] == cell_value].values.flatten(), start=1):
                    sheet.cell(row=row_index, column=col_index, value=value)
        
        # Save the workbook
        workbook.save(excel_file)

    def update_excel_BCXH_with_postgres_data(excel_file, sheet_name, query, connection_details):
        """
        Ghi dữ liệu từ PostgreSQL vào tệp Excel bắt đầu từ hàng 3.
        """
        # Load the Excel file and the specific sheet
        workbook = load_workbook(excel_file)
        sheet = workbook[sheet_name]
        
        # Get the data from PostgreSQL
        data_df = connect_postgres(query, connection_details)
        
        # Start writing from the 3rd row in the Excel sheet
        start_row = 3
        
        for row_idx, row in data_df.iterrows():
            for col_idx, value in enumerate(row, start=1):
                sheet.cell(row=row_idx + start_row, column=col_idx, value=value)
        
        # Save the workbook
        workbook.save(excel_file)
    ```
    
* Winform:

    ```python
    root = tk.Tk()
    root.title("Report Kinh Doanh")
    root.geometry("450x400")
    
    frame = ttk.Frame(root, padding="10")
    frame.grid(row=0, column=0, sticky=(tk.W, tk.E, tk.N, tk.S))
    root.columnconfigure(0, weight=1)
    root.rowconfigure(0, weight=1)
    
    ttk.Label(frame, text="Connection Info").grid(column=0, row=0, columnspan=2, sticky=tk.W)
    
    entry_width = 25
    
    ttk.Label(frame, text="DBname").grid(column=0, row=1, sticky=tk.W)
    dbname_entry = ttk.Entry(frame, width=entry_width)
    dbname_entry.grid(column=0, row=2, sticky=tk.W, padx=(0, 5))
    
    ttk.Label(frame, text="User").grid(column=1, row=1, sticky=tk.W)
    user_entry = ttk.Entry(frame, width=entry_width)
    user_entry.grid(column=1, row=2, sticky=tk.W)
    
    ttk.Label(frame, text="Host").grid(column=0, row=3, sticky=tk.W)
    host_entry = ttk.Entry(frame, width=entry_width)
    host_entry.grid(column=0, row=4, sticky=tk.W, padx=(0, 5))
    
    ttk.Label(frame, text="Password").grid(column=1, row=3, sticky=tk.W)
    password_entry = ttk.Entry(frame, width=entry_width, show="*")
    password_entry.grid(column=1, row=4, sticky=tk.W)
    
    ttk.Label(frame, text="Port").grid(column=0, row=5, sticky=tk.W)
    port_entry = ttk.Entry(frame, width=entry_width)
    port_entry.grid(column=0, row=6, sticky=tk.W, padx=(0, 5))
    
    ttk.Button(frame, text="Test Connection", command=test_connection).grid(column=1, row=6, sticky=tk.E)
    
    connection_status = ttk.Label(frame, text="")
    connection_status.grid(column=0, row=7, columnspan=2, sticky=tk.W)
    
    # Checkboxes to select which sheets to update
    var_template_BCTH = tk.BooleanVar()
    var_template_BCXH = tk.BooleanVar()
    
    ttk.Checkbutton(frame, text="Update template_BCTH", variable=var_template_BCTH).grid(column=0, row=8, columnspan=2, sticky=tk.W)
    ttk.Checkbutton(frame, text="Update template_BCXH", variable=var_template_BCXH).grid(column=0, row=9, columnspan=2, sticky=tk.W)
    
    ttk.Button(frame, text="Export", command=export).grid(column=1, row=10, sticky=tk.E)
    
    frame.columnconfigure(0, weight=1)
    frame.columnconfigure(1, weight=1)
    
    root.mainloop()
    ```

* Export:
         
    ```python
    
    def export():
        dbname = dbname_entry.get()
        user = user_entry.get()
        host = host_entry.get()
        password = password_entry.get()
        port = port_entry.get()
        
        password = urllib.parse.quote_plus(password)
        connection_string = f'postgresql://{user}:{password}@{host}:{port}/{dbname}'
        
        try:
        
            excel_file = 'template_report_kinh_doanh.xlsx'
        
            if var_template_BCTH.get():
                query1 = "SELECT * FROM xep_hang_kinh_doanh.results"
                sheet_name1 = 'template_BCTH'
                update_excel_BCTH_with_postgres_data(excel_file, sheet_name1, query1, connection_string)
            
            if var_template_BCXH.get():
                query2 = "SELECT * FROM xep_hang_kinh_doanh.xep_hang"
                sheet_name2 = 'template_BCXH'
                update_excel_BCXH_with_postgres_data(excel_file, sheet_name2, query2, connection_string)
            
            messagebox.showinfo("Success", "Report generated successfully!")
        except Exception as e:
            messagebox.showerror("Error", f"Failed to generate report:\n{str(e)}")
    ```

* Results:
  <div align="center">
      <img src="https://github.com/user-attachments/assets/b1efe68b-72b6-4d92-b346-23ded147846c"/>
       <p><em>Winform Screen</em></p>
     </div>
  

</details>

<details>
  <summary id="4-data-visualization">4. Data Visualization</summary>
<div align="center">
<img src="https://github.com/user-attachments/assets/426dd3b0-02fa-41ec-8a2f-2dce80e9f861"/>
   <p><em>Bao Cao Tong Hop</em></p>
 </div>

<div align="center">
<img src="https://github.com/user-attachments/assets/32ae03c1-447f-4ba2-b79c-5df873fe7a70"/>
<p><em>Bao Cao Xếp Hạng</em></p>
</div>

</details>

<details>
  <summary id="5-demo">5. Demo</summary>

https://github.com/user-attachments/assets/9e9fca5b-a12a-48bf-af1e-5d16cda652a2

<p><em>Demo project</em></p>

</details>

