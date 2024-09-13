using System;
using System.Collections.Generic;
using System.Text;

namespace TranningDB
{
    public class Product
    {
        public int ProductID { get; set; }
        public string ProductName { get; set; }
        public decimal UnitPrice { get; set; }
        public int QuantityInStock { get; set; }
    }
}
