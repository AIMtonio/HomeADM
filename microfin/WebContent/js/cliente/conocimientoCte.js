var clienteexiste = 0;
var nacionalidad = '';
var nivelRiesgo = '';
var nivelRiesgoActividad = '';
var esPep = '';
var parentescoPep = '';
var importa = '';
var exporta = '';
var nivelRiesgoAnt = '';
var catListaReferencia = {
'principal' : 1,
'pld' : 2
}
var esTab = false;
var catTipoTransaccionConocimientoCte = {
'agrega' : '1',
'modifica' : '2'
};

var catTipoConsultaConocimientoCte = {
'principal' : 1,
'foranea' : 2
};
var catTipoConRelacion = {
	'principal' : 1
};

var expedienteBean = {
'clienteID' : 0,
'tiempo' : 0,
'fechaExpediente' : '1900-01-01',
};
var listaPersBloqBean = {
'estaBloqueado' : 'N',
'coincidencia' : 0
};
var esCliente = 'CTE';
var esUsuario = 'USS';
var parametroBean = consultaParametrosSession();
$(document).ready(function() {
	$('#clienteID').focus();

	$('#operacionAnios').val('0');
	$('#giroAnios').val('0');
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');
	deshabilitaBoton('modifica', 'submit');
	deshabilitaBoton('agrega', 'submit');
	$("#datosAdicionalesCteAltoRiesgo").hide();

	iniciaPEPS();
	iniciaParentescoPEPS();
	iniciaImporta();
	iniciaExporta();
	mostrarOC();
	iniciaBanCredOtraEnt();
	$('#nivelRiesgo').val('');
	$('#tiposClientes').val('');
	$('#instrumentosMonetarios').val('');

	$(':text').focus(function() {
		esTab = false;
	});
	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});

	if ($('#flujoCliNumCli').val() != undefined) {
		if (!isNaN($('#flujoCliNumCli').val())) {
			var numCliFlu = Number($('#flujoCliNumCli').val());
			if (numCliFlu > 0) {
				$('#clienteID').val($('#flujoCliNumCli').val());
				validaConocimientoCte('clienteID');

			} else {
				mensajeSis('No se puede agregar Conocimiento de ' + $('#alertSocio').val() + ' sin ' + $('#alertSocio').val());
			}
		}
	}

	$.validator.setDefaults({
		submitHandler : function(event) {
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'clienteID', "exitoConocimiento", "falloConocimiento");
		}
	});

	$('#agrega').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccionConocimientoCte.agrega);
	});

	$('#modifica').click(function() {
		if($('#giroAnios').val() == '')	$('#giroAnios').val('0');		
		if($('#operacionAnios').val() == '') $('#operacionAnios').val('0');
		$('#tipoTransaccion').val(catTipoTransaccionConocimientoCte.modifica);
	});

	$('#clienteID').bind('keyup', function(e) {
		lista('clienteID', '3', '14', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});

	$('#clienteID').blur(function() {
		setTimeout("$('#cajaLista').hide();", 200);
		var cliente = $('#clienteID').asNumber();
		$("#nivelRiesgo").val('');
		if (cliente > 0) {
			listaPersBloqBean = consultaListaPersBloq(cliente, esCliente, 0, 0);
			if (listaPersBloqBean.estaBloqueado != 'S') {
				expedienteBean = consultaExpedienteCliente($('#clienteID').val());
				if (expedienteBean.tiempo <= 1) {
					if (alertaCte(cliente) != 999) {
						validaConocimientoCte(this.id);
					}
				} else {
					mensajeSis('Es necesario Actualizar el Expediente del ' + $('#alertSocio').val() + ' para Continuar.');
					inicializaForma('formaGenerica', 'clienteID');
					$('#clienteID').focus();
					$('#clienteID').val('');
					limpiaCampos();
				}
			} else {
				mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
				inicializaForma('formaGenerica', 'clienteID');
				$('#clienteID').focus();
				$('#clienteID').val('');
				limpiaCampos();
			}
		} else if (cliente == 0) {
			limpiaCampos();
			$('#nombreCliente').val('');
			limpiaPreguntasCte();
			deshabilitaBoton('modifica', 'submit');
			deshabilitaBoton('agrega', 'submit');
		}
	});

	$('#funcionID').bind('keyup', function(e) {
		lista('funcionID', '2', '1', 'descripcion', $('#funcionID').val(), 'listaFuncionPub.htm');
	});
	$('#funcionID').blur(function() {
		consultaFuncionPub(this.id);
	});

	$('#telefonoRef').setMask('phone-us');
	$('#telefonoRef2').setMask('phone-us');
	$('#telRefCom').setMask('phone-us');
	$('#telRefCom2').setMask('phone-us');

	$("#extTelRefCom").blur(function() {
		if (this.value != '') {
			if ($("#telRefCom").val() == '') {
				this.value = '';
				mensajeSis("El Número de Teléfono está Vacío.");
				$("#telRefCom").focus();
			}
		}
	});
	$("#telRefCom").blur(function() {
		if (this.value == '') {
			$("#extTelRefCom").val('');
		}
	});

	$("#extTelRefCom2").blur(function() {
		if (this.value != '') {
			if ($("#telRefCom2").val() == '') {
				this.value = '';
				mensajeSis("El Número de Teléfono está Vacío.");
				$("#telRefCom2").focus();
			}
		}
	});
	$("#telRefCom2").blur(function() {
		if (this.value == '') {
			$("#extTelRefCom2").val('');
		}
	});

	$("#extTelefonoRefUno").blur(function() {
		if (this.value != '') {
			if ($("#telefonoRef").val() == '') {
				this.value = '';
				mensajeSis("El Número de Teléfono está Vacío.");
				$("#telefonoRef").focus();
			}
		}
	});
	$("#telefonoRef").blur(function() {
		if (this.value == '') {
			$("#extTelefonoRefUno").val('');
		}
	});

	$("#extTelefonoRefDos").blur(function() {
		if (this.value != '') {
			if ($("#telefonoRef2").val() == '') {
				this.value = '';
				mensajeSis("El Número de Teléfono está Vacío.");
				$("#telefonoRef2").focus();
			}
		}
	});
	$("#telefonoRef2").blur(function() {
		if (this.value == '') {
			$("#extTelefonoRefDos").val('');
		}
	});

	$('#importa2').click(function() {
		importaNo();
	});
	$('#importa').click(function() {
		importaSi();
	});

	$('#exporta').click(function() {
		exportaSi();
	});
	$('#exporta2').click(function() {
		exportaNo();
	});

	$('#definicion').click(function() {
		var def = '<P><BLOCKQUOTE>De acuerdo a las Disposiciones de Car&aacute;cter General a que se refiere el ' + 'art&iacute;culo 115 de la Ley de Instituciones de Cr&eacute;dito se consider&oacute; que una ' + 'Persona Pol&iacute;ticamente Expuesta ser&iacute;a aquel individuo que desempe&ntilde;ase o ' + 'hubiese desempe&ntilde;ado funciones p&uacute;blicas destacadas en un pa&iacute;s extranjero ' + 'o en territorio nacional.<br> Para ello fueron considerados, entre otros ' + 'puestos, a los jefes de estado o de gobierno, l&iacute;deres pol&iacute;ticos, ' + 'funcionarios gubernamentales, judiciales o militares de alta jerarqu&iacute;a, ' + 'altos ejecutivos de empresas estatales o funcionarios miembros ' + 'importantes de los partidos pol&iacute;ticos.</P> ' + '<P>Los c&oacute;nyuges de estas, o las personas con las que se mantuviese ' + 'parentesco por consanguinidad o afinidad hasta el segundo grado.</P> ';
		definicionP(def);
	});

	$('#PEPs').click(function() {
		iniciaPEPS();
	});

	$('#PEPs').blur(function() {
		iniciaPEPS();
	});

	$('#PEPs2').click(function() {
		iniciaPEPS();
	});

	$('#PEPs2').blur(function() {
		iniciaPEPS();
	});

	$('#parentescoPEP').click(function() {
		parentescoPEPSi();
	});

	$('#parentescoPEP2').click(function() {
		parentescoPEPNo(true);
	});

	$('#parentescoPEP').blur(function() {
		parentescoPEPSi();
	});

	$('#parentescoPEP2').blur(function() {
		parentescoPEPNo(true);
	});

	$('#cober_Geograf').click(function() {
		$('#cober_Geograf').val('L');
	});
	$('#cober_Geograf2').click(function() {
		$('#cober_Geograf2').val('E');
	});
	$('#cober_Geograf3').click(function() {
		$('#cober_Geograf3').val('R');
	});
	$('#cober_Geograf4').click(function() {
		$('#cober_Geograf4').val('N');
	});
	$('#cober_Geograf5').click(function() {
		$('#cober_Geograf5').val('I');
	});

	$('#dolaresExport').click(function() {
		$('#dolaresExport').val('DExp');
	});
	$('#dolaresExport2').click(function() {
		$('#dolaresExport2').val('DExp2');
	});
	$('#dolaresExport3').click(function() {
		$('#dolaresExport3').val('DExp3');
	});
	$('#dolaresExport4').click(function() {
		$('#dolaresExport4').val('DExp4');
	});
	$('#dolaresImport').click(function() {
		$('#dolaresImport').val('DImp');
	});
	$('#dolaresImport2').click(function() {
		$('#dolaresImport2').val('DImp2');
	});
	$('#dolaresImport3').click(function() {
		$('#dolaresImport3').val('DImp3');
	});
	$('#dolaresImport4').click(function() {
		$('#dolaresImport4').val('DImp4');
	});
	$('#ingAproxMes').click(function() {
		$('#ingAproxMes').val('Ing1');
	});
	$('#ingAproxMes2').click(function() {
		$('#ingAproxMes2').val('Ing2');
	});
	$('#ingAproxMes3').click(function() {
		$('#ingAproxMes3').val('Ing3');
	});
	$('#ingAproxMes4').click(function() {
		$('#ingAproxMes4').val('Ing4');
	});
	$('#ingAproxMes5').click(function() {
		$('#ingAproxMes5').val('Ing5');
	});
	$('#banCredOtraEnt1').click(function() {
		$('#banCredOtraEnt').val('S');
	});
	$('#banCredOtraEnt12').click(function() {
		$('#banCredOtraEnt').val('N');
	});
	$('#banCredOtraEnt21').click(function() {
		$('#banCredOtraEnt2').val('S');
	});
	$('#banCredOtraEnt22').click(function() {
		$('#banCredOtraEnt2').val('N');
	});

	$('#tipoRelacion1').bind('keyup', function(e) {
		lista('tipoRelacion1', '2', '1', 'descripcion', $('#tipoRelacion1').val(), 'listaParentescos.htm');
	});

	$('#tipoRelacion1').blur(function() {
		consultaParentesco(this.id);
	});

	$('#tipoRelacion2').bind('keyup', function(e) {
		lista('tipoRelacion2', '2', '1', 'descripcion', $('#tipoRelacion2').val(), 'listaParentescos.htm');
	});

	$('#tipoRelacion2').blur(function() {
		consultaParentesco(this.id);
	});
	$('#nivelRiesgo').click(function() {
		nivelRiesgoAnt = $('#nivelRiesgo option:selected').val()
	});
	$("#nivelRiesgo").change(function(){
		if($('#nivelRiesgo option:selected').val()!=''){
			$('#evaluaXMatriz2').attr('checked', true);
		}
	});

	$('#fechaNombramiento').change(function() {
		var Xfecha= $('#fechaNombramiento').val();
		var Yfecha=  parametroBean.fechaSucursal;
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaNombramiento').val(parametroBean.fechaSucursal);

			if ( mayor(Xfecha, Yfecha) ){
				mensajeSis("La Fecha Capturada es Mayor a la de Hoy")	;
				$('#fechaNombramiento').val(parametroBean.fechaSucursal);
				$('#fechaNombramiento').focus();
			}
			$('#fechaNombramiento').focus();
		} else {
			$('#fechaNombramiento').val('');
			$('#fechaNombramiento').focus();
		}
	});

	$('#porcentajeAcciones').blur(function(){
		validaPorcentajeAcciones();
	});

	$('#montoAcciones').blur(function(){
		validaMontoAcciones();
	});

	$('#operacionAnios').blur(function(){
		validaOperacionAnios();
	});

	$('#giroAnios').blur(function(){
		validaGiroAnios();
	});

	//------------ Validaciones de la Forma -------------------------------------

$('#formaGenerica').validate({
	rules : {
		clienteID : {
			required : true,
			minlength : 1
		},
		extTelefonoRefUno : {
			number : true,
		},
		extTelefonoRefDos : {
			number : true,
		},
		extTelRefCom : {
			number : true,
		},
		extTelRefCom2 : {
			number : true,
		},
		activos : {
			number : true,
			maxlength : 16
		},
		pasivos : {
			number : true,
			maxlength : 16
		},
		capital : {
			number : true,
			maxlength : 16
		},
		capitalContable : {
			number : true,
			maxlength : 16
		},
		participacion : {
			number : true,
			maxlength : 16
		},
		importeVta : {
			number : true,
			maxlength : 22
		},
		paisesExport : {
			maxlength : 50
		},
		paisesExport2 : {
			maxlength : 50
		},
		paisesExport3 : {
			maxlength : 50
		},
		paisesImport : {
			maxlength : 50
		},
		paisesImport2 : {
			maxlength : 50
		},
		paisesImport3 : {
			maxlength : 50
		},
		preguntaCte1 : {
			required : function() {
				return $('#preguntaCte1').is(':visible');
			},
			maxlength : 100
		},
		respuestaCte1 : {
			required : function() {
				return $('#respuestaCte1').is(':visible');
			},
			maxlength : 200
		}
	},

	messages : {
		clienteID : {
			required : 'Especifique ' + $('#alertSocio').val(),
			minlength : 'Al menos 1 Caracteres'
		},
		extTelefonoRefUno : {
			number : 'Sólo Números(Campo opcional)',
		},
		extTelefonoRefDos : {
			number : 'Sólo Números(Campo opcional)'
		},
		extTelRefCom : {
			number : 'Sólo Números(Campo opcional)'
		},
		extTelRefCom2 : {
			number : 'Sólo Números(Campo opcional)'
		},
		activos : {
			number : 'Sólo Números',
			maxlength : 'Máximo 10 Caracteres'
		},
		pasivos : {
			number : 'Sólo Números',
			maxlength : 'Máximo 10 Caracteres'
		},
		capital : {
			number : 'Sólo Números',
			maxlength : 'Máximo 10 Caracteres'
		},
		capitalContable : {
			number : 'Sólo Números',
			maxlength : 'Máximo 10 Caracteres'
		},
		participacion : {
			number : 'Sólo Números',
			maxlength : 'Máximo 10 Caracteres'
		},
		importeVta : {
			number : 'Sólo Números',
			maxlength : 'Máximo 16 Caracteres'
		},
		paisesExport : {
			maxlength : 'Máximo 50 Caracteres'
		},
		paisesExport2 : {
			maxlength : 'Máximo 50 Caracteres'
		},
		paisesExport3 : {
			maxlength : 'Máximo 50 Caracteres'
		},
		paisesImport : {
			maxlength : 'Máximo 50 Caracteres'
		},
		paisesImport2 : {
			maxlength : 'Máximo 50 Caracteres'
		},
		paisesImport3 : {
			maxlength : 'Máximo 50 Caracteres'
		},
		preguntaCte1 : {
			required : "Especifique una pregunta",
			maxlength : 'Máximo 100 Caracteres'
		},
		respuestaCte1 : {
			required : "Especifique una respuesta",
			maxlength : 'Máximo 200 Caracteres'
		}
	}
});

	//------------ Validaciones de Controles -------------------------------------

	function consultaParentesco(idControl) {
		var jqParentesco = eval("'#" + idControl + "'");
		var parentescoID = $(jqParentesco).val();
		var id = idControl.substring(12);
		var jqDescParen = eval("'#descRelacion" + id + "'");

		if (parentescoID != '' && parentescoID != 0 && !isNaN(parentescoID)) {
			var parentescoBean = {
				'parentescoID' : parentescoID
			};
			parentescosServicio.consultaParentesco(catTipoConRelacion.principal, parentescoBean, function(parentesco) {
				if (parentesco != null) {
					$(jqDescParen).val(parentesco.descripcion);
				} else {
					mensajeSis("El Parentesco No Existe");
					$(jqDescParen).val('');
					$(jqParentesco).focus();
				}
			});
		}
	}

	function validaConocimientoCte(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).asNumber();
		setTimeout("$('#cajaLista').hide();", 200);
		$("#nivelRiesgo").val('');
		$('#comentarioNivel').val('');

		if (numCliente > 0) {
			consultaCliente('clienteID');
			deshabilitaBoton('agrega', 'submit');
			habilitaBoton('elimina', 'submit');
			var ConocCteBeanCon = {
				'clienteID' : numCliente
			};
			conocimientoCteServicio.consulta(1, ConocCteBeanCon, function(conocimiento) {
				if (conocimiento != null) {
					dwr.util.setValues(conocimiento);
					$('#participacion').formatCurrency({
					positiveFormat : '%n',
					roundToDecimalPlace : 2
					});
					$('#descripcion').val(conocimiento.funcionID);
					if (conocimiento.funcionID == 0) {
						$('#funcionID').val('');
						$('#descripcion').val('');
					}
					consultaFuncionPub('descripcion');
					if (conocimiento.PEPs == 'S') {
						$('#PEPs').attr("checked", "1");
					}
					if (conocimiento.PEPs == 'N') {
						$('#PEPs2').attr("checked", "1");
					}
					if (conocimiento.parentescoPEP == 'S') {
						$('#parentescoPEP').attr("checked", "1");
					}
					if (conocimiento.parentescoPEP == 'N') {
						$('#parentescoPEP2').attr("checked", "1");
					}
					if (conocimiento.cober_Geograf == 'L') {
						$('#cober_Geograf').attr("checked", "1");
					}
					if (conocimiento.cober_Geograf == 'E') {
						$('#cober_Geograf2').attr("checked", "1");
					}
					if (conocimiento.cober_Geograf == 'R') {
						$('#cober_Geograf3').attr("checked", "1");
					}
					if (conocimiento.cober_Geograf == 'N') {
						$('#cober_Geograf4').attr("checked", "1");
					}
					if (conocimiento.cober_Geograf == 'I') {
						$('#cober_Geograf5').attr("checked", "1");
					}
					if (conocimiento.importa == 'S') {
						$('#importa').attr("checked", "1");
						ocultaDolaresImporta();
					}
					if (conocimiento.importa == 'N') {
						$('#importa2').attr("checked", "1");
						ocultaDolaresImporta();
					}
					if (conocimiento.dolaresImport == 'DImp') {
						$('#dolaresImport').attr("checked", "1");
					}
					if (conocimiento.dolaresImport == 'DImp2') {
						$('#dolaresImport2').attr("checked", "1");
					}
					if (conocimiento.dolaresImport == 'DImp3') {
						$('#dolaresImport3').attr("checked", "1");
					}
					if (conocimiento.dolaresImport == 'DImp4') {
						$('#dolaresImport4').attr("checked", "1");
					}
					if (conocimiento.dolaresExport == 'DExp') {
						$('#dolaresExport').attr("checked", "1");
					}
					if (conocimiento.dolaresExport == 'DExp2') {
						$('#dolaresExport2').attr("checked", "1");
					}
					if (conocimiento.dolaresExport == 'DExp3') {
						$('#dolaresExport3').attr("checked", "1");
					}
					if (conocimiento.dolaresExport == 'DExp4') {
						$('#dolaresExport4').attr("checked", "1");
					}
					if (conocimiento.exporta == 'S') {
						$('#exporta').attr("checked", "1");
						ocultaDolaresExporta();
					}
					if (conocimiento.exporta == 'N') {
						$('#exporta2').attr("checked", "1");
						ocultaDolaresExporta();
					}
					if (conocimiento.ingAproxMes == 'Ing1') {
						$('#ingAproxMes').attr("checked", "1");
					}
					if (conocimiento.ingAproxMes == 'Ing2') {
						$('#ingAproxMes2').attr("checked", "1");
					}
					if (conocimiento.ingAproxMes == 'Ing3') {
						$('#ingAproxMes3').attr("checked", "1");
					}
					if (conocimiento.ingAproxMes == 'Ing4') {
						$('#ingAproxMes4').attr("checked", "1");
					}
					if (conocimiento.ingAproxMes == 'Ing5') {
						$('#ingAproxMes5').attr("checked", "1");
					}
					deshabilitaBoton('agrega', 'submit');
					habilitaBoton('modifica', 'submit');
					if (conocimiento.PEPs == 'S') {
						$('#PEPs').attr("checked", true);
						$('#PEPs2').attr("checked", false);
						PEPSi();
					} else if (conocimiento.PEPs == 'N') {
						$('#PEPs2').attr("checked", true);
						$('#PEPs').attr("checked", false);
						PEPNo(false);
					}
					if (conocimiento.parentescoPEP == 'S') {
						$('#parentescoPEP').attr("checked", true);
						$('#parentescoPEP2').attr("checked", false);
						parentescoPEPSi();
					} else if (conocimiento.parentescoPEP == 'N') {
						$('#parentescoPEP').attr("checked", false);
						$('#parentescoPEP2').attr("checked", true);
						parentescoPEPNo(false);
					}

					if (conocimiento.banCredOtraEnt == 'S') {
						$('#banCredOtraEnt1').attr("checked", true);
						$('#banCredOtraEnt12').attr("checked", false);
						$('#banCredOtraEnt').val('S');
					} else if (conocimiento.banCredOtraEnt == 'N') {
						$('#banCredOtraEnt1').attr("checked", false);
						$('#banCredOtraEnt12').attr("checked", true);
						$('#banCredOtraEnt').val('N');
					} else {
						$('#banCredOtraEnt1').removeAttr("checked");
						$('#banCredOtraEnt12').removeAttr("checked");
						$('#banCredOtraEnt').val('');
					}
					if (conocimiento.banCredOtraEnt2 == 'S') {
						$('#banCredOtraEnt21').attr("checked", true);
						$('#banCredOtraEnt22').attr("checked", false);
						$('#banCredOtraEnt2').val('S');
					} else if (conocimiento.banCredOtraEnt2 == 'N') {
						$('#banCredOtraEnt21').attr("checked", false);
						$('#banCredOtraEnt22').attr("checked", true);
						$('#banCredOtraEnt2').val('N');
					} else {
						$('#banCredOtraEnt21').removeAttr("checked");
						$('#banCredOtraEnt22').removeAttr("checked");
						$('#banCredOtraEnt2').val('');
					}
					$('#descRelacion1').val('');
					$('#descRelacion2').val('');
					if (conocimiento.tipoRelacion1 != 0) {
						consultaParentesco('tipoRelacion1');
					} else {
						$('#tipoRelacion1').val('');
						$('#descRelacion1').val('');
					}
					if (conocimiento.tipoRelacion2 != 0) {
						consultaParentesco('tipoRelacion2');
					} else {
						$('#tipoRelacion2').val('');
						$('#descRelacion2').val('');
					}

					$('#telefonoRef').setMask('phone-us');
					$('#telefonoRef2').setMask('phone-us');
					$('#telRefCom').setMask('phone-us');
					$('#telRefCom2').setMask('phone-us');
					consultaReferenciasPLD();
					agregaFormatoControles('formaGenerica');
				} else {
					limpiaCampos();

					if (clienteexiste == 1) {
						$('#clienteID').val('');
						$('#nombreCliente').val('');
						$('#clienteID').focus();
						$('#clienteID').select();
						clienteexiste = 0;
						deshabilitaBoton('modifica', 'submit');
					} else {
						$('#nomGrupo').focus();
						$('#nomGrupo').select();
						deshabilitaBoton('modifica', 'submit');
						habilitaBoton('agrega', 'submit');

					}
					asignaValorRadios();
				}
			});

		}
	}

	function consultaCliente(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();
		var tipConForanea = 23;
		setTimeout("$('#cajaLista').hide();", 200);

		if (numCliente != '' && !isNaN(numCliente)) {
			clienteServicio.consulta(tipConForanea, numCliente, { async:false, callback : function(cliente) {
				if (cliente != null) {
					if (cliente.esMenorEdad != 'S') {
						$('#clienteID').val(cliente.numero);
						$('#nombreCliente').val(cliente.nombreCompleto);
						nacionalidad = cliente.nacion;
						nivelRiesgo = cliente.nivelRiesgo;
						$('#nivelRiesgo').val(nivelRiesgo);

						consultaActividadBMX(cliente.actividadBancoMX);

						asignaNivelRiesgo();

					} else {
						clienteexiste = 1;
						mensajeSis("El " + $('#alertSocio').val() + " Es Menor de Edad.");
					}

				} else {
					clienteexiste = 1;
					mensajeSis("No Existe el " + $('#alertSocio').val());

				}
			}, errorHandler : function(message) {
			mensajeSis('Error al Consulta los Parámetros Generales.');
			return false;
		}});
		}
	}

	function consultaFuncionPub(idControl) {
		var jqFuncion = eval("'#" + idControl + "'");
		var numFuncion = $(jqFuncion).val();
		var tipCon = 1;
		setTimeout("$('#cajaLista').hide();", 200);

		var FuncionBeanCon = {
			'funcionID' : numFuncion
		};
		if (numFuncion != '' && !isNaN(numFuncion)) {
			funcionesPubServicio.consulta(tipCon, FuncionBeanCon, function(funcion) {
				if (funcion != null) {
					$('#funcionID').val(funcion.funcionID);
					$('#descripcion').val(funcion.descripcion);

				} else {
					mensajeSis("No Existe la Función");
					$('#funcionID').focus();
					$('#funcionID').select();
				}
			});
		}
	}

	function definicionP(definicion) {
		var data;
		data = '<table align="center"><tr align="center"><td id="encabezadoLista">Definici&oacute;n Persona Politicamente Expuesta(PEPs):' + ' </td></tr><tr><td align="justify"><font face="times new roman" size="3" color="#2E2E2E"> ' + definicion + '</font></td></tr></table>';
		$('#definicionPEP').html(data);
		$.blockUI({
			message : $('#definicionPEP')
		});
		$('.blockOverlay').attr('title', 'Clic para Desbloquear').click($.unblockUI);
	}

});

function ocultaDolaresImporta() {
	if ($('#importa2').is(":checked")) {
		$('#trImporta').hide();
		$('#tdImporta1').hide();
		$('#tdImporta2').hide();
		$('#tdImporta3').hide();
		$('#tdImporta4').hide();
		$('#tdImporta5').hide();
		$('#tdImporta6').hide();
		$('#tdImporta7').hide();
	} else if ($('#importa').is(":checked")) {
		$('#trImporta').show();
		$('#tdImporta1').show();
		$('#tdImporta2').show();
		$('#tdImporta3').show();
		$('#tdImporta4').show();
		$('#tdImporta5').show();
		$('#tdImporta6').show();
		$('#tdImporta7').show();
	}
}

function ocultaDolaresExporta() {
	if ($('#exporta2').is(":checked")) {
		$('#tdExportaDolar').hide();
		$('#tdExportaPais').hide();
		$('#trExporta1').hide();
		$('#trExporta2').hide();
		$('#trExporta3').hide();
		$('#trExporta4').hide();
	} else if ($('#exporta').is(":checked")) {
		$('#tdExportaDolar').show();
		$('#tdExportaPais').show();
		$('#trExporta1').show();
		$('#trExporta2').show();
		$('#trExporta3').show();
		$('#trExporta4').show();
	}
}

function exitoConocimiento() {
	deshabilitaBoton('modifica', 'submit');
	deshabilitaBoton('agrega', 'submit');
	inicializaForma('formaGenerica', 'clienteID');
	$('#banCredOtraEnt1').removeAttr("checked");
	$('#banCredOtraEnt12').removeAttr("checked");
	$('#banCredOtraEnt21').removeAttr("checked");
	$('#banCredOtraEnt22').removeAttr("checked");
	$('#tiposClientes').val('');
	$('#instrumentosMonetarios').val('');
	$("#nivelRiesgo").val('');
	$('#ingAproxMes').attr("checked", "1");
	$('#evaluaXMatriz1').attr('checked', true);
}

function falloConocimiento() {

}

//Asigna valores por defaul
function asignaValorRadios() {
	PEPNo(true);
	parentescoPEPNo(true);
	$('#cober_Geograf').attr('checked', true);
	$('#dolaresImport').attr('checked', true);
	$('#dolaresExport').attr('checked', true);
	$('#ingAproxMes').attr('checked', true);
	exportaNo();
	importaNo();
	$('#cober_Geograf').val('L');
	$('#dolaresImport').val('DImp');
	$('#dolaresExport').val('DExp');
	$('#ingAproxMes').val('Ing1');
}
function limpiaCampos() {
	$('#nomGrupo').val('');
	$('#RFC').val('');
	$('#participacion').val('');
	$('#nacionalidad').val('');
	$('#razonSocial').val('');
	$('#giro').val('');
	$('#tiempoOperacion').val('');
	$('#tiempoGiro').val('');

	$('#PEPs2').attr("checked", true);
	$('#parentescoPEP2').attr("checked", true);
	$('#importa2').attr("checked", true);
	$('#exporta2').attr("checked", true);
	PEPNo(true);
	parentescoPEPNo(true);
	importaNo();
	exportaNo();
	$('#funcionID').val('');
	$('#descripcion').val('');
	$('#nombFamiliar').val('');
	$('#aPaternoFam').val('');
	$('#aMaternoFam').val('');
	$('#noEmpleados').val('');
	$('#serv_Produc').val('');
	$('#cober_Geograf').attr("checked", "1");
	$('#estados_Presen').val('');
	$('#importeVta').val('');
	$('#activos').val('');
	$('#pasivos').val('');
	$('#dolaresImport').attr("checked", "1");
	$('#paisesImport').attr("checked", "1");
	$('#capital').val('');
	$('#dolaresExport').attr("checked", "1");
	$('#paisesExport').attr("checked", "1");
	$('#nombRefCom').val('');
	$('#noCuentaRefCom').val('');
	$('#direccionRefCom').val('');
	$('#telRefCom').val('');
	$('#nombRefCom2').val('');
	$('#noCuentaRefCom2').val('');
	$('#direccionRefCom2').val('');
	$('#telRefCom2').val('');
	$('#bancoRef').val('');
	$('#banTipoCuentaRef').val('');
	$('#noCuentaRef').val('');
	$('#banSucursalRef').val('');
	$('#banNoTarjetaRef').val('');
	$('#banTarjetaInsRef').val('');
	$('#banCredOtraEnt1').removeAttr("checked");
	$('#banCredOtraEnt12').removeAttr("checked");
	$('#banCredOtraEnt').val('');
	$('#banInsOtraEnt').val('');
	$('#bancoRef2').val('');
	$('#banTipoCuentaRef2').val('');
	$('#noCuentaRef2').val('');
	$('#banSucursalRef2').val('');
	$('#banNoTarjetaRef2').val('');
	$('#banTarjetaInsRef2').val('');
	$('#banCredOtraEnt21').removeAttr("checked");
	$('#banCredOtraEnt22').removeAttr("checked");
	$('#banCredOtraEnt2').val('');
	$('#banInsOtraEnt2').val('');
	$('#nombreRef').val('');
	$('#domicilioRef').val('');
	$('#telefonoRef').val('');
	$('#nombreRef2').val('');
	$('#domicilioRef2').val('');
	$('#telefonoRef2').val('');
	$('#pFuenteIng').val('');
	$('#ingAproxMes').attr("checked", "1");
	$('#extTelefonoRefUno').val('');
	$('#extTelefonoRefDos').val('');
	$('#extTelRefCom').val('');
	$('#extTelRefCom2').val('');
	$('#tipoRelacion1').val('');
	$('#tipoRelacion2').val('');
	$('#descRelacion1').val('');
	$('#descRelacion2').val('');
	$('#capitalContable').val('');

	$('#comentarioNivel').val('');
	$('#fechaNombramiento').val('');
	$('#porcentajeAcciones').val('');
	$('#periodoCargo').val('');
	$('#montoAcciones').val('');
	$('#tiposClientes').val('');
	$('#instrumentosMonetarios').val('');
	$('#evaluaXMatriz1').attr('checked', true);
	$('#operacionAnios').val('0');
	$('#giroAnios').val('0');
}

function PEPSi() {
	$('#tdLabelFuncion').show();
	$('#tdFuncionID').show();
	$('#tdSeparador').show();
	$('#noEmpleados').show();
	$('#trNombramientoPorcen').show();
	$('#trPeriodoMonto').show();
	$('#PEPs').val('S');
	if ((nacionalidad == 'E' && esPep == 'S') || (nivelRiesgo == 'A')) {
		$("#datosAdicionalesCteAltoRiesgo").show(500);
	} else {
		limpiaPreguntasCte();
	}
}

function PEPNo(inicializa) {
	$('#tdLabelFuncion').hide();
	$('#tdFuncionID').hide();
	$('#tdSeparador').hide();
	$('#trNombramientoPorcen').hide();
	$('#trPeriodoMonto').hide();

	$('#PEPs2').val('N');
	if (inicializa) {
		$('#funcionID').val('');
		$('#descripcion').val('');
	}

	if (nivelRiesgo != 'A' || nivelRiesgoActividad == 'B' || nivelRiesgoActividad == 'M') {
		limpiaPreguntasCte();
	}
}

function iniciaPEPS() {
	esPep = $('input[name=PEPs]:checked').val();
	if (esPep == 'S') {
		PEPSi();
	} else if (esPep == 'N') {
		PEPNo(true);
	}
}

function parentescoPEPSi() {
	$('#trFamiliar').show();
	$('#tdLabelApellidoMaterno').show();
	$('#tdApellidoMaterno').show();
	$('#parentescoPEP').val('S');
}

function parentescoPEPNo(inicializa) {
	$('#trFamiliar').hide();
	$('#tdLabelApellidoMaterno').hide();
	$('#tdApellidoMaterno').hide();
	$('#parentescoPEP2').val('N');
	if (inicializa) {
		$('#nombFamiliar').val('');
		$('#aPaternoFam').val('');
		$('#aMaternoFam').val('');
	}
}

function iniciaParentescoPEPS() {
	parentescoPep = $('input[name=parentescoPEP]:checked').val();
	if (parentescoPep == 'S') {
		parentescoPEPSi();
	} else if (parentescoPep == 'N') {
		parentescoPEPNo(true);
	}
}

function importaNo() {
	$('#dolaresImport').attr('checked', false);
	$('#dolaresImport2').attr('checked', false);
	$('#dolaresImport3').attr('checked', false);
	$('#dolaresImport4').attr('checked', false);
	$('#paisesImport').val('');
	$('#paisesImport2').val('');
	$('#paisesImport3').val('');
	$('#importa2').val('N');
	ocultaDolaresImporta();
}

function importaSi() {
	$('#trImporta').show();
	$('#tdImporta1').show();
	$('#tdImporta2').show();
	$('#tdImporta3').show();
	$('#tdImporta4').show();
	$('#tdImporta5').show();
	$('#tdImporta6').show();
	$('#tdImporta7').show();
	$('#dolaresImport').attr('checked', false);
	$('#dolaresImport2').attr('checked', false);
	$('#dolaresImport3').attr('checked', false);
	$('#dolaresImport4').attr('checked', false);
	$('#paisesImport').val('');
	$('#paisesImport2').val('');
	$('#paisesImport3').val('');
	$('#importa').val('S');
	ocultaDolaresImporta();
}

function iniciaImporta() {
	importa = $('input[name=importa]:checked').val();
	if (importa == 'S') {
		importaSi();
	} else if (importa == 'N') {
		importaNo();
	}
}

function exportaNo() {
	$('#dolaresExport').attr("checked", false);
	$('#dolaresExport2').attr("checked", false);
	$('#dolaresExport3').attr("checked", false);
	$('#dolaresExport4').attr('checked', false);
	$('#paisesExport').val('');
	$('#paisesExport2').val('');
	$('#paisesExport3').val('');
	$('#exporta2').val('N');
	ocultaDolaresExporta();
}

function exportaSi() {
	$('#tdExportaDolar').show();
	$('#tdExportaPais').show();
	$('#trExporta1').show();
	$('#trExporta2').show();
	$('#trExporta3').show();
	$('#trExporta4').show();
	$('#dolaresExport').attr("checked", false);
	$('#dolaresExport2').attr("checked", false);
	$('#dolaresExport3').attr("checked", false);
	$('#dolaresExport4').attr('checked', false);
	$('#paisesExport').val('');
	$('#paisesExport2').val('');
	$('#paisesExport3').val('');
	$('#exporta').val('S');
	ocultaDolaresExporta();
}

function iniciaExporta() {
	exporta = $('input[name=exporta]:checked').val();
	if (exporta == 'S') {
		exportaSi();
	} else if (exporta == 'N') {
		exportaNo();
	}
}

//Inicializa los valores del campo credito con otra entidad a vacio
function iniciaBanCredOtraEnt() {
	$('#banCredOtraEnt1').attr("checked", false);
	$('#banCredOtraEnt2').attr("checked", false);
	$('#banCredOtraEnt1').val('');
	$('#banCredOtraEnt2').val('');
	$('#banCredOtraEnt21').attr("checked", false);
	$('#banCredOtraEnt22').attr("checked", false);
	$('#banCredOtraEnt21').val('');
	$('#banCredOtraEnt22').val('');
}

function limpiaPreguntasCte() {
	$("#datosAdicionalesCteAltoRiesgo").hide();
	$('#preguntaCte1').val('');
	$('#respuestaCte1').val('');
	$('#preguntaCte2').val('');
	$('#respuestaCte2').val('');
	$('#preguntaCte3').val('');
	$('#respuestaCte3').val('');
	$('#preguntaCte4').val('');
	$('#respuestaCte4').val('');
}

function asignaNivelRiesgo() {
	if (nivelRiesgo == 'A' || (nacionalidad == 'E' && esPep == 'S')) {
		$("#datosAdicionalesCteAltoRiesgo").show(500);
	} else if (nivelRiesgo == 'B') {
		$("#datosAdicionalesCteAltoRiesgo").hide(500);
	}
}

function consultaActividadBMX(idActividad) {
	var numActividad = Number(idActividad);
	var tipConCompleta = 3;
	setTimeout("$('#cajaLista').hide();", 200);

	if (numActividad > 0) {

		actividadesServicio.consultaActCompleta(tipConCompleta, idActividad, function(actividadComp) {
			if (actividadComp != null) {
				nivelRiesgoActividad = actividadComp.claveRiesgo;
			} else {}
		});
	}
}
function consultaReferenciasPLD() {
	var clienteBean = {
	'solicitudCreditoID' : 0,
	'clienteID' : $('#clienteID').val()
	};
	referenciaClienteServicio.lista(catListaReferencia.pld, clienteBean, function(referencias) {
		if (referencias != null) {
			if ($('#nombRefCom').val() == '') {
				if (referencias.length > 0) {
					$('#nombRefCom').val(referencias[0].nombreCompleto);
					$('#telRefCom').val(referencias[0].telefono);
					$('#extTelRefCom').val(referencias[0].extTelefonoPart);
				}
			}
			if ($('#nombRefCom2').val() == '') {
				if (referencias.length > 1) {
					$('#nombRefCom2').val(referencias[1].nombreCompleto);
					$('#telRefCom2').val(referencias[1].telefono);
					$('#extTelRefCom2').val(referencias[1].extTelefonoPart);
				}
			}
		}
	});
}

function mostrarOC() {
	var mostrar = false;
	var numeroUsuario = parametroBean.numeroUsuario;
	var tipoCon = 1;
	var ParametrosSisBean = {
		'empresaID' : 1
	};

	habilitaBoton('modificar', 'submit');
	parametrosSisServicio.consulta(tipoCon, ParametrosSisBean, { async:false, callback : function(parametrosSisBean) {
		if (parametrosSisBean != null) {
			dwr.util.setValues(parametrosSisBean);
			var oficial = parametrosSisBean.oficialCumID;
			var puedeModificar = parametrosSisBean.modNivelRiesgo;
			if (Number(oficial) == Number(numeroUsuario)) {
				mostrar = true;
				if (puedeModificar == 'S') {
					habilitaControl('nivelRiesgo');
				} else {
					deshabilitaControl('nivelRiesgo');
				}
			} else {
				mostrar = false;
			}
		} else {
			mostrar = false;
		}
		mostrarElementoPorClase("mostrarOC", mostrar);
	}, errorHandler : function(message) {
		mensajeSis('Error al Consulta los Parámetros Generales.');
		return false;
	}});
}

function esFechaValida(fecha){
	if (fecha != undefined && fecha != '' && fecha != NaN){
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
			mensajeSis("Fecha introducida errónea");
		return false;
		}
		if (dia>numDias || dia==0){
			mensajeSis("Fecha introducida errónea");
			return false;
		}
		return true;
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

function validaPorcentajeAcciones(){
	var porcentajeAcciones = $('#porcentajeAcciones').asNumber();
	var porcentajeAccionesVal = $('#porcentajeAcciones').val();
	if (porcentajeAccionesVal != '' && porcentajeAccionesVal != NaN ){
		if(porcentajeAcciones <= 0){
			mensajeSis('El Porcentaje de las acciones debe ser mayor a CERO');
			$('#porcentajeAcciones').val('');
			$('#porcentajeAcciones').focus(10);

		}else if(porcentajeAcciones > 100.00){
			mensajeSis('El Porcentaje de las acciones no debe ser mayor a 100');
			$('#porcentajeAcciones').val('');
			$('#porcentajeAcciones').focus(10);
		}
	}
}

function validaMontoAcciones(){
	var montoAcciones = $('#montoAcciones').asNumber();
	var montoAccionesVal = $('#montoAcciones').val();
	if (montoAccionesVal != '' && montoAccionesVal != NaN ){
		if(montoAcciones <= 0){
			mensajeSis('El Monto de las acciones debe ser mayor a CERO');
			$('#montoAcciones').val('');
			$('#montoAcciones').focus(10);
		}
	}
}


function funcionIsNumeric(input){ 
    var RE = /^-{0,1}\d*\.{0,1}\d+$/; 
    return (RE.test(input)); 
}

function validaOperacionAnios(){
	var operacionAnios = $('#operacionAnios').asNumber();
	var operacionAniosVal = $('#operacionAnios').val();
	
	if(operacionAniosVal.length > 0) {		
		if(funcionIsNumeric(operacionAniosVal)) {
			if(operacionAnios < 0){
				mensajeSis('El Valor del campo "Años de Operación" debe ser Mayor o Igual a Cero');
				$('#operacionAnios').val('');
				$('#operacionAnios').focus(2);
			}
		} else{
			mensajeSis('El Valor del Campo "Años de Operación" debe tener un Valor Numérico');
			$('#operacionAnios').val('');
			$('#operacionAnios').focus(2);
		}
	} else {
		$('#operacionAnios').val('0');
	}
}

function validaGiroAnios(){
	var giroAnios = $('#giroAnios').asNumber();
	var giroAniosVal = $('#giroAnios').val();
	// ...
	if(giroAniosVal.length > 0) {		
		if(funcionIsNumeric(giroAniosVal)){
			if(giroAnios < 0){
				mensajeSis('El Valor del Campo "Años de Giro" debe ser Mayor o Igual a Cero');
				$('#giroAnios').val('');
				$('#giroAnios').focus(2);
			}
		}
		else{
			mensajeSis('El Valor del Campo "Años de Giro" debe tener un Valor Numérico');
			$('#giroAnios').val('');
			$('#giroAnios').focus(2);
		}
	} else {
		$('#giroAnios').val('0');
	}
}