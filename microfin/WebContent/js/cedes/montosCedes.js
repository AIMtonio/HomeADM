$(document).ready(function() {

	esTab = true;
	var catTipoListaTipoCede = {
			'tipoCedesAct':3
		};	
	var catTipoConsultaTipoCede = {
			'principal':1
		};
	// Definicion de Constantes y Enums
	var catTipoTransaccionInversiones = {
			'agrega' : 1,
			'modifica' : 2
	};
	 
	$(':text').focus(function() {	
	 	esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$('#tipoCedeID').val("");
	$('#tipoCedeID').focus();
	deshabilitaBoton('agrega', 'submit');
	$.validator.setDefaults({
			submitHandler: function(event) { 
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','tipoCedeID','exitoTransaccionGrabar','falloTransaccionGrabar');
			}
    });			
	
	$('#agrega').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionInversiones.agrega);
		creaMontosCEDES();
		consultaMontosInfSup();
		
	});
	$('#tipoCedeID').bind('keyup',function(e){	
		 var camposLista = new Array();
		 var parametrosLista = new Array();
		 camposLista[0] = "descripcion";
		 parametrosLista[0] = $('#tipoCedeID').val();
		
		lista('tipoCedeID', 2, catTipoListaTipoCede.tipoCedesAct, camposLista, parametrosLista, 'listaTiposCedes.htm');
	});
	
	$('#tipoCedeID').blur(function() {
		if(esTab == true & !isNaN($('#tipoCedeID').val())){
			validaTipoCede($('#tipoCedeID').val());
			if(!isNaN($('#tipoCedeID').val()) & esTab == true){
			consultaMontos();
			}
		}
		
	});

	 //Funcion para consultar rango de montos
	function consultaMontos(){	
		var params = {};
		params['tipoLista'] = 2;
		params['tipoCedeID'] = $('#tipoCedeID').val();
		
		$.post("gridMontosCedes.htm", params, function(data){	
		
				if(data.length >0) {	
					$('#gridMontos').html(data);
					$('#gridMontos').show();
				}else{					
					$('#gridMontos').html("");
					$('#gridMontos').show();
				}
		});
	}
	
	/*=====Valida Forma========*/
	$('#formaGenerica').validate({
		rules: {
			tipoInversionID: { 
				minlength: 1
			}
		},
		messages: { 			
		 	tipoInversionID: {
				minlength: 'Al menos un Caracter'
			}
		}		
	});
		
	
	/*Funcion para consultar el tipo de Cede y moneda*/
	function validaTipoCede(tipCede){
		var TipoCedeBean ={
			'tipoCedeID' :tipCede
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(tipCede != '' && !isNaN(tipCede) && esTab){
		
				habilitaBoton('agrega', 'submit');
				tiposCedesServicio.consulta(catTipoConsultaTipoCede.principal,TipoCedeBean, function(tipoCede){
					if(tipoCede!=null){
						$('#descripcion').val(tipoCede.descripcion);	
						$('#tipoCedeID').val(tipoCede.tipoCedeID);
						$('#monedaID').val(tipoCede.monedaID);	
						$('#descripcionMoneda').val(tipoCede.descripcionMon);
						$('#estatusTipoCede').val(tipoCede.estatus);
						if(tipoCede.estatus == 'I'){	
							mensajeSis("El Producto "+tipoCede.descripcion+" se encuentra Inactivo, por favor comunicarse con el Administrador para más información.");
							deshabilitaBoton('agrega', 'submit');
							$('#tipoCedeID').focus();
						}
					}else{
						$('#estatusTipoCede').val('');
						$('#descripcion').val('');
						mensajeSis("El Tipo de CEDES no Existe.");
						$('#tipoCedeID').focus();
						$('#tipoCedeID').val('');
						$('#monedaID').val("");	
						$('#descripcionMoneda').val("");
						deshabilitaBoton('agrega', 'submit');
					}
				});
			
		}				
	}
	
	
	/*Funcion para crear la lista de montos*/
	function creaMontosCEDES(){
		var contador = 1;	
		$('#montosInferior').val("");
		$('#montosSuperior').val("");		
		quitaFormatoControles('gridMontos');
		
		$('input[name=montoInferior]').each(function() {	
			var MontoInferioruno =$('#inferior'+contador).asNumber();			
			if (contador != 1){
				$('#montosInferior').val($('#montosInferior').val() + ','  + MontoInferioruno);
			}else{				
				$('#montosInferior').val(MontoInferioruno);
			}

			contador = contador + 1;
			MontoInferioruno='';
		});
		contador = 1;
		$('input[name=montoSuperior]').each(function() {
			var montoSuperiorUno=$('#superior'+contador).asNumber();
			if (contador != 1){
				$('#montosSuperior').val($('#montosSuperior').val() + ','  + montoSuperiorUno);
			}else{
				
				$('#montosSuperior').val(montoSuperiorUno);
			}
			contador = contador + 1;
			montoSuperiorUno='';
		});	
	}
	

});

/*Funcion para validar que el monto inferior no sea mayor al superior*/
function consultaMontosInfSup(){
	var contador = 1;	
	$('input[name=montoSuperior]').each(function() {	
		$('#inferior'+contador).asNumber();			
		$('#superior'+contador).asNumber();			
		if($('#inferior'+contador).asNumber()	> $('#superior'+contador).asNumber()){
			mensajeSis("El Monto Superior debe de ser Mayor al Monto Inferior.");	
		 $('#superior'+contador).focus();	
		 agregaFormatoControles('gridMontosCedes');
		 event.preventDefault();
		}
		contador = contador + 1;
	});
	
}

function exitoTransaccionGrabar(){
	agregaFormatoControles('gridMontosCedes');
	
}
function falloTransaccionGrabar(){
	agregaFormatoControles('gridMontosCedes');
	
}