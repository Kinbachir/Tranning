<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SupplierList.aspx.cs" Inherits="Tranning.SupplierList" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Supplier Management</title>
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
    <!-- Toolbar with "Add Supplier" button -->
    <div id="toolbar">
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" id="addSupplierBtn">Add New Supplier</a>
    </div>

    <!-- EasyUI DataGrid to display suppliers -->
    <table id="supplierTable" class="easyui-datagrid" style="width:100%;height:400px;"
           url="SupplierList.aspx/GetAllSuppliers" 
           method="post"
           pagination="true"
           toolbar="#toolbar"
           rownumbers="true"
           fitColumns="true"
           singleSelect="true">
        <thead>
            <tr>
                <th field="SupplierID" hidden="true">ID</th>
                <th field="SupplierName" width="30%">Supplier Name</th>
                <th field="Phone" width="30%">Phone</th>
                <th field="ContactEmail" width="30%">Contact Email</th>
                <th field="Action" width="10%" formatter="actionFormatter">Action</th>
            </tr>
        </thead>
    </table>

    <script>
        // Formatter to add Update/Delete buttons to each row
        function actionFormatter(value, row, index) {
            return `
                <a href="javascript:void(0)" onclick="editSupplier(${row.SupplierID})" class="easyui-linkbutton" iconCls="icon-edit">Edit</a>
                <a href="javascript:void(0)" onclick="deleteSupplier(${row.SupplierID})" class="easyui-linkbutton" iconCls="icon-remove">Delete</a>
            `;
        }

        // Add Supplier using SweetAlert2
        $('#addSupplierBtn').click(function () {
            Swal.fire({
                title: 'Add New Supplier',
                html: `
                    <input id="supplierName" class="swal2-input" placeholder="Supplier Name">
                    <input id="phone" class="swal2-input" placeholder="Phone">
                    <input id="contactEmail" class="swal2-input" placeholder="Contact Email">
                `,
                confirmButtonText: 'Add Supplier',
                preConfirm: () => {
                    const supplierName = document.getElementById('supplierName').value;
                    const phone = document.getElementById('phone').value;
                    const contactEmail = document.getElementById('contactEmail').value;

                    if (!supplierName || !phone || !contactEmail) {
                        Swal.showValidationMessage('Please enter all details');
                    } else {
                        return { supplierName, phone, contactEmail };
                    }
                }
            }).then((result) => {
                if (result.isConfirmed) {
                    $.ajax({
                        type: 'POST',
                        url: 'SupplierList.aspx/AddSupplier',
                        data: JSON.stringify(result.value),
                        contentType: 'application/json; charset=utf-8',
                        success: function (response) {
                            $('#supplierTable').datagrid('loadData', JSON.parse(response.d));
                            $('#supplierTable').datagrid('reload');  // Reload the data in DataGrid
                            Swal.fire('Supplier Added!', '', 'success');
                        }
                    });
                }
            });
        });

        // Edit Supplier using SweetAlert2
        function editSupplier(supplierId) {
            $.ajax({
                type: 'POST',
                url: 'SupplierList.aspx/GetSupplierByID',
                data: JSON.stringify({ SupplierID: supplierId }),
                contentType: 'application/json; charset=utf-8',
                success: function (response) {
                    const supplier = response.d;
                    Swal.fire({
                        title: 'Edit Supplier',
                        html: `
                            <input id="supplierName" class="swal2-input" value="${supplier.SupplierName}" placeholder="Supplier Name">
                            <input id="phone" class="swal2-input" value="${supplier.Phone}" placeholder="Phone">
                            <input id="contactEmail" class="swal2-input" value="${supplier.ContactEmail}" placeholder="Contact Email">
                        `,
                        confirmButtonText: 'Update Supplier',
                        preConfirm: () => {
                            const supplierName = document.getElementById('supplierName').value;
                            const phone = document.getElementById('phone').value;
                            const contactEmail = document.getElementById('contactEmail').value;

                            if (!supplierName || !phone || !contactEmail) {
                                Swal.showValidationMessage('Please enter all details');
                            } else {
                                return { SupplierID: supplierId, supplierName, phone, contactEmail };
                            }
                        }
                    }).then((result) => {
                        if (result.isConfirmed) {
                            $.ajax({
                                type: 'POST',
                                url: 'SupplierList.aspx/UpdateSupplier',
                                data: JSON.stringify(result.value),
                                contentType: 'application/json; charset=utf-8',
                                success: function (response) {
                                    $('#supplierTable').datagrid('loadData', JSON.parse(response.d));
                                    $('#supplierTable').datagrid('reload');
                                    Swal.fire('Supplier Updated!', '', 'success');
                                }
                            });
                        }
                    });
                }
            });
        }

        // Delete Supplier using SweetAlert2
        function deleteSupplier(supplierId) {
            Swal.fire({
                title: 'Are you sure?',
                text: 'This supplier will be deleted!',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonText: 'Yes, delete it!'
            }).then((result) => {
                if (result.isConfirmed) {
                    $.ajax({
                        type: 'POST',
                        url: 'SupplierList.aspx/DeleteSupplier',
                        data: JSON.stringify({ SupplierID: supplierId }),
                        contentType: 'application/json; charset=utf-8',
                        success: function (response) {
                            $('#supplierTable').datagrid('loadData', JSON.parse(response.d));
                            $('#supplierTable').datagrid('reload');
                            Swal.fire('Deleted!', 'The supplier has been deleted.', 'success');
                        }
                    });
                }
            });
        }

        // Load suppliers on page load
        $(document).ready(function () {
            $('#supplierTable').datagrid('loadData', <%=suppliersList%>);
        });
    </script>
</body>
</html>
