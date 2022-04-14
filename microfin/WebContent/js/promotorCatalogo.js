$(document).ready(function() {
		esTab = true;
	 
	//Definicion de Constantes y Enums  
	var catTipoTransaccionPromotor = {
  		'agrega':'1',
  		'modifica':'2'
	};
	
	var catTipoConsultaPromotor = {
  		'principal':1,
  		'foranea':2
	};	
	
	
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	
	
	deshabilitaBoton('modifica', 'submit');
   deshabilitaBoton('agrega', 'submit');


	$(':text').focus(function() {	
	 	esTab = false;
	});
	

	$('#formaGenerica').submit(function(event){
		grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje');
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
		lista('usuarioID', '1', '1', 'nombre', $('#usuarioID').val(), 'listaUsuarios.htm');
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
	
	//------------ Validaciones de la Forma -------------------------------------
	
	$('#formaGenerica').validate({
				
		rules: {
			nombrePromotor: {
				required: true,
				minlength: 5
			},
			
			nombreCoordinador: {
				required: true,
				minlength: 5
			},
			
			sucursalID: 'required',
			
			usuarioID:'required',
			
			correo:'email',
			
			numeroEmpleado:'required'			
		},
		
		messages: {
			
			nombrePromotor: {
				required: 	'Especifique Nombre del Promotor',
				minlength: 	'Al menos cinco Caracteres'
			},
		
			nombreCoordinador: {
				required: 	'Especifique Nombre del Coordinador',
				minlength: 	'Al menos cinco Caracteres'
			},
			
			sucursalID:		'Especifique la Sucursal',
			
			usuarioID:		'Especifique el Usuario',
			
			correo: {
				email: 		'Direccion Invalida'
			},
				
			numeroEmpleado:'Especifique un numero de empleado'
		
		}		
	});
	
	//------------ Validaciones de Controles -------------------------------------
	
	
	function validaPromotor(control) {
		var numPromotor = $('#promotorID').val();
		var tipConForanea = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		
		if(numPromotor != '' && !isNaN(numPromotor) && esTab){
			
			if(numPromotor=='0'){
				estatus.disabled=true;
				habilitaBoton('agrega', 'submit');		
				deshabilitaBoton('modifica', 'submit');
				//inicializaForma($('#formaGenerica'),$('#promotorID'));
				inicializaForma('formaGenerica','promotorID');
				
				
			} else {
				estatus.disabled=false;
				deshabilitaBoton('agrega', 'submit');
				habilitaBoton('modifica', 'submit');			
				promotoresServicio.consultaPromotor(tipConForanea, numPromotor,function(promotor) {
						if(promotor!=null){
							dwr.util.setValues(promotor);	
							deshabilitaBoton('agrega', 'submit');
							habilitaBoton('modifica', 'submit');													
						}else{
							
							alert("No Existe el Promotor");
							deshabilitaBoton('modifica', 'submit');
   						deshabilitaBoton('agrega', 'submit');
   						$('#promotorID').focus();
							$('#promotorID').select();	
							inicializaForma($('#formaGenerica'),$('#promotorID'));
																			
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
							alert("No Existe la Sucursal");
						}    						
				});
			}
		}
		
		
		function consultaUsuario(idControl) {
		var jqUsuario = eval("'#" + idControl + "'");
		var numUsuario = $(jqUsuario).val();	
		var conUsuario=2;
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numUsuario != '' && !isNaN(numUsuario) && esTab){
			usuarioServicio.consulta(conUsuario,numUsuario,function(usuario) {
						if(usuario!=null){							
							$('#usuario').val(usuario.nombre);
																	
						}else{
							alert("No Existe el Usuario");
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
							alert("No Existe la empresa");
						}    						
				});
			}
		}
	
		
});