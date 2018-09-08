var datatable = $('#{componentName}').DataTable({ "ajax": "/component/datatable/{componentName}", "serverSide": true, "columns": [{columns}], ordering: {disableSort} });

if ({autoRefresh}) {
    setInterval(function() {
            datatable.ajax.reload();
        },
        {refreshInterval});
}