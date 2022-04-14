$(document).ready(function() {

	esTab = true;

	// Definicion de Constantes y Enums
	var catTipoTransaccionInversiones = {
			'agrega' : 1,
			'modifica' : 2
	};
	
	var catTipoConsultaTipoCede = {
			'principal':1
	};
	
	var catTipoListaTipoCede={
			'tipoCedesAct':3
	}; 
	
	deshabilitaBoton('agrega', 'submit');
	
	$(':text').focus(function() {	
	 	esTab = false;
	});
	$('#tipoCedeID').val("");
	$('#tipoCedeID').focus();

	$.validator.setDefaults({
			submitHandler: function(event) { 
         	grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','tipoCedeID'); 
			}
    });			
	
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#agrega').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionInversiones.agrega);
		creaPlazosInversion();
		consultaPlazosInfSup();
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
				consultaPlazos();
			}
		}		
	});

	
	function consultaPlazos(){	
		var params = {};
		params['tipoLista'] = 2;
		params['tipoCedeID'] = $('#tipoCedeID').val();
		
		$.post("gridPlazosCedes.htm", params, function(data){
				if(data.length >0) {
					$('#gridPlazos').html(data);
					$('#gridPlazos').show();
				}else{
					$('#gridPlazos').html("");
					$('#gridPlazos').show();
				}
		});
	}

	$('#formaGenerica').validate({
		rules: {
			tipoCedeID: { 
				minlength: 1
			}
		},
		messages: { 			
			tipoCedeID: {
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
						$('#tipoCedeID').val('');
						$('#monedaID').val("");	
						$('#descripcionMoneda').val("");
						$('#tipoCedeID').focus();
						mensajeSis("El Tipo de CEDES no Existe.");
						deshabilitaBoton('agrega', 'submit');
					}
				});
		}				
	}
	
	
	function creaPlazosInversion(){
		var contador = 1;	
		$('#diasInferior').val("");
		$('#diasSuperior').val("");		
		
		$('input[name=plazoInferior]').each(function() {					
			if (contador != 1){
				$('#diasInferior').val($('#diasInferior').val() + ','  + this.value);
			}else{
				$('#diasInferior').val(this.value);
			}
			contador = contador + 1;
		});
		contador = 1;
		$('input[name=plazoSuperior]').each(function() {
			if (contador != 1){
				$('#diasSuperior').val($('#diasSuperior').val() + ','  + this.value);
			}else{
				$('#diasSuperior').val(this.value);
			}
			contador = contador + 1;
		});
	}
	

});
/*Funcion para validar que el monto inferior no sea mayor al superior*/
function consultaPlazosInfSup(){
	var contador = 1;	
	$('input[name=plazoSuperior]').each(function() {	
		$('#inferior'+contador).asNumber();			
		$('#superior'+contador).asNumber();			
		if($('#inferior'+contador).asNumber()	> $('#superior'+contador).asNumber()){
			mensajeSis("El Día Superior debe de ser Mayor al Día Inferior.");	
		 $('#superior'+contador).focus();	
		 agregaFormatoControles('gridPlazos');
		 event.preventDefault();
		}
		contador = contador + 1;
	});
	
}
