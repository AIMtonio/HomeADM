$(document).ready(function() {
	/******* DEFINICION DE CONSTANTES Y NUMEROS DE CONSULTAS *******/		
	esTab = true;

	// Definicion de Constantes y Enums
	var catTipoTransaccionOrganigrama = {
		'grabar' : '1'
		
	};
	
	var catTipoConsultaEmpleados = {
		'principal' : 1,
		'foranea'	: 2,
	};
						
	/******* FUNCIONES CARGA AL INICIAR PANTALLA *******/
	inicializaPantalla();
	$("#puestoPadreID").focus();
			
	/******* VALIDACIONES DE LA FORMA *******/		
	$.validator.setDefaults({
        submitHandler: function(event) { 
        	var mandar = verificarvacios();   
    		if(mandar != 1){  
    			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','puestoPadreID','funcionExito', 'funcionError'); 
    		}
    	}	
	});	
	
	$('#formaGenerica').validate({		
		rules: {
			puestoPadreID: {
				required: true
			},
		},		
		messages: {
			puestoPadreID: {
				required: 'Especificar Empleado.'
			},
		}		
	});
	
	/******* MANEJO DE EVENTOS *******/
	$(':text').focus(function() {
		esTab = false;
	});

	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});				
				
	$('#grabar').click(function(event) {		
		$('#tipoTransaccion').val(catTipoTransaccionOrganigrama.grabar);
		crearOrganigrama();		
	});	
		
	$('#puestoPadreID').bind('keyup',function(e){
		 var camposLista = new Array(); var
		 parametrosLista = new Array(); camposLista[0] = "nombreCompleto";
		 parametrosLista[0] = $('#puestoPadreID').val();
		 listaAlfanumerica('puestoPadreID', '2', '1', camposLista, parametrosLista, 'listaEmpleados.htm'); 
	});
			
	$('#puestoPadreID').blur(function() {
		if(esTab){
			consultaEmpleado(this.id);
		}
	});
	
	$('#ctaContaSI').click(function(){
		validaRequiereCtaCon('S');
	});
	
	$('#ctaContaNO').click(function(){
		validaRequiereCtaCon('N');
	});
				 				
	/*******  FUNCIONES PARA VALIDACIONES DE CONTROLES *******/
	// FUNCION CONSULTAR EMPLEADO
	function consultaEmpleado(idControl) {
		var jqEmpleado = eval("'#" + idControl + "'");
		var numEmpleado = $(jqEmpleado).val();
		var numCon = 6;
		setTimeout("$('#cajaLista').hide();", 200);
		var EmpleadoBeanCon = {
			'empleadoID' : numEmpleado
		};
		inicializaPantalla();
		if (numEmpleado != '' && !isNaN(numEmpleado) && numEmpleado > 0) {
			empleadosServicio.consulta(numCon,EmpleadoBeanCon, function(empleados) {
				if(empleados != null) {
					if(empleados.estatus == 'A'){
						$('#nombre').val(empleados.nombreCompleto);
						$('#puesto').val(empleados.puesto);
						$('#categoriaID').val(empleados.categoriaID);
						$('#ctaContable').val(empleados.ctaContable);
						if(empleados.ctaContable != ''){
							consultaCtaContable('ctaContable');
						}
						$('#centroCostoID').val(empleados.centroCostoID);
						$('#jefeInmediato').val(empleados.jefeInmediato);
						consultaDetalle();
						habilitaBoton('grabar','submit');						
					}else{
						mensajeSis("El Empleado no esta Activo.");
						$(jqEmpleado).focus();
						$(jqEmpleado).val("");						
					}					
				}else{	
					mensajeSis("No Existe el Empleado");
					$(jqEmpleado).focus();
					$(jqEmpleado).val("");
				}
			});
		}else if(numEmpleado != '' && isNaN(numEmpleado)){
			mensajeSis("No Existe el Empleado");
			$(jqEmpleado).focus();		
			$(jqEmpleado).val("");	
		}
	}
	
	// FUNCION CONSULTAR PUESTO
	function consultaPuesto(idControl) {
		var jqEmpleado = eval("'#" + idControl + "'");
		var numEmpleado = $(jqEmpleado).val();
		var conEmpleado = 2;
		var EmpleadoBeanCon = {
			'empleadoID' : numEmpleado
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if (numEmpleado != '' && !isNaN(numEmpleado)) {
			empleadosServicio.consulta(conEmpleado,EmpleadoBeanCon, function(empleado) {
				if (empleado != null) {
					$('#puesto').val(empleado.descripcion);
				} 
			});
		}
	}

	// FUNCION CONSULTAR PUESTO
	function consultaDependenciaEmp(idControl) {
		var jqEmpleado = eval("'#" + idControl + "'");
		var numEmpleado = $(jqEmpleado).val();
		var conEmpleado = 5;
		var EmpleadoBeanCon = {
			'empleadoID' : numEmpleado
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if (numEmpleado != '' && !isNaN(numEmpleado)) {
			empleadosServicio.consulta(conEmpleado,EmpleadoBeanCon, function(empleado) {
				if (empleado != null) {
					$('#puesto').val(empleado.descripcion);
				} 
			});
		}
	}
	
	//CONSULTA DETALLE ORGANIGRAMA
	function consultaDetalle(){	
		var params = {};
		params['tipoLista'] = 1;
		params['puestoPadreID'] = $('#puestoPadreID').val();
		params['requiereCtaConta'] = $('input:radio[name=requiereCtaConta]:checked').val();
		
		$.post("listaOrganigrama.htm", params, function(data){
			if(data.length >0) {		
				$('#gridOrganigrama').html(data);
				$('#gridOrganigrama').show();
				var requiereCta = 'N';
				$('input[name=lisRequiereCtaConta]').each(function() {
					var jq = eval("'#" + this.id + "'");
					requiereCta = $(jq).val();										
				});				
				validaRequiereCtaCon(requiereCta);
			}else{				
				$('#gridOrganigrama').html("");
				$('#gridOrganigrama').show();
			}
		});
	}
		
	function crearOrganigrama(){			
		$('#dependencias').val("");
				
		$('input[name=consecutivoID]').each(function() {
			var jqConsecutivo = eval("'#" + this.id + "'");			
			var consecutivo = $(jqConsecutivo).asNumber();
			
			var jqPuestoHijoID = eval("'#puestoHijoID" + consecutivo + "'");	
			var jqCentroCostoID = eval("'#centroCostoID" + consecutivo + "'");	
			var jqCtaContable = eval("'#ctaContable" + consecutivo + "'");	
			
			var puestoHijoID = $(jqPuestoHijoID).val();
			var centroCostoID = $(jqCentroCostoID).val();
			var ctaContable = $(jqCtaContable).val();
			
			$('#dependencias').val(
					$('#dependencias').val() + 
						puestoHijoID + ","+
						centroCostoID + ","+
						ctaContable +
					']');			
		});	
	}
				
					
	// FUNCION VALIDA PUESTO
	function validaPuestoPadre(control) {
		var numPuestoPadre = $('#puestoPadreID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numPuestoPadre != '' && !isNaN(numPuestoPadre) && esTab){	
			if(numPuestoPadre=='0'){				
				inicializaForma('formaGenerica','puestoPadreID' );
				$('#gridOrganigrama').hide();	         
			} else {
				$('#gridOrganigrama').show();								
			}
												
		}
	}
	
	// FUNCION CUENTA CONTABLE
	function consultaCtaContable(idControl) {
		var jqCtaContable = eval("'#" + idControl + "'");
		var jqDescripcion = eval("'#descripcionCtaCon'");
		var numCtaContable = $(jqCtaContable).val();
		setTimeout("$('#cajaLista').hide();", 200);
		var conPrincipal = 1;
		var CtaContableBeanCon = {
				'cuentaCompleta':numCtaContable
		};
		
		if(numCtaContable != '' && !isNaN(numCtaContable)){
			cuentasContablesServicio.consulta(conPrincipal,CtaContableBeanCon,function(ctaConta){
				if(ctaConta!=null){ 
					$(jqDescripcion).val(ctaConta.descriCorta); 		
				}else{
					mensajeSis("La Cuenta Contable no Existe.");
					$(jqCtaContable).val(""); 
					$(jqDescripcion).val("");
					$(jqCtaContable).focus(); 
				}
			}); 																					
		}
	}
				
}); // FIN $(DOCUMENT).READY()


