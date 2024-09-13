using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Text;

namespace TranningDB
{

    public class StockTransactionManager
    {
        private string connectionString = "Data Source=BACHIR;Initial Catalog=tranning;Integrated Security=True;MultipleActiveResultSets=True;Encrypt=False";

        // Add a stock transaction (IN/OUT)
        public void AddStockTransaction(StockTransaction transaction)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("AddStockTransaction", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@ProductID", transaction.ProductID);
                    cmd.Parameters.AddWithValue("@Quantity", transaction.Quantity);
                    cmd.Parameters.AddWithValue("@TransactionType", transaction.TransactionType);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        // Get all stock transactions
        public List<StockTransaction> GetAllStockTransactions()
        {
            List<StockTransaction> transactions = new List<StockTransaction>();

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("GetAllStockTransactions", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            transactions.Add(new StockTransaction
                            {
                                TransactionID = reader.GetInt32(0),
                                ProductID = reader.GetInt32(1),
                                Quantity = reader.GetInt32(2),
                                TransactionDate = reader.GetDateTime(3),
                                TransactionType = reader.GetString(4)
                            });
                        }
                    }
                }
            }

            return transactions;
        }

        // Get stock transaction by ID
        public StockTransaction GetStockTransactionByID(int transactionID)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("GetStockTransactionByID", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@TransactionID", transactionID);

                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            return new StockTransaction
                            {
                                TransactionID = reader.GetInt32(0),
                                ProductID = reader.GetInt32(1),
                                Quantity = reader.GetInt32(2),
                                TransactionDate = reader.GetDateTime(3),
                                TransactionType = reader.GetString(4)
                            };
                        }
                    }
                }
            }

            return null;
        }
    }
}
