$(document).ready(function() {
	// Definicion de Constantes y Enums
	esTab = false;
	var catTipoTransaccionSeguro = {
			'alta' : '1',
			'cancela' : '2'
		};

	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');
	deshabilitaBoton('cancelar', 'submit');
	$('#tipoTransaccion').val(catTipoTransaccionSeguro.cancela);
	$('#observacion').attr('maxlength','200');
	
	consultaMotivosActivacion(2);
	$('#seguroClienteID').focus();
	
	$(':text').focus(function() {	
		esTab = false;
	});
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$('#seguroClienteID').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "nombreCliente";
		parametrosLista[0] = $('#seguroClienteID').val();		
		listaAlfanumerica('seguroClienteID', '3', '3', camposLista, parametrosLista, 'listaClientesSeguro.htm');
	});	

	$('#seguroClienteID').blur(function(e){
		if(esTab){
			consultaSeguroVida(this.id);
		}		
	});	
	
	$.validator.setDefaults({
		submitHandler : function(event) {
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica','contenedorForma', 'mensaje', 'true','seguroClienteID',
				'funcionExito','funcionError');
		}
	});
	
	$('#formaGenerica').validate({
		rules : {
			seguroClienteID : {
				required : true
			},
			motivoCambioEstatus : {
				required : true
			},
			claveUsuarioAutoriza : {
				required : true
			},
			contrasenia: {
				required : true
			}
		},
	
		messages : {
			seguroClienteID : {
				required : 'Especificar Número de Póliza de Seguro'
			},
	
			motivoCambioEstatus : {
				required : 'Especifique Motivo de Cancelación'
			},
			 claveUsuarioAutoriza : {
				required : 'Especifique Clave de Usuario que Autoriza'
			},
			contrasenia : {
				required : 'Especifique Contraseña'
			}
	
		}
	});
	
	function consultaMotivosActivacion(tipoMov) {
		var motivoBean = {
			'motivoActivaID' : 1, 
			'tipoMovimiento' : tipoMov,
		};
		dwr.util.removeAllOptions('motivoCambioEstatus'); 
		dwr.util.addOptions('motivoCambioEstatus', {'':'SELECCIONAR'});
		motivActivacionServicio.listaCombo(motivoBean, 3, function(motivos){
			dwr.util.addOptions('motivoCambioEstatus', motivos, 'motivoActivaID', 'descripcion');
		});
	}

	function consultaSeguroVida(idControl){
		var jqControl = eval("'#"+idControl+"'");
		setTimeout("$('#cajaLista').hide();", 200);
		inicializaForma('formaGenerica', 'seguroClienteID');
		$('#motivoCambioEstatus').val('');
		
		if (!isNaN($(jqControl).val().trim())){
			var valor = Number($(jqControl).val().trim());
			if(valor > 0){
				var tipoCancela = 5;
				var bean = {
						'seguroClienteID':valor,
						'clienteID':0
				};
				seguroCliente.consulta(tipoCancela, bean,function( beanRespuestaSeguro){
					if(beanRespuestaSeguro != null){
						var tipoConPrincipal = 1;
						$('#sucursalOrigen').val(beanRespuestaSeguro.sucursalSeguro);
						var tipoConSucursal = 2;
						sucursalesServicio.consultaSucursal(tipoConSucursal, beanRespuestaSeguro.sucursalSeguro,function(beanRespuestaSucursal){
							if(beanRespuestaSucursal != null){
								$('#sucursalO').val(beanRespuestaSucursal.nombreSucurs);
							}
						});
						
						$('#fechaAlta').val(beanRespuestaSeguro.fechaInicio);
						
						clienteServicio.consulta(tipoConPrincipal, beanRespuestaSeguro.clienteID, '',function(beanRespuestaCliente){
							if(beanRespuestaCliente != null){
								$('#titulo').val(beanRespuestaCliente.titulo);
								switch(beanRespuestaCliente.tipoPersona){
								case 'F':$('#tipoPersona').val('FISICA');break;
								case 'A':$('#tipoPersona').val('FISICA CON ACT. EMP.');break;
								case 'M':$('#tipoPersona').val('MORAL');break;
								default:$('#tipoPersona').val('INDEFINIDO');
								}
								$('#primerNombre').val(beanRespuestaCliente.primerNombre);
								$('#segundoNombre').val(beanRespuestaCliente.segundoNombre);
								$('#tercerNombre').val(beanRespuestaCliente.tercerNombre);
								$('#apellidoPaterno').val(beanRespuestaCliente.apellidoPaterno);
								$('#apellidoMaterno').val(beanRespuestaCliente.apellidoMaterno);
								$('#fechaNacimiento').val(beanRespuestaCliente.fechaNacimiento);
							}
						});
						
						switch(beanRespuestaSeguro.estatus){
						case 'V':$('#desEstatus').val('VIGENTE');habilitaBoton('cancelar', 'submit');break;
						case 'B':
							$('#desEstatus').val('VENCIDO');
							deshabilitaBoton('cancelar', 'submit');
							$(jqControl).focus().select();		
							mensajeSis('Solo se Pueden Cancelar Pólizas de Seguro Vigentes');
							break;
						case 'C':
							$('#desEstatus').val('COBRADO');
							deshabilitaBoton('cancelar', 'submit');
							$(jqControl).focus().select();		
							mensajeSis('Solo se Pueden Cancelar Pólizas de Seguro Vigentes');
							break;
						case 'K':
							$('#motivoCambioEstatus').val(beanRespuestaSeguro.motivoCambioEstatus);
							$('#observacion').val(beanRespuestaSeguro.observacion);
							$('#desEstatus').val('CANCELADO');
							deshabilitaBoton('cancelar', 'submit');
							$(jqControl).focus().select();		
							mensajeSis('Solo se Pueden Cancelar Pólizas de Seguro Vigentes');
							break;
						default:
							$('#desEstatus').val('INDEFINIDO');
							deshabilitaBoton('cancelar', 'submit');
							$(jqControl).focus().select();		
							mensajeSis('Solo se Pueden Cancelar Pólizas de Seguro Vigentes');
						}
					}else{
						mensajeSis('No existe el Número de Póliza');
						$(jqControl).focus().select();						
					}
				});
			}else{
				if($(jqControl).val().trim() != ''){
					mensajeSis('No existe el Número de Póliza');
					$(jqControl).focus().select();	
				}
				
			}
		}
	}
		
});

function funcionExito(){
	$('#motivoCambioEstatus').val('').select()== true;
	deshabilitaBoton('cancelar', 'submit');
}


function funcionError(){
	
}