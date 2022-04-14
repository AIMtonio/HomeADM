$(document).ready(function() {
	
	$('#promotorID').focus();
	
		esTab = false;	
	//Definicion de Constantes y Enums  
	var catTipoTransaccionPromotor = {
  		'agrega':'1',
  		'modifica':'2'
	};
	
	var catTipoConsultaPromotor = {
  		'principal':1,
  		'foranea':2,
  		'promotorAct' :3
	};	
	
	var catTipoPromotorCon ={
		'tipoPromotor'	: 5
	};
	
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	
	
	deshabilitaBoton('modifica', 'submit');
	deshabilitaBoton('agrega', 'submit');
	
	$(':text').focus(function() {	
	 	esTab = false;
	});
	

	$.validator.setDefaults({
            submitHandler: function(event) { 
            	if($('#tipoTransaccion').val()==catTipoTransaccionPromotor.modifica){
            		if(confirm("Cambio Promotor,¿Está seguro de Cambiar al Usuario Actual?")){
            			grabaFormaTransaccionRetrollamada(event, 'formaGenerica','contenedorForma', 'mensaje', 'true','promotorID','exitoTransPromotor','');
            			//grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','promotorID'); 
                    }

                	}
            	if($('#tipoTransaccion').val()==catTipoTransaccionPromotor.agrega){
            		grabaFormaTransaccionRetrollamada(event, 'formaGenerica','contenedorForma', 'mensaje', 'true','promotorID','exitoTransPromotor','');
            		//grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','promotorID'); 
            	}
  }
    });		
	
	    
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#agrega').click(function() {	
		
		$('#tipoTransaccion').val(catTipoTransaccionPromotor.agrega);
	});
	
	$('#modifica').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionPromotor.modifica);
	});	
	
	$('#agrega').attr('tipoTransaccion', '1');
	$('#modifica').attr('tipoTransaccion', '2');
	

	$('#promotorID').bind('keyup',function(e){
		//TODO Agregar Libreria de Constantes Tipo Enum		
		lista('promotorID', '1', '1', 'nombrePromotor', $('#promotorID').val(), 'listaPromotores.htm');
	});
		
	$('#promotorID').blur(function() {
  		validaPromotor(this.id);
	});
    
	$('#sucursalID').bind('keyup',function(e){
		//TODO Agregar Libreria de Constantes Tipo Enum
		lista('sucursalID', '1', '1', 'nombreSucurs', $('#sucursalID').val(), 'listaSucursales.htm');		       
	});	
   	
	$('#sucursalID').blur(function() {
  		consultaSucursal(this.id);
	});
	
	$('#usuarioID').bind('keyup',function(e){
		//TODO Agregar Libreria de Constantes Tipo Enum
		lista('usuarioID', '1', '1', 'nombreCompleto', $('#usuarioID').val(), 'listaUsuarios.htm');
	});	
	
	$('#gestorID').bind('keyup',function(e){
		   lista('gestorID', '2', '9', 'nombreCompleto', $('#gestorID').val(), 'listaUsuarios.htm');
	});
   	
	$('#gestorID').blur(function(){
		consultaGestor(this.id);
	});	
	
	$('#usuarioID').blur(function() {
  		consultaUsuario(this.id);
  		
	});
	

	
	
	
	$('#empresa').bind('keyup',function(e){
		//TODO Agregar Libreria de Constantes Tipo Enum		
	});	
   	
	$('#empresa').blur(function() {
  		//consultaEmpresas(this.id);
	});
	
	$('#telefono').setMask('phone-us');
	$('#celular').setMask('phone-us');
	
	$('#extTelefonoPart').blur(function() {
		if(this.value != ''){
			if($("#telefono").val() == ''){
				this.value = '';
				mensajeSis("El Número de Teléfono está Vacío.");
				$("#telefono").focus();
			}
		}
	});
	
	$('#telefono').blur(function() {
		if(this.value == ''){
			$("#extTelefonoPart").val('');
		}
	});
	
	$('#aplicaPromotor1').click(function(){
		$('#aplicaPromotor').val(this.value);
	});

	$('#aplicaPromotor2').click(function(){
		$('#aplicaPromotor').val(this.value);
	});
	
	$('#aplicaPromotor3').click(function(){
		$('#aplicaPromotor').val(this.value);
	});
	validaPromotorCaptacion();
	//------------ Validaciones de la Forma -------------------------------------
	
	$('#formaGenerica').validate({
				
		rules: {
			nombrePromotor: {
				required: true,
				minlength: 4
			},
			
			nombreCoordinador: {
				required: true,
				minlength: 5
			},
			telefono : {
				required : false,				
			},
			celular: {
				required : false,				
			},
			extTelefonoPart: {
				number : true,
			},
			
			
			sucursalID : {
				required : true,
				number : true
			},
			
			
			
			usuarioID:'required',
			
			correo:'email',
			
			numeroEmpleado:'required',
			
		
			 
			aplicaPromotorOpc: {
				required : function() {return $('#aplicaPromotorTr').is(':checked');}
			},
			
			
		
				
		},
		
		messages: {
			
			nombrePromotor: {
				required: 	'Especificar Nombre del Promotor',
				minlength: 	'Al Menos Cuatro Caracteres'
			},
		
			nombreCoordinador: {
				required: 	'Especificar Nombre del Coordinador',
				minlength: 	'Al Menos Cinco Caracteres'
			},
			telefono : {				
			},
			celular: {				
			},
			extTelefonoPart:{
				number: 'Sólo Números (Campo Opcional)',
			},
		
			sucursalID: {
				required: 	'Especificar la Sucursal',
				number: 'Sólo Números',
			},
			
			
			usuarioID:		'Especificar el Usuario',
			
			correo: {
				email: 		'Dirección Inválida'
			},
				
			numeroEmpleado:'Especificar un Número de Empleado',
			
			
				
			aplicaPromotorOpc: {
				required:  'Seleccione una Opción'
			},
				
			
		}		
	});
	
	//------------ Validaciones de Controles -------------------------------------
	
	// funcion para validar para ocultar  o habilitar  campo en caso de ser requerido
	function validaPromotorCaptacion(){
		var promotorBean = {
			'tipoPromotorID' : ''
		};
		promotoresServicio.consulta(catTipoPromotorCon.tipoPromotor, promotorBean, function(promotorBean){
			if (promotorBean != null){
				
				if (promotorBean.aplicaPromotor == '1'){
					$('#aplicaPromotorTr').show();
					$('#aplicaPromotor').val("CR");
				}else{
					$('#aplicaPromotorTr').hide();
					$('#aplicaPromotor').val("N");
				}
			}			
		});
	}
	
	function validaPromotor(control) {
		var numPromotor = $('#promotorID').val();
		
		setTimeout("$('#cajaLista').hide();", 200);
		
		if(numPromotor != '' && !isNaN(numPromotor) && esTab){
			
			if(numPromotor=='0'){
				
				$('#estatus').disabled=true;
				 deshabilitaBoton('agrega', 'submit'); 		
				 deshabilitaBoton('modifica', 'submit');
				//inicializaForma($('#formaGenerica'),$('#promotorID'));
				inicializaForma('formaGenerica','promotorID');
				$('#estatus').disabled=false;
				$('#sucursal').val('');
					
				$('#aplicaPromotor1').attr('checked', 'true' );
				validaPromotorCaptacion();
				
			} else {
				$('#estatus').disabled=false;
				deshabilitaBoton('agrega', 'submit');
				habilitaBoton('modifica', 'submit');	
				
				var promotor = {
					 'promotorID' : $('#promotorID').val()
					};
			
				validaPromotorCaptacion();
				
				promotoresServicio.consulta(catTipoConsultaPromotor.principal, promotor,function(promotor) {
						if(promotor!=null){
							// mensajeSis("promotor"+promotor.extTelefonoPart);
							dwr.util.setValues(promotor);	
							
							$('#telefono').setMask('phone-us');
							$('#celular').setMask('phone-us');
							$('#sucursalID').val(promotor.sucursalID); 
							$('#sucursal').val(promotor.sucursal);
							$('#usuarioID').val(promotor.usuarioID);
						
							if (promotor.aplicaPromotor == 'CR'){
								$('#aplicaPromotor1').attr('checked', 'true' );
							
							}else if(promotor.aplicaPromotor == 'CA'){
								$('#aplicaPromotor2').attr('checked', 'true' );
							}
								else if(promotor.aplicaPromotor == 'A'){
									$('#aplicaPromotor3').attr('checked', 'true' );
							}
								else{
								validaPromotorCaptacion();	
							}
							 
							
								esTab = true;
							consultaSucursal('sucursalID');
							consultaUsuario('usuarioID'); 
							deshabilitaBoton('agrega', 'submit');
							habilitaBoton('modifica', 'submit');																			
							
							
						
						}else{
							
							mensajeSis("No Existe el Promotor");
							deshabilitaBoton('modifica', 'submit');
							deshabilitaBoton('agrega', 'submit');
   							$('#promotorID').focus();
   							$('#aplicaPromotor1').focus();
							$('#promotorID').select();	
							deshabilitaBoton('agrega', 'submit');
						
							//inicializaForma($('#formaGenerica'),$('#promotorID'));
																			
							}
				});
								
			}
												
		}
	}
	
	
	function consultaSucursal(idControl) {
		var jqSucursal = eval("'#" + idControl + "'");
		var numSucursal = $(jqSucursal).val();	
		var conSucursal=2;
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numSucursal != '' && !isNaN(numSucursal) && esTab){
			sucursalesServicio.consultaSucursal(conSucursal,numSucursal,function(sucursal) {
						if(sucursal!=null){							
							$('#sucursal').val(sucursal.nombreSucurs);
																	
						}else{
							mensajeSis("No Existe la Sucursal");
							  $('#sucursalID').focus();
							  $('#sucursalID').val('');
							  $('#sucursal').val('');
						}    						
				});
			}else{
				if(isNaN(numSucursal) && esTab){
					mensajeSis("No Existe la Sucursal");
					$('#sucursalID').focus();
					$('#sucursalID').val('');
					$('#sucursal').val('');
				}
			}
		}
		
		
		function consultaUsuario(idControl) {
		var jqUsuario = eval("'#" + idControl + "'");
		var numUsuario = $(jqUsuario).val();	
		var conUsuario=2;
		var usuarioBeanCon = {
  				'usuarioID':numUsuario 
				};	
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numUsuario != '' && !isNaN(numUsuario)){
			usuarioServicio.consulta(conUsuario,usuarioBeanCon,function(usuario) {

						if(usuario!=null){							
							$('#nombrePromotor').val(usuario.nombreCompleto);
							consultaPromotorActivo();								
						}else{
							
							mensajeSis("No Existe el Usuario");
							$('#usuarioID').focus();
							$('#usuarioID').val('');
						}  
				});
			}
		}
	
	
		function consultaEmpresas(idControl) {
		var jqEmpresa = eval("'#" + idControl + "'");
		var numEmpresa = $(jqEmpresa).val();	
		var conEmpresa=2;
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numEmpresa != '' && !isNaN(numEmpresa) && esTab){
			gruposEmpServicio.consultaEmpresa(conEmpresa,numEmpresa,function(empresa) {
						if(empresa!=null){							
							$('#empre').val(empresa.nombreGrupo);
																	
						}else{
							mensajeSis("No Existe la empresa");
						}    						
				});
			}
		}
		
	function consultaPromotorActivo(){
			var tipoCon = 3 ;
			var promotor={
				'usuarioID':$('#usuarioID').val(),
				'promotorID':$('#promotorID').val()
				};				
			
			
			promotoresServicio.consulta(catTipoConsultaPromotor.promotorAct, promotor,function(promotor) {
				
				
				if(promotor.estatus=='PA' || promotor.estatus=='PI'){
					mensajeSis('El Usuario ya Cuenta con un Promotor Activo.');
					deshabilitaBoton('agrega', 'submit');
					deshabilitaBoton('modifica', 'submit');
					$('#usuarioID').focus();
					$('#usuarioID').val('');
					$('#nombrePromotor').val('');
					
				}
				if(promotor.estatus=='M'){
					deshabilitaBoton('agrega', 'submit');
					habilitaBoton('modifica', 'submit');
				}
				if(promotor.estatus=='UA' && $('#promotorID').val()=='0' && $('#usuarioID').val()!=''){
					habilitaBoton('agrega', 'submit');
					deshabilitaBoton('modifica', 'submit');
				}
		
				
				if(promotor.estatus=='UA' && $('#promotorID').val()>'0'){
					deshabilitaBoton('agrega', 'submit');
					habilitaBoton('modifica', 'submit');
				}
				if(promotor.estatus=='UI'){
					mensajeSis('El Usuario se encuentra Inactivo.');
					deshabilitaBoton('agrega', 'submit');
					deshabilitaBoton('modifica', 'submit');
					$('#usuarioID').focus();
					$('#usuarioID').val('');
					$('#nombrePromotor').val('');
				}
//				if(promotor.estatus == 'A'){
//					mensajeSis('El usuario ya cuenta con un promotor activo');	
//					deshabilitaBoton('agrega', 'submit');	
//				}
			});
	}
	
	/*function consultaPromotorActivo(){
			var tipoCon = 3 ;
			var promotor={
				'usuarioID':$('#usuarioID').val()
				};			
			promotoresServicio.consulta(catTipoConsultaPromotor.promotorAct, promotor,function(promotor) {
				if(promotor != null){
					$('#estatusUsu').val(promotor.estatusUsu);
					if(promotor.estatus != 'A' && promotor.estatusUsu == 'A'){
						habilitaBoton('agrega', 'submit');
					}else{
						if($('#estatusUsu').val() == 'B' || $('#estatusUsu').val() == 'C'){
							deshabilitaBoton('modifica','submit');
						}else if($('#estatusUsu').val() == 'A'){
							habilitaBoton('modifica','submit');
						}
						mensajeSis('El Usuario ya se Encuentra Asignado como Promotor');	
						$('#usuarioID').focus();
						deshabilitaBoton('agrega', 'submit');
					}
				}
			});			
	}*/
	
	//funcion que consulta el gestor
	function consultaGestor(idControl) {
		var jqUsuario = eval("'#" + idControl + "'");
		var numUsuario = $(jqUsuario).val();
		var gestor = 12;
		var usuarioBeanCon = {  
				'usuarioID':numUsuario 
		};
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numUsuario != '' && !isNaN(numUsuario)&& numUsuario >0){
			usuarioServicio.consulta(gestor,usuarioBeanCon,function(usuario) {  
				if(usuario!=null){
					$('#gestorID').val(usuario.usuarioID);						
					habilitaBoton('agrega','submit');
					$('#agrega').focus();
				}else{ 
					deshabilitaBoton('agrega','submit');
					mensajeSis("El Usuario seleccionado No es Gestor");
					$('#gestorID').focus();
					$('#gestorID').val('');
					
					
				}    						
			});
		}else{
			$('#gestorID').val("0");
		 }	 
	}
	
});

function ayudaTelefono(){	
		var data;       
			data ='<fieldset class="ui-widget ui-widget-content ui-corner-all">'+ 
					'<div id="ContenedorAyuda">'+ 
					'<legend class="ui-widget ui-widget-header ui-corner-all">El No. de telefono debe contener 10 digitos: </legend>'+
					'<table id="tablaLista">'+
					'<tr>'+
					'<td id="encabezadoAyuda"><b>Ejemplo: </b></td>'+ 
					'<td id="contenidoAyuda">9511771020</td>'+
					'</tr>'+
					'</table>'+
					'</div>'+ 
					'</fieldset>'; 
	
			$('#ContenedorAyuda').html(data); 
			$.blockUI({message: $('#ContenedorAyuda'),
				   css: { 
                top:  ($(window).height() - 400) /2 + 'px', 
                left: ($(window).width() - 400) /2 + 'px', 
                width: '400px' 
            } });  
   	$('.blockOverlay').attr('title','Clic para Desbloquear').click($.unblockUI); 		      
		
}

function exitoTransPromotor(){
	$('#sucursal').val('');
	deshabilitaBoton('modifica', 'submit');
	deshabilitaBoton('agrega', 'submit');
	inicializaForma('formaGenerica','clienteID');
}