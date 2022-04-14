var accedeHuella = 'N';
var huella_nombreCompleto,huella_usuarioID,huella_OrigenDatos, motivo, motivoID, bandera;
$(document).ready(function() {

	var parametroBean = consultaParametrosSession();
	$('#sucursalOrigen').val(parametroBean.sucursal);	
	$('#sucursalO').val(parametroBean.nombreSucursal);	
	
	esTab = true;
	// Definicion de Constantes y Enums
	var catTipoTransaccionCliente = {
		'activa' : '5',
		'inactiva' : '6'
	};

	var catTipoConsultaCliente = {
		'principal' : '1',
		'foranea' : '2',
		'clave': '3'
	};
	
		
	var catMotivActiva = {
		'activa' : '1',
		'inactiva' : '2'
	};
	
	// ------------ Metodos y Manejo de Eventos
	// -----------------------------------------
	deshabilitaBoton('activa', 'submit');
	deshabilitaBoton('inactiva', 'submit');
	
	agregaFormatoControles('formaGenerica');
	$('#numero').focus();
	
	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});

	$(':text').focus(function() {
		esTab = false;
	});
	
	consultaMotivosActivacion(1);

	$.validator.setDefaults({
		submitHandler : function(event) {
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica','contenedorForma', 'mensaje', 'true','numero', 'inicializa','funcionError');
			parametroBean = consultaParametrosSession();
			$('#sucursalOrigen').val(parametroBean.sucursal);	
			$('#sucursalO').val(parametroBean.nombreSucursal);
			$('#claveUsuarioAut').val('');
			$('#contraseniaAut').val('');			
			$('#numero').focus();
		}
	});
	
	$('#activa').click(function() {
		motivo ='ACTIVACION DEL CLIENTE';
		motivoID = 102;

		if(!$('#formaGenerica').valid()){
			return false;
		}
		if(accedeHuella == 'S' && $('#claveUsuarioAut').val() != ''){
			if($('#contraseniaAut').val() != ''){
				bandera = 'N';
				$('#tipoInactiva').focus();
				$('#tipoTransaccion').val(catTipoTransaccionCliente.activa);
				$('#tipoMovimiento').val(catMotivActiva.activa);
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica','contenedorForma', 'mensaje', 'true','numero', 'inicializa','funcionError');
					parametroBean = consultaParametrosSession();
					$('#sucursalOrigen').val(parametroBean.sucursal);	
					$('#sucursalO').val(parametroBean.nombreSucursal);
					$('#claveUsuarioAut').val('');
					$('#contraseniaAut').val('');			
					$('#numero').focus();
					$('#statusSrvHuella').hide();
			}else{
				bandera = 'S';
				serverHuella.funcionMostrarFirmaUsuario(
					huella_nombreCompleto,huella_usuarioID,huella_OrigenDatos
				); 
				$('#tipoInactiva').focus();
				$('#tipoTransaccion').val(catTipoTransaccionCliente.activa);
				$('#tipoMovimiento').val(catMotivActiva.activa);
			}
		}else{
			if($('#contraseniaAut').val() == ''){
				mensajeSis("La contraseña está vacía");
				$('#contraseniaAut').focus();
			}else{
				bandera = 'N';
				$('#tipoInactiva').focus();
				$('#tipoTransaccion').val(catTipoTransaccionCliente.activa);
				$('#tipoMovimiento').val(catMotivActiva.activa);
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica','contenedorForma', 'mensaje', 'true','numero', 'inicializa','funcionError');
					parametroBean = consultaParametrosSession();
					$('#sucursalOrigen').val(parametroBean.sucursal);	
					$('#sucursalO').val(parametroBean.nombreSucursal);
					$('#claveUsuarioAut').val('');
					$('#contraseniaAut').val('');			
					$('#numero').focus();
					$('#statusSrvHuella').hide();
			}
		}
	});

	$('#inactiva').click(function() {
		motivo = 'INACTIVACION DE CLIENTE';
		motivoID = 101;

		if(!$('#formaGenerica').valid()){
			return false;
		}

		if(accedeHuella == 'S' && $('#claveUsuarioAut').val() != ''){
			if($('#contraseniaAut').val() != ''){
				bandera = 'N';
				$('#tipoInactiva').focus();
				$('#tipoTransaccion').val(catTipoTransaccionCliente.inactiva);
				$('#tipoMovimiento').val(catMotivActiva.inactiva);
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica','contenedorForma', 'mensaje', 'true','numero', 'inicializa','funcionError');
					parametroBean = consultaParametrosSession();
					$('#sucursalOrigen').val(parametroBean.sucursal);	
					$('#sucursalO').val(parametroBean.nombreSucursal);
					$('#claveUsuarioAut').val('');
					$('#contraseniaAut').val('');			
					$('#numero').focus();
					$('#statusSrvHuella').hide();
			}else{
				bandera = 'S';
				serverHuella.funcionMostrarFirmaUsuario(
					huella_nombreCompleto,huella_usuarioID,huella_OrigenDatos
				); 
				$('#tipoInactiva').focus();
				$('#tipoTransaccion').val(catTipoTransaccionCliente.inactiva);
				$('#tipoMovimiento').val(catMotivActiva.inactiva);
			}
		}else{
			if($('#contraseniaAut').val() == ''){
				mensajeSis("La contraseña está vacía");
				$('#contraseniaAut').focus();
			}else{
				bandera = 'N';
				$('#tipoInactiva').focus();
				$('#tipoTransaccion').val(catTipoTransaccionCliente.inactiva);
				$('#tipoMovimiento').val(catMotivActiva.inactiva);
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica','contenedorForma', 'mensaje', 'true','numero', 'inicializa','funcionError');
					parametroBean = consultaParametrosSession();
					$('#sucursalOrigen').val(parametroBean.sucursal);	
					$('#sucursalO').val(parametroBean.nombreSucursal);
					$('#claveUsuarioAut').val('');
					$('#contraseniaAut').val('');			
					$('#numero').focus();
					$('#statusSrvHuella').hide();
			}
			
		}
	});
	
	$('#numero').bind('keyup',function(e) {
				lista('numero', '3', '10', 'nombreCompleto', $('#numero').val(), 'listaCliente.htm');
	});
	$('#numero').bind('keyup',function(e){
		if($('#numero').val().length<3){		
			$('#cajaListaCte').hide();
		}
	});

	$('#buscarMiSuc').click(function(){
		listaCte('numero', '3', '22', 'nombreCompleto', $('#numero').val(), 'listaCliente.htm');
	});
	$('#buscarGeneral').click(function(){
		listaCte('numero', '3', '10', 'nombreCompleto', $('#numero').val(), 'listaCliente.htm');
	});

	$('#numero').blur(function() {
		validaCliente(this,0);
	});
	$('#claveUsuarioAut').blur(function() {
  		validaUsuario(this);
	});

	// ------------ Validaciones de la Forma
	$('#formaGenerica').validate({
		rules : {
			numero : {
				required : true
			},
			tipoInactiva : {
				required: true
			},
			motivoInactiva: {
				required: true
			}, 
			claveUsuarioAut:{
				required: true
			}
		},
	
		messages : {
			numero : {
				required : 'Especificar número de Cliente'
			},	
			tipoInactiva : {
				required: 'Seleccione un Motivo'
			},
			motivoInactiva: {
				required: 'Capture las Observaciones'
			},
			claveUsuarioAut:{
				required: 'Capture el usuario que autoriza'
			},
			contraseniaAut:{
				required: 'Capture la contraseña del usuario que autoriza'
			}
		}
	});
	// ------------ Validaciones de Controles-------------------------------------

	function validaCliente(control,valorProspecto) {
		accedeHuella = 'N';
		var numCliente = $('#numero').val();
		setTimeout("$('#cajaLista').hide();", 200);
		
		if (numCliente != '' && !isNaN(numCliente) && esTab) {
			clienteServicio.consulta(1,numCliente,function(cliente) {
				if (cliente != null) {
						dwr.util.setValues(cliente);
						$('#motivo').val(cliente.motivoInactiva);
						$('#motivoInactiva').val('');
						esTab = true;
						if (cliente.estatus == 'A'){
							$('#estatus').val('ACTIVO');
							$('#tipoInactiva').val(2);
							habilitaBoton('inactiva', 'submit');
							deshabilitaBoton('activa', 'submit');
							consultaMotivosActivacion(2);
							$('#tipoInactiva').focus();
							}else if (cliente.estatus == 'I'){
							$('#estatus').val('INACTIVO');
							$('#tipoInactiva').val(1);
							deshabilitaBoton('inactiva', 'submit');
							habilitaBoton('activa', 'submit');
							consultaMotivosActivacion(1);
							$('#tipoInactiva').focus();
							validaMotivos(cliente.tipoInactiva); //validacion para saber si necesita permite reactivacion y requiere cobro
						}
					
						
						if (cliente.fechaNacimiento == '1900-01-01'){
							$('#fechaNacimiento').val('');
						}else{
							$('#fechaNacimiento').val(cliente.fechaNacimiento);
						}
						if (cliente.tipoPersona == 'F') {
							$('#tipoPersona').attr("checked","1");
							$('#tipoPersona2').attr("checked",false);
							$('#tipoPersona3').attr("checked",false);
							$('#personaFisica').show(500);
							$('#personaMoral').hide(500);
						} else {
							if (cliente.tipoPersona == 'A') {
								$('#tipoPersona3').attr("checked","1");
								$('#tipoPersona2').attr("checked",false);
								$('#tipoPersona').attr("checked",false);
								$('#personaFisica').show(500);
								$('#personaMoral').hide(500);
							}
							if (cliente.tipoPersona == 'M'){
								$('#tipoPersona2').attr("checked","1");
								$('#tipoPersona').attr("checked",false);
								$('#tipoPersona3').attr("checked",false);
								$('#personaMoral').show(500);
								$('#generar').hide(500);
								$('#personaFisica').hide(500);
								$('#grupoEmpresarial').val(cliente.grupoEmpresarial);
							}
						}
						$('#sucursalOrigen').val(cliente.sucursalOrigen);
						consultaSucursal('sucursalOrigen');
						$('#estadoID').val(cliente.estadoID);
						consultaEstado('estadoID');
						$('#lugarNacimiento').val(cliente.lugarNacimiento);
						consultaPaisNac('lugarNacimiento');
						$('#paisResidencia').val(cliente.paisResidencia);
						consultaPais('paisResidencia'); 
						$('#telefonoCelular').setMask('phone-us');
						$('#telefonoCasa').setMask('phone-us');
					} else {
						limpiaForm($('#formaGenerica'));
						mensajeSis("No Existe el Cliente");
						deshabilitaBoton('activa','submit');
						deshabilitaBoton('inactiva','submit');
						$('#numero').focus();
						$('#numero').select();
					}
				});
			}else{
				if(isNaN(numCliente) && esTab){
					limpiaForm($('#formaGenerica'));
					mensajeSis("No Existe el Cliente");
					deshabilitaBoton('activa','submit');
					deshabilitaBoton('inactiva','submit');
					$('#numero').focus();
					$('#numero').select();					
				}
			}
		
	}

	
	function validaNacionalidadCte(){
		var nacionalidad = $('#nacion').val();
		var pais= $('#lugarNacimiento').val();
		var mexico='700';
		var nacdadMex='N';
		var nacdadExtr='E';
		if('#tipoPersona2'.checked = false){
			if(nacionalidad==nacdadMex){
				if(pais!=mexico){
					mensajeSis("Por la Nacionalidad de la Persona el País Debe ser México");
					$('#lugarNacimiento').val('');
					$('#paisNac').val('');
				}
			}
		}
		if(nacionalidad==nacdadExtr){
			if(pais==mexico){
				mensajeSis("Por la Nacionalidad de la Persona el País NO Debe ser México");
				$('#lugarNacimiento').val('');
				$('#paisNac').val('');
			}
		}
	}

	function consultaMotivosActivacion(tipoMov) {
		
		var motivoBean = {
			'motivoActivaID' : 1, 
			'tipoMovimiento' : tipoMov,
		};			 	
		motivActivacionServicio.listaCombo(motivoBean, 3, function(motivos){
			dwr.util.removeAllOptions('tipoInactiva'); 
			dwr.util.addOptions('tipoInactiva', {'':'SELECCIONA'});
			dwr.util.addOptions('tipoInactiva', motivos, 'motivoActivaID', 'descripcion');
		});
	}
