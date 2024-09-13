using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using TranningDB;
namespace Tranning
{
    public partial class ProductList : System.Web.UI.Page
    {
        public string productsList;
        protected void Page_Load(object sender, EventArgs e)
        {
            productsList= JsonConvert.SerializeObject(GetAllProducts());
        }
        public static List<Product> GetAllProducts()
        {
            ProductManager productManager = new ProductManager();
            return productManager.GetAllProducts();  // Get all products from the database
        }

        [WebMethod]
        public static Product GetProductByID(int ProductID)
        {
            ProductManager productManager = new ProductManager();
            return productManager.GetProductByID(ProductID);  // Get product by ID
        }

        [WebMethod]
        public static string AddProduct(string productName, decimal unitPrice, int quantityInStock)
        {
            ProductManager productManager = new ProductManager();
            Product newProduct = new Product
            {
                ProductName = productName,
                UnitPrice = unitPrice,
                QuantityInStock = quantityInStock
            };
            productManager.AddProduct(newProduct);
            return JsonConvert.SerializeObject(productManager.GetAllProducts());
        }

        [WebMethod]
        public static string UpdateProduct(int ProductID, string productName, decimal unitPrice, int quantityInStock)
        {
            ProductManager productManager = new ProductManager();
            Product updatedProduct = new Product
            {
                ProductID = ProductID,
                ProductName = productName,
                UnitPrice = unitPrice,
                QuantityInStock = quantityInStock
            };
            productManager.UpdateProduct(updatedProduct);
            return JsonConvert.SerializeObject(productManager.GetAllProducts());
        }

        [WebMethod]
        public static string DeleteProduct(int ProductID)
        {
            ProductManager productManager = new ProductManager();
            productManager.DeleteProduct(ProductID); 
            return JsonConvert.SerializeObject(productManager.GetAllProducts());
        }
    }
}