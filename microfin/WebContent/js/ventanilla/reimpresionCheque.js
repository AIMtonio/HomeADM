$(document).ready(function() {
	esTab = true;
	var parametroBean = consultaParametrosSession(); 
	var catTipoConsultaInstituciones = {
		'principal':1, 
		'foranea':2
	};

	var catTipoConsultaCheques = {
		'principal':1,		
	};	

	agregaFormatoControles('formaGenerica');
	deshabilitaBoton('reimprimirCheque');
	$('#fechaEmision').val();
	$('#institucionID').focus();
	//------------ Metodos y Manejo de Eventos -----------------------------------------

	$(':text').focus(function() {	
		esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$.validator.setDefaults({
        submitHandler: function(event) {
        	grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'false', 'numCtaInstit'); 		   
        }
    });	
	
	$('#fechaEmision').val( parametroBean.fechaSucursal);
	
	//validacion bind
	$('#institucionID').bind('keyup',function(e){
		//TODO Agregar Libreria de Constantes Tipo Enum
		lista('institucionID', '1', '1', 'nombre', $('#institucionID').val(), 'listaInstituciones.htm');
	});

	$('#numCtaBancaria').bind('keyup',function(e){
       	var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "numCtaInstit";
		camposLista[1] = "institucionID";
		parametrosLista[0] = $('#numCtaBancaria').val();
		parametrosLista[1] = $('#institucionID').val();
		listaAlfanumerica('numCtaBancaria', '2', '7', camposLista,parametrosLista, 'ctaNostroLista.htm');	       
	});	
	
//-- Lista de cheques emitidos--//
	$('#numCheque').bind('keyup',function(e) { 
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "institucionID"; //DONDE MOSTRAR RESULTADO
		camposLista[1] = "numCtaBancaria";
		camposLista[2] = "tipoChequera";
		camposLista[3] = "fechaEmision";
		camposLista[4] = "numCheque";
		camposLista[5] = "cajaCheque";
		parametrosLista[0] = $('#institucionID').val();//FILTROS
		parametrosLista[1] = $('#numCtaBancaria').val();
		parametrosLista[2] = $('#tipoChequera').val();
		parametrosLista[3] = $('#fechaEmision').val();
		parametrosLista[4] = $('#numCheque').val();
		parametrosLista[5] = parametroBean.cajaID;
		lista('numCheque', '2', '1',  camposLista, parametrosLista, 'listaReimpresionCheques.htm');
	}); 
	
 	
	$('#numCtaBancaria').blur(function() {
		validaNumCuentaBancaria();
	});
	
 	function cargaTipoChequera(){
		tipoChequeraBean = {
				'institucionID': $('#institucionID').val(),
				'numCtaInstit': $('#numCtaBancaria').val()
				};
		
			cuentaNostroServicio.listaCombo(15,tipoChequeraBean,function(tiposChe){
				if(tiposChe!=''){
					dwr.util.removeAllOptions('tipoChequera'); 
  			  		dwr.util.addOptions('tipoChequera', {'':'SELECCIONAR'});
  			  		dwr.util.addOptions('tipoChequera', tiposChe, 'tipoChequera', 'descripTipoChe');  
				}
			});	
		}
 	
 	
   $('#institucionID').blur(function() {
   	limpiaCampos();
	   consultaInstitucion(this.id);	   		  
 	});	
   
   $('#numCheque').blur(function(){	  
	   consultaChequesEmi(this.id);	  
   });
    
   $('#fechaEmision').blur(function () {
   	$('#numCheque').val('');
		$('#numCliente').val('');
		$('#beneficiario').val('');
		$('#monto').val('');
		$('#concepto').val('');
		$('#referencia').val('');						
		$('#transaccion').val('');
		deshabilitaBoton('reimprimirCheque');
	});
   
 	$('#fechaEmision').change(function(){
  		var fecha= $('#fechaEmision').val();
  		esFechaValida(fecha);   		
  	});
  	
 	
   $('#tipoChequera').blur(function () {
	   	$('#numCheque').val('');
			$('#numCliente').val('');
			$('#beneficiario').val('');
			$('#monto').val('');
			$('#concepto').val('');
			$('#referencia').val('');						
			$('#transaccion').val('');
			deshabilitaBoton('reimprimirCheque');
		});
   
   
  	$('#reimprimirCheque').click(function(){
  		if($('#institucionID').val()!=''){
  		imprimirCheque();
  		}
  	});
   	

// metodo para la impresion del cheque 
function imprimirCheque(){	
	var numeroPoliza = parseInt($('#polizaCheque').val());
	var nombreRutaCheque = $('#rutaCheque').val();
	var numTran = parseInt($('#transaccion').val());
	var numSucursal= parseInt($('#sucursalCheque').val());
	var moneda = 1;
	var fechaEmision = $('#fechaEmisionCheque').val();
	var nombreOperacion = limpiarCaracteresEsp($('#concepto').val());
	var nombreBeneficiario = $('#beneficiario').val();
	var monto = $('#monto').asNumber();
	var usuarioCheque = $('#usuarioCheque').val();
	var numCheque = parseInt($('#numCheque').val());

	
	window.open('imprimeCheque.htm?polizaID='+numeroPoliza+'&nombreReporte='+nombreRutaCheque+'&transaccion='+numTran+
			'&sucursalID='+numSucursal+'&monedaID='+moneda+'&fechaEmision='+fechaEmision+'&nombreOperacion='+
			nombreOperacion+'&nombreBeneficiario='+nombreBeneficiario+'&monto='+monto+'&nombreUsuario='+usuarioCheque+
			'&NumeroCheque='+numCheque+'&numeroTransaccion='+numTran,'_blank');

}

	function validaNumCuentaBancaria(){
		cargaTipoChequera();
		$('#tipoChequera').focus();
		setTimeout("$('#cajaLista').hide();", 200);
		$('#numCheque').val('');
		$('#numCliente').val('');
		$('#beneficiario').val('');
		$('#monto').val('');
		$('#concepto').val('');
		$('#referencia').val('');						
		$('#transaccion').val('');
		deshabilitaBoton('reimprimirCheque');
	}

   //Funcion de consulta para obtener el nombre de la institucion	
	function consultaInstitucion(idControl) {
		var jqInstituto = eval("'#" + idControl + "'");
		var numInstituto = $(jqInstituto).val();
		setTimeout("$('#cajaLista').hide();", 200);	
		var InstitutoBeanCon = {
			'institucionID':numInstituto
		};
		if(numInstituto!='' && !isNaN(numInstituto)){
				institucionesServicio.consultaInstitucion(catTipoConsultaInstituciones.foranea,InstitutoBeanCon,function(instituto){		
					if(instituto!=null){
						$('#nombreInstitucion').val(instituto.nombre);
					}else{
						mensajeSis("No existe la Institución"); 
						$('#institucionID').val('');
						$('#institucionID').focus();
						$('#nombreInstitucion').val("");
					}
				});
		}else{
			$('#institucionID').val('');
			$('#nombreInstitucion').val("");
			limpiaCampos();
			$('#institucionID').focus();
		}
		
	}
		
	 //Funcion de consulta para obtener datos del cheque
	function consultaChequesEmi(idControl) {
		var jqNumCheque = eval("'#" + idControl + "'");
		var numCheque = parseFloat($(jqNumCheque).val());
		setTimeout("$('#cajaLista').hide();", 200);	
		var ChequeBeanCon = {
				'institucionID'	: $('#institucionID').val(),
				'numCtaBancaria': $('#numCtaBancaria').val(),
				'fechaEmision' 	: $('#fechaEmision').val(),
				'numCheque'		: numCheque, 
				'cajaCheque'	: parametroBean.cajaID,
				'tipoChequera'	: $('#tipoChequera').val()
		};
		
		if(numCheque!='' && !isNaN(numCheque) && esTab){
			reimpresionChequeServicio.consulta(catTipoConsultaCheques.principal,ChequeBeanCon,function(cheque){		
					if(cheque!=null){
						$('#numCliente').val(cheque.numCliente);
						$('#beneficiario').val(cheque.beneficiario);
						$('#monto').val(cheque.monto);
						$('#monto').formatCurrency({
							positiveFormat: '%n',
							negativeFormat: '%n', 
							roundToDecimalPlace: 2	
						});						
						$('#concepto').val(cheque.concepto);
						$('#referencia').val(cheque.referencia);						
						$('#transaccion').val(cheque.numTransaccion);						
						var str = cheque.rutaCheque;
						var res = str.split(".");
						$('#rutaCheque').val(res[0]);
						
						$('#cajaCheque').val(cheque.cajaCheque);
						$('#sucursalCheque').val(cheque.sucursalCheque);
						$('#fechaEmisionCheque').val(cheque.fechaEmisionCheque);
						$('#horaCheque').val(cheque.fechaActual);
						$('#usuarioCheque').val(cheque.usuarioCheque);
						$('#polizaCheque').val(cheque.polizaCheque);
						habilitaBoton('reimprimirCheque');
					}else{
						mensajeSis("No existe el Cheque, Verifique el Núm. de Cuenta y la Fecha de Emisión");
						deshabilitaBoton('reimprimirCheque'); 
						$('numCheque').val('');
						$('#numCliente').val('');
						$('#beneficiario').val('');
						$('#monto').val('');
						$('#concepto').val('');
						$('#referencia').val('');						
						$('#transaccion').val('');
						$('#numCheque').focus();
					}    						
				});
		}else{
			deshabilitaBoton('reimprimirCheque');
			$('#numCheque').val('');
			$('#numCliente').val('');
			$('#beneficiario').val('');
			$('#monto').val('');
			$('#concepto').val('');
			$('#referencia').val('');						
			$('#transaccion').val('');
		}
		
	}
	
	function limpiaCampos(){	
		$('#numCtaBancaria').val('');
		$('#numCheque').val('');
		$('#numCliente').val('');
		$('#beneficiario').val('');
		$('#monto').val('');
		$('#concepto').val('');
		$('#referencia').val('');						
		$('#transaccion').val('');
		$('#tipoChequera').val('');
		deshabilitaBoton('reimprimirCheque');
	}   	

  	$('#formaGenerica').validate({
  		rules: {
  			institucionID: {
  				required: true  				
  			},
  			numCtaBancaria:{
  				required: true,	
  				maxlength: 25,
  				minlength: 1
  			},
  			tipoChequera:{
  				required: true
  			},
  			fechaEmision:{
  				required: true,
  			}
  		},  		
  		messages: {
  			institucionID: {
  				required: 'La Institución está vacía.', 				
  			},
  			numCtaBancaria:{
  				required: 'El Número de Cuenta está Vacía.',	
  				maxlength: 'Máximo 25 Caracteres.',
  				minlength: 'Mínimo 1 Cacter.',
  			},
  			tipoChequera:{
  				required: 'Especifique el Formato del Cheque a Cancelar.'
  			},
  			fechaEmision:{
  				required: 'La Fecha está Vacía.',
  			}
  			
  		}		
  	});
  	
  	
  	/*funcion valida fecha formato (yyyy-MM-dd)*/
	function esFechaValida(fecha){
		if (fecha != undefined && fecha.value != "" ){
			var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
			if (!objRegExp.test(fecha)){
				mensajeSis("Formato de Fecha no Válido (aaaa-mm-dd)");
				$('#fechaEmision').val('');
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
				if (comprobarSiBisisesto(anio)){ numDias=29 }else{ numDias=28};
				break;
			default:
				mensajeSis("Fecha Introducida Errónea");
			return false;
			}
			if (dia>numDias || dia==0){
				mensajeSis("Fecha Introducida Errónea");
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
	
	$('#fechaEmision').change(function(){
		var Xfecha= $('#fechaEmision').val();
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaEmision').val(parametroBean.fechaSucursal);
			var Yfecha= parametroBean.fechaAplicacion;
			if( mayor(Xfecha, Yfecha)){
				mensajeSis("La Fecha Emisión es Mayor a la Fecha del Sistema")	;
				$('#fechaEmision').val(parametroBean.fechaSucursal);
				$('#fechaEmision').val(parametroBean.fechaSucursal);
				regresarFoco('fechaEmision');
			}else{
				if(!esTab){
					regresarFoco('fechaEmision');
				}
				$('#fechaEmision').val($('#fechaEmision').val());
			}
		}else{
			$('#fechaEmision').val(parametroBean.fechaSucursal);
			regresarFoco('fechaEmision');
		}
	});
	
	function mayor(fecha, fecha2){
		//0|1|2|3|4|5|6|7|8|9|
		//2 0 1 2 / 1 1 / 2 0
		var xMes=fecha.substring(5, 7);
		var xDia=fecha.substring(8, 10);
		var xAnio=fecha.substring(0,4);

		var yMes=fecha2.substring(5, 7);
		var yDia=fecha2.substring(8, 10);
		var yAnio=fecha2.substring(0,4);



		if (xAnio > yAnio){
			return true;
		}else{
			if (xAnio == yAnio){
				if (xMes > yMes){
					return true;
				}
				if (xMes == yMes){
					if (xDia > yDia){
						return true;
					}else{
						return false;
					}
				}else{
					return false;
				}
			}else{
				return false ;
			}
		} 
	} 
		
	//Regresar el foco a un campo de texto.
	function regresarFoco(idControl){
		var jqControl=eval("'#"+idControl+"'");
		setTimeout(function(){
			$(jqControl).focus();
		 },0);
	}
	
	/*funcion para limpiar caracteres especiales*/
	function limpiarCaracteresEsp(cadena){
		 // Definimos los caracteres que queremos eliminar
	   var specialChars = "!@$^%*()+=-[]\/{}|:<>?,.";
	   // Elimina caracteres especiales
	   for (var i = 0; i < specialChars.length; i++) {
	       cadena= cadena.replace(new RegExp("\\" + specialChars[i], 'gi'), '');
	   }   

	   // Se cambia las letras por valores URL
	   cadena = cadena.replace(/&/gi,"%26");
	   cadena = cadena.replace(/#/gi,"%23");
	  
	   return cadena;

	}

});