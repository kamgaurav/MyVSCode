GetData("chart/live/{componentName}", function (data) {
    var ctx = document.getElementById("{componentName}").getContext('2d');
    var chart = new Chart(ctx, {
        type: "{chartType}",
        data: {
            datasets: [
                {
                    label: '{label}',
                    backgroundColor: '{backgroundColor}',
                    borderColor: '{backgroundColor}',
                    borderWidth: {borderWidth},
                    data: [data]
                }]
        },
        options: {
            legend: { display: true }, scales: {
                xAxes: [{
                    type: "time",
                    time: {
                        // round: 'day'
                        tooltipFormat: 'll HH:mm'
                    },
                    scaleLabel: {
                        display: true
                    }
                },],
                yAxes: [{
                    scaleLabel: {
                        display: true
                    }
                }]
            }
        }
    });

    setInterval(function() {
            GetData("chart/live/{componentName}",
                function (data) {
                    chart.data.datasets[0].data.push(data);
                    if (chart.data.datasets[0].data.length > {dataPointHistory}) {
                        chart.data.datasets[0].data.shift();
                    }
                    chart.update();
                });
        },
        {refreshInterval});
});