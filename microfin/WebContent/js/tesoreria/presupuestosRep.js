$(document).ready(function() {
	// Definicion de Constantes y Enums
	esTab = true;

	var parametroBean = consultaParametrosSession();   
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');

	consultaSucursal();
	var catTipoConsultaProveedores = {
			'principal'	: 1


	};	

	$('#pdf').attr("checked",true) ; 

	$('#anioInicio').change(function() {	
		validaAnios();
	});

	$('#anioFin').change(function() {	
		validaAnios();
	});

	$('#mesInicio').change(function() {	
		var aIni = $('#anioInicio').val();
		var aFin = $('#anioFin').val();
		if(parseInt(aIni) == parseInt(aFin)){
			validaMeses();
		}
	});

	inicializaAnioMesFin();
	llenarAnioInicio();
	llenarAnioFin();


	$('#mesFin').change(function() {	
		var aIni = $('#anioInicio').val();
		var aFin = $('#anioFin').val();
		if(parseInt(aIni) == parseInt(aFin)){
			validaMeses();
		} 
	});

	function validaAnios(){
		var fecha =  parametroBean.fechaSucursal;
		var array = fecha.split('-'); 
		var anio=array[0];
		var anioIniSelect='';
		var anioFinSelect='';

		var aIni = $('#anioInicio').val();
		var aFin = $('#anioFin').val();
		if(parseInt(aIni) > parseInt(aFin)){
			alert('El año de inicio no puede ser mayor al año final.');
			anioFinSelect  = eval("'#anioFin option[value=" +anio+ "]'");
			anioIniSelect  = eval("'#anioInicio option[value=" +anio+ "]'");
			$(anioIniSelect).attr('selected',true);
			$(anioFinSelect).attr('selected',true);
		}
	}

	function validaMeses(){
		var fecha =  parametroBean.fechaSucursal;
		var array = fecha.split('-'); 
		var mesActual=array[1];
		var mesIniSelect='';
		var mesFinSelect='';

		var mIni = $('#mesInicio').val();
		var mFin = $('#mesFin').val();
		if(parseInt(mIni) > parseInt(mFin)){
			alert('El mes de inicio no puede ser mayor al mes final.');
			mesIniSelect = eval("'#mesInicio option[value=" + parseInt(mesActual)+ "]'");
			mesFinSelect = eval("'#mesFin option[value=" + parseInt(mesActual)+ "]'");
			$(mesIniSelect).attr('selected',true);
			$(mesFinSelect).attr('selected',true);
		}
	}


	function inicializaAnioMesFin(){
		var fecha =  parametroBean.fechaSucursal;
		var array = fecha.split('-'); 
		var anioActual=array[1];
		var mesActual=array[1];
		var iniciaEnEnero=1;
		var mesFinSelect = eval("'#mesFin option[value=" + parseInt(mesActual)+ "]'");
		var mesIniSelect = eval("'#mesInicio option[value=" +iniciaEnEnero+ "]'");
		var anioFinSelect = eval("'#anioFin option[value=" +anioActual+ "]'");
		var anioIniSelect  = eval("'#anioInicio option[value=" +anioActual+ "]'");
		$(mesFinSelect).attr('selected',true);
		$(mesIniSelect).attr('selected',true);
		$(anioFinSelect).attr('selected',true);
		$(anioIniSelect).attr('selected',true);
	}

	$('#generar').click(function() {	
		var tipoReporte = 0;
		var tipoLista = 0;
		var sucursal = $("#sucursal option:selected").val();
		var estatus = $("#estatusPre option:selected").val();
		var estatusMov = $("#estatusPet option:selected").val(); 
		var usuario = 	parametroBean.nombreUsuario; 
		var fechaEmision = parametroBean.fechaSucursal;
		var anioInicio = $("#anioInicio option:selected").val();
		var anioFin = $("#anioFin option:selected").val();
		var mesInicio = $("#mesInicio option:selected").val();
		var mesFin = $("#mesFin option:selected").val();

		if($('#pantalla').is(':checked')){
			tipoReporte = 1;

		}
		if($('#pdf').is(':checked')){
			tipoReporte = 2;
		}
		if($('#excel').is(':checked')){
			tipoReporte = 3;
		}
		if(estatus=='0'){
			estatus='';
		}
		if(estatusMov=='0'){
			estatusMov='';
		}

		/*if($('#excel').is(':checked')){
			tipoReporte = 3;
			tipoLista = 2;
		}

		var nivelDetalle=1; q
		if($('#detallado').is(':checked'))	{
			nivelDetalle=1;
		}
		else 			
			if($('#sumarizado').is(':checked'))	{
				nivelDetalle=0;
			}
		 */
		/// VALORES TEXTO
		var nombreSucursal = $("#sucursal option:selected").val();
		var nombreUsuario = parametroBean.nombreUsuario; 
		var nombreInstitucion =  parametroBean.nombreInstitucion; 
		var nombreEstatus = $("#estatusPre option:selected").val();
		var nombreMesIni = $("#mesInicio option:selected").html();
		var nombreMesFin = $("#mesFin option:selected").html();
		var nombreEstatusMov = $("#estatusPet option:selected").val();
		if(nombreEstatus=='0'){
			nombreEstatus='';
		}
		else{
			nombreEstatus = $("#estatusPre option:selected").html();
		}

		if(nombreEstatusMov=='0'){
			nombreEstatusMov='';
		}
		else{
			nombreEstatusMov = $("#estatusPet option:selected").html();
		}


		if(nombreSucursal=='0'){
			nombreSucursal='';
		}
		else{
			nombreSucursal = $("#sucursal option:selected").html();
		}




		$('#ligaGenerar').attr('href','reportePresupuestos.htm?anioInicio='+anioInicio+'&anioFin='+
				anioFin+'&mesInicio='+mesInicio+'&mesFin='+mesFin+'&sucursal='+sucursal+'&estatusPre='+estatus
				+'&estatusPet='+estatusMov+'&nomEstatusMov='+nombreEstatusMov+'&usuario='+usuario+'&tipoReporte='
				+tipoReporte+'&tipoLista='+tipoLista+'&nombreSucursal='+nombreSucursal+'&nombreUsuario='
				+nombreUsuario+'&parFechaEmision='+fechaEmision+'&nombreMesIni='+nombreMesIni+'&nombreMesFin='
				+nombreMesFin+'&nombreInstitucion='+nombreInstitucion+'&nombreEstatus='+nombreEstatus);

	});


	function consultaSucursal(){
		var tipoCon=2;
		dwr.util.removeAllOptions('sucursal');
		dwr.util.addOptions( 'sucursal', {'0':'TODAS'});
		sucursalesServicio.listaCombo(tipoCon, function(sucursales){
			dwr.util.addOptions('sucursal', sucursales, 'sucursalID', 'nombreSucurs');
		});
	}

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});


	function llenarAnioInicio(){
		var i=0;
		var anioArranque=2008;
		var fecha = parametroBean.fechaSucursal;
		var anioSucursal=fecha.substring(0,4);
		var anioSucurInt = parseInt(anioSucursal);
		dwr.util.removeAllOptions('anioInicio');
		 
		for (i=anioArranque; i <=  (anioSucurInt +5) ; i++){
			 
			dwr.util.addOptions( 'anioInicio', [i]);

		} 
		var jqAnio = eval("'#anioInicio option[value="+anioSucurInt+"]'");
	     
		
		$(jqAnio).attr('selected',true);
	}

	function llenarAnioFin(){
		var i=0;
		var anioArranque=2008;
		var fecha = parametroBean.fechaSucursal;
		var anioSucursal=fecha.substring(0,4);
		var anioSucurInt = parseInt(anioSucursal);
		dwr.util.removeAllOptions('anioFin');
		for (i=anioArranque; i <=  (anioSucurInt +5) ; i++){
			dwr.util.addOptions( 'anioFin', [i]);

		} 
		var jqAnio = eval("'#anioFin option[value="+anioSucurInt+"]'");
		$(jqAnio).attr('selected',true);
	}


});