// consultar los datos que necesito para Reactivar cliente //	
	function validaMotivos(tipoMovReact) {
		var motivoBean = {
				'motivoActivaID' : tipoMovReact,
				};
		setTimeout("$('#cajaLista').hide();", 200);		
		motivActivacionServicio.consulta(motivoBean,1,function(motivosR) {
				if (motivosR != null) {
					if(motivosR.permiteReactivacion == 'N'){
							mensajeSis("El Motivo de Inactivación No Puede Volver a Activarse.");
							deshabilitaBoton('activa', 'submit');
							$('#numero').focus();
						}
						if(motivosR.permiteReactivacion== 'S' && motivosR.requiereCobro == 'S'){
							$('#permiteReactReqCosto').val('S');
							consultaCobro('numero');
						}else{
							$('#permiteReactReqCosto').val('N');
						}
						
					}
			});
		}
		
	//consultar estatus de cobro de COBROREACTIVACLI
	function consultaCobro(idControl){
		var jqNumCliente = eval("'#" + idControl + "'");
		var jqNum = $(jqNumCliente).val();
		var numBean = {
				'numero' : jqNum
				};
		if (jqNum != '' && !isNaN(jqNum) ) {
			cobroReactivaCliServicio.consulta(1,numBean, function(estCobro){
				if(estCobro != null){	
		
				}
				else{
					mensajeSis("El Motivo de Reactivación Tiene un Costo Favor de Pagarlo en Caja");
					deshabilitaBoton('activa', 'submit');
					$('#numero').focus();
					}
				});
			}
		}	
	
	
	function formaRFC() {
		var pn = $('#primerNombre').val();
		var sn = $('#segundoNombre').val();
		var tn = $('#tercerNombre').val();
		var nc = pn + ' ' + sn + ' ' + tn;

		var rfcBean = {
			'primerNombre' : nc,
			'apellidoPaterno' : $('#apellidoPaterno').val(),
			'apellidoMaterno' : $('#apellidoMaterno').val(),
			'fechaNacimiento' : $('#fechaNacimiento').val()
		};
		clienteServicio.formaRFC(rfcBean, function(cliente) {
			if (cliente != null) {

				$('#RFC').val(cliente.RFC);
			}
		});
	}

	function validaRFC(idControl) {
		var jqRFC = eval("'#" + idControl + "'");
		var numRFC = $(jqRFC).val();
		var tipCon = 4;
		setTimeout("$('#cajaLista').hide();", 200);
		if (numRFC != '' && esTab ) {
			clienteServicio.consultaRFC(tipCon,	numRFC,function(rfc) {
				if (rfc != null) {
					mensajeSis("El Cliente: "
							+ rfc.numero
							+ "\ncon RFC : "
							+ rfc.RFCOficial
							+ ", \nYa Está Registrado en el Sistema, \nFavor de Utilizar Este Folio");
					$(jqRFC).focus();
				}
			});
		}
	}

	function consultaSucursal(idControl) {
		var jqSucursal = eval("'#" + idControl + "'");
		var numSucursal = $(jqSucursal).val();
		var conSucursal = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		if (numSucursal != '' && !isNaN(numSucursal) && esTab) {
			sucursalesServicio.consultaSucursal(conSucursal,
					numSucursal, function(sucursal) {
						if (sucursal != null) {
							$('#sucursalO').val(
									sucursal.nombreSucurs);
						} else {
							mensajeSis("No Existe la Sucursal");
						}
					});
		}
	}

	function consultaPais(idControl) {
		var jqPais = eval("'#" + idControl + "'");
		var numPais = $(jqPais).val();
		var conPais = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		if (numPais != '' && !isNaN(numPais) && esTab) {
			paisesServicio.consultaPaises(conPais, numPais,
					function(pais) {
						if (pais != null) {
							$('#paisR').val(pais.nombre);
						} else {
							mensajeSis("No Existe el País");
						}
					});
		}
	}
	function consultaPaisNac(idControl) {
		var jqPais = eval("'#" + idControl + "'");
		var numPais = $(jqPais).val();
		var conPais = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		if (numPais != '' && !isNaN(numPais) && esTab) {
			paisesServicio.consultaPaises(conPais, numPais,
					function(pais) {
						if (pais != null) {
							$('#paisNac').val(pais.nombre);
							if (pais.paisID != 700) {
								$('#estadoID').val(0);
								$('#estadoID').attr('readonly',true);
							}
							validaNacionalidadCte();
						} else {
							mensajeSis("No Existe el País");
						}
					});
		}
	}

	function consultaEstado(idControl) {
		var jqEstado = eval("'#" + idControl + "'");
		var numEstado = $(jqEstado).val();
		var tipConForanea = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		if (numEstado != '' && !isNaN(numEstado) && esTab) {
			estadosServicio
					.consulta(
							tipConForanea,
							numEstado,
							function(estado) {
								if (estado != null) {
									var p = $('#lugarNacimiento').val();
									if (p == 700 && estado.estadoID == 0 && esTab) {
										mensajeSis("No Existe el Estado");
										$('#estadoID').focus();
									}
									$('#nombreEstado').val(estado.nombre);
								} else {
									mensajeSis("No Existe el Estado");
								}
							});
		}
	}

	function validaNacionalidad(idControl) {
		var jqnacion = eval("'#" + idControl + "'");
		var nacion = $(jqnacion).val();
		var conPais = 2;
		var numPais = 700;
		
		setTimeout("$('#cajaLista').hide();", 200);
		if (nacion == 'N' && esTab) {
			paisesServicio.consultaPaises(conPais, numPais,
					function(pais) {
						if (pais != null) {
							
							$('#paisR').val(pais.nombre);
						}
					});
		}
	}

	function consultaCliente(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();
		setTimeout("$('#cajaLista').hide();", 200);

		if (numCliente != '' && !isNaN(numCliente) && esTab) {
			clienteServicio.consulta(1, numCliente, function(
					cliente) {
				if (cliente != null) {
					$('#numero').val(cliente.numero);
					$('#nombreCliente').val(cliente.nombreCompleto);
					$('#pagaIVA').val(cliente.pagaIVA);
					$('#pagaISR').val(cliente.pagaISR);
					$('#pagaIDE').val(cliente.pagaIDE);
					habilitaBoton('actualiza','submit');

				} else {
					mensajeSis("No Existe el Cliente");
					$('#numero').val('');
					$('#nombreCliente').val('');
					$('#pagaIVA').val('S');
					$('#pagaISR').val('S');
					$('#pagaIDE').val('S');
					deshabilitaBoton('actualiza','submit');
				}
			});
		}
	}

	function validaClienteForanea(controlOrigen, controlDestino) {
		var jqCliente = eval("'#" + controlOrigen + "'");
		var jqDestino = eval("'#" + controlDestino + "'");
		var numCliente = $(jqCliente).val();
		setTimeout("$('#cajaLista').hide();", 200);
		if (numCliente != '' && !isNaN(numCliente) && esTab) {
			clienteServicio.consulta(catTipoConsultaCliente.foranea, numCliente,function(cliente) {
				if (cliente != null) {
					$(jqDestino).val(cliente.nombreCompleto);
				} else {
					mensajeSis("No Existe el Cliente");
				}
			});
		}
	}
	
	function compare_dates(fecha){
      var fechaHoy = parametroBean.fechaSucursal;
      var xMonth=fecha.substring(3, 5);
      var xDay=fecha.substring(0, 2);
      var xYear=fecha.substring(6,10);
      var yMonth=fechaHoy.substring(3, 5);
      var yDay=fechaHoy.substring(0, 2);
      var yYear=fechaHoy.substring(6,10);
      if (xYear> yYear){
			return(true);
		}
      else{
			if (xYear == yYear){ 
				if (xMonth> yMonth){
					return(true);
            }
            else{ 
              if (xMonth == yMonth){
                if (xDay> yDay)
                  return(true);
                else
                  return(false);
              }
              else
              	return(false);
            }
          }
          else
				return(false);
		}
	}
	
	
	function mayor(fecha, fecha2){ // valida si fecha > fecha2: true else false
		//0|1|2|3|4|5|6|7|8|9|
		//2 0 1 2 / 1 1 / 2 0
		var xMes=fecha.substring(5, 7);
		var xDia=fecha.substring(8, 10);
		var xAnio=fecha.substring(0,4);

		var yMes=fecha2.substring(5, 7);
		var yDia=fecha2.substring(8, 10);
		var yAnio=fecha2.substring(0,4);



		if (xAnio > yAnio){
			return true;
		}else{
			if (xAnio == yAnio){
				if (xMes > yMes){
					return true;
				}
				if (xMes == yMes){
					if (xDia > yDia){
						return true;
					}else{
						return false;
					}
				}else{
					return false;
				}
			}else{
				return false ;
			}
		} 
	}


	/*funcion valida fecha formato (yyyy-MM-dd)*/
	function esFechaValida(fecha){

		if (fecha != undefined && fecha.value != "" ){
			var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
			if (!objRegExp.test(fecha)){
				mensajeSis("Formato de Fecha No Válido (aaaa-mm-dd)");
				return false;
			}

			var mes=  fecha.substring(5, 7)*1;
			var dia= fecha.substring(8, 10)*1;
			var anio= fecha.substring(0,4)*1;

			switch(mes){
			case 1: case 3:  case 5: case 7:
			case 8: case 10:
			case 12:
				numDias=31;
				break;
			case 4: case 6: case 9: case 11:
				numDias=30;
				break;
			case 2:
				if (comprobarSiBisisesto(anio)){ numDias=29; }else{ numDias=28;};
				break;
			default:
				mensajeSis("Fecha Introducida Errónea.");
			return false;
			}
			if (dia>numDias || dia==0){
				mensajeSis("Fecha Introducida Errónea.");
				return false;
			}
			return true;
		}
	}


	function comprobarSiBisisesto(anio){
		if ( ( anio % 100 != 0) && ((anio % 4 == 0) || (anio % 400 == 0))) {
			return true;
		}
		else {
			return false;
		}
	}
	/***********************************/
	
});//	FIN VALIDACIONES DE REPORTES


	function inicializa() {
		// Esta es tu funcion de exito
		if(bandera == 'S'){
		serverHuella.registroBitacoraUsuario(motivo,motivoID, huella_usuarioID, $('#campoGenerico').val());
		}
		if($('#numeroMensaje').val()){
			inicializaForma('formaGenerica', 'numero');
			deshabilitaBoton('activa', 'submit');
			deshabilitaBoton('inactiva', 'submit');
			dwr.util.removeAllOptions('tipoInactiva'); 
			dwr.util.addOptions('tipoInactiva', {'':'SELECCIONAR'});
			$('#numero').focus();
		}
	}

	function funcionError(){
		
	}

