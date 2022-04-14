$(document).ready(function(){
$('#segtoPrograIDCob').focus();
	
	parametroBean = consultaParametrosSession();
	if($('#segtoPrograID').val()!= undefined){
		$('#segtoPrograIDCob').val($('#segtoPrograID').val());
		$('#segtoRealizaIDCob').val($('#segtoRealizaID').val());
		
		
		esTab=true;
		consultaMotivosNoPago();
		consultaOrigenPago();
		consultaSegtoCobranza('segtoRealizaIDCob');
		$('#salir').show();
	}

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	$(':text').focus(function() {	
		esTab = false; 
	});
	var consultaPrincipal ={
		'principal'	: 1
	};
	
			
	var catTipoTranSegto = { 
  		'agrega'	: 1, 
  		'modifica'	: 2
	};
//-----------------------Métodovalidas y manejo de eventos-----------------------
	agregaFormatoControles('formaGenerica2');
	deshabilitaBoton('agrega', 'submit');
	deshabilitaBoton('modifica', 'submit');
	consultaMotivosNoPago();
	consultaOrigenPago();
	$.validator.setDefaults({
		submitHandler: function(event) {
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica2', 'contenedorForma', 'mensaje','true','segtoPrograIDCob',
					'funcionExito','funcionError');

		}
	});

	 $('#segtoPrograIDCob').bind('keyup',function(e){
		   if(this.value.length >= 2){
			   var camposLista = new Array(); 
			   var parametrosLista = new Array();
			   camposLista[0] = "puestoResponsableID"; 
			   camposLista[1] = "nombreResponsable";
				parametrosLista[0] = parametroBean.numeroUsuario;
			   parametrosLista[1] = $('#segtoPrograIDCob').val();
			   listaAlfanumerica('segtoPrograIDCob', '1', '2', camposLista, parametrosLista, 'listaCalSegto.htm');
		   }
	   });


	$('#segtoRealizaIDCob').blur(function(){
		consultaSegtoCobranza(this.id);
	});
	
	
	$('#agrega').click(function(){
		$('#tipoTransaccionCob').val(catTipoTranSegto.agrega);
	});
	
	$('#modifica').click(function(){
		$('#tipoTransaccionCob').val(catTipoTranSegto.modifica);

	});

	$('#salir').click(function(){
		$('#divDetalleSegumiento').unblock();
		$('#contenedorForma').unblock();
		$.unblockUI({ 
            onUnblock: function(){  } 
        }); 
	});
	
	
	$('#fechaPromPago').blur(function(){
		$('#montoPromPago').focus();
	});
	
	$('#montoPromPago').blur(function(){
		$('#existFlujo').focus();
	});
	
	
	
	$('#existFlujo2').click(function() {	
		$('#lblcerrarFecha').hide();
		$('#fechaEstFlujo').val('1900-01-01');
		$('#cerrarFecha').hide();
		$('#existFlujo2').focus().select;
	
	});

	$('#existFlujo1').click(function() {	
		$('#lblcerrarFecha').show();
		$('#fechaEstFlujo').val('');
		$('#cerrarFecha').show();
		$('#existFlujo1').focus().select;
	
	});
	
	$('#fechaPromPago').blur(function(){
		FechaValida($('#fechaPromPago').val(),this.id);
	});
	
	$('#fechaEstFlujo').blur(function(){
		FechaValida($('#fechaEstFlujo').val(),this.id);
	});
	
	$('#fechaPromPago').change(function(){
		$('#fechaPromPago').focus().select;
		
	});

	
	
	$('#fechaEstFlujo').change(function(){
		$('#fechaEstFlujo').focus().select;
		
	});
	
	$('#origenPagoID').change(function () {
		if (this.value == 1 || this.value == 2) {
			deshabilitaControl('nomOriRecursos');
			$('#nomOriRecursos').val($('#nombreCompleto').val());
		}else {
			$('#nomOriRecursos').val('');
			habilitaControl('nomOriRecursos');			
		}
	});
	
	
	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica2').validate({
		rules: {			
			
			telefonFijo:{
				required: function() {return $('#telefonCel').val()=='';},
				numeroPositivo: true
			},
			
			telefonCel:{
				required: function() {return $('#telefonFijo').val()=='';},
				numeroPositivo: true
			},
			
			fechaEstFlujo:{
				required: function() {return $('#existFlujo1').is(':checked');}
			
			},
			
			fechaPromPago:{
				required: true
			
			},
			montoPromPago:{
				required: true,
				
			},
			nomOriRecursos:{
				required: true,
				
			},
		
			motivoNPID:{
				required: true,
				
			},
			origenPagoID:{
				required: true,
				
			}
			
			
			
		
		},		
		messages: {
			telefonFijo: {
				required: 'Especificar telefono fijo.',
				numeroPositivo: 'Sólo números positivos.',
			},
			telefonCel: {
				required: 'Especificar telefono celular.',
				numeroPositivo: 'Sólo números positivos.',
			},
			fechaEstFlujo:{
				required: 'Especificar Fecha.',
				
			},
			
			fechaPromPago:{
				required: 'Especificar Fecha.',
				
			},
			montoPromPago:{
				required: 'Especificar el Monto Promesa.',
				
			},
			nomOriRecursos:{
				required: 'Especificar Nombre de Origen de Recurso.',
				
			},
			motivoNPID:{
				required: 'Especificar Motivo de no Pago.',
				
			},
			origenPagoID:{
				required: 'Especificar Origen de Pago.',
				
			}
			

		}
	});
	
	
	function consultaOrigenPago() {
		
		var motivoBean = {
			'origenPagoID' : ''
		};
		dwr.util.removeAllOptions('origenPagoID'); 
		dwr.util.addOptions('origenPagoID', {'':'SELECCIONAR'});
		 	
		segtoOrigenPagoServicio.listaCombo(motivoBean, 3, function(motivos){
			dwr.util.addOptions('origenPagoID', motivos, 'origenPagoID', 'descripcion');
		});
	}	
	
	function consultaMotivosNoPago() {
		
		var motivoBean = {
			'motivoNPID' : ''
		};
		dwr.util.removeAllOptions('motivoNPID'); 
		dwr.util.addOptions('motivoNPID', {'':'SELECCIONAR'});
		 	
		segtoMotNoPagoServicio.listaCombo(motivoBean, 3, function(motivos){
			dwr.util.addOptions('motivoNPID', motivos, 'motivoNPID', 'descripcion');
		});
	}
		//funcion que consulta seguimiento 
	function consultaSegtoCobranza(idSegto) {
		var numSegto = $('#segtoPrograIDCob').val();
		var consecutivo = $('#segtoRealizaIDCob').val();

		var tipoPrincipal = 1;
		setTimeout("$('#cajaLista').hide();", 200);				
		if(consecutivo != '' && !isNaN(consecutivo)){
			var bean={
				'segtoPrograID': numSegto,
				'segtoRealizaID' : consecutivo
			};
			resultadoSegtoCobranzaServicio.consultaPrincipal(tipoPrincipal,bean,function(segto) {
			
				if(segto!=null){
					$('#fechaPromPago').val(segto.fechaPromPago);
					$('#montoPromPago').val(segto.montoPromPago);
					$('#existFlujo').val(segto.montoPromPago);
					if ((segto.existFlujo)=='S'){
						$('#lblcerrarFecha').show();
						$('#fechaEstFlujo').val(segto.fechaEstFlujo);
						$('#cerrarFecha').show();
						$('#existFlujo1').attr("checked",true);
					}else{
						$('#lblcerrarFecha').hide();
						$('#fechaEstFlujo').val('1900-01-01');
						$('#cerrarFecha').hide();
						$('#existFlujo2').attr("checked",true);		
					}
					$('#fechaEstFlujo').val(segto.fechaEstFlujo);
					$('#origenPagoID').val(segto.origenPagoID);
					$('#motivoNPID').val(segto.motivoNPID);
					$('#nomOriRecursos').val(segto.nomOriRecursos);
					if (segto.origenPagoID == 1 || segto.origenPagoID == 2) {
						deshabilitaControl('nomOriRecursos');
					}else {
						habilitaControl('nomOriRecursos');
					}
					$('#telefonFijo').val(segto.telefonFijo);
					$('#telefonCel').val(segto.telefonCel);
				
					habilitaBoton('modifica','submit');
					deshabilitaBoton('agrega','submit');
				}else{
					$('#segtoPrograIDCob').val();
					$('#segtoRealizaIDCob').val();
					$('#fechaPromPago').val('');
					$('#montoPromPago').val('');
					$('#existFlujo').val('');
					$('#fechaEstFlujo').val('');
					$('#origenPagoID').val('');
					$('#motivoNPID').val(20);
					$('#nomOriRecursos').val('');
					$('#telefonFijo').val('');
					$('#telefonCel').val('');
				deshabilitaBoton('modifica','submit');
				habilitaBoton('agrega','submit');
				}
				
							
			});
		}
	}
	
	
	 function FechaValida(fecha,idcontrol){
			var fechas=eval("'#"+idcontrol+"'");
			if(fecha == ""){return false;}
			if (fecha != undefined  ){
				
				var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
				if (!objRegExp.test(fecha)){
					alert("formato de fecha no válido (aaaa-mm-dd)");
					$(fechas).val('');
					return true;
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
					alert("Fecha introducida errónea.");
				$(fechas).val('');
				
				return true;
				}
				if (dia>numDias || dia==0){
					alert("Fecha introducida errónea.");
					$(fechas).val('');
					return true;
					
				}
				return false;
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
	
	
	
	
});





