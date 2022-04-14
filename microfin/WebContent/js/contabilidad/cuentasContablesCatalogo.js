$(document).ready(function() {
	esTab = true;
	 
	//Definicion de Constantes y Enums  
	var catTipoConsultaCtaContable = {
  		'principal':1
	};	
	
	var catTipoTransaccionCtaContable = {
  		'agrega':'1',
  		'modifica':'2',
  		'eliminar':'3'
	};
	
	//------------ Metodos y Manejo de Eventos -----------------------------------------
   deshabilitaBoton('agrega', 'submit');
   deshabilitaBoton('modifica', 'submit');
   deshabilitaBoton('eliminar', 'submit');
   agregaFormatoControles('formaGenerica');
   $('#cuentaCompleta').focus();	
   

	$(':text').focus(function() {	
	 	esTab = false;
	});

	$.validator.setDefaults({
      submitHandler: function(event) { 
      	grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','cuentaCompleta');
      }
   });					

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$('#agrega').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionCtaContable.agrega);
	});
	
	$('#modifica').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionCtaContable.modifica);
	});	
	
	$('#eliminar').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionCtaContable.eliminar);
	});
	
	$('#agrega').attr('tipoTransaccion', '1');
	$('#modifica').attr('tipoTransaccion', '2');	
	$('#eliminar').attr('tipoTransaccion', '3');
	
	$('#cuentaCompleta').blur(function() {
  		validaCuentaContable('cuentaCompleta');
  		var ctaCompleta = $('#cuentaCompleta').val() ;  		 
  		var ctaMayor = ctaCompleta.substr(0, 4);
  		$('#cuentaMayor').val(ctaMayor) ; 
	});
	
	$('#cuentaCompleta').bind('keyup',function(e){
		if(this.value.length >= 2){ 
			var camposLista = new Array();
			var parametrosLista = new Array();			
			camposLista[0] = "descripcion"; 
			parametrosLista[0] = $('#cuentaCompleta').val();
			listaAlfanumerica('cuentaCompleta', '1', '1', camposLista, parametrosLista, 'listaCuentasContables.htm');
		}
	}); 
	
	$('#fechaCreacionCta').change(function() {
		var Xfecha= $('#fechaCreacionCta').val(); 
		var Yfecha=  parametroBean.fechaSucursal;
		
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaCreacionCta').val(parametroBean.fechaSucursal);

			if ( mayor(Xfecha, Yfecha) )
			{
				alert("La Fecha no debe ser mayor a la del Sistema");
				
				$('#fechaCreacionCta').val(parametroBean.fechaSucursal);
			}else{
				$('#fechaCreacionCta').focus();	
			}
		}else{
			$('#fechaCreacionCta').val(parametroBean.fechaSucursal);
		}

	});
	
	consultaMoneda();

	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {			 
			cuentaCompleta: {
				required: true,
				number: true,
				maxlength: 25,
				minlength: 1
			},  
			nivel: {
				required: true,
				number: true,
				
			},  
			
			codigoAgrupador: {
				required: true,
				
				
				
			},
			
			descripcion		: 'required', 
			descriCorta		: 'required', 
			naturaleza		: 'required',
			grupo			: 'required',
			tipoCuenta		: 'required',
			monedaID		: 'required', 
			restringida		: 'required', 	
			fechaCreacionCta : 'required'
		},
		
		messages: { 
			cuentaCompleta: {
				required: 'Especifique la cuenta',
				number:   'Solo Números',
				maxlength: 'máximo 25 números',
				minlength: 'mínimo 1 número'
			},  
			
			nivel: {
				required: 'Especifique el Nivel de la Cuenta',
				number:   'Solo Números',
			},
			
			codigoAgrupador: {
				required: 'Especifique el Código Agrupador',
				
					
			},
			descripcion		: 'Especifique la Descripcion', 
			descriCorta		: 'Especifique la Descripcion Corta',  
			naturaleza		: 'Especifique la naturaleza',
			grupo			: 'Especifique el Grupo',
			tipoCuenta		: 'Especifique el Tipo de Cuenta',
			monedaID		: 'Especifique la Moneda', 
			restringida		: 'Especifique si es Restringida o No',
			fechaCreacionCta : 'Especifique la Fecha de Creación de la Cuenta'
		}		
	}); 
	//------------ Validaciones de Controles ----------------------------------

	function validaCuentaContable(idControl) { 
		var jqCtaContable = eval("'#" + idControl + "'");
		var numCtaContable = $(jqCtaContable).val();
		var conPrincipal = 1;
		var conForanea = 2;
		var CtaContableBeanCon = {
  			'cuentaCompleta':numCtaContable
		};
		var CtaBalanzaBeanCon = {
  			'cuentaContable':numCtaContable
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCtaContable != '' && !isNaN(numCtaContable) && esTab){
			cuentasContablesServicio.consulta(conPrincipal,CtaContableBeanCon,function(ctaConta){
				if(ctaConta!=null){ 
					dwr.util.setValues(ctaConta);	
					$('#monedaID').val(ctaConta.monedaID).selected = true; 
					if(ctaConta.naturaleza=='A'){                                 
						$('#naturalezaA').attr("checked","1") ;
					} else{ 
						if(ctaConta.naturaleza=='D')
							$('#naturalezaD').attr("checked","1") ; 
					}
					
					if(ctaConta.grupo=='E'){                                 
						$('#grupoE').attr("checked","1") ;
					} else{
						if(ctaConta.grupo=='D')
							$('#grupoD').attr("checked","1") ;
					} 
                  if(ctaConta.restringida=='S'){                                 
                	  $('#restringidaS').attr("checked","1");
                  } else {
                	  if(ctaConta.restringida=='N')
                		  $('#restringidaN').attr("checked","1") ;
                  }	                 
                  deshabilitaBoton('agrega', 'submit');
                  habilitaBoton('modifica', 'submit'); 	
                  habilitaBoton('eliminar', 'submit'); 												
				} else{
					inicializaForma('formaGenerica','cuentaCompleta');
					deshabilitaBoton('modifica', 'submit');
					deshabilitaBoton('eliminar', 'submit');
					habilitaBoton('agrega', 'submit');					
					inicializaForma('formaGenerica','cuentaCompleta');
					var ctaCompleta = $('#cuentaCompleta').val() ; 
					var ctaMayor = ctaCompleta.substr(0, 4);
			  		$('#cuentaMayor').val(ctaMayor) ; 
									 
				}
			}); 
		}  
	}
		
	function consultaMoneda() {			
  			dwr.util.removeAllOptions('monedaID');
		//	dwr.util.addOptions('monedaID', {0:'Seleciona'});
			monedasServicio.listaCombo(3, function(monedas){
			dwr.util.addOptions('monedaID', monedas, 'monedaID', 'descripcion');
			});
	}
	
	
	
	/*funcion valida fecha formato (yyyy-MM-dd)*/
	function esFechaValida(fecha){

		if (fecha != undefined && fecha.value != "" ){
			var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
			if (!objRegExp.test(fecha)){
				alert("Formato de Fecha no Válido (aaaa-mm-dd)");
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
				if (comprobarSiBisisesto(anio)){ numDias=29; }else{ numDias=28;};
				break;
			default:
				alert("Fecha Introducida Errónea.");
			return false;
			}
			if (dia>numDias || dia==0){
				alert("Fecha Introducida Errónea.");
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
	function mayor(fecha, fecha2){ // valida si fecha > fecha2: true else false
		
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
	
	
});



function validadorConPunto(e){
	key=(document.all) ? e.keyCode : e.which;
	if (key < 48 || key > 57 || key == 46){
		if (key==8|| key == 46 || key == 0){
			return true;
		}
		else 
  		return false;
	}
} 

function validador(e){
	key=(document.all) ? e.keyCode : e.which;
	if (key < 48 || key > 57){
		if (key==8 || key == 0){
			return true;
		}
		else 
  		return false;
	}
}