function verificarvacios(){	
	var exito = 0;
	var primerVacio = '';
	$('input[name=consecutivoID]').each(function() {
		var jqConsecutivo = eval("'#" + this.id + "'");			
		var consecutivo = $(jqConsecutivo).asNumber();
		
		var jqPuestoHijoID = eval("'#puestoHijoID" + consecutivo + "'");	
		var jqCentroCostoID = eval("'#centroCostoID" + consecutivo + "'");	
		var jqCtaContable = eval("'#ctaContable" + consecutivo + "'");	
		
		var puestoHijoID = $(jqPuestoHijoID).val();
		var centroCostoID = $(jqCentroCostoID).val();
		var ctaContable = $(jqCtaContable).val();

		if (puestoHijoID == ""){			
			$(jqPuestoHijoID).addClass("error");	
			if(exito == 0){
				primerVacio = jqPuestoHijoID;
			}
			exito = 1;
		}	
		if (centroCostoID == ""){			
			$(jqCentroCostoID).addClass("error");	
			if(exito == 0){
				primerVacio = jqCentroCostoID;
			}
			exito = 1;
		}	
		if (ctaContable == "" && $('#ctaContaSI').is(':checked') == true){			
			$(jqCtaContable).addClass("error");	
			if(exito == 0){
				primerVacio = jqCtaContable;
			}
			exito = 1;
		}			
	});	
	
	if(exito != 0){
		mensajeSis("Faltan Datos.");
		$(primerVacio).val('');	
		$(primerVacio).focus();
	}
	
	return exito;
}

function listaEmpleados(idControl){
	var jq = eval("'#" + idControl + "'");	
	var camposLista = new Array(); var
	
	parametrosLista = new Array(); camposLista[0] = "nombreCompleto";
	parametrosLista[0] = $(jq).val();
	listaAlfanumerica(idControl, '2', '1', camposLista, parametrosLista, 'listaEmpleados.htm');
}

function listaCentroCostoGrid(idControl){
	var jq = eval("'#" + idControl + "'");	
	
	lista(idControl, '2', '1', 'descripcion', $(jq).val(), 'listaCentroCostos.htm');
}

function listaCtaContableGrid(idControl){
	var jq = eval("'#" + idControl + "'");	
	
	var camposLista = new Array();
	var parametrosLista = new Array();			
	camposLista[0] = "descripcion"; 
	parametrosLista[0] = $(jq).val();
	listaAlfanumerica(idControl, '2', '6', camposLista, parametrosLista, 'listaCuentasContables.htm');
}

// ////////////////funcion consultar empleado//////////////////
function consultaEmpleadoGrid(idControl,idNombreEmp,idPuesto){ 		
	var jqEmpleado = eval("'#" + idControl + "'");
	var nombreEmpleado = eval("'#"+idNombreEmp+"'");
	var puestoEmp = eval("'#"+idPuesto+"'");
	
	var numEmpleado = $(jqEmpleado).val();
	var conPrincipal = 6;
	var empleadoBeanCon = {
	  'empleadoID':numEmpleado
	};

	setTimeout("$('#cajaLista').hide();", 200);
	if(numEmpleado != '' && !isNaN(numEmpleado)){
		empleadosServicio.consulta(conPrincipal,empleadoBeanCon,function(empleado){
			if(empleado!=null){
				if(empleado.estatus == 'A'){
					if(numEmpleado != $('#puestoPadreID').val()){// valida que el empleado no se pueda asignar a el mismo
						if(empleado.jefeInmediato != ''){// valida si el empleado ya tiene jefe inmediato						
							if(empleado.categoriaID > $('#categoriaID').val() && $('#categoriaID').val() > 0){//validacion de la categoria del empleado
								//valida que no este ya agregado en el grid
								var existeReg = 'N';
								$('input[name=lisPuestoHijoID]').each(function() {
									if(idControl != this.id){
										var jq = eval("'#" + this.id + "'");				
										if($(jq).val() == numEmpleado){
											existeReg = 'S';
										}									
									}	
								});
								if(existeReg == 'N'){
									$(nombreEmpleado).val(empleado.nombreCompleto);
									$(puestoEmp).val(empleado.puesto);
									habilitaBoton('grabar',' submit' );								
								}else{
									mensajeSis("El empleado ya esta agregado.");
									$(jqEmpleado).val("");
									$(nombreEmpleado).val("");
									$(puestoEmp).val("");
									$(jqEmpleado).focus();									
								}						
							}else{
								mensajeSis("El empleado debe tener una categoria menor para ser agregado.");
								$(jqEmpleado).val("");
								$(nombreEmpleado).val("");
								$(puestoEmp).val("");
								$(jqEmpleado).focus();	
							}					
						}else{
							mensajeSis("El empleado es dependencia de: "+empleado.jefeInmediato);
							$(jqEmpleado).val("");
							$(nombreEmpleado).val("");
							$(puestoEmp).val("");
							$(jqEmpleado).focus();							
						}					
					}else{
						mensajeSis("El empleado no puede ser dependencia de el mismo.");
						$(jqEmpleado).val("");
						$(nombreEmpleado).val("");
						$(puestoEmp).val("");
						$(jqEmpleado).focus();					
					}					
				}else{
					mensajeSis("El empleado no esta Activo.");
					$(jqEmpleado).val("");
					$(nombreEmpleado).val("");
					$(puestoEmp).val("");
					$(jqEmpleado).focus();						
				}			
			}else{
				deshabilitaBoton('grabar','submit');
				mensajeSis("No existe el empleado.");
				$(jqEmpleado).val("");
				$(nombreEmpleado).val("");
				$(puestoEmp).val("");
				$(jqEmpleado).focus();
			}
		});
	}
}

function consultaPuestoGrid(idControl, fila) {
	var jqEmpleado = eval("'#" + idControl + "'");
	var numEmpleado = $(jqEmpleado).val();
	var descripcionPuesto = eval("'#"+fila+"'");
	var conEmpleado = 2;
	var EmpleadoBeanCon = {
		'empleadoID' : numEmpleado
	};
	setTimeout("$('#cajaLista').hide();", 200);
	if(numEmpleado != '' && !isNaN(numEmpleado) && esTab){
		empleadosServicio.consulta(conEmpleado,	EmpleadoBeanCon, function(empleado) {
			if (empleado != null) {
				$(descripcionPuesto).val(empleado.descripcion);
	
			} 
			else{
				$(descripcionPuesto).val("");
			}
		});
	}
}

//FUNCION CONSULTA CENTRO DE COSTOS
function consultaCentroCostosGrid(idControl) {
	var jqNumCentroCosto = eval("'#" + idControl + "'");
	var numero= idControl.substr(13,idControl.length);
	var jqDescripcion = eval("'#descripcionCenCos" + numero + "'");
	var numCentroCosto = $(jqNumCentroCosto).val();
	setTimeout("$('#cajaLista').hide();", 200);
	var numCon=1;
	var BeanCon = {
		'centroCostoID':numCentroCosto 
	};
	
	if(numCentroCosto != '' && !isNaN(numCentroCosto)){	
		centroServicio.consulta(numCon,BeanCon,function(centro) { 
			if(centro!=null){
				$(jqDescripcion).val(centro.descripcion);
			}else{
				mensajeSis('No Existe el Centro de Costos');
				$(jqNumCentroCosto).val('');	
				$(jqDescripcion).val('');				
				$(jqNumCentroCosto).focus();				
			} 
		});
	}
}

// FUNCION CUENTA CONTABLE
function consultaCtaContableGrid(idControl) {
	var jqCtaContable = eval("'#" + idControl + "'");
	var numero= idControl.substr(11,idControl.length);
	var jqDescripcion = eval("'#descripcionCtaCon" + numero + "'");
	var numCtaContable = $(jqCtaContable).val();
	setTimeout("$('#cajaLista').hide();", 200);
	var conPrincipal = 1;
	var CtaContableBeanCon = {
			'cuentaCompleta':numCtaContable
	};
	
	if(numCtaContable != '' && !isNaN(numCtaContable)){
		cuentasContablesServicio.consulta(conPrincipal,CtaContableBeanCon,function(ctaConta){
			if(ctaConta!=null){ 
				$(jqDescripcion).val(ctaConta.descripcion); 		
			}else{
				mensajeSis("La Cuenta Contable no Existe.");
				$(jqCtaContable).val(""); 
				$(jqDescripcion).val("");
				$(jqCtaContable).focus(); 
			}
		}); 																					
	}
}

//FUNCION PARA VERIFICAR I REQUIERE CUENTA CONTABLE O NO
function validaRequiereCtaCon(requiere){
	if(requiere == 'S'){
		$('#ctaContaSI').attr("checked",true);
		$('#lblCuentaConta').show();		
		$('input[name=lisCtaContable]').each(function() {
			var jq = eval("'#" + this.id + "'");				
			$(jq).show();			
		});

		$('input[name=lisDescripcionCtaCon]').each(function() {
			var jq = eval("'#" + this.id + "'");	
			$(jq).show();			
		});
	
	}else{
		$('#ctaContaNO').attr("checked",true);
		$('#lblCuentaConta').hide();	
		$('input[name=lisCtaContable]').each(function() {
			var jq = eval("'#" + this.id + "'");	
			$(jq).val('');			
			$(jq).hide();			
		});

		$('input[name=lisDescripcionCtaCon]').each(function() {
			var jq = eval("'#" + this.id + "'");	
			$(jq).val('');
			$(jq).hide();			
		});		
	}
}

//FUNCION INICIALIZA PANTALLA
function inicializaPantalla(){
	inicializaForma('formaGenerica','puestoPadreID');
	agregaFormatoControles('formaGenerica');

	deshabilitaBoton('grabar', 'submit');
	$('#gridOrganigrama').hide();
	$('#gridOrganigrama').html("");
	$('#ctaContaNO').attr("checked",true);
}

//FUNCIÓN DE ÉXITO DE LA TRANSACCIÓN
function funcionExito() {
	inicializaPantalla();
}

//FUNCIÓN DE ERROR DE LA TRANSACCIÓN
function funcionError() {
}