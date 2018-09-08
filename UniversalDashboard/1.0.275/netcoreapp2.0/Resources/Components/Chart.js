GetData("chart/{componentName}", function (data) {
    var ctx = document.getElementById("{componentName}").getContext('2d');
    var chart = new Chart(ctx, {
        type: "{chartType}",
        data: data,
        options: {options}
    });

    if ({autoRefresh}) {
        setInterval(function() {
                GetData("chart/{componentName}",
                    function(data) {
                        chart.data = data;
                        chart.update();
                    });
            },
            {refreshInterval});
    }
});