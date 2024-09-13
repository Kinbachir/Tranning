using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Web.Services;
using System.Web.UI;
using TranningDB;

namespace Tranning
{
    public partial class SupplierList : System.Web.UI.Page
    {
        public string suppliersList;

        protected void Page_Load(object sender, EventArgs e)
        {
            suppliersList = JsonConvert.SerializeObject(GetAllSuppliers());
        }

        public static List<Supplier> GetAllSuppliers()
        {
            SupplierManagement SupplierManagement = new SupplierManagement();
            return SupplierManagement.GetAllSuppliers();  // Get all suppliers from the database
        }

        [WebMethod]
        public static Supplier GetSupplierByID(int SupplierID)
        {
            SupplierManagement SupplierManagement = new SupplierManagement();
            return SupplierManagement.GetSupplierByID(SupplierID);  // Get supplier by ID
        }

        [WebMethod]
        public static string AddSupplier(string supplierName, string phone, string contactEmail)
        {
            SupplierManagement SupplierManagement = new SupplierManagement();
            Supplier newSupplier = new Supplier
            {
                SupplierName = supplierName,
                Phone = phone,
                ContactEmail = contactEmail
            };
            SupplierManagement.AddSupplier(newSupplier);
            return JsonConvert.SerializeObject(SupplierManagement.GetAllSuppliers());
        }

        [WebMethod]
        public static string UpdateSupplier(int SupplierID, string supplierName, string phone, string contactEmail)
        {
            SupplierManagement SupplierManagement = new SupplierManagement();
            Supplier updatedSupplier = new Supplier
            {
                SupplierID = SupplierID,
                SupplierName = supplierName,
                Phone = phone,
                ContactEmail = contactEmail
            };
            SupplierManagement.UpdateSupplier(updatedSupplier);
            return JsonConvert.SerializeObject(SupplierManagement.GetAllSuppliers());
        }

        [WebMethod]
        public static string DeleteSupplier(int SupplierID)
        {
            SupplierManagement SupplierManagement = new SupplierManagement();
            SupplierManagement.DeleteSupplier(SupplierID);
            return JsonConvert.SerializeObject(SupplierManagement.GetAllSuppliers());
        }
    }
}
