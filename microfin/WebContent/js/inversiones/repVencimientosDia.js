$(document).ready(function() {
	// Definicion de Constantes y Enums
	esTab = true;
	$('#fecha').focus();
	var catTipoListaTipoInversion = {
			'principal':1
		};
	var catTipoConsultaTipoInversion = {
			'principal':1,
			'general':3
		};

	var parametroBean = consultaParametrosSession();
	$('#fecha').val(parametroBean.fechaSucursal);
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');

	consultaPromotor();
	consultaSucursal();
	consultaMoneda();
	$('#tipoInversionID').val(0);
	$('#descripcion').val('TODOS');
	$('#pdf').attr("checked",true);
	$('#pantalla').attr("checked",false);
	$('#excel').attr("checked",false);
	$('#reporte').val(2);
	
	$(':text').focus(function() {	
	 	esTab = false;
	});

	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			fecha:{
				required : true,
				date : true
			},
		},
		
		messages: {
			fecha: {
				required : 'La fecha es requerida',
				date : 'Especifique una fecha correcta'
			},
		}
	}); 

	function consultaPromotor(){
		var tipoCon=3;
		dwr.util.removeAllOptions('promotorID');
		dwr.util.addOptions( 'promotorID', {'0':'Todos'});
		promotoresServicio.listaCombo(tipoCon, function(promotores){
			dwr.util.addOptions('promotorID', promotores, 'promotorID', 'nombrePromotor');
		});
	}
   
	function consultaSucursal(){
		var tipoCon=2;
		dwr.util.removeAllOptions('sucursalID');
		dwr.util.addOptions( 'sucursalID', {'0':'Todas'});
		sucursalesServicio.listaCombo(tipoCon, function(sucursales){
			dwr.util.addOptions('sucursalID', sucursales, 'sucursalID', 'nombreSucurs');
		});
	}

	function consultaMoneda() {		
		var tipoCon = 3;
		dwr.util.removeAllOptions('tipoMonedaID');
		dwr.util.addOptions( 'tipoMonedaID', {'0':'Todas'});
		monedasServicio.listaCombo(tipoCon, function(monedas){
			dwr.util.addOptions('tipoMonedaID', monedas, 'monedaID', 'descripcion');
		});
	}

	function validaTipoInversion(tipoInver){
		var TipoInversionBean ={
			'tipoInvercionID' :tipoInver,
			'monedaId': 0
		};
		esTab=true;
		setTimeout("$('#cajaLista').hide();", 200);
		if(tipoInver == '' || tipoInver == 0 ){
			$('#tipoInversionID').val(0);
			$('#descripcion').val('TODOS');
		}
		else if(tipoInver != '' && !isNaN(tipoInver) && esTab){
			if(tipoInver != 0){

				tipoInversionesServicio.consultaPrincipal(catTipoConsultaTipoInversion.general,
																		TipoInversionBean, function(tipoInversion){
					if(tipoInversion!=null){						
						$('#descripcion').val(tipoInversion.descripcion);				
						$('#tipoInversionID').val(tipoInversion.tipoInvercionID);
					}else{
						$('#tipoInversionID').val('');
						$('#descripcion').val('');
						$('#tipoInversionID').focus();
						mensajeSis("El tipo de Inversión no Existe");
					}
				});
			}
		}				
	}

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#pdf').click(function() {
		$('#pdf').focus();
		$('#pdf').attr("checked",true);
		$('#pantalla').attr("checked",false);
		$('#excel').attr("checked",false);
		$('#reporte').val(2);
	});
	
	$('#pantalla').click(function() {
		$('#pantalla').focus();
		$('#pantalla').attr("checked",true);
		$('#pdf').attr("checked",false);
		$('#excel').attr("checked",false);
		$('#reporte').val(1);
	});
	
	$('#excel').click(function() {
		$('#excel').focus();
		$('#excel').attr("checked",true);
		$('#pdf').attr("checked",false);
		$('#pantalla').attr("checked",false);
		$('#reporte').val(3);
	});

	$('#imprimir').click(function() {
		var tipoReporte = $('#reporte').val();
		var fecha = $('#fecha').val();
		var inversion = $('#tipoInversionID').val();
		var desTipInv = $('#descripcion').val();
		var promotor = $("#promotorID option:selected").val();
		var sucursal = $("#sucursalID option:selected").val();
		var moneda = $("#tipoMonedaID option:selected").val();
		var nombreInstitucion =  parametroBean.nombreInstitucion;
		var nombreUsuario = parametroBean.claveUsuario;
		var nombreSucursal = caracteresEspeciales($("#sucursalID option:selected").val());
		var nombreMoneda = caracteresEspeciales($("#tipoMonedaID option:selected").val());
		var nombrePromotor = caracteresEspeciales($("#promotorID option:selected").val());
		var estatus = $("#estatus").val();
		var fechaAc = parametroBean.fechaSucursal;

		if(nombrePromotor=='0'){
			nombrePromotor='';
		}
		else{
			nombrePromotor = caracteresEspeciales($("#promotorID option:selected").html());
		}

		if(nombreSucursal=='0'){
			nombreSucursal='';
		}
		else{
			nombreSucursal = caracteresEspeciales($("#sucursalID option:selected").html());
		}

		if(nombreMoneda=='0'){
			nombreMoneda='';
		}else{
			nombreMoneda = caracteresEspeciales($("#tipoMonedaID option:selected").html());
		}

		$('#ligaImp').attr('href','VencimientosDia.htm?fechaVencimiento='+fecha+'&tipoInversionID='+inversion+
				'&descripcionTipoInv='+desTipInv+'&promotorID='+promotor+'&nombrePromotor='+nombrePromotor+
				'&sucursalID='+sucursal+'&nombreSucursal='+nombreSucursal+'&fechaActual='+fechaAc+
				'&monedaID='+moneda+'&nombreMoneda='+nombreMoneda+'&tipoReporte='+tipoReporte+'&nombreUsuario='+nombreUsuario+'&nombreInstitucion='+nombreInstitucion
				+'&estatus='+estatus); 
	});

	$('#tipoInversionID').blur(function() {
		validaTipoInversion($('#tipoInversionID').val());
	});
			
	$('#tipoInversionID').bind('keyup',function(e){

		 var camposLista = new Array();
		 var parametrosLista = new Array();
		 camposLista[0] = "monedaId";
		 camposLista[1] = "descripcion";
		 parametrosLista[0] = $('#monedaID').val();
		 parametrosLista[1] = $('#tipoInversionID').val();

		lista('tipoInversionID', 3, catTipoListaTipoInversion.principal, camposLista,
				 parametrosLista, 'listaTipoInversiones.htm');
	});
	
	//cambiar Caracteres especiales
	function caracteresEspeciales(cadena){
	   	// Se cambia las letras por valores URL
	   	cadena = cadena.replace(/á/gi,"%c1");
	   	cadena = cadena.replace(/é/gi,"%c9");
	   	cadena = cadena.replace(/í/gi,"%cd");
	   	cadena = cadena.replace(/ó/gi,"%d3");
	  	cadena = cadena.replace(/ú/gi,"%da");
	   	return cadena;
	}
	
});