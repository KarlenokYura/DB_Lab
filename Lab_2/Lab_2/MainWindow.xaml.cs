using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;

namespace Lab_2
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        SqlConnection con;
        SqlCommand com;

        public MainWindow()
        {
            InitializeComponent();
        }

        public string getConnection()
        {
            string connectionString = @"Data Source=.\SQLEXPRESS;Initial Catalog=Lab_1;Integrated Security=True";
            return connectionString;
        }

        public DataTable getFlatType()
        {
            DataSet dataSet;
            using (con = new SqlConnection(getConnection()))
            {
                con.Open();
                using (com = new SqlCommand("SELECT * FROM flat_type", con))
                {
                    com.CommandType = CommandType.Text;
                    SqlDataAdapter sqlDataAdapter = new SqlDataAdapter();
                    sqlDataAdapter.SelectCommand = com;
                    dataSet = new DataSet();
                    sqlDataAdapter.Fill(dataSet, "flat_type");
                    con.Close();
                }
            }
            return dataSet.Tables["flat_type"];
        }

        public void setFlatType()
        {
            FlatType flatType = new FlatType();
            flatType.FlatTypeName = flatTypeName.Text;

            using (con = new SqlConnection(getConnection()))
            {
                con.Open();
                using (com = new SqlCommand("flat_type_insert", con))
                {
                    com.CommandType = CommandType.StoredProcedure;
                    SqlParameter nameParam = new SqlParameter
                    {
                        ParameterName = "@flat_type_name",
                        Value = flatType.FlatTypeName
                    };
                    com.Parameters.Add(nameParam);
                    com.ExecuteScalar();
                }
            }
        }

        public void updateFlatType()
        {
            FlatType flatType = new FlatType();
            flatType.FlatTypeId = Int32.Parse(flatTypeId.Text);
            flatType.FlatTypeName = flatTypeName.Text;

            using (con = new SqlConnection(getConnection()))
            {
                con.Open();
                using (com = new SqlCommand("flat_type_update", con))
                {
                    com.CommandType = CommandType.StoredProcedure;
                    SqlParameter idParam = new SqlParameter
                    {
                        ParameterName = "@flat_type_id",
                        Value = flatType.FlatTypeId
                    };
                    SqlParameter nameParam = new SqlParameter
                    {
                        ParameterName = "@flat_type_name",
                        Value = flatType.FlatTypeName
                    };
                    com.Parameters.Add(idParam);
                    com.Parameters.Add(nameParam);
                    com.ExecuteScalar();
                }
            }
        }

        public void deleteFlatType()
        {
            FlatType flatType = new FlatType();
            flatType.FlatTypeId = Int32.Parse(flatTypeId.Text);
            flatType.FlatTypeName = flatTypeName.Text;

            using (con = new SqlConnection(getConnection()))
            {
                con.Open();
                using (com = new SqlCommand("flat_type_delete", con))
                {
                    com.CommandType = CommandType.StoredProcedure;
                    SqlParameter idParam = new SqlParameter
                    {
                        ParameterName = "@flat_type_id",
                        Value = flatType.FlatTypeId
                    };
                    com.Parameters.Add(idParam);
                    com.ExecuteScalar();
                }
            }
        }

        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            dataGrid.ItemsSource = getFlatType().DefaultView;
        }

        private void Insert_Click(object sender, RoutedEventArgs e)
        {
            setFlatType();
            dataGrid.ItemsSource = getFlatType().DefaultView;
            flatTypeId.Clear();
            flatTypeName.Clear();
        }

        private void Update_Click(object sender, RoutedEventArgs e)
        {
            updateFlatType();
            dataGrid.ItemsSource = getFlatType().DefaultView;
            flatTypeId.Clear();
            flatTypeName.Clear();
        }
        private void Delete_Click(object sender, RoutedEventArgs e)
        {
            deleteFlatType();
            dataGrid.ItemsSource = getFlatType().DefaultView;
            flatTypeId.Clear();
            flatTypeName.Clear();
        }

        private void DataGrid_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            DataGrid dataGrid = sender as DataGrid;
            DataRowView dataRow = dataGrid.SelectedItem as DataRowView;
            if (dataRow != null)
            {
                flatTypeId.Text = dataRow["FLAT_TYPE_ID"].ToString();
                flatTypeName.Text = dataRow["FLAT_TYPE_NAME"].ToString();
            }
        }
    }
}
