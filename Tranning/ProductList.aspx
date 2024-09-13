<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProductList.aspx.cs" Inherits="Tranning.ProductList" %>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Product Management</title>
<!-- EasyUI CSS -->
<link rel="stylesheet" type="text/css" href="https://www.jeasyui.com/easyui/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="https://www.jeasyui.com/easyui/themes/icon.css">

<!-- EasyUI JS -->
<script type="text/javascript" src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script type="text/javascript" src="https://www.jeasyui.com/easyui/jquery.easyui.min.js"></script>
    <!-- SweetAlert2 JS -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>
<body>
    <!-- Toolbar with "Add Product" button -->
    <div id="toolbar">
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" id="addProductBtn">Add New Product</a>
    </div>

    <!-- EasyUI DataGrid to display products -->
    <table id="productTable" class="easyui-datagrid" style="width:100%;height:400px;"
           url="ProductList.aspx/GetAllProducts" 
           method="post"
           pagination="true"
           toolbar="#toolbar"
           rownumbers="true"
           fitColumns="true"
           singleSelect="true">
        <thead>
            <tr>
                <th field="ProductID" hidden="true">ID</th>
                <th field="ProductName" width="40%">Product Name</th>
                <th field="UnitPrice" width="20%">Unit Price</th>
                <th field="QuantityInStock" width="20%">Stock Quantity</th>
                <th field="Action" width="20%" formatter="actionFormatter">Action</th>
            </tr>
        </thead>
    </table>

    <script>
        var productList = <%=productsList%>;
        console.log(productList);
        $(document).ready(function () {
            $('#productTable').datagrid('loadData', productList);
        });
        // Formatter to add Update/Delete buttons to each row
        function actionFormatter(value, row, index) {
            return `
                <a href="javascript:void(0)" onclick="editProduct(${row.ProductID})" class="easyui-linkbutton" iconCls="icon-edit">Edit</a>
                <a href="javascript:void(0)" onclick="deleteProduct(${row.ProductID})" class="easyui-linkbutton" iconCls="icon-remove">Delete</a>
            `;
        }

        // Add Product using SweetAlert2
        $('#addProductBtn').click(function () {
            Swal.fire({
                title: 'Add New Product',
                html: `
                    <input id="productName" class="swal2-input" placeholder="Product Name">
                    <input id="unitPrice" class="swal2-input" type="number" placeholder="Unit Price">
                    <input id="quantityInStock" class="swal2-input" type="number" placeholder="Stock Quantity">
                `,
                confirmButtonText: 'Add Product',
                preConfirm: () => {
                    const productName = document.getElementById('productName').value;
                    const unitPrice = document.getElementById('unitPrice').value;
                    const quantityInStock = document.getElementById('quantityInStock').value;

                    if (!productName || !unitPrice || !quantityInStock) {
                        Swal.showValidationMessage('Please enter all details');
                    } else {
                        return { productName, unitPrice, quantityInStock };
                    }
                }
            }).then((result) => {
                if (result.isConfirmed) {
                    $.ajax({
                        type: 'POST',
                        url: 'ProductList.aspx/AddProduct',
                        data: JSON.stringify(result.value),
                        contentType: 'application/json; charset=utf-8',
                        success: function (reponse) {
                            console.log(reponse)
                            $('#productTable').datagrid('loadData', JSON.parse(reponse.d));
                            $('#productTable').datagrid('reload');  // Reload the data in DataGrid
                            Swal.fire('Product Added!', '', 'success');
                        }
                    });
                }
            });
        });

        // Edit Product using SweetAlert2
        function editProduct(productId) {
            $.ajax({
                type: 'POST',
                url: 'ProductList.aspx/GetProductByID',
                data: JSON.stringify({ ProductID: productId }),
                contentType: 'application/json; charset=utf-8',
                success: function (response) {
                    const product = response.d;
                    Swal.fire({
                        title: 'Edit Product',
                        html: `
                            <input id="productName" class="swal2-input" value="${product.ProductName}" placeholder="Product Name">
                            <input id="unitPrice" class="swal2-input" type="number" value="${product.UnitPrice}" placeholder="Unit Price">
                            <input id="quantityInStock" class="swal2-input" type="number" value="${product.QuantityInStock}" placeholder="Stock Quantity">
                        `,
                        confirmButtonText: 'Update Product',
                        preConfirm: () => {
                            const productName = document.getElementById('productName').value;
                            const unitPrice = document.getElementById('unitPrice').value;
                            const quantityInStock = document.getElementById('quantityInStock').value;

                            if (!productName || !unitPrice || !quantityInStock) {
                                Swal.showValidationMessage('Please enter all details');
                            } else {
                                return { ProductID: productId, productName, unitPrice, quantityInStock };
                            }
                        }
                    }).then((result) => {
                        if (result.isConfirmed) {
                            $.ajax({
                                type: 'POST',
                                url: 'ProductList.aspx/UpdateProduct',
                                data: JSON.stringify(result.value),
                                contentType: 'application/json; charset=utf-8',
                                success: function (reponse) {
                                    console.log(reponse)
                                    $('#productTable').datagrid('loadData', JSON.parse(reponse.d));
                                    $('#productTable').datagrid('reload');
                                    Swal.fire('Product Updated!', '', 'success');
                                }
                            });
                        }
                    });
                }
            });
        }

        // Delete Product using SweetAlert2
        function deleteProduct(productId) {
            Swal.fire({
                title: 'Are you sure?',
                text: 'This product will be deleted!',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonText: 'Yes, delete it!'
            }).then((result) => {
                if (result.isConfirmed) {
                    $.ajax({
                        type: 'POST',
                        url: 'ProductList.aspx/DeleteProduct',
                        data: JSON.stringify({ ProductID: productId }),
                        contentType: 'application/json; charset=utf-8',
                        success: function (reponse) {
                            console.log(reponse)
                            $('#productTable').datagrid('loadData', JSON.parse(reponse.d));
                            $('#productTable').datagrid('reload');
                            Swal.fire('Deleted!', 'The product has been deleted.', 'success');
                        }
                    });
                }
            });
        }
    </script>
</body>
</html>
