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
   deshabilitaBoton('cancelar', 'submit');
   datosSesion();
   $("#cuentaAhoID").focus();
   
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
	
	$('#cancelar').click(function() {		
		$('#tipoActualizacion').val(catTipoActTipoCtaAho.cancelar); 
		$('#tipoTransaccion').val(catTipoTransaccionCtaAho.actualiza);
	});
	
	$('#cancelar').attr('tipoActualizacion', '4');

	$('#cuentaAhoID').blur(function() {
  		consultaCtaAho(this.id);
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

	$('#usuarioCanID').bind('keyup',function(e){
		if(this.value.length >= 4){
			lista('usuarioCanID', '4', '1', 'nombre', $('#usuarioCanID').val(), 'listaUsuarios.htm');
		}
	});
	
	

	
	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			clienteID: 'required',
			usuarioCanID: 'required',
			fechaCan: 'required'	,				
			motivoCan: 'required'
		},
		
		messages: {
			clienteID: 'Especifique número de cliente',
			usuarioCanID: 'Especifique el Usuario',
			fechaCan:'Especifique Fecha de cancelación'		,
			motivoCan:'Especifique el Motivo de Cancelación'
		}		
	});
	
	//------------ Validaciones de Controles -------------------------------------

	function consultaCtaAho(idControl) {
		var jqCtaAho  = eval("'#" + idControl + "'");
		var numCtaAho = $(jqCtaAho).val();	
		var CuentaAhoBeanCon = {
			'cuentaAhoID'	:numCtaAho
		};
		var conCtaAho =1;
	
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numCtaAho != '' && !isNaN(numCtaAho) && esTab){
			cuentasAhoServicio.consultaCuentasAho(conCtaAho,CuentaAhoBeanCon,function(ctaAho){
						if(ctaAho!=null){							
							$('#clienteID').val(ctaAho.clienteID);
							$('#usuarioCanID').val(ctaAho.usuarioCanID);
							$('#fechaCan').val(ctaAho.fechaCan);							
							$('#motivoCan').val(ctaAho.motivoCan);	
							consultaCliente('clienteID');
							validaEstatus(ctaAho.estatus);
							consultaUsuario('usuarioCanID');						
						}else{		
							mensajeSis("No Existe la "+ $('#varSafilocale').val());
							$(jqCtaAho).focus();	
							$(jqCtaAho).val("");	
							$('#clienteID').val("");					
							$('#nombreCte').val("");					
							$('#motivoCan').val("");					
							$('#estatus').val("");	
							deshabilitaBoton('activa', 'submit');	
							datosSesion();
						}    						
				});
		}else{
			if(isNaN(numCtaAho) && esTab){
				mensajeSis("No Existe la "+ $('#varSafilocale').val());
				$(jqCtaAho).focus();	
				$(jqCtaAho).val("");	
				$('#clienteID').val("");					
				$('#nombreCte').val("");					
				$('#motivoCan').val("");				
				$('#estatus').val("");		
				deshabilitaBoton('activa', 'submit');	
				datosSesion();
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
	
	var usuarioBean = {
				'usuarioID':numUsuario
	};
	if(numUsuario != '' && !isNaN(numUsuario) && esTab){
		usuarioServicio.consulta(conUsuario,usuarioBean,function(usuario) {
					if(usuario!=null){							
						$('#nombreUsuario').val(usuario.nombreCompleto);
						
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
			 habilitaBoton('cancelar', 'submit');
			 $('#estatus').val('ACTIVO');
			 habilitaControl('motivoCan');
			 datosSesion();
			 
		}
		if(var_estatus == estatusBloqueado){
			  habilitaBoton('cancelar', 'submit');
			 $('#estatus').val('BLOQUEADO');
			 datosSesion();
		}
		if(var_estatus == estatusCancelada){
			 deshabilitaBoton('cancelar', 'submit');
			 $('#estatus').val('CANCELADO');
			soloLecturaControl('motivoCan');
		}
		if(var_estatus == estatusInactivo){
			habilitaBoton('cancelar', 'submit');
			 $('#estatus').val('INACTIVO');
			 datosSesion();
		}
		if(var_estatus == estatusRegistrada){
			habilitaBoton('cancelar', 'submit');
			 $('#estatus').val('REGISTRADO');
			 datosSesion();
		}		
	}
	
	 function datosSesion(){
		 var parametroBean = consultaParametrosSession();
			$('#usuarioCanID').val(parametroBean.numeroUsuario);   
			$('#nombreUsuario').val(parametroBean.nombreUsuario);           
			$('#fechaCan').val(parametroBean.fechaSucursal);
	 }
	
	
});
