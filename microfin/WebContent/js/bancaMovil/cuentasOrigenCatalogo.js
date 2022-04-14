var esTab = false;
$(document).ready(function() {
$("#clienteID").focus();
$('#gridCuenta').hide();
var parametroBean = consultaParametrosSession();	

	//Definicion de Constantes y Enums
	var catTipoTransaccionCuentas = {
			'agrega' : 1,
			'modifica' : 2
	};

//------------ Metodos y Manejo de Eventos
// ----------------------------------------
	deshabilitaBoton('guarda', 'submit');
	deshabilitaBoton('agregarCuen', 'submit');
	agregaFormatoControles('formaGenerica');
	
	$('input, select').focus(function() {
		esTab = false;
	});

	$('input ,select').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});

	$('input ,select').blur(function() {
		
		$(this).valid();
		
		if ($(this).attr('id') == $('#formaGenerica :input:enabled:visible:last').attr('id') && esTab) {
			setTimeout(function() {
				$('#formaGenerica :input:enabled:visible:first').focus();
			}, 0);
		}
	});
	
	$(':text').focus(function() {
		esTab = false;
	});
	
	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});
	
	$('#clienteID').blur(function() {
		if(esTab){
			if( $('#clienteID').val() =='' ){
				$('#clienteID').val(-999);
				deshabilitaBoton('agregarCuen', 'submit');
				limpiaForma();
				$('#clienteID').val('');
				$('#clienteID').focus();
				$('#clienteID').select();
				mensajeSis("El Cliente esta vacío");
				$('#gridCuentas').hide();

			}else if(!isNaN($('#clienteID').val())){
				validaUsuario(this,0);
				$('#gridCuenta').show();
			}else{
				$('#clienteID').val(-999);
				consultaUsuarios();
				deshabilitaBoton('agregarCuen', 'submit');
				$('#clienteID').val('');
				$('#clienteID').focus();
				$('#clienteID').select();	
				limpiaForma();
				mensajeSis("Error en Cliente");
				$('#gridCuenta').hide();
				$('#cajaLista').hide();
			}
		}
	});
	
	//Para la caja lista
	$('#clienteID').bind('keyup',function(e){
		//TODO Agregar Libreria de Constantes Tipo Enum		
		if ($('#clienteID').val().length < 3) {
			$('#cajaLista').hide();
		} else {
			lista('clienteID', '3', '1', 'clienteID',$('#clienteID').val(),'listaBAMUsuarios.htm');
		}
	});
	
	//mouseover
	$('#agregarCuen').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionCuentas.agrega);
		creaCuentasOrigen();
		
	});
});
	
	
	$.validator.setDefaults({
		submitHandler : function(event) {
			
			var idsCompare = [];
			var duplicados = false;
			$('#miTabla tr').each(function(index) {
				if(index > 0){
					var value = $('#' + $(this).find("input[name^='cuentasOrigen']").attr('id')).val();
					var found = idsCompare.indexOf(value);
					
					if(found != -1){
						duplicados = true;
					}
					idsCompare.push(value);
				}
			});
			
			if(duplicados){
				mensajeSis("Existen valores duplicados.");
			}else{
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica','contenedorForma', 'mensaje', 'true','clienteID', 'exito','fracaso');
				parametroBean = consultaParametrosSession();
			}
			
		}
	});
	
	$('#formaGenerica').validate({
		rules: {
			clienteID: { 
				minlength: 1
			}
		},
		messages: { 			
			clienteID: {
				minlength: 'Al menos un Caracter'
			}
		}		
	});

	function exito(){
	limpiaForma();
	$('#gridCuenta').hide();
	$('#clienteID').focus();
	deshabilitaBoton('agregarCuen', 'submit');	
	}
	
	function fracaso(){
		$('#clienteID').focus();
		console.log(":(");
	}
	function consultaUsuarios(){	
		var params = {};
		params['tipoLista'] = 1;
		params['clienteID'] = $('#clienteID').val();
		
		$.post("gridBAMCuentasOrigen.htm", params, function(data){				
				if(data.length >0) {	
					$('#gridCuentas').html(data);
					$('#gridCuentas').show();
				}else{					
					$('#gridCuentas').html("");
					$('#gridCuentas').show();
				}
		});
	}
	
	function validaUsuario(control,valorProspecto) {
		var idUsuario = $('#clienteID').val();
		consultaUsuarios();
		usuariosServicio.consultaUsuarios(1,idUsuario,function(usuarios){
			if (usuarios != null){
				habilitaBoton('agregaPlazo', 'button');
				habilitaBoton('agregarCuen', 'submit');
				limpiaForma();
				if(usuarios.estatus=='A'){
					$('#estatus').val('ACTIVO');
				}else if(usuarios.estatus=='I'){
					$('#estatus').val('INACTIVO');
				}
				$('#clienteID').val(usuarios.clienteID);
				$('#email').val(usuarios.email);
				$('#perfilID').val(usuarios.perfilID);
				$('#telefono').val(usuarios.telefono);
				$('#fechaCreacion').val(usuarios.fechaCreacion);
				
				var numCliente = usuarios.clienteID;
				clienteServicio.consulta(1,numCliente,function(cliente){
					$('#nombreCliente').val(cliente.nombreCompleto);		
				});
				var idPerfil = usuarios.perfilID;
				perfilServicio.consulta(1,idPerfil,function(perfil) {
					$('#nombrePerfil').val(perfil.nombrePerfil);
				});
				
			}else{
				limpiaForma();
				deshabilitaBoton('agregarCuen', 'submit');
				deshabilitaBoton('agregaPlazo', 'button')
				$('#clienteID').val('');;
				$('#clienteID').focus();
				$('#clienteID').select();	
				mensajeSis("No Existe el Cliente");
				$('#gridCuenta').hide();
			}
		});
	}
	
	function limpiaForma(){
		$('#email').val('');
		$('#telefono').val('');
		$('#nombreCliente').val('');
		$('#estatus').val('');
		$('#perfilID').val('');
		$('#nombrePerfil').val('');
		$('#fechaCreacion').val('');
	}
	
	/*Metodos para el grid*/
	function creaCuentasOrigen(){
		var contador = 1;	
		$('#cuentaAhoID').val("");
		
		$('input[name=cuentasOrigen]').each(function() {
			var montoSuperiorUno=$('#cuenta'+contador).asNumber();
			if (contador != 1){
				$('#cuentaAhoID').val($('#cuentaAhoID').val() + ','  + montoSuperiorUno);
			}else{
				$('#cuentaAhoID').val(montoSuperiorUno);
			}
			contador = contador + 1;
			montoSuperiorUno='';
		});	
	}
