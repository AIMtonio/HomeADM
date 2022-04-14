
//Definicion de Constantes y Enums
	var catTipoConsultaPromotor = {
			'principal':1,
			'foranea':2,
			'promotorAct' :3
	};
$(document).ready(function() {
	validaEmpresaID();
	$("#lblAdeudoProfun").hide();
	$("#tdadeudoPROFUN").hide();
	//------------ Metodos y Manejo de Eventos -----------------------------------------

	$(':text').focus(function() {
		esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$('#numeroTarjeta').bind('keypress', function(e){
		return validaAlfanumerico(e,this);
	});

	$('#numeroTarjeta').blur(function(e){
		var longitudTarjeta=$('#numeroTarjeta').val().length;
		if (longitudTarjeta<16){
			$('#numeroTarjeta').val("");
		}else{
			consultaClienteIDTarDeb('numeroTarjeta');
		}
	});


	//Función para poder ingresar solo números o letras
	function validaAlfanumerico(e,elemento){//Recibe al evento
		var key;
		if(window.event){//Internet Explorer ,Chromium,Chrome
			key = e.keyCode;
		}else if(e.which){//Firefox , Opera Netscape
				key = e.which;
		}
		 if (key > 31 && (key < 48 ||  key > 57) && (key <65 || key >90) && (key<97 || key >122)) //Comparación con código ascii
		    return false;
		 var longitudTarjeta=$('#numeroTarjeta').val().length;
		 		if (longitudTarjeta == 16 ){
					consultaClienteIDTarDeb('numeroTarjeta');
				}
		 return true;


	}


	 $('#numero').bind('keyup',function(e){
		 if(this.value.length >= 2){
			var camposLista = new Array();
		    var parametrosLista = new Array();
		    	camposLista[0] = "nombreCompleto";
		    	parametrosLista[0] = $('#numero').val();
		 listaContenedor('numero', '2', '1', camposLista, parametrosLista, 'listaCliente.htm'); }
	 });


	$('#numero').blur(function() {
			consultaClienteResumen(this.id);
	});


	$( '#tabs' ).tabs({
		ajaxOptions: {
			error: function( xhr, status, index, anchor ) {
				$( anchor.hash ).html(
						"No es posible mostrar la pestaña. Estamos trabajando para repararla lo antes posible. ");
			}
		}
	});




	// ---------------------- PERFIL DEL CLIENTE ------------------------------------
	function consultaClienteResumen(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();
		var tipConForanea = 1;

		setTimeout("$('#cajaListaContenedor').hide();", 200);
		if(numCliente != '' && !isNaN(numCliente) && esTab == true){
			clienteServicio.consulta(tipConForanea,numCliente,function(cliente) {
				if(cliente!=null){
					dwr.util.setValues(cliente);
					$('#numero').val(cliente.numero);
					$('#nom').html(cliente.nombreCompleto);
					$('#nombreCliente').val(cliente.nombreCompleto);
					$('#promotorActual').val(cliente.promotorActual);
					$('#sucursalOrigen').val(cliente.sucursalOrigen);
					$('#tipoSociedadID').val(cliente.tipoSociedadID);
					$('#grupoEmpresarial').val(cliente.grupoEmpresarial);
					$('#telefonoCasa').setMask('phone-us');


					if(cliente.tipoPersona == 'F'){
						$('#tipoPersona').val('FÍSICA');
						$('#personaMoral').hide(500);
					}else{
						if(cliente.tipoPersona == 'A'){
							$('#tipoPersona').val('FÍSICA ACT. EMP.');
							$('#personaMoral').show(500);
						}else{
							$('#tipoPersona').val('MORAL');
							$('#personaMoral').show(500);
						}
					}
					if(cliente.sexo == 'F'){
						$('#sexo').val('FEMENINO');
					}else{
						$('#sexo').val('MASCULINO');
					}
					if(cliente.nacion == 'N'){
						$('#nacion').val('NACIONAL');
					}else{
						$('#nacion').val('EXTRANJERO');
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

					$('#actividadBancoMX').val(cliente.actividadBancoMX);
					$('#ocupacionID').val(cliente.ocupacionID);
					esTab =true;
					consultaActividadBMX('actividadBancoMX');
					consultaOcupacion('ocupacionID');
					consultaMontoAdeudoPROFUN('numero');
					consultaPromotorA('promotorActual');
					consultaSucursal('sucursalOrigen');
					consultaSociedad('tipoSociedadID');
					consultaGEmpres('grupoEmpresarial');
					ConsultaFotoCte('numero');
					consultaAhoCte(cliente.numero);
					consultaInvCte(cliente.numero);
					consultaCreditoCte(cliente.numero);
					consultaCreditosAvalados(cliente.numero);
					consultaAvalesCliente(cliente.numero);
					consultaCedeCte(cliente.numero);
					consultaAportaciones(cliente.numero);
				}else{
					mensajeSis("No Existe el Cliente.");
					$('#nom').html('');
					$('#numero').focus();
					$('#numero').val('');
				}
			});
		}
	}


	function consultaPromotorA(idControl) {
		var jqPromotor = eval("'#" + idControl + "'");
		var numPromotor = $(jqPromotor).val();

		if(numPromotor != '' && !isNaN(numPromotor) && esTab){
			var promotor = {
				'promotorID': numPromotor
			};
			promotoresServicio.consulta(catTipoConsultaPromotor.foranea,promotor,function(promotor) {
				if(promotor!=null){
					$('#promotorActual').val(promotor.nombrePromotor);
				}else{
					mensajeSis("No Existe el Promotor.");
				}
			});
		}
	}

	function consultaSucursal(idControl) {
		var jqSucursal = eval("'#" + idControl + "'");
		var numSucursal = $(jqSucursal).val();
		var conSucursal=2;

		if(numSucursal != '' && !isNaN(numSucursal) && esTab){
			sucursalesServicio.consultaSucursal(conSucursal,numSucursal,function(sucursal) {
				if(sucursal!=null){
					$('#sucursalOrigen').val(sucursal.nombreSucurs);
				}else{
					mensajeSis("No Existe la Sucursal.");
				}
			});
		}
	}

	function consultaActividadBMX(idControl) {
		var jqActividad = eval("'#" + idControl + "'");
		var numActividad = $(jqActividad).val();
		var tipConCompleta = 3;

		if(numActividad != '' && !isNaN(numActividad) && esTab){
			actividadesServicio.consultaActCompleta(tipConCompleta, numActividad,function(actividadComp) {
				if(actividadComp!=null){
					$('#actividadBancoMX').val(actividadComp.descripcionBMX);
					$('#actividadINEGI').val(actividadComp.descripcionINE);
					$('#sectorEconomico').val(actividadComp.descripcionSEC);
				}else{
					mensajeSis("No Existe la Actividad BMX.");
				}
			});
		}
	}

	function consultaOcupacion(idControl) {
		var jqOcupacion = eval("'#" + idControl + "'");
		var numOcupacion = $(jqOcupacion).val();
		var tipConForanea = 2;

		if(numOcupacion != '' && !isNaN(numOcupacion) && esTab){
			ocupacionesServicio.consultaOcupacion(tipConForanea,numOcupacion,function(ocupacion) {
				if(ocupacion!=null){
					$('#ocupacionID').val(ocupacion.descripcion);
				}else{
					var tp= $('#tipoPersona').val();
					if(tp == 'F'){
						mensajeSis("No Existe la Ocupación.");
						$('#ocupacionID').focus();
					}
				}
			});
		}
	}






	function consultaSociedad(idControl) {
		var jqSociedad = eval("'#" + idControl + "'");
		var numSociedad = $(jqSociedad).val();
		var tipoConForanea= 2;
		setTimeout("$('#cajaLista').hide();", 200);
		var SociedadBeanCon = {
			'tipoSociedadID':numSociedad
		};
		if(numSociedad != '' && !isNaN(numSociedad) && esTab){
			tipoSociedadServicio.consulta(tipoConForanea,SociedadBeanCon,function(sociedad) {
				if(sociedad!=null){
					$('#tipoSociedadID').val(sociedad.descripcion);
				}else{
					var tp= $('#tipoPersona').val();
					if(tp == 'M'){
						mensajeSis("No Existe el Tipo de Sociedad.");
					}
				}
			});
		}
	}

	function consultaGEmpres(idControl) {
		var jqGempresa = eval("'#" + idControl + "'");
		var numGempresa = $(jqGempresa).val();
		var conGempresa=2;

		if(numGempresa != '' && !isNaN(numGempresa) && esTab){
			gruposEmpServicio.consulta(conGempresa,numGempresa,function(empresa) {
				if(empresa!=null){
					$('#grupoEmpresarial').val(empresa.nombreGrupo);

				}else{
				var tp= $('#tipoPersona').val();
				if(tp == 'M'){
					mensajeSis("No Existe el Grupo.");}
				}
			});
		}
	}
	// Consulta el monto adeudado de PROFUN
	function  consultaMontoAdeudoPROFUN(controlID){
		var jqCliente  = eval("'#" + controlID + "'");
		var clienteID = $(jqCliente).val();
		var numConsulta =2;
		var bean = {
				'clienteID'		: clienteID
			};
		if(clienteID != '' && !isNaN(clienteID)){
			clientesPROFUNServicio.consulta(numConsulta,bean,function(adeudo){
						if(adeudo!=null){
							// setea en los campos en los que se muestra esa informacion
							if(adeudo.numClientesProfun >0){
								$("#lblAdeudoProfun").show();
								$("#tdadeudoPROFUN").show();
								$("#adeudoPROFUN").val(adeudo.montoPendiente);
							}else{
								$("#lblAdeudoProfun").hide();
								$("#tdadeudoPROFUN").hide();
							}
						}else{
							$("#adeudoPROFUN").val("0.00");
						}
				});
			}
	}

	// ---------------------  PRODUCTOS DEL CLIENTE  ---------------------------------

	function consultaCreditosAvalados(clienteID){
		var params = {};
		params['tipoLista'] = 27;
		params['clienteID'] = clienteID;
		if (clienteID != '' && !isNaN(clienteID)){
			$.post("resumenCteCreditosAvalados.htm", params, function(dat){
				if(dat.length >0) {
					$('#gridCreditosAvalados').html(dat);
					$('#gridCreditosAvalados').show();
				}else{
					$('#gridCreditosAvalados').html("");
					$('#gridCreditosAvalados').show();
				}
			});
		}
	}

	function consultaCreditoCte(clienteID){
		var params = {};
		params['tipoLista'] = 7;
		params['clienteID'] = clienteID;
		if (clienteID != '' && !isNaN(clienteID)){
			$.post("resumenCteCredGrid.htm", params, function(dat){
				if(dat.length >0) {
					$('#gridCredCte').html(dat);
					$('#gridCredCte').show();
				}else{
					$('#gridCredCte').html("");
					$('#gridCredCte').show();
				}
			});
		}
	}

	function consultaInvCte(clienteID){
		if (clienteID != '' && !isNaN(clienteID)){
			var params = {};
			params['tipoLista'] = 2;
			params['clienteID'] = clienteID;
			$.post("resumenCteInvGrid.htm", params, function(dat){
				if(dat.length >0) {
					$('#gridInvCte').html(dat);
					$('#gridInvCte').show();
				}else{
					$('#gridInvCte').html("");
					$('#gridInvCte').show();
				}
			});
		}
	}

	function consultaAvalesCliente(clienteID){

		var params = {};
		params['tipoLista'] = 3;
		params['clienteID'] = clienteID;
		if (clienteID != '' && !isNaN(clienteID)){
			$.post("resumenAvalesCliente.htm", params, function(dat){
				if(dat.length >0) {
					$('#gridMisAvales').html(dat);
					$('#gridMisAvales').show();
				}else{
					$('#gridMisAvales').html("");
					$('#gridMisAvales').show();
				}
			});
		}
	}


	function consultaCedeCte(clienteID){
		if (clienteID != '' && !isNaN(clienteID)){
			var params = {};
			params['tipoLista'] = 3;
			params['clienteID'] = clienteID;
			$.post("resumenCteCedeGrid.htm", params, function(dat){
				if(dat.length >0) {
					$('#gridCedeCte').html(dat);
					$('#gridCedeCte').show();
				}else{
					$('#gridCedeCte').html("");
					$('#gridCedeCte').show();
				}
			});
		}
	}

	function consultaAportaciones(clienteID){
		if (clienteID != '' && !isNaN(clienteID)){
			var params = {};
			params['tipoLista'] = 3;
			params['clienteID'] = clienteID;
			$.post("resumenAportGrid.htm", params, function(dat){
				if(dat.length >0) {
					$('#gridAportaciones').html(dat);
					$('#gridAportaciones').show();
				}else{
					$('#gridAportaciones').html("");
					$('#gridAportaciones').show();
				}
			});
		}
	}


	//----------------- DIRECCION DEL CLIENTE ----------------------------
	$('#direccionesCte').click(function() {
		if ($(this).attr("href") != undefined ){
			consultaDireccion();
		}
	});


	function consultaDireccion(cte){
		$('#direcciones').load("mapaDireccion.htm");
	}


	function validaEmpresaID() {
		var numEmpresaID = 1;
		var tipoCon = 1;
		var ParametrosSisBean = {
				'empresaID'	:numEmpresaID
		};
		parametrosSisServicio.consulta(tipoCon,ParametrosSisBean,function(parametrosSisBean) {
			if (parametrosSisBean != null) {
				if(parametrosSisBean.servReactivaCliID !=null){

						if(parametrosSisBean.tarjetaIdentiSocio=="S"){
							$('#tarjetaIdentiCA').show();
							$('#numeroTarjeta').val("");
							$('#idCtePorTarjeta').val("");
							$('#nomTarjetaHabiente').val("");
							$("#numeroTarjeta").focus();
						}else{
							$("#numero").focus();
							$('#tarjetaIdentiCA').hide();
							$('#numeroTarjeta').val("");
							$('#idCtePorTarjeta').val("");
							$('#nomTarjetaHabiente').val("");
						}
				}else{

				}
			}
		});
	}


	function consultaClienteIDTarDeb(control){
		var jqControl=	eval("'#" + control + "'");
		var numeroTar=$(jqControl).val();
		var numTarIdenAccess=numeroTar.replace(/[%&(=?¡'{-|})><ĸ¬°Çü½«»~÷Ø§ç¨`^€¶ŧ←↓→øþæßðđŋħł¢“µ·½\/\]\]\[\”\\]/gi, '');
			numTarIdenAccess=numTarIdenAccess.replace(/[_]/gi,'');
			numTarIdenAccess=numTarIdenAccess.replace(/[' ']/gi,''); // Quitamos los espacios en blanco
			numeroTar=numTarIdenAccess;

		$(jqControl).val(numeroTar);
		var conNumTarjeta=20;
		var TarjetaBeanCon = {
				'tarjetaDebID'	:numeroTar
			};

		if(numeroTar != '' && numeroTar > 0){
			if ($(jqControl).val().length>16){
				mensajeSis("El Número de Tarjeta es Incorrecto deben de ser 16 dígitos");
				$(jqControl).val("");
				$(jqControl).focus();
			}
			if($(jqControl).val().length == 16){
				tarjetaDebitoServicio.consulta(conNumTarjeta,TarjetaBeanCon,function(tarjetaDebito) {
					if(tarjetaDebito!=null){
						if (tarjetaDebito.estatusId==7){
							$('#idCtePorTarjeta').val(tarjetaDebito.clienteID);
							$('#nomTarjetaHabiente').val(tarjetaDebito.nombreCompleto);
							if ($('#numeroTarjeta').val()!=""&& $('#idCtePorTarjeta').val()!=""){
								$('#numero').val($('#idCtePorTarjeta').val());
								esTab=true;
								consultaClienteResumen('numero');
							}
							$('#numero').focus();
							$('#numeroTarjeta').val("");
							$('#idCtePorTarjeta').val("");
						}else{
								if (tarjetaDebito.estatusId==1){
									mensajeSis("La Tarjeta no se Encuentra Asociada a una Cuenta");
								}else
								if (tarjetaDebito.estatusId==6){
									mensajeSis("La Tarjeta no se Encuentra Activa");
								}else
								if (tarjetaDebito.estatusId==8){
									mensajeSis("La Tarjeta se Encuentra Bloqueada");
								}else
								if (tarjetaDebito.estatusId==9){
									mensajeSis("La Tarjeta se Encuentra Cancelada");
								}
								$(jqControl).focus();
								$(jqControl).val("");
								$('#idCtePorTarjeta').val("");
								$('#nomTarjetaHabiente').val("");
								$('#gridAhoCte').html("");
								$('#gridAhoCte').show();
								$('#numero').val("");
								$('#nom').html("");
								$('#nombreCliente').val("");
								$('#promotorActual').val("");
								$('#sucursalOrigen').val("");
								$('#tipoSociedadID').val("");
								$('#grupoEmpresarial').val("");
								$('#telefonoCasa').val('');
								$('#correo').val('');
								$('#gridInvCte').html("");
								$('#gridInvCte').show();
								$('#gridCredCte').html("");
								$('#gridCredCte').show();
								$('#gridCreditosAvalados').html("");
								$('#gridCreditosAvalados').show();
								$('#tipoPersona').val("");
								$('#fechaAlta').val("");
								$('#adeudoPROFUN').val("");
								$('#sexo').val("");
								$('#fechaNacimiento').val("");
								$('#nacion').val("");
								$('#estadoCivil').val("");
								$('#actividadBancoMX').val("");
								$('#actividadINEGI').val("");
								$('#sectorEconomico').val("");
								$('#ocupacionID').val("");
								$('#puesto').val("");
								$('#personaMoral').hide();
								var source = 'images/user.jpg';
								$('#imgCliente').attr("src",source);
						}
					}else{
						mensajeSis("La Tarjeta de Identificación no existe.");
						$(jqControl).focus();
						$(jqControl).val("");
						$('#idCtePorTarjeta').val("");
						$('#nomTarjetaHabiente').val("");
						$('#nom').html('');
						$('#numero').val('');
						$('#gridAhoCte').html("");
						$('#gridAhoCte').show();
						$('#numero').val("");
						$('#nom').html("");
						$('#nombreCliente').val("");
						$('#promotorActual').val("");
						$('#sucursalOrigen').val("");
						$('#tipoSociedadID').val("");
						$('#grupoEmpresarial').val("");
						$('#telefonoCasa').val('');
						$('#gridInvCte').html("");
						$('#gridInvCte').show();
						$('#gridCredCte').html("");
						$('#gridCredCte').show();
						$('#gridCreditosAvalados').html("");
						$('#gridCreditosAvalados').show();
						$('#tipoPersona').val("");
						$('#fechaAlta').val("");
						$('#adeudoPROFUN').val("");
						$('#sexo').val("");
						$('#fechaNacimiento').val("");
						$('#nacion').val("");
						$('#estadoCivil').val("");
						$('#actividadBancoMX').val("");
						$('#actividadINEGI').val("");
						$('#sectorEconomico').val("");
						$('#ocupacionID').val("");
						$('#puesto').val("");
						$('#correo').val('');
						$('#personaMoral').hide();
						var source = 'images/user.jpg';
						$('#imgCliente').attr("src",source);
					}
					});
				}
			}
		 }

});  //FIN

function convierteStrInt(jControl){
	var valor=($(jControl).formatCurrency({
					positiveFormat: '%n',
					roundToDecimalPlace: 2
				})).asNumber();
	return  parseFloat(valor);
}
// se manda a llamar desde cuentas/resumenCteGridVista,jsp

function pegaHtml(cuentaAhoID, saldoBloq ){
	var  catTipoListaBloqPrincipal=1;
	if(!isNaN(cuentaAhoID)){
		var parametroBean = consultaParametrosSession();
		var fechaSucursal =parametroBean.fechaSucursal;
		var mesSucursal = fechaSucursal.substr(5,2);
		var anioSucursal = fechaSucursal.substr(0,4);

		var params = {};
		params['cuentaAhoID'] = cuentaAhoID;
		params['tipoLista'] =  catTipoListaBloqPrincipal;
		params['anio'] = anioSucursal;
		params['mes'] = mesSucursal;

		$.post("listaBloqueo.htm", params, function(data){
			if(data.length >0) {
				$('#bloq').html(data);
				$('#bloq').show();


			}else{
				$('#bloq').html("");
				$('#bloq').show();
			}
		});

		$.blockUI({message: $('#bloq'),
			css: {
				top:  ($(window).height() - 400)  + 'px',
				left: ($(window).width() - 1100)  + 'px',
				width: '900px'
			} });
		$('.blockOverlay').attr('title','Clic para Desbloquear').click($.unblockUI);
	}
}

function consultaAhoCte(numCliente){
	var params = {};
	params['tipoLista'] = 4;
	params['clienteID'] = numCliente;
	if (numCliente != '' && !isNaN(numCliente)){
		$.post("resumenCteAhoGrid.htm", params, function(data){
			if(data.length >0) {
				$('#gridAhoCte').html(data);
				$('#gridAhoCte').show();
			}else{
				$('#gridAhoCte').html("");
				$('#gridAhoCte').show();
			}
		});
	}
}
function ConsultaFotoCte(idControl) {
	var jqCte = eval("'#" + idControl + "'");
	var numCte = $(jqCte).val();
	var tipConVerImgCte = 13;
	var fotoBeanCon = {
			'clienteID':$('#numero').val(),
			'tipoDocumento':'1',
			'prospectoID' :'0'
	};
	clienteArchivosServicio.consulta(tipConVerImgCte,fotoBeanCon,function(archivo) {
		if(archivo!=null){
			var parametros = "?clienteID="+numCte+"&tipoConsulta="+tipConVerImgCte;
			var recursos= archivo.recurso;
			var verImgCte="clientesVerArchivos.htm"+parametros+"&recurso="+recursos;
			$('#imgCliente').attr("src",verImgCte);
			$('#imagen').attr('href',verImgCte);
		}
		else{
			var source = 'images/user.jpg';
			$('#imgCliente').attr("src",source);
		}
	});
}