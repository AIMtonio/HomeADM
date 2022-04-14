$(document).ready(function() {
	var parametroBean = consultaParametrosSession();	
	
	esTab = true;
	// Definicion de Constantes y Enums
	var catTipoConsultaCliente = {
		'principal' : '1',
		'foranea' : '2'
	};
	
	// ------------ Metodos y Manejo de Eventos
	deshabilitaBoton('generar', 'submit');
	
	$(':text').focus(function() {
		esTab = false;
	});

	$.validator.setDefaults({
		submitHandler : function(event) {
		}
	});

	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});

	$('#generar').click(function() {
		if($('#numero').asNumber()>0){
			generaReporte();	
		}else{
			alert("Especifique Número de Cliente.");
			$('#nombreCliente').val("");
			$('#sexo').val("");
			$('#tipoPersona').val("");
			$('#estadoCivil').val("");	
			$('#numero').focus();			
		}
	});

	$('#numero').bind('keyup',function(e) { 
		lista('numero', '2', '1', 'nombreCompleto', $('#numero').val(), 'listaCliente.htm');
	});

	$('#numero').blur(function() {
		consultaCliente('numero');
	});
	
	
	// ------------ Validaciones de la Forma
	$('#formaGenerica').validate({
		rules : {
			numero : {
				required : false
			}			
		},
	
		messages : {
			numero : {
				required : 'Especificar Cliemte'
			}
		}
	});
	// ------------ Validaciones de Controles-------------------------------------

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
					if(cliente.sexo == 'F'){
						$('#sexo').val('FEMENINO');
					}else{
						$('#sexo').val('MASCULINO');
					}	
					switch(cliente.estadoCivil){
						case "S":
							$('#estadoCivil').val('SOLTERO');
						break;
						case "CS":
							$('#estadoCivil').val('CASADO BIENES SEPARADOS');
						break;
						case "CM":
							$('#estadoCivil').val('CASADO BIENES MANCOMUNADOS');
						break;
						case "CC":
							$('#estadoCivil').val('CASADO BIENES MANCOMUNADOS CON CAPITULACION');
						break;
						case "V":
							$('#estadoCivil').val('VIUDO');
						break;
						case "D":
							$('#estadoCivil').val('DIVORCIADO');
						break;
						case "SE":
							$('#estadoCivil').val('SEPARADO');
						break;
						case "U":
							$('#estadoCivil').val('UNION LIBRE');
						break;
						default:
							$('#estadoCivil').val('NO IDENTIFICADO');
					}
					
					if(cliente.tipoPersona == 'F'){
						$('#tipoPersona').val('FÍSICA');
						$('#personaMoral').hide(500);
					}else{
						if(cliente.tipoPersona == 'A'){
							$('#tipoPersona').val('FÍSICA ACTIVIDAD EMPRESARIAL');
							$('#personaMoral').show(500);
						}else{
							$('#tipoPersona').val('MORAL');
							$('#personaMoral').show(500);
						}
					}	
					
					habilitaBoton('generar','submit');
				} else {
					alert("No Existe el Cliente");
					$('#numero').val('');
					$('#nombreCliente').val('');
					deshabilitaBoton('generar','submit');
				}
			});
		}
	}
	
	function generaReporte(){		
		window.open('generarReporteDireccionesCliente.htm?'
				+'clienteID='+$('#numero').asNumber('')
				+'&nombreInstitucion='+ parametroBean.nombreInstitucion
				+'&fechaSistema='+parametroBean.fechaSucursal
				+'&nombreSucursal='+parametroBean.nombreSucursal
				+'&nombreUsuario='+parametroBean.nombreUsuario);
	}

});//	FIN VALIDACIONES DE REPORTES