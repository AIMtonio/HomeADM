$(document).ready(function() {

	esTab = true;

	// Definicion de Constantes y Enums
	var catTipoTransaccionInverciones = {
			'agrega' : 1 ,
			'modifica' :2
	};

	var catTipoListaMonedas = {
			'combo' : 3
	};

	var catTipoConsultaInverciones = {
			'principal' : 1,
			'secundaria' : 2,
			'tercera':3
	};

	deshabilitaBoton('modifica', 'submit');
	deshabilitaBoton('agrega', 'submit');
	consultaMoneda();
	validaPagoPeriodico();

	$('#tipoInvercionID').focus();
	agregaFormatoControles('formaGenerica');
	$(':text').focus(function() {	
	 	esTab = false;
	});
	
	$.validator.setDefaults({
		submitHandler: function(event) { 
				grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','tipoInvercionID');
				deshabilitaBoton('modifica', 'submit');
				deshabilitaBoton('agrega', 'submit');
			}
	});
	
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#agrega').click(function() {	
		if ($('#fechaInscripcion').val()==null 	|| $('#fechaInscripcion').val()=='' ) {
			$('#fechaInscripcion').val('1900-01-01');
		}	
		$('#tipoTransaccion').val(catTipoTransaccionInverciones.agrega);
		inicializaForma($('#formaGenerica')," ");
	});
	
	$('#modifica').click(function() {
		if ($('#fechaInscripcion').val()==null 	|| $('#fechaInscripcion').val()=='' ) {
			$('#fechaInscripcion').val('1900-01-01');
		}			
		$('#tipoTransaccion').val(catTipoTransaccionInverciones.modifica);
	});
	
	
	function consultaMoneda() {			
		dwr.util.removeAllOptions('monedaSelect');
		monedasServicio.listaCombo(catTipoListaMonedas.combo, function(monedas){
			dwr.util.addOptions('monedaSelect', monedas, 'monedaID', 'descripcion');
		});
	}
	
	
	$('#tipoInvercionID').bind('keyup',function(e){
		//TODO Agregar Libreria de Constantes Tipo Enum
		
		if(this.value.length >= 3){
			
			var camposLista = new Array();
			 var parametrosLista = new Array();
			 camposLista[0] = "monedaId";
			 camposLista[1] = "descripcion";
			 parametrosLista[0] = 0;
			 parametrosLista[1] = $('#tipoInvercionID').val();
			 
			 lista('tipoInvercionID', 3, '5', camposLista, parametrosLista, 'listaTipoInversiones.htm');
		}

	});
		
	$('#tipoInvercionID').blur(function() {
		validaTipoInvercion(this);
	});
	
	$('#tipoReinversion').change(function(){
		if($('#tipoReinversion').val() == 'N'){
			$('#reinvertir1').attr("disabled",true);
			$('#reinvertir2').attr("checked",true);
		}else{
			$('#reinvertir1').attr("checked",true);
			$('#reinvertir1').attr("disabled",false);
			$('#reinvertir2').attr("disabled",false);
		}
	});
	
	
	
	$('input:radio[name=reinversion]').change(function () {
		if(this.value == 'S'){
			dwr.util.removeAllOptions('tipoReinversion');
			dwr.util.addOptions( "tipoReinversion", {'C':'Solo Capital', 'CI': 'Capital mas Interes','I': 'Indistinto'});
		}else{
			dwr.util.removeAllOptions('tipoReinversion');
			dwr.util.addOptions( "tipoReinversion", {'N':'No realizar Reinversion'});
		}
		
	}) ;
	
		function validaPagoPeriodico() {
		var numEmpresaID = 1;
		var tipoCon = 1;
		var ParametrosSisBean = {
				'empresaID'	:numEmpresaID
		};
		
				parametrosSisServicio.consulta(tipoCon,ParametrosSisBean,function(parametrosSisBean) {
					if (parametrosSisBean != null) {

						if(parametrosSisBean.invPagoPeriodico == "S"){
							mostrarElementoPorClase('pagoPeriodico', true);
						}else{
							mostrarElementoPorClase('pagoPeriodico', false);
						}
					}
				});
			
		

	}
	
	function validaTipoInvercion(){
		var tipoInvercion = $('#tipoInvercionID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		
		if(tipoInvercion != '' && !isNaN(tipoInvercion) && esTab){
			
			if(tipoInvercion == '0'){
				habilitaBoton('agrega', 'submit');		
				deshabilitaBoton('modifica', 'submit');
				inicializaForma('formaGenerica','tipoInvercionID');				
				$('#fechaInscripcion').val("");
				dwr.util.removeAllOptions('tipoReinversion');
				dwr.util.addOptions( "tipoReinversion", {'C':'Solo Capital', 'CI':'Capital mas Interes', 'I':'Indistinto'});
				
				$('#reinvertir1').attr("checked",true);
				$('#pagoPeriodicoNo').attr("checked",true);

				
			}else{
				deshabilitaBoton('agrega', 'submit');
				habilitaBoton('modifica', 'submit');
				
				var tipoInversionBean = {
		                'tipoInvercionID':tipoInvercion,
		                'monedaId':0
		        };
				dwr.util.removeAllOptions('tipoReinversion');
				
				tipoInversionesServicio.consultaPrincipal(catTipoConsultaInverciones.tercera, tipoInversionBean, function(tipoInver){
					if(tipoInver!=null){
						dwr.util.setValues(tipoInver);
						deshabilitaBoton('agrega', 'submit');
						
						if(tipoInver.fechaInscripcion=='1900-01-01'){
							$('#fechaInscripcion').val("");
							
						}else{								
							$('#fechaInscripcion').val(tipoInver.fechaInscripcion);
						}
						
						if(tipoInver.reinversion == 'S'){ $('#reinvertir1').attr("checked",true);
						}else{  $('#reinvertir2').attr("checked",true);}
						
						dwr.util.removeAllOptions('tipoReinversion');
						dwr.util.addOptions( "tipoReinversion", {'C':'Solo Capital', 'CI':'Capital mas Interes', 'N':'Ninguna Opcion','I':'Indistinto' });
						$('#tipoReinversion').val(tipoInver.reinvertir);
						if(tipoInver.pagoPeriodico == 'S'){
							$('#pagoPeriodicoSi').attr("checked",true);
						}else{
							$('#pagoPeriodicoNo').attr("checked",true);
						}
						
						if(tipoInver.estatus == 'I'){
							mensajeSis("El Producto "+tipoInver.descripcion+" se encuentra Inactivo, por favor comunicarse con el Administrador para más información.");
							deshabilitaBoton('modifica', 'submit');
							$('#tipoInvercionID').focus();	
						}else{
							habilitaBoton('modifica', 'submit');
						}
						
					}else{
						//inicializaForma($('#formaGenerica'),"tipoInvercionID");
						mensajeSis("No Existe el Tipo de Inversión");
						deshabilitaBoton('modifica', 'submit');
						deshabilitaBoton('agrega', 'submit');
						$('#tipoInvercionID').focus();
						$('#tipoInvercionID').select();
					}
					
				});
				
				
			}
			
		}
		
	}

	$('#fechaInscripcion').change(function() {
		var Yfecha= $('#fechaInscripcion').val();
		if(esFechaValida(Yfecha)){
			if(Yfecha ==''){
				$('#fechaInscripcion').val(parametroBean.fechaSucursal);
			}
				if($('#fechaInscripcion').val() > parametroBean.fechaSucursal) {
					mensajeSis("La Fecha de Inscripcion  es Mayor a la Fecha del Sistema.");
					$('#fechaInscripcion').val(parametroBean.fechaSucursal);
				}				
			
		}else{
			$('#fechaInscripcion').val(parametroBean.fechaSucursal);
		}

	});

	/*==== Funcion valida fecha formato (yyyy-MM-dd) =====*/
	function esFechaValida(fecha){

		if (fecha != undefined && fecha.value != "" ){
			var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
			if (!objRegExp.test(fecha)){
				mensajeSis("formato de fecha no válido (aaaa-mm-dd)");
				return false;
			}

			var mes=  fecha.substring(5, 7)*1;
			var dia= fecha.substring(8, 10)*1;
			var anio= fecha.substring(0,4)*1;

			switch(mes){
			case 1: case 3:  case 5: case 7:
			case 8: case 10:
			case 12:
				numDias=31;
				break;
			case 4: case 6: case 9: case 11:
				numDias=30;
				break;
			case 2:
				if (comprobarSiBisisesto(anio)){ numDias=29}else{ numDias=28};
				break;
			default:
				mensajeSis("Fecha introducida errónea");
			return false;
			}
			if (dia>numDias || dia==0){
				mensajeSis("Fecha introducida errónea");
				return false;
			}
			return true;
		}
	}

	function comprobarSiBisisesto(anio){
		if ( ( anio % 100 != 0) && ((anio % 4 == 0) || (anio % 400 == 0))) {
			return true;
		}
		else {
			return false;
		}
	}
	
	
	
	$('#formaGenerica').validate({
		rules: {
			tipoInvercionID: 'required',
			descripcion: 'required',
			monedaSelect: 'required',
			tipoReinversion: 'required',
			claveCNBV : {
							soloAlfanumerico : $('#claveCNBV').val()
						}
				
		},
		
		messages: {
			tipoInvercionID: 'El valor esta vacio',
			descripcion: 'Se requiere un descripcion de la Inversion',
			monedaSelect: 'Se requiere un tipo de moneda',
			tipoReinversion: 'Se requiere un tipo de Reinversion',

		}
	});
	
		

	jQuery.validator.addMethod("soloAlfanumerico", function(value, element) {
  		return this.optional( element ) || /^[a-zA-Z0-9]*$/.test( value );
	}, "No se permiten caracteres especiales");

	
});
