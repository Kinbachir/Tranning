using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Text;

namespace TranningDB
{

    public class ProductManager
    {
        private string connectionString = "Data Source=BACHIR;Initial Catalog=tranning;Integrated Security=True;MultipleActiveResultSets=True;Encrypt=False";

        // Add a new product
        public int AddProduct(Product product)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("AddProduct", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@ProductName", product.ProductName);
                    cmd.Parameters.AddWithValue("@UnitPrice", product.UnitPrice);
                    cmd.Parameters.AddWithValue("@QuantityInStock", product.QuantityInStock);

                    conn.Open();
                    return Convert.ToInt32(cmd.ExecuteScalar()); // Return ProductID
                }
            }
        }

        // Update a product's details
        public void UpdateProduct(Product product)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("UpdateProduct", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@ProductID", product.ProductID);
                    cmd.Parameters.AddWithValue("@ProductName", product.ProductName);
                    cmd.Parameters.AddWithValue("@UnitPrice", product.UnitPrice);
                    cmd.Parameters.AddWithValue("@QuantityInStock", product.QuantityInStock);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        // Delete a product
        public void DeleteProduct(int productID)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("DeleteProduct", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@ProductID", productID);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        // Get all products
        public List<Product> GetAllProducts()
        {
            List<Product> products = new List<Product>();

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("GetAllProducts", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            products.Add(new Product
                            {
                                ProductID = reader.GetInt32(0),
                                ProductName = reader.GetString(1),
                                UnitPrice = reader.GetDecimal(2),
                                QuantityInStock = reader.GetInt32(3)
                            });
                        }
                    }
                }
            }

            return products;
        }

        // Get product by ID
        public Product GetProductByID(int productID)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("GetProductByID", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@ProductID", productID);

                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            return new Product
                            {
                                ProductID = reader.GetInt32(0),
                                ProductName = reader.GetString(1),
                                UnitPrice = reader.GetDecimal(2),
                                QuantityInStock = reader.GetInt32(3)
                            };
                        }
                    }
                }
            }

            return null;
        }
    }
}