//funcion que se ejecuta cuando el resultado fue exito
function funcionExito(){
	deshabilitaBoton('grabar', 'submit');
	deshabilitaBoton('modifica', 'submit');
	$('#fechaPromPago').val('');
	$('#montoPromPago').val('');
	$('#existFlujo').val('');
	$('#fechaEstFlujo').val('');
	$('#origenPagoID').val('');
	$('#motivoNPID').val('');
	$('#nomOriRecursos').val('');
	$('#telefonFijo').val('');
	$('#telefonCel').val('');
	if($('#segtoPrograID').val()!= undefined){
		$('#divDetalleSegumiento').hide();
	}
}
//funcion que se ejecuta cuando el resultado fue error
//diferente de cero
function funcionError(){
	deshabilitaBoton('grabar', 'submit');
	deshabilitaBoton('modifica', 'submit');
	$('#fechaPromPago').val('');
	$('#montoPromPago').val('');
	$('#existFlujo').val('');
	$('#fechaEstFlujo').val('');
	$('#origenPagoID').val('');
	$('#motivoNPID').val('');
	$('#nomOriRecursos').val('');
	$('#telefonFijo').val('');
	$('#telefonCel').val('');
	if($('#segtoPrograID').val()!= undefined){
		$('#divDetalleSegumiento').hide();
	}
	
	
}
