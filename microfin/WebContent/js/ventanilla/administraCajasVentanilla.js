$(document).ready(function (){
	esTab = true;
	parametros = consultaParametrosSession();
	var catTipoTransCajas= {
		'activaCaja'	: 4,
		'cancelaCaja' 	: 5,
		'inactivaCaja' 	: 6
	};
	
	agregaFormatoControles('formaGenerica');
	deshabilitaBoton('activa', 'submit');
	deshabilitaBoton('inactiva', 'submit');
	deshabilitaBoton('cancela', 'submit');
	$('#cajaID').focus();
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	$(':text').focus(function() {	
	 	esTab = false;
	});
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	$.validator.setDefaults({
	      submitHandler: function(event) {
	    	  var tipoTrans = $('#tipoTransaccion').val();
	    	  
	    	  if (tipoTrans == catTipoTransCajas.cancelaCaja){
	    		  var conEfectivo  = 2;
	    		  var numCaja = $('#cajaID').val();
	    		  var suc	=$('#sucursalID').val();
	    		  
	    		  var CajasBeanCon = {
	    				  'cajaID' : numCaja,
	    				  'sucursalID' :suc
	    		  };
	    		  cajasVentanillaServicio.consulta(conEfectivo, CajasBeanCon ,function(saldoEfectivo){
	    			  if (saldoEfectivo != null){
	    				  if (saldoEfectivo.estatus == 1){
	    					  mensajeSis ("La Caja que desea cancelar aun cuenta con saldo. No se puede Cancelar.");
	    				  }else{
	    					  grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','cajaID');
	    				  }
	    			  }
	    		  });
	    	  }else{
	    		  grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','cajaID');
	    	  }
	      }
	});

	$('#formaGenerica').validate({
		rules: {
			cajaID: {
				required: true
			},
			motivo:{
				required: true
				,maxlength: 50
			}
		},
		
		messages: {
			cajaID: {
				required: 'Especificar Caja '
			},
			motivo:{
				required: 'Especifica el Motivo'
				,maxlength: 'Máximo 50 caracteres.'
			}
		}
	});
	$('#fecha').val(parametros.fechaSucursal);
	
	$('#activa').click(function(){
		$('#tipoTransaccion').val(catTipoTransCajas.activaCaja);
	});
	
	$('#inactiva').click(function(){
		$('#tipoTransaccion').val(catTipoTransCajas.inactivaCaja);
	});
	
	$('#cancela').click(function(){
		$('#tipoTransaccion').val(catTipoTransCajas.cancelaCaja);
	});
	$('#cajaID').blur(function(){
		consultaCaja(this.id);
	});
		
	$('#cajaID').bind('keyup',function(e) {
		if(this.value.length >= 2){
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "cajaID";
			camposLista[1] = "sucursalID";
			parametrosLista[0] = $('#cajaID').val();
			parametrosLista[1] = parametros.sucursal;
			lista('cajaID', '1', '2', camposLista, parametrosLista, 'listaCajaVentanilla.htm');
		}
	});
		
	function consultaCaja( idControl ) {
		var jqCajaID = eval("'#" + idControl + "'");
		var numCajaID = $(jqCajaID).val();
		var conPrincipal = 3;
		var CajasBeanCon = {
  			'cajaID': numCajaID
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCajaID != '' && !isNaN(numCajaID)){
			cajasVentanillaServicio.consulta(conPrincipal, CajasBeanCon ,function(cajasVentanilla){
				if(cajasVentanilla != null){
					$('#tipoCaja').attr('disabled', 'disabled');
					$('#tipoCaja').val(cajasVentanilla.tipoCaja);
					$('#usuarioID').val(cajasVentanilla.usuarioID);
					$('#sucursalID').val(cajasVentanilla.sucursalID);
					$('#limiteEfectivoMN').val(cajasVentanilla.limiteEfectivoMN);
					$('#descripcionCaja').val(cajasVentanilla.descripcionCaja);
					$('#fecha').val(parametros.fechaSucursal);
					if (cajasVentanilla.estatus == 'A'){
						$('#estatus').val('ACTIVA');
						$('#motivoUltimo').val(cajasVentanilla.motivoAct);
						habilitaBoton('inactiva', 'submit');
						habilitaBoton('cancela', 'submit');
						deshabilitaBoton('activa', 'submit');
					}else if(cajasVentanilla.estatus == 'I'){
						$('#estatus').val('INACTIVA');
						$('#motivoUltimo').val(cajasVentanilla.motivoInac);
						habilitaBoton('activa', 'submit');
						habilitaBoton('cancela', 'submit');
						deshabilitaBoton('inactiva', 'submit');
					}else if(cajasVentanilla.estatus == 'C'){
						$('#estatus').val('CANCELADA');
						$('#motivoUltimo').val(cajasVentanilla.motivoCan);
						habilitaBoton('activa', 'submit');
						habilitaBoton('inactiva', 'submit');
						deshabilitaBoton('cancela', 'submit');
					}
					if (cajasVentanilla.usuarioID != 0){
						esTab = true;
					}else{
						esTab = false;
					}
					consultaUsuario(cajasVentanilla.usuarioID);
					consultaSucursal(cajasVentanilla.sucursalID);
				}
				else{
					mensajeSis("No Existe la Caja");
					inicializaForma('formaGenerica', 'cajaID');
					$('#cajaID').focus();
					$('#fecha').val(parametros.fechaSucursal);
				}
			});
		}
	}
	
	function consultaUsuario(usuarioID){
		var conForanea = 2;
		var usuarioBean = {
			'usuarioID' : usuarioID
		};
		if(usuarioID != '' && !isNaN(usuarioID) && esTab){
			usuarioServicio.consulta(conForanea, usuarioBean, function(usuario){
				if (usuario != null){
					$('#nombreUsuario').val(usuario.nombreCompleto);
				}else{
					mensajeSis('No Existe el Usuario');
				}
			});
		}
	}

	function consultaSucursal(sucursalID){
		var conForanea = 2;
		if(sucursalID != '' && !isNaN(sucursalID)){
			sucursalesServicio.consultaSucursal(conForanea, sucursalID, function(sucursal){
				if (sucursal != null){
					$('#desSucursal').val(sucursal.nombreSucurs);
					habilitaBoton('modificar', 'submit');
				}else{
					mensajeSis('No Existe la Sucursal');
				}
			});
		}
	}
});