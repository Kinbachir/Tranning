using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace TranningDB
{
    public class SupplierManagement
    {
        private string connectionString = "Data Source=BACHIR;Initial Catalog=tranning;Integrated Security=True;MultipleActiveResultSets=True;Encrypt=False";


        // 1. Add a new supplier
        public int AddSupplier(Supplier supplier)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("AddSupplier", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@SupplierName", supplier.SupplierName);
                    cmd.Parameters.AddWithValue("@ContactEmail", supplier.ContactEmail);
                    cmd.Parameters.AddWithValue("@Phone", supplier.Phone);

                    conn.Open();
                    int supplierID = Convert.ToInt32(cmd.ExecuteScalar()); // Get the newly created SupplierID
                    return supplierID;
                }
            }
        }

        // 2. Update a supplier's details
        public void UpdateSupplier(Supplier supplier)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("UpdateSupplier", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@SupplierID", supplier.SupplierID);
                    cmd.Parameters.AddWithValue("@SupplierName", supplier.SupplierName);
                    cmd.Parameters.AddWithValue("@ContactEmail", supplier.ContactEmail);
                    cmd.Parameters.AddWithValue("@Phone", supplier.Phone);

                    conn.Open();
                    try
                    {
                        cmd.ExecuteNonQuery();
                        Console.WriteLine("Supplier updated successfully.");
                    }
                    catch (SqlException ex)
                    {
                        Console.WriteLine("Error updating supplier: " + ex.Message);
                    }
                }
            }
        }

        // 3. Delete a supplier
        public void DeleteSupplier(int supplierID)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("DeleteSupplier", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@SupplierID", supplierID);

                    conn.Open();
                    try
                    {
                        cmd.ExecuteNonQuery();
                        Console.WriteLine("Supplier deleted successfully.");
                    }
                    catch (SqlException ex)
                    {
                        Console.WriteLine("Error deleting supplier: " + ex.Message);
                    }
                }
            }
        }

        // 4. Get all suppliers (returns List<Supplier>)
        public List<Supplier> GetAllSuppliers()
        {
            List<Supplier> suppliers = new List<Supplier>();

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("GetAllSuppliers", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            Supplier supplier = new Supplier
                            {
                                SupplierID = reader.GetInt32(0),
                                SupplierName = reader.GetString(1),
                                ContactEmail = reader.IsDBNull(2) ? null : reader.GetString(2),
                                Phone = reader.IsDBNull(3) ? null : reader.GetString(3)
                            };
                            suppliers.Add(supplier);
                        }
                    }
                }
            }

            return suppliers;
        }

        // 5. Get a supplier by ID (returns Supplier object)
        public Supplier GetSupplierByID(int supplierID)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("GetSupplierByID", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@SupplierID", supplierID);

                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            Supplier supplier = new Supplier
                            {
                                SupplierID = reader.GetInt32(0),
                                SupplierName = reader.GetString(1),
                                ContactEmail = reader.IsDBNull(2) ? null : reader.GetString(2),
                                Phone = reader.IsDBNull(3) ? null : reader.GetString(3)
                            };
                            return supplier;
                        }
                        else
                        {
                            Console.WriteLine("Supplier not found.");
                            return null;
                        }
                    }
                }
            }
        }
    }
}