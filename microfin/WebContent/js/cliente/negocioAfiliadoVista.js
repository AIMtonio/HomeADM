$(document).ready(function() {
		esTab = true;
	 
	//Definicion de Constantes y Enums  
	var catTipoTransaccionNegocioAfiliado = {   
  		'agrega':'1',
  		'modifica':'2',	
  		'baja':'3'
	};
	
	var catTipoActualizacionNegocioAfiliado = {   	
	  		'baja':1
		};
		
	
	var catTipoConsultaNegocioAfiliad = {
  		'principal'	: 1
	};	

	//------------ Metodos y Manejo de Eventos -----------------------------------------
	deshabilitaBoton('modifica', 'submit');
    deshabilitaBoton('agrega', 'submit');
    deshabilitaBoton('baja', 'submit');
	var parametroBean = consultaParametrosSession();
	$('#fechaRegistro').val(parametroBean.fechaSucursal);
	
	

	$.validator.setDefaults({
            submitHandler: function(event) { 
            	grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','negocioAfiliadoID',
            			'funcionExitoNegAfi','funcionErrorNegAfi'); 
            }
    });	
	
	$(':text').focus(function() {	
	 	esTab = false;
	});
	    
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#agrega').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionNegocioAfiliado.agrega);
	});
	
	$('#modifica').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionNegocioAfiliado.modifica);
	});	
	
	$('#baja').click(function(){
		$('#tipoTransaccion').val(catTipoTransaccionNegocioAfiliado.baja);
		$('#tipoActualizacion').val(catTipoActualizacionNegocioAfiliado.baja);
	});
	
	$('#negocioAfiliadoID').blur(function() { 
		validaNegocioAfiliado(this.id); 
	});
 
	
	//··········°° arroja la lista de los negocios afiliados
	$('#negocioAfiliadoID').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "razonSocial";
		parametrosLista[0] = $('#negocioAfiliadoID ').val();
		lista('negocioAfiliadoID', '2', '1', camposLista, parametrosLista,'listaNegociosAfiliados.htm');			
	});
	
	/* se lista el promotor*/
	$('#promotorOrigen').bind('keyup',function(e) {
		parametroBean = consultaParametrosSession();
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "nombrePromotor";
		camposLista[1] = "sucursalID";
		parametrosLista[0] = $('#promotorOrigen').val();
		parametrosLista[1] = parametroBean.sucursal;  
		lista('promotorOrigen', '1', '1',camposLista, parametrosLista, 'listaPromotores.htm');
	});
	/*se consulta el promotor*/
	$('#promotorOrigen').blur(function() {
		consultaPromotor(this.id);
	});
	
	$('#clienteID').bind('keyup',function(e){
		lista('clienteID', '2', '1', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});
	
	$('#clienteID').blur(function() {
  		consultaCliente(this.id);
	});
	
	/* valida rfc */
	$('#rfc').blur(function() {
		if($('#tipoPersona').is(':checked')){  
			validaRFC('rfc');
		}else{
			if($('#tipoPersona3').is(':checked')){  
				validaRFC('rfc');
			}
		}
	}); 
	//------------ Validaciones de la Forma -------------------------------------
	
	$('#formaGenerica').validate({
		rules: {
			negocioAfiliadoID: {
				required:true
			},
				razonSocial:{
				required:true	

			},
			rfc:{
				required: true,
				maxlength: 12,
				minlength: 12
			},
			telefonoContacto:{
				required: true	

			},
			direccionCompleta:{
				required: true	

			},
			correo:{
				required: 	true,	
				mail: 		true

			},
			nombreContacto:{
				required: true	

			},
			fechaRegistro:{
				required:true	

			},
			promotorOrigen:{
				required:true	
			}
		},
		messages: {
			negocioAfiliadoID: {
				 required:'Especifique Negocio Afiliado.' 
	
			 },
			 
			 razonSocial:{
				 required:'Especifique La Razón Social.' 
			 },
			 
			 rfc:{
				 required:'Especifique El RFC.' ,
				 	maxlength: 'Máximo 12 caracteres',
					minlength: 'Mínimo 12 caracteres'
			 },
			 
			 telefonoContacto:{
				 required:'Especifique El Teléfono de Contacto.' 
			 },
			 
			 direccionCompleta:{
				 required:'Especifique La Dirección Completa.' 
			 },
			 
			 email:{
				 required:'Especifique El Correo Electrónico.' ,
				 mail: 'Formato de Correo Incorrecto'
				 
			 },			 
			 nombreContacto:{
				 required:'Especifique El Nombre de Contacto.'
			 },
			 
			 fechaRegistro:{
				 required:'Especifique Fecha de Registro.'
			 },
			 promotorOrigen:{
				 required:'Especifique El ID del Promotor.'
			 }
		}		
	});
	

	//------------ Validaciones de Controles -------------------------------------
	function validaNegocioAfiliado(control) {
		var negAfil = $('#negocioAfiliadoID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(negAfil != '' && !isNaN(negAfil) && esTab){
			var negocioAfiliadoBeanCon = {
					'negocioAfiliadoID':$('#negocioAfiliadoID').val()  		
			};
			if(negAfil==0){
				habilitaBoton('agrega', 'submit');
				deshabilitaBoton('modifica', 'submit');
				deshabilitaBoton('baja', 'submit');
				inicializaForma('formaGenerica', 'negocioAfiliadoID');
				$('#fechaRegistro').val(parametroBean.fechaSucursal);
				$('#estatusDescripcion').val('ALTA');
				$('#estatus').val('A');
			}else{
				negocioAfiliadoServicio.consulta(catTipoConsultaNegocioAfiliad.principal,negocioAfiliadoBeanCon,function(negoAfili) {
					if(negoAfili!=null){

						dwr.util.setValues(negoAfili);	
						esTab=true;			
						consultaPromotor('promotorOrigen');
						if(negoAfili.clienteID==0){
							$('#clienteID').val("");
							$('#nombreCliente').val("");
						}
						consultaCliente('clienteID');
						if(negoAfili.estatus == "B"){
							deshabilitaBoton('agrega', 'submit');
							deshabilitaBoton('modifica', 'submit');
							deshabilitaBoton('baja', 'submit');
							alert("El Negocio Afiliado está dado de Baja");

						}else{
							deshabilitaBoton('agrega', 'submit');
							habilitaBoton('modifica', 'submit');
							habilitaBoton('baja', 'submit');
							
						}
					}else{
						alert("No Existe el Negocio Afiliado");
							$('#negocioAfiliadoID').focus();
							$('#negocioAfiliadoID').select();
							$('#razonSocial').val('');
							deshabilitaBoton('agrega', 'submit');
							deshabilitaBoton('modifica', 'submit');
							deshabilitaBoton('baja', 'submit');
							inicializaForma('formaGenerica', 'negocioAfiliadoID');
						}
				});
				
			}					
		}
	}

	function consultaPromotor(idControl) {
		var jqPromotor = eval("'#" + idControl + "'");
		var numPromotor = $(jqPromotor).val();
		var tipConForanea = 2;
		var promotor = {
			'promotorID' : numPromotor
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if (numPromotor != '' && !isNaN(numPromotor) && esTab) {
			promotoresServicio.consulta(tipConForanea,promotor, function(promotor) {
				if (promotor != null) {
					if(promotor.estatus != 'A'){
						alert("El promotor debe de estar Activo");
						 $(jqPromotor).val("");
						 $(jqPromotor).focus();
						 $('#nombrePromotor').val("");
					}else{
						$('#nombrePromotor').val(promotor.nombrePromotor);
					}
					
				} else {
					alert("No Existe el Promotor");
					 $(jqPromotor).val("");
					 $(jqPromotor).focus();
					 $('#nombrePromotor').val("");
				}
			});
		}
	}

	function consultaCliente(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();	
		var tipConForanea = 2;	
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numCliente != '' && !isNaN(numCliente) && numCliente>0 && esTab){
			clienteServicio.consulta(tipConForanea,numCliente,function(cliente) {
				if(cliente!=null){	
					$('#clienteID').val(cliente.numero);			
					$('#nombreCliente').val(cliente.nombreCompleto);
				}else{
					alert("No Existe el Cliente");
					$('#clienteID').focus();
					$('#clienteID').select();	
					$('#clienteID').val("");
					$('#nombreCliente').val("");
				}    	 						
			});
		}
	}	
		
});// fin jquery

/* funcion de exito que se ejecuta en la retrollamada */
function funcionExitoNegAfi(){
	deshabilitaBoton('modifica', 'submit');
	deshabilitaBoton('agrega', 'submit');
	deshabilitaBoton('baja', 'submit');
	inicializaForma('formaGenerica', 'negocioAfiliadoID');	
}
function funcionErrorNegAfi(){
}
var nav4 = window.Event ? true : false;
function IsNumber(evt){
	var key = nav4 ? evt.which : evt.keyCode;
	return (key <= 13 || (key >= 48 && key <= 57) );
}