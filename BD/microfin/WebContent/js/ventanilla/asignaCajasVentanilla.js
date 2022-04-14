$(document).ready(function (){
	esTab = true;
	parametros = consultaParametrosSession();
	var catTipoTransCajas= {
		'asignaCaja'	: 7
	};
	
	agregaFormatoControles('formaGenerica');
	deshabilitaBoton('asigna', 'submit');
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
	    	  var usuarioID = $('#usuarioID').val();
	    	  var numCajaID = $('#cajaID').val();
	    	  var sucursalID = $('#sucursalID').val();
	    	  var quest;
	    	  var numConsulta = 4;
	    	  var CajasBeanCon = {
  					'cajaID'	 : numCajaID,
  					'sucursalID' : sucursalID,
  					'usuarioID'	 : usuarioID	
	    	  };
	    	  if (usuarioID != 0 && usuarioID != ''){
					cajasVentanillaServicio.consulta(numConsulta, CajasBeanCon ,function(usuario){
						if (usuario != null){
							quest = confirm('El usuario ya esta asignado a la caja: '+ usuario.cajaID + ' de la Sucursal: '+usuario.sucursalID+'. Al reasignarlo quedara vacia la caja: '+ usuario.cajaID +' ¿Desea reasignarlo?');
							if (quest){
								grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','folioTransaccion','funcionExito','funcionError');
							}
						}else{
							grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','folioTransaccion','funcionExito','funcionError');
						}
					});
				}
	      }
	});

	$('#formaGenerica').validate({
		rules: {
			cajaID: {
				required: true
			},
			usuarioID:{
				required: true
			},
			descripcionCaja:{
				maxlength: 50
			}
		},
		
		messages: {
			cajaID: {
				required: 'Especifique la Caja '
			},
			usuarioID:{
				required: 'Especifique el Usuario'
			},
			descripcionCaja:{
				maxlength: 'Máximo 50 caracteres.'
			}
		}
	});

	$('#asigna').click(function(){
		$('#tipoTransaccion').val(catTipoTransCajas.asignaCaja);
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
		
	$('#usuarioID').blur(function (){
		if(this.value != 0){
			esTab=true;	
		}
		consultaUsuario(this.value);
	});
	$('#usuarioID').bind('keyup',function(e) {
		if(this.value.length >= 2){
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "nombreCompleto";
			parametrosLista[0] = $('#usuarioID').val();
			lista('usuarioID', '1', '1', camposLista, parametrosLista, 'listaUsuarios.htm');
		}
	});
	
	function consultaCaja( idControl ) {
		var jqCajaID = eval("'#" + idControl + "'");
		var numCajaID = $(jqCajaID).val();
		var conPrincipal = 3;
		var CajasBeanCon = {
  			'cajaID'	 : numCajaID,
  			'sucursalID' : parametros.sucursal
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
					$('#auxUsuario').val(cajasVentanilla.usuarioID);
					$('#nombreUsuario').val('');
					if (cajasVentanilla.estatus == 'A'){
						$('#estatus').val('ACTIVA');
					}else if (cajasVentanilla.estatus == 'I'){
						$('#estatus').val('INACTIVA');
					}
					else if(cajasVentanilla.estatus == 'C'){
						$('#estatus').val('CANCELADA');
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
					deshabilitaBoton('asigna','submit');
				}
			});
		}
	}
	
	function consultaUsuario(usuarioID){
		var conForanea = 2;
		var usuarioAux = $('#auxUsuario').val();
		var usuarioBean = {
			'usuarioID' : usuarioID
		};
		if(usuarioID != '' && !isNaN(usuarioID) && esTab){
			usuarioServicio.consulta(conForanea, usuarioBean, function(usuario){
				if (usuario != null){					
					$('#nombreUsuario').val(usuario.nombreCompleto);
					if (usuarioID != usuarioAux){
						habilitaBoton('asigna','submit');
						$('#asigna').focus();
					}else{
						deshabilitaBoton('asigna','submit');
					}
				}else{
					mensajeSis('No Existe el Usuario');
					$('#usuarioID').focus();
					$('#nombreUsuario').val('');
					if (usuarioID != usuarioAux && usuarioID>0){
						habilitaBoton('asigna','submit');
					}else{
						deshabilitaBoton('asigna','submit');
					}
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
					$('#asigna').focus();
					
				}else{
					mensajeSis('No Existe la Sucursal');
				}
			});
		}
	}
});


function funcionExito(){
	deshabilitaBoton('asigna','submit');
}

function funcionError(){
	deshabilitaBoton('asigna','submit');
}