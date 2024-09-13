using System;
using System.Collections.Generic;
using System.Text;

namespace TranningDB
{
    public class StockTransaction
    {
        public int TransactionID { get; set; }
        public int ProductID { get; set; }
        public int Quantity { get; set; }
        public DateTime TransactionDate { get; set; }
        public string TransactionType { get; set; } // 'IN' or 'OUT'
    }
}
