$(document).ready(function(){
		
		var parametroBean = consultaParametrosSession();   
		//Definicion de constantes y Enums
		
		var catTipoConTipoCamp = { 
  		'principal'	: 1,
  		'foranea'	: 2,  		
	};	
			
		var catTipoTranTipoCamp = { 
  		'agrega'		: 1,
  		'modifica'		: 2,
  		'elimina'  	    :3,
	};		
		//-----------------------Metodos y manejo de eventos-----------------------		
		deshabilitaBoton('agregar', 'submit');
		deshabilitaBoton('modificar', 'submit');
		deshabilitaBoton('eliminar', 'submit');
		
		$('#tipoCampaniaID').focus();


	agregaFormatoControles('formaGenerica');
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
		}
	});			
    
   	$.validator.setDefaults({
            submitHandler: function(event) { 
            	grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','tipoCampaniaID','funcionExito','funcionError'); 
			deshabilitaBoton('agregar', 'submit');			
            }
    });	
    
	$('#agregar').click(function(){
		$('#tipoTransaccion').val(catTipoTranTipoCamp.agrega);		
	});
	$('#modificar').click(function(){
		$('#tipoTransaccion').val(catTipoTranTipoCamp.modifica);		
	});
	$('#eliminar').click(function(){
		$('#tipoTransaccion').val(catTipoTranTipoCamp.elimina);			
	});
	
	
	$('#tipoCampaniaID').blur(function(){
		validaTipoCampania(this.id);		
	});	
	
	$('#tipoCampaniaID').bind('keyup',function(e) { 
		lista('tipoCampaniaID', '1', '1', 'nombre', $('#tipoCampaniaID').val(),'TipoCampaniasLista.htm');
	});
	
	$('#clasificacion').blur(function(){
		validaOpcionesClasifCateg();
	});
	
	$('#clasificacion').change(function() {
  		validaOpcionesClasifCateg();
	});

	//------------ Validaciones de la Forma -------------------------------------
	
	$('#formaGenerica').validate({
		rules: {
			tipoCampaniaID: {
				number: true
			},
			nombre: {
				required: true
			},
			clasificacion: {
				required: true
			},
			categoria: {
				required: true
			}
		},
		messages: {
			tipoCampaniaID: {
				number: 'Sólo números'
			},
			nombre: {
				required: 'Especificar Nombre'
			},
			clasificacion: {
				required: 'Especificar Clasificacion'
			},
			categoria: {
				required: 'Especificar Categoria'
			}
		}		
	});	
//-------------Validaciones de controles---------------------					
	function validaTipoCampania(idControl){
		var jqTipoCam  = eval("'#" + idControl + "'");
		var numTipoCam = $(jqTipoCam).val();	
		
		setTimeout("$('#cajaLista').hide();", 200);
		if(numTipoCam != '' && !isNaN(numTipoCam) ){
			var tipoCampBeanCon = { 
			'tipoCampaniaID' :numTipoCam
			};
				if(numTipoCam == '0'){ 
					habilitaBoton('agregar', 'submit');	
					deshabilitaBoton('modificar', 'submit');
					deshabilitaBoton('eliminar', 'submit');
					inicializaForma('formaGenerica','tipoCampaniaID');
					$('#categoria').val('');
					$("#categoria option[value='A']").remove();
					$("#categoria option[value='C']").remove();
					$("#categoria option[value='E']").remove();
					$('#clasificacion').val('');
					$('#nombre').val('');
					
				}else{					
					habilitaBoton('modificar', 'submit');				
					habilitaBoton('eliminar', 'submit');
					tipoCampaniasServicio.consulta(catTipoConTipoCamp.principal,tipoCampBeanCon,function(tipoCampanias) {
						if(tipoCampanias!=null){							 
							dwr.util.setValues(tipoCampanias);
							$('#clasificacion').val(tipoCampanias.clasificacion);
							 validaOpcionesClasifCateg();	
							 $('#categoria').val(tipoCampanias.categoria);
							 deshabilitaBoton('agregar', 'submit');							 
						}else{
							inicializaForma('formaGenerica','tipoCampaniaID');
							limpiaForm($('#formaGenerica'));	
							$('#tipoCampaniaID').val('');
							$('#tipoCampaniaID').focus();
							$('#tipoCampaniaID').select();
							mensajeSis("El tipo de Campania no Existe");
							deshabilitaBoton('agregar', 'submit');
							deshabilitaBoton('modificar', 'submit');
							deshabilitaBoton('eliminar', 'submit');
						}
				});	// consulta																		
		}// != 0
	}
	}
	
// Valida opciones del combo de clasificacion y categoria
	function validaOpcionesClasifCateg(){
		if($('#clasificacion').val() == 'E') {
			$("#categoria option[value='A']").remove();
			$("#categoria option[value='C']").remove();
			$("#categoria option[value='E']").remove();
				$('#categoria').append(new Option('POR EVENTO', 'E', true, true));  
		}
		
		if($('#clasificacion').val() == 'S') {
				$("#categoria option[value='A']").remove();
				$("#categoria option[value='C']").remove();
				$("#categoria option[value='E']").remove();
				$('#categoria').append(new Option('AUTOMATICA', 'A', true, true));  
				$('#categoria').append(new Option('CAMPAÑA', 'C', true, true));  
		}
		
		if($('#clasificacion').val() == 'I') {
			$("#categoria option[value='A']").remove();
			$("#categoria option[value='C']").remove();
			$("#categoria option[value='E']").remove();
			$('#categoria').append(new Option('CAMPAÑA', 'C', true, true));  
			}
		}
	
	});

//funcion que se ejecuta cuando el resultado fue exito
function funcionExito(){
	$('#tipoCampaniaID').focus();
	deshabilitaBoton('agregar', 'submit');
	deshabilitaBoton('modificar', 'submit');
	deshabilitaBoton('eliminar', 'submit');
	$("#categoria option[value='A']").remove();
	$("#categoria option[value='C']").remove();
	$("#categoria option[value='E']").remove();
	$('#categoria').val('');
	$('#clasificacion').val('');
	$('#nombre').val('');

}

//funcion que se ejecuta cuando el resultado fue error
function funcionError(){

}
