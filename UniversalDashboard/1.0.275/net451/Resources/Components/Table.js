GetData('table/{componentName}',
    function(data) {
        $('#{componentName} tbody').append(data.rows);
    });

if ({autoRefresh}) {
    setInterval(function() {
        GetData('table/{componentName}',
            function (data) {
                $('#{componentName} tbody').empty();
                    $('#{componentName} tbody').append(data.rows);
                });
        },
        {refreshInterval});
}