function formaCURP() {
	var sexo = $('#sexo').val();
	var nacionalidad = $('#nacion').val();
	if(sexo == "M")
	{sexo = "H";}
	else if(sexo == "F")
	{sexo = "M";}
	else{
		sexo = "H";
		mensajeSis("no se asigno sexo");
	}
	
	if(nacionalidad == "N")
	{nacionalidad = "N";}
	else if(nacionalidad == "E")
	{nacionalidad = "S";}
	else{
		nacionalidad = "N";
		mensajeSis("No se asigno nacionalidad");
	}
	var CURPBean = {
		'primerNombre'	:$('#primerNombre').val(),
		'segundoNombre'	:$('#segundoNombre').val(),
		'tercerNombre'	:$('#tercerNombre').val(),
		'apellidoPaterno' : $('#apellidoPaterno').val(),
		'apellidoMaterno' : $('#apellidoMaterno').val(),
		'sexo'			:sexo,
		'fechaNacimiento' : $('#fechaNacimiento').val(),
		'nacion'		:nacionalidad,
		'estadoID':$('#estadoID').val()
		
	};
	clienteServicio.formaCURP(CURPBean, function(cliente) {
		if (cliente != null) {
			$('#CURP').val(cliente.CURP);
		}
	});
}

function validaCURP(idControl) {
	var jqCURP = eval("'#" + idControl + "'");
	var numCURP = $(jqCURP).val();
	var tipCon = 11;
	setTimeout("$('#cajaLista').hide();", 200);
	if (numCURP != '' && esTab ) {
		clienteServicio.consultaCURP(tipCon, numCURP,function(curp) {
			if (curp != null) {
				mensajeSis("El Cliente: "
						+ curp.numero
						+ "\ncon CURP : "
						+ curp.CURP
						+ ", \nYa Está Registrado en el Sistema, \nFavor de Utilizar Este Folio");
				$(jqCURP).focus();
			}
		});
	}
}

var serverHuella = new HuellaServer({


	fnHuellaValida:	function(datos){
				$('#contraseniaAut').val('HD>>'+datos.tokenHuella);
					grabaFormaTransaccionRetrollamada({}, 'formaGenerica','contenedorForma', 'mensaje', 'true','numero', 'inicializa','funcionError');
					parametroBean = consultaParametrosSession();
					$('#sucursalOrigen').val(parametroBean.sucursal);	
					$('#sucursalO').val(parametroBean.nombreSucursal);
					$('#claveUsuarioAut').val('');
					$('#contraseniaAut').val('');			
					$('#numero').focus();
					$('#statusSrvHuella').hide();
					},
	fnHuellaInvalida: function(datos){
							return false;
					}
});

function validaUsuario(control) {
	var claveUsuario = $('#claveUsuarioAut').val();
	serverHuella.cancelarOperacionActual();
	$('#statusSrvHuella').hide();
	$('#contraseniaAut').show();
	if(claveUsuario != ''){
		var usuarioBean = {
				'clave':claveUsuario
		};
		usuarioServicio.consulta(3, usuarioBean, function(usuario) {
						if(usuario!=null){
							accedeHuella = usuario.accedeHuella;
							huella_nombreCompleto = usuario.clave;
							huella_usuarioID = usuario.usuarioID;	
							huella_OrigenDatos = usuario.origenDatos;
							$('#encriptaContrasenia').val(usuario.contrasenia);
							if(accedeHuella=='S'){
								$('#statusSrvHuella').show(500);
							}else{
								$('#statusSrvHuella').hide();
							}
						}else{
							mensajeSis('El Usuario Ingresado No Existe');
							accedeHuella=='N';
						}
			});
	}
}