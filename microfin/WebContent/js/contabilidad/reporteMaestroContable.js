$(document).ready(function (){

	esTab = true;

	// Definicion de Constantes y Enums
	var catTipoListaMoneda = {
			'principal': 3
	};

	var parametroBean = consultaParametrosSession();
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	cargaMonedas();

	$(':text').focus(function() {	
		esTab = false;
	});


	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	function cargaMonedas(){
		dwr.util.removeAllOptions('monedaID');
		dwr.util.addOptions( 'monedaID', {'0':'TODAS'});
		monedasServicio.listaCombo(catTipoListaMoneda.principal, function(monedas){
			dwr.util.addOptions('monedaID', monedas, 'monedaID', 'descripcion');
		});
	}

	function generaReporteConsultar(consultar){
		var tipolisPantalla = 1;
		var tipolisPDF = 2;
		var mon = $("#monedaID option:selected").val();
		var moneDescripcion =$("#monedaID option:selected").val();
		var conceptoCta = $("#tipoCuenta option:selected").html();
		var tipoCta  = $("#tipoCuenta option:selected").val(); 
		var usuario = 	parametroBean.nombreUsuario;
		var nombreInstitucion =  parametroBean.nombreInstitucion;
		var fechaEmision = parametroBean.fechaSucursal;
		if(moneDescripcion=='0'){
			moneDescripcion='TODAS';
		}
		else{
			moneDescripcion = $("#monedaID option:selected").html();
		}
		if(consultar==tipolisPantalla){
			$('#enlacePantalla').attr('href','MaestroContableRepPDF.htm?monedaID='+mon+'&descripcionMoneda='+moneDescripcion
					+'&tipoCuenta='+tipoCta+'&conceptoCta='+conceptoCta+'&usuario='+usuario+'&nombreInstitucion='
					+nombreInstitucion+'&fechaEmision='+fechaEmision+'&consultar='+consultar);
		}else{
			if(consultar== tipolisPDF){
				$('#enlacePDF').attr('href','MaestroContableRepPDF.htm?monedaID='+mon+'&descripcionMoneda='+moneDescripcion
						+'&tipoCuenta='+tipoCta+'&conceptoCta='+conceptoCta+'&usuario='+usuario+'&nombreInstitucion='
						+nombreInstitucion+'&fechaEmision='+fechaEmision+'&consultar='+consultar);
			}
			else{
				$('#enlaceExcel').attr('href','MaestroContableRepPDF.htm?monedaID='+mon+'&descripcionMoneda='+moneDescripcion
						+'&tipoCuenta='+tipoCta+'&conceptoCta='+conceptoCta+'&usuario='+usuario+'&nombreInstitucion='
						+nombreInstitucion+'&fechaEmision='+fechaEmision+'&consultar='+consultar);	
			}
		}
	}

	$('#pantalla').click(function() {	
		var tipoLista= 1;
		generaReporteConsultar(tipoLista);

	});
	$('#pdf').click(function() {	
		var tipoLista= 2;
		generaReporteConsultar(tipoLista);

	});
	$('#excel').click(function() {	
		var tipoLista= 3;
		generaReporteConsultar(tipoLista);

	});


});