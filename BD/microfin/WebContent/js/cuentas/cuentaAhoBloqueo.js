$(document).ready(function() {
		esTab = false;
	 
	//Definicion de Constantes y Enums   
	var catTipoConsultaTipoCtaAho = {
  		'principal':1,
  		'foranea':2
	};	
	
	var catTipoActTipoCtaAho = {
  		'apertura':1,
  		'bloquea':2,
  		'desbloqueo':3,
  		'cancelar':4
	};	
	
	var catTipoTransaccionCtaAho = {
  		'agrega':'1',
  		'modifica':'2',
  		'actualiza':'3'
	};
	
	//------------ Metodos y Manejo de Eventos -----------------------------------------
   deshabilitaBoton('bloquear', 'submit');
   deshabilitaBoton('desbloquear', 'submit');
   $('#cuentaAhoID').focus();
   
	$(':text').focus(function() {	
	 	esTab = false;
	});
	
	$.validator.setDefaults({
      submitHandler: function(event) { 
      	grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','cuentaAhoID');
      }
   });					
	    
	$(':text').bind('keydown',function(e){ 
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#bloquear').click(function() {		
		$('#tipoActualizacion').val(catTipoActTipoCtaAho.bloquea); 
		$('#tipoTransaccion').val(catTipoTransaccionCtaAho.actualiza);
	});
	
	$('#bloquear').attr('tipoActualizacion', '2');
	
	$('#desbloquear').click(function() {		
		$('#tipoActualizacion').val(catTipoActTipoCtaAho.desbloqueo); 
		$('#tipoTransaccion').val(catTipoTransaccionCtaAho.actualiza);
	});
	$('#desbloquear').attr('tipoActualizacion', '3');

	$('#cuentaAhoID').blur(function() {
		if(esTab){
			consultaCtaAho(this.id);
		}  		
	});
	
	$('#cuentaAhoID').bind('keyup',function(e){
		if(this.value.length >= 2){
			var camposLista = new Array();
			var parametrosLista = new Array();
			
			camposLista[0] = "clienteID";
			
			parametrosLista[0] = $('#cuentaAhoID').val();
				
						
			lista('cuentaAhoID', '2', '3', camposLista, parametrosLista, 'cuentasAhoListaVista.htm');
		}				       
	});	
	
	$('#clienteID').blur(function() {
  		consultaCliente(this.id);
	});

	$('#usuarioBloID').bind('keyup',function(e){
		if(this.value.length >= 4){
			lista('usuarioBloID', '4', '1', 'nombre', $('#usuarioBloID').val(), 'listaUsuarios.htm');
		}
	});
	
	$('#usuarioBloID').blur(function() {
  		consultaUsuario(this.id);
	});

	
	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			clienteID: 'required',
			usuarioBloID: 'required',
			fechaBlo: 'required'	,				
			motivoBlo: 'required'
		},
		
		messages: {
			clienteID: 'Especifique numero de cliente',
			usuarioBloID: 'Especifique el Usuario',
			fechaBlo:'Especifique Fecha de registro'		,
			motivoBlo:'Especifique el Motivo de Bloqueo'
		}		
	});
	
	//------------ Validaciones de Controles -------------------------------------

	function consultaCtaAho(idControl) {
		var jqCtaAho  = eval("'#" + idControl + "'");
		var numCtaAho = $(jqCtaAho).val();	
		var CuentaAhoBeanCon = {
			'cuentaAhoID'	:numCtaAho
		};
		var conCtaAho =3;
		var var_estatus;
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numCtaAho != '' && !isNaN(numCtaAho)){
			cuentasAhoServicio.consultaCuentasAho(conCtaAho,CuentaAhoBeanCon,function(ctaAho){
						if(ctaAho!=null){						
							$('#cuentaAhoID').val(ctaAho.cuentaAhoID);	
							$('#clienteID').val(ctaAho.clienteID);
							$('#motivoBlo').val(ctaAho.motivoBlo);
							var_estatus=(ctaAho.estatus);
							consultaCliente('clienteID');
							validaEstatus(var_estatus);				
									
						}else{
							mensajeSis("No Existe la "+ $('#varSafilocale').val());
							$(jqCtaAho).select();
							$(jqCtaAho).focus();
							inicializaPantalla();
						}
				});
		}else{
			if(isNaN(numCtaAho)){
				mensajeSis("No Existe la "+ $('#varSafilocale').val());
				$(jqCtaAho).select();
				$(jqCtaAho).focus();
				inicializaPantalla();
			}
		}	
	}

	
	function consultaCliente(idControl) {
		var jqCliente  = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();	
		var conCliente =2;
		var rfc = ' ';
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numCliente != '' && !isNaN(numCliente)){
			clienteServicio.consulta(conCliente,numCliente,rfc,function(cliente){
						if(cliente!=null){							
							$('#nombreCte').val(cliente.nombreCompleto);												
						}else{
							mensajeSis("No Existe el Cliente");
							$(jqCliente).focus();
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
						$('#usuarioBloID').val(usuario.numero);			
						$('#nombreUsuario').val(usuario.nombre);								
					}else{
						mensajeSis("No Existe el Usuario");
						$(jqUsuario).focus();
					}    						
			});
		}
	}
	
	
	function validaEstatus(var_estatus) {
		var estatusActivo 	="A";
		var estatusBloqueado ="B";
		var estatusCancelada ="C";
		var estatusInactivo 	="I";
		var estatusRegistrada="R";
	
		if(var_estatus == estatusActivo){
			 habilitaBoton('bloquear', 'submit');
			 deshabilitaBoton('desbloquear', 'submit');
			 $('#estatus').val('ACTIVO');
		}
		if(var_estatus == estatusBloqueado){
			 deshabilitaBoton('bloquear', 'submit');
			 habilitaBoton('desbloquear', 'submit');
			 $('#estatus').val('BLOQUEADO');
		}
		if(var_estatus == estatusCancelada){
			 deshabilitaBoton('bloquear', 'submit');
			 deshabilitaBoton('desbloquear', 'submit');
			 $('#estatus').val('CANCELADO');
		}
		if(var_estatus == estatusInactivo){
			habilitaBoton('bloquear', 'submit');
			deshabilitaBoton('desbloquear', 'submit');
			 $('#estatus').val('INACTIVO');
		}
		if(var_estatus == estatusRegistrada){
			habilitaBoton('bloquear', 'submit');
			deshabilitaBoton('desbloquear', 'submit');
			 $('#estatus').val('REGISTRADO');
		}		
	}
	
	var parametroBean = consultaParametrosSession();
	$('#usuarioBloID').val(parametroBean.numeroUsuario);   
	$('#nombreUsuario').val(parametroBean.nombreUsuario);           
   $('#fechaBlo').val(parametroBean.fechaSucursal);  
	
	/*
	//Fecha a mostrar
	$('#fecha').html(obtenDia());

	//Fecha Del sistema
	$('#fechaBlo').val(obtenDia());
	
	function obtenDia(){
		var f = new Date();
		dia = f.getDate();
	    mes = f.getMonth() +1;
	    anio = f.getFullYear();
	    if (dia <10){ dia = "0" + dia;}
	    if (mes <10){ mes = "0" + mes;}  
		
	    return anio + "-" + mes + "-" + dia;	    	    
	}	
	*/	
   
   function inicializaPantalla(){
		$('#clienteID').val("");
		$('#nombreCte').val("");
		$('#estatus').val("");
		$('#motivoBlo').val("");
		deshabilitaBoton('bloquear', 'submit');
		deshabilitaBoton('desbloquear', 'submit');	
		
	   $('#usuarioBloID').val(parametroBean.numeroUsuario);   
	   $('#nombreUsuario').val(parametroBean.nombreUsuario);           
	   $('#fechaBlo').val(parametroBean.fechaSucursal);  
   }
});