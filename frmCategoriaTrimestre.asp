<html>
	<head>
		
	</head>
	<body>
		<div id="container"></div>
		<script src="../library/jquery/jquery-1.11.1.min.js"></script>
		<script src="../library/highcharts/highcharts.js"></script>
		<script>
			$(document).ready(function(e){
				$("#container").highcharts({
					chart:{
						type:'bar'
					},
					title:{
						text:'Acompanhamento 3 trimestre'
					},
					subtitle:{
						text:'julho/agosto/setembro'
					},
					xAxis : {
						categories: ['Alimentação','Habitação','Transporte'],
						title:{
							text:null
						}
					},
					yAxis : {
						min:0,
						title:{
							text:'valor gasto',
							align:'high'
						},
						labels:{
							overflow:'justify'
						}
					},
					credits: {
						enabled: false
					},
					series: [
						{
							name:'julho',
							data:[107, 5, 20]
						},
						{
							name:'agosto',
							data:[30, 20, 35]
						},
						{
							name:'setembro',
							data:[150, 25, 40]
						}
					]
				});
			});
						
		</script>
	</body>
</html>