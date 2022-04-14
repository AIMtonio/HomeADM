var solicitudOrigen = "";
var catTipoConsultaCredito = {
		'principal'	: 1,
		'foranea'	: 2,
		'prodSinLin'	:3
};

var editaSucursal = "N";
$(document).ready(function() {
// Fecha : 23-marzo-2013, Bloque de funcionalidad extra para esta pantalla
// Solicitado por FCHIA para pantalla pivote (solicitud credito grupal)
// Valida en la pantalla de solicitud grupal el numero de solicitud (perteneciente al grupo)seleccionado
// no eliminar, no afecta el comportamiento de la pantalla de manera individual
	if( $('#numSolicitud').val() != "" ){
		var numSolicitud=  $('#numSolicitud').val();
		$('#solicitudCreditoID').val(numSolicitud);
		$('#solicitudCreditoID').focus();
		consultaParamsSolicitud('solicitudCreditoID');
	}
// fin  Bloque de funcionalidad extra

	// Definicion de Constantes y Enums
	esTab = false;
	var parametroBean = consultaParametrosSession();

	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');
	consultaModificaSuc();
	deshabilitaBoton('agregar', 'submit');
	deshabilitaBoton('grabar', 'submit');
	deshabilitaBoton('autorizar', 'submit');

	validaEstatusGarantia();
	$('#miTabla').hide();

	var catTipoTransaccionGarantias = {
			'grabar':'3',
			'grabarGarReest':'4'
	};

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

			if(verificaGrid()==true)	{
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','garantiaID','funcionExito','funcionError');
			}
		}
	});

	$('#solicitudCreditoID').bind('keyup',function(e){
		lista('solicitudCreditoID', '2', '1', 'clienteID', $('#solicitudCreditoID').val(), 'listaSolicitudCredito.htm');
	});

	$('#creditoID').bind('keyup',function(e){
		lista('creditoID', '2', '1', 'creditoID', $('#creditoID').val(), 'ListaCredito.htm');
	});

	$('#solicitudCreditoID').blur(function() {
		if(esTab){
			consultaParamsSolicitud(this.id);
		}
	});

	$('#prospectoID').blur(function() {
		consultaProspectos(this.id);
	});

	$('#clienteID').blur(function() {
		consultaCliente(this.id);
	});

	$('#garantiaID').blur(function() {
		if($('#garantiaID').val()!='' && $('#garantiaID').val()!= 0){
			consultaGarantia(this.id);
		}
		if($('#garantiaID').val()!='' && $('#garantiaID').val()== 0){
			inicializaForma('formaGenerica', 'garantiaID');

			deshabilitaBoton('agregar', 'submit');
			deshabilitaBoton('grabar', 'submit');
		}
	});

	$('#grabar').click(function() {


		if(solicitudOrigen == 'R'){
			$('#tipoTransaccion').val(catTipoTransaccionGarantias.grabarGarReest);
			}else{
				$('#tipoTransaccion').val(catTipoTransaccionGarantias.grabar);

			}
	});

	$('#autorizar').click(function() {
		var total= $('#totalAsignado').asNumber();

		if(validaCubreMontoCredito(total)==true){
			$('#estatus').val('U');
			$('#tipoTransaccion').val(catTipoTransaccionGarantias.grabar);
		}else{
			$('#estatus').val('A');
			$('#tipoTransaccion').val(catTipoTransaccionGarantias.grabar);
		}
	});

	$('#agregar').click(function() {
		if( $('#creditoID').val()==''  && $('#solicitudCreditoID').val()==''){
			mensajeSis("Especificar el número de Solicitud o Crédito");
			$('#solicitudCreditoID').focus();
		}else{
			agregaNuevoDetalle();
			$('#miTabla').show();
			habilitaBoton('grabar', 'submit');
		}
	});

	// FUNCION CONSULTA DATOS DEL CLIENTE
	function consultaCliente(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();
		var tipConPrincipal = 1;
		setTimeout("$('#cajaLista').hide();", 200);

		if(numCliente != '' && !isNaN(numCliente)){
			clienteServicio.consulta(tipConPrincipal,numCliente,function(cliente) {
				if(cliente!=null){
					$('#clienteID').val(cliente.numero);
					$('#clienteNombre').val(cliente.nombreCompleto);
				}else{
					mensajeSis("Cliente No Valido");
					$('#clienteID').val('');
					$('#clienteID').focus();

				}
			});
		}
	}

	// FUNCION CONSULTA DATOS PROSPECTO
	function consultaProspectos(idControl) {
		var jqProspecto = eval("'#" + idControl + "'");
		var numProspecto = $(jqProspecto).val();
		var tipConPrincipal = 1;
		setTimeout("$('#cajaLista').hide();", 200);
		var prospectoBean = {
				'prospectoID'	:numProspecto
		};
		if(numProspecto != '' && !isNaN(numProspecto)){
			prospectosServicio.consulta(tipConPrincipal,prospectoBean,function(Prospecto) {
				if(Prospecto!=null){
					$('#prospectoNombre').val(Prospecto.nombreCompleto);
				}else{
					mensajeSis("Prospecto No Valido");
					$('#prospectoID').val('');

				}
			});
		}
	}

	// FUNCION CONSULTA GARANTIA
	function consultaGarantia(idControl) {
		var jqGarantia = eval("'#" + idControl + "'");
		var garantiaID = $(jqGarantia).val();
		var tipConPrincipal = 1;
		var garantiaBean = {
			'garantiaID' :garantiaID,
			'solicitudCreditoID' : $('#solicitudCreditoID').val()
		};

		if(garantiaID != '' && !isNaN(garantiaID)){
			garantiaServicioScript.consultaGarantia(tipConPrincipal,garantiaBean,function(data) {
				if(data!=null){
					dwr.util.setValues(data);

				}else{
					mensajeSis("No se encontro la garantía.");
				}
			});
		}
	}

	// FUNCION CONSULTA PARAMETROS DE LA SOLICITUD DE CREDITO
	function consultaParamsSolicitud(idControl) {
		var jqSolici = eval("'#" + idControl + "'");
		var soliciID = $(jqSolici).val();
		var tipConCredito = 4;
		var siRequiere="S";
		var estatusInactivo='I';
		var estatusAutorizada='A';
		var estatusDesembolsada='D';
		var estaus="";
		var garantiaBean = {
				'solicitudCreditoID':soliciID,
				'creditoID':0,
				'garantiaID'	:0
		};

		setTimeout("$('#cajaLista').hide();", 200);

		if(soliciID != '' && !isNaN(soliciID)){
			garantiaServicioScript.consultaGarantia(tipConCredito,garantiaBean,function(data) {
				if(data!=null){
					if(data.requiereGarantia==siRequiere || data.requiereGarantia=='I'){
						if(data.estatus == estatusInactivo || data.estatus == estatusAutorizada || data.estatus == estatusDesembolsada ){
							if(data.estatus == estatusDesembolsada){
								mensajeSis('La Solicitud está Desembolsada');
								$('#solicitudCreditoID').focus();
								deshabilitaBoton('agregar', 'submit');
								deshabilitaBoton('grabar', 'submit');
							}
							validaSolicitudCredito(idControl);
							$('#relGarantCred').val(data.relGarantCred);
						}else{
							switch(data.estatus){

							case 'C': estaus='La Solicitud está Cancelada'; 	break;
							case 'R': estaus='La Solicitud está Rechazada'; 	break;
							case 'D': estaus='La Solicitud está Desembolsada';  break;
							case 'L': estaus='La Solicitud está Liberada';  	break;
							}
							mensajeSis(estaus);
							$('#solicitudCreditoID').focus();
							limpiarParametrosPantalla();
							$('#solicitudCreditoID').val('');
							$('#solicitudCreditoID').focus();
							deshabilitaBoton('agregar', 'submit');
							deshabilitaBoton('grabar', 'submit');
						}
					}else{
						mensajeSis("El producto relacionado a la solicitud no requiere garantías");
						limpiarParametrosPantalla();
						$('#solicitudCreditoID').val('');
						$('#solicitudCreditoID').focus();
						deshabilitaBoton('agregar', 'submit');
						deshabilitaBoton('grabar', 'submit');
					}
				}else{
					mensajeSis("No se encontro la Solicitud");
					$('#solicitudCreditoID').val('');
					$('#solicitudCreditoID').focus();
					limpiarParametrosPantalla();
					deshabilitaBoton('agregar', 'submit');
					deshabilitaBoton('grabar', 'submit');
				}
			});
		}else{
			if(isNaN(soliciID)){
				mensajeSis("No se encontro la Solicitud");
				$('#solicitudCreditoID').val('');
				$('#solicitudCreditoID').focus();
				limpiarParametrosPantalla();
				deshabilitaBoton('agregar', 'submit');
				deshabilitaBoton('grabar', 'submit');
			}
		}
	}

	$('#formaGenerica').validate({
		rules: {
			garantiaID: {
				required: true
			},
		},
		messages: {
			garantiaID: {
				required: 'Especifica Folio'
			},
		}
	});

// INICIO VALIDACION CREDITOS

	// FUNCION CONSULTA PARAMETROS CREDITO SIN UTILIZAR
	function consultaParamsCredito(idControl) {
		var jqCredito = eval("'#" + idControl + "'");
		var creditoID = $(jqCredito).val();
		var tipConCredito = 3;
		var siRequiere="S";
		var estatusInactivo='I';
		var estaus="";
		var garantiaBean = {
				'solicitudCreditoID':0,
				'creditoID':creditoID,
				'garantiaID'	:0
		};

		if(creditoID != '' && !isNaN(creditoID)){

			garantiaServicioScript.consultaGarantia(tipConCredito,garantiaBean,function(data) {
				if(data!=null){

					if(data.requiereGarantia==siRequiere || data.requiereGarantia=='I'){

						if(data.estatus == estatusInactivo){
							validaCredito(idControl);
							$('#relGarantCred').val(data.relGarantCred);
						}
						else{
							switch(data.estatus){

							case 'A': estaus='El Crédito ya ha sido Autorizado';  break;
							case 'V': estaus='El Crédito está Vigente';  	break;
							case 'P': estaus='El Crédito está Pagado';  	break;
							case 'C': estaus='El Crédito está Cancelado'; 	break;
							case 'B': estaus='El Crédito está Vencido'; 	break;
							case 'K': estaus='El Crédito está Castigado';   break;
							}
							mensajeSis(estaus);
						}
					}else{
						mensajeSis("El producto relacionado al crédito no requiere de garantía");
						limpiarParametrosPantalla();
						$('#solicitudCreditoID').val('');
						$('#solicitudCreditoID').focus();
					}
				}else{
					mensajeSis("No se encontro el crédito.");
					$('#creditoID').val('');
					if( $('#solicitudCreditoID').val()==0 || $('#solicitudCreditoID').val()==''){
						limpiarParametrosPantalla();
					}
				}
			});
		}
	}

	// FUNCION CONSULTA DATOS DEL CREDITO SI UTILIZAR
	function validaCredito(control) {
		var numCredito = $('#creditoID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCredito != '' && !isNaN(numCredito)){

			if(numCredito=='0'){
			} else {
				var creditoBeanCon = {
						'creditoID':$('#creditoID').val()
				};
				creditosServicio.consulta(catTipoConsultaCredito.principal,creditoBeanCon,function(credito) {
					if(credito!=null){
						dwr.util.setValues(credito);

						if(credito.solicitudCreditoID>0){
							validaSolicitudCredito('solicitudCreditoID');
						}
						consultaCliente('clienteID');
						var solCreID = $('#solicitudCreditoID').val();
						var creditoID =  $('#creditoID').val();
						pegaHtml(solCreID,creditoID);
					}else{
						mensajeSis("No Existe el Credito");
						$('#creditoID').val('');
					}
				});

			}

		}
	}

// FIN VALIDACION CREDITOS

	// VALIDA SOLICITUD DE CREDITO
	function validaSolicitudCredito(control) {
		var numCredito = $('#solicitudCreditoID').val();
		var perfilAnalistaDeCred = 12;
		setTimeout("$('#cajaLista').hide();", 200);

		if(numCredito != '' && !isNaN(numCredito)){
			if(numCredito=='0'){
			} else {
				var creditoBeanCon = {
						'solicitudCreditoID':$('#solicitudCreditoID').val()
				};

				solicitudCredServicio.consulta(catTipoConsultaCredito.principal,creditoBeanCon,function(credito) {
					if(credito!=null){
						if( credito.sucursalID==parametroBean.sucursal || parametroBean.perfilUsuario==perfilAnalistaDeCred
							|| editaSucursal == 'S' ){
							dwr.util.setValues(credito);

							solicitudOrigen = credito.tipoCredito;

							if(credito.prospectoID>0){
								consultaProspectos('prospectoID');
							}else{
								$('#prospectoID').val('');
							}
							consultaProducCredito('productoCreditoID');
							if(credito.clienteID>0){
								consultaCliente('clienteID');
							}else{
								$('#clienteID').val('');
							}

							var solCreID = $('#solicitudCreditoID').val();
							var creditoID =  $('#creditoID').val();
							pegaHtml(solCreID,creditoID);

						}else{
							mensajeSis("La Solicitud de Crédito no pertenece a esta sucursal o El Usuario no cuenta con los permisos necesarios para Asignar Garantías a Esta solicitud");
							deshabilitaBoton('modifica', 'submit');
							deshabilitaBoton('agrega', 'submit');
							$('#solicitudCreditoID').val('');
							$('#solicitudCreditoID').focus();
							limpiarParametrosPantalla();
						}
					}else{
						mensajeSis("No Existe la Solicitud de  Credito");
						deshabilitaBoton('modifica', 'submit');
						deshabilitaBoton('agrega', 'submit');
						$('#solicitudCreditoID').val('');
						$('#solicitudCreditoID').focus();
						limpiarParametrosPantalla();
					}
				});
			}
		}
	}

	//FUNCION CONSULTA DATOS PRODUCTO DE CREDITO
	function consultaProducCredito(idControl) {
		var jqProdCred  = eval("'#" + idControl + "'");
		var ProdCred = $(jqProdCred).val();
		var ProdCredBeanCon = {
				'producCreditoID':ProdCred
		};
		setTimeout("$('#cajaLista').hide();", 200);

		if(ProdCred != '' && !isNaN(ProdCred)  ){
			productosCreditoServicio.consulta(1,ProdCredBeanCon,function(prodCred) {
				if(prodCred!=null){
					$('#nombreProd').val(prodCred.descripcion);
				}else{

				}
			});
		}
	}

	// FUNCION CONSULTA GARANTIAS REGISTRADAS A LA SOLICITUD
	function pegaHtml(solCreID,creditoID){
		var params = {};

		params['solicitudCreditoID'] = solCreID;
		params['creditoID'] = 0;
		params['garantiaID'] =  0;


		if(solicitudOrigen ==  'R'){
			params['tipoLista'] = 7;
		}else{
			params['tipoLista'] = 2;
		}
		$.post("asignacionGarantiasGrid.htm", params, function(data){
			if(data.length >0 ){
				$('#tableCon').replaceWith(data);

				var estatus='A';
				$('input[name=lestatus]').each(function() {
					var jqestatus = eval("'#" + this.id + "'");
					estatus = $(jqestatus).val();
				});

				$('#estatus').val(estatus);

				agregaTotales();
				agregaFormatoControles('formaGenerica');
				validaEstatusGarantia();

				if(solicitudOrigen == 'R'){
					validaEstatus();
				}
				if($('#numeroDetalle').val()==''){
					$('#numeroDetalle').val(0);
					$('#miTabla').hide();
				}
			}else{
			}
		});
	}//fin funcion pega Html

	// FUNCION VALIDA ESTATUS DE LA ASIGNACION DE GATANTIAS
	function validaEstatusGarantia(){
		var estatus = $('#estatus').val();

		if(estatus == 'A'){
			$('#estatusNombre').val('ASIGNADA');

			habilitaBoton('agregar', 'submit');
			habilitaBoton('grabar', 'submit');
		}
		if(estatus == 'U'){
			$('#estatusNombre').val('AUTORIZADA');

			deshabilitaBoton('agregar', 'submit');
			deshabilitaBoton('grabar', 'submit');
			deshabilitaBoton('autorizar', 'submit');
		}
	}

	// FUNCION QUE VALIDA QUE NINGUN CAMPO DEL GRIS ESTE VACIO
	function verificaGrid(){
		var returno = true;

		$('input[name=lmontoAsignado]').each(function() {
			var numero= this.id.substr(13,this.id.length);

			var jqValorAsignado = eval("'#" + this.id + "'");
			var jqGarantiaID = eval("'#" + "garantiaID"+numero+"'");

			if( $(jqGarantiaID).asNumber() > 0){
				if( $(jqValorAsignado).val()<=0) {
					mensajeSis('Especificar Valor Asignado');
					returno = false;
					$(jqValorAsignado).focus();
					return false;
				}
			}else{
				mensajeSis('Especificar la Garantía');
				returno = false;
				$(jqGarantiaID).focus();
				return false;
			}
		});

		return returno;
	}

	//Metodo para consultar si modifica sucursal
	function consultaModificaSuc(){
		var tipoConsulta = 58;
		var paramGeneralesBean = {
			'empresaID' : 1
		};
		paramGeneralesServicio.consulta(tipoConsulta, paramGeneralesBean, {
			async: false, callback:function(paramGeneralesBeanResponse) {
				if (paramGeneralesBeanResponse != null && paramGeneralesBeanResponse.valorParametro=="S"){
					editaSucursal = paramGeneralesBeanResponse.valorParametro;
				}else {
					editaSucursal = 'N';
				}

			},
			errorHandler : function(message, exception) {
				editaSucursal = 'N';
				mensajeSis("Error en Consulta del Parámetro General para Modificación de Sucursal.<br>" + message + ":" + exception);
			}
		});
	}

});///::::::::::::::  F I N    D E     J Q U E R Y :::::::::::::::::::.

//FUNCION LIMPIA CAMPOS EN LA PANTALLA
function limpiarParametrosPantalla(){
	$('#creditoID').val('');
	$('#prospectoID').val('');
	$('#clienteID').val('');
	$('#clienteNombre').val('');
	$('#prospectoNombre').val('');
	$('#montoCredito').val('');
	$('#montoSolici').val('');
	$('#montoAutorizado').val('');
	$('#fechaInicio').val('');
	$('#fechaRegistro').val('');
	$('#relGarantCred').val('');
	$('#numeroDetalle').val('-1');

	$('#estatusNombre').val('');
	$('#productoCreditoID').val('');
	$('#nombreProd').val('');

	var tablaNueva=' <table id="miTabla">';
	tablaNueva+='<tr><td> </td>';
	tablaNueva+='<td class="label"> <label for="lblgarantia">Garantia: </label> </td> ';
	tablaNueva+='<td class="label"> <label for="lblgarantia">Observasiones: </label> 	</td>';
	tablaNueva+='<td class="label"> <label for="lblgarantia">Valor Comercial: </label> </td>';
	tablaNueva+='<td class="label"> <label for="lblgarantia">Valor Asignado: </label> </td>';
	tablaNueva+='</tr>	</table>';

	$('#miTabla').replaceWith(tablaNueva);
	$('#miTabla').hide();

	var msjPorc = '<td id="tdPorcentaje"><label for="lblgarantia"><h3>0.00%</h3> </label>  </td> ';
	$('#tdPorcentaje').replaceWith(msjPorc);
}

// GUARDA EL NUMERO DE FILAS QUE TIENE LA SECCION DEL GRID DE GARANTIAS
$("#numeroDetalle").val($('input[name=consecutivoID]').length);

// FUNCION ELIMINA FILA EN GRID DE GRANTIAS
function eliminaDetalle(control){
	var numeroID = control.id;
	var jqTr = eval("'#renglon" + numeroID + "'");


	var jqConsecutivoID = eval("'#consecutivoID" + numeroID + "'");
	var jqGarantiaID = eval("'#garantiaID" + numeroID + "'");
	var jqObserbaciones = eval("'#obserbaciones" + numeroID + "'");
	var jqValorComercial = eval("'#valorComercial" + numeroID + "'");
	var jqMontoAsignado = eval("'#montoAsignado" + numeroID + "'");

	var jqElimina = eval("'#" + numeroID + "'");
	var jqAgrega = eval("'#agrega" + numeroID + "'");


	$(jqConsecutivoID).remove();
	$(jqGarantiaID).remove();
	$(jqObserbaciones).remove();
	$(jqValorComercial).remove();
	$(jqMontoAsignado).remove();

	$(jqElimina).remove();
	$(jqAgrega).remove();
	$(jqTr).remove();

	//Reordenamiento de Controles
	var contador = 1;
	$('input[name=consecutivoID]').each(function() {
		var jqCicInf = eval("'#" + this.id + "'");
		$(jqCicInf).attr("id", "consecutivoID" + contador);

		contador = contador + 1;
	});
	contador=1;
	$('input[name=consecutivoID]').each(function() {
		var jqCicInf = eval("'#" + this.id + "'");

		$(jqCicInf).val(contador);
		contador = contador + 1;
	});
	//Reordenamiento de Controles
	contador = 1;
	$('input[name=lgarantiaID]').each(function() {
		var jqCicInf = eval("'#" + this.id + "'");
		$(jqCicInf).attr("id", "garantiaID" + contador);
		contador = contador + 1;
	});

	contador = 1;// agrega metodo onKeyUp
	$('input[name=lgarantiaID]').each(function() {
		var jqCicInf = eval("'#" + this.id + "'");
		$(jqCicInf).attr("onKeyUp", "obtenerGarantia('garantiaID"+contador+"');" );
		contador = contador + 1;
	});

	contador = 1;// quita onBlur
	$('input[name=lgarantiaID]').each(function() {
		var jqCicInf = eval("'#" + this.id + "'");
		$(jqCicInf).removeAttr('onblur');
		contador = contador + 1;

	});

	contador = 1;// agregametodo onBlur
	$('input[name=lgarantiaID]').each(function() {
		var jqCicInf = eval("'#" + this.id + "'");
		$(jqCicInf).attr("onBlur", "consultaSiFueAsignadaGarantia('"+ contador +"');");
		contador = contador + 1;

	});

	//Reordenamiento de Controles
	contador = 1;
	$('textarea[name=lobserbaciones]').each(function() {
		var jqCicSup = eval("'#" + this.id + "'");
		$(jqCicSup).unbind();
		$(jqCicSup).attr("id", "obserbaciones" + contador);
		//listaDescripcion("descripcion" + contador);
		contador = contador + 1;
	});


	//Reordenamiento de Controles
	contador = 1;
	$('input[name=lvalorComercial]').each(function() {
		var jqCicSup = eval("'#" + this.id + "'");
		$(jqCicSup).unbind();
		$(jqCicSup).attr("id", "valorComercial" + contador);
		contador = contador + 1;
	});

	//Reordenamiento de Controles
	contador = 1;
	$('input[name=lmontoAsignado]').each(function() {
		var jqCicSup = eval("'#" + this.id + "'");
		$(jqCicSup).unbind();
		$(jqCicSup).attr("id", "montoAsignado" + contador);
		contador = contador + 1;
	});

	//Reordenamiento de Controles
	contador = 1;
	$('input[name=agrega]').each(function() {
		var jqAgrega = eval("'#" + this.id + "'");
		$(jqAgrega).attr("id", "agrega" + contador);
		contador = contador + 1;
	});

	//Reordenamiento de Controles
	contador = 1;
	$('input[name=elimina]').each(function() {
		var jqCicElim = eval("'#" + this.id + "'");
		$(jqCicElim).attr("id", contador);
		contador = contador + 1;
	});

	//Reordenamiento de Controles
	contador = 1;
	$('tr[name=renglon]').each(function() {
		var jqCicTr = eval("'#" + this.id + "'");
		$(jqCicTr).attr("id", "renglon" + contador);
		contador = contador + 1;
	});

	$('#numeroDetalle').val($('#numeroDetalle').val()-1);
	agregaTotales();
}

// FUNCION AGREGA FILA EN EL GRID DE GARANTIAS
function agregaNuevoDetalle(){

	var numeroFila = document.getElementById("numeroDetalle").value;
	var nuevaFila = parseInt(numeroFila) + 1;

	var tds = '<tr id="renglon' + nuevaFila + '" name="renglon">';

	tds += '<td><input type="text" id="consecutivoID'+nuevaFila+'" name="consecutivoID" size="3" value="'+nuevaFila+'" autocomplete="off" /></td>';
	tds += '<td><input type="text" id="garantiaID'+nuevaFila+'" name="lgarantiaID" size="13" path="lgarantiaID"  autocomplete="off" onKeyUp="obtenerGarantia(\'garantiaID'+nuevaFila+'\');"  onblur="consultaSiFueAsignadaGarantia('+nuevaFila+');"  /></td>';
	tds += '<td><textarea  id="obserbaciones'+nuevaFila+'" name="lobserbaciones" value="" autocomplete="off" readOnly="true" COLS="50" ROWS="1" /></td>';
	tds += '<td><input type="text" id="valorComercial'+nuevaFila+'" name="lvalorComercial"  style="text-align:right;" readOnly="true"/></td>';
	tds += '<td><input type="text" id="montoAsignado'+nuevaFila+'" name="lmontoAsignado"  style="text-align:right;" esMoneda="true" path="lmontoAsignado" onblur="validaMontoAsignado(\''+nuevaFila+'\');"/></td>';


	tds += '<td align="center">	<input type="button" name="elimina" id="'+nuevaFila +'" class="btnElimina" onclick="eliminaDetalle(this)"/>';
	tds += '<input type="button" name="agrega" id="agrega'+nuevaFila +'" class="btnAgrega" onclick="agregaNuevoDetalle()"/></td>';
	tds += '<td><input type="hidden" id="estatusSolicitud'+nuevaFila+'"  value="N" name="lestatusSolicitud" />';
	tds += '<input type="hidden" id="montoDisponible'+nuevaFila+'"  name="lisMontoDisponible" style="text-align:right;" readOnly="true" value="0.00" />';
	tds += '<input type="hidden" id="montoGarantia'+nuevaFila+'"  name="lisMontoGarantia" style="text-align:right;" readOnly="true" value="0.00" />';
	tds += '<input type="hidden" id="montoAvaluado'+nuevaFila+'"  name="lisMontoAvaluado" style="text-align:right;" readOnly="true" value="0.00" /></td>';

	tds += '</tr>';


	document.getElementById("numeroDetalle").value = nuevaFila;
	$("#miTabla").append(tds);
	$('#garantiaID'+nuevaFila).focus();
	agregaFormatoControles('formaGenerica');
	$('#montoAsignado'+nuevaFila).formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});

	agregaTotales();

	return false;
}

// FUNCION QUE CALCULA EL TOTAL ASIGNADO DE LAS GARANTIAS Y DEFINE SI ES SUFICIENTE O NO
function agregaTotales(){
	$('#trTotales').replaceWith('');
	var tds='<tr  id="trTotales" >';
	tds += '<td>  </td>';
	tds += '<td>  </td>';
	tds += '<td>  </td>';
	tds += '<td> <label for="lblgarantia">Total Asignado: </label> </td>';
	tds += '<td><input type="text" id="totalAsignado" name="totalAsignado" esMoneda="true" readOnly="true"  style="text-align:right;" path="totalAsignado" /></td>';
	tds += '</tr>';

	$("#miTabla").append(tds);

	var total=0.00;
	$('input[name=lmontoAsignado]').each(function() {
		var jqmonto = eval("'#" + this.id + "'");
		var monto = $(jqmonto).asNumber();
		total+=monto;
	});

	$('#totalAsignado').val(total);
	$('#totalAsignado').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});

	if(validaCubreMontoCredito(total)==true){
		if($('#estatus').val()!='U'){//U=Autorizada
			habilitaBoton('autorizar', 'submit');
		}
	}else{
		var msj='<td id="tdmensaje"> <label for="lblgarantia"><h3>Garantías Insuficientes</h3> </label> </td> ';
		$('#tdmensaje').replaceWith(msj);

		deshabilitaBoton('autorizar', 'submit');
	}
}

// FUNCION QUE VALIDA QUE SI EL TOTAL DEL VALOR ASIGNADO DE LAS GARANTIAS
// YA CUBRE EL MONTO RELACION GARANTIA DE CREDITO
function validaCubreMontoCredito(totalAsignado){
	var montoCredito= $('#montoCredito').asNumber();
	var montoSolici= $('#montoSolici').asNumber();
	var montoAutorizado= $('#montoAutorizado').asNumber();
	var requerido = $('#relGarantCred').asNumber() / 100;
	var porcentaje=0;
	var msjPorc = '';

	if(montoSolici!='0' && montoSolici != '')	 {
		if ( (totalAsignado/requerido) >= montoSolici){
			porcentaje = (totalAsignado*100)/montoSolici;
			var msj='<td id="tdmensaje"> <label for="lblgarantia"><h3>Las garantías ya cubren el monto solicitado</h3> </label> </td> ';
			$('#tdmensaje').replaceWith(msj);
			msjPorc = '<td id="tdPorcentaje"><label for="lblgarantia"><h3>'+  porcentaje.toFixed(2) +' %</h3> </label>  </td> ';
			$('#tdPorcentaje').replaceWith(msjPorc);
			return true;
		}
		else{
			porcentaje = (totalAsignado*100)/montoSolici;
			msjPorc = '<td id="tdPorcentaje"><label for="lblgarantia"><h3>'+  porcentaje.toFixed(2)+' %</h3> </label>  </td> ';
			$('#tdPorcentaje').replaceWith(msjPorc); return false;
		}
	}

	if(montoAutorizado!='0' && montoAutorizado != '')	 {
		if ( (totalAsignado/requerido) >= montoAutorizado)  {
			porcentaje = (totalAsignado*100)/montoAutorizado;
			var msj='<td id="tdmensaje"> <label for="lblgarantia"><h3>Las garantías ya cubren el monto autorizado</h3> </label> </td> ';
			$('#tdmensaje').replaceWith(msj);
			msjPorc = '<td id="tdPorcentaje"><label for="lblgarantia"><h3>'+  porcentaje.toFixed(2)  +' %</h3> </label>  </td> ';
			$('#tdPorcentaje').replaceWith(msjPorc);
			return true;
		}
		else{
			porcentaje = (totalAsignado*100)/montoAutorizado;
			msjPorc = '<td id="tdPorcentaje"><label for="lblgarantia"><h3>'+ porcentaje.toFixed(2)  +' %</h3> </label>  </td> ';
			$('#tdPorcentaje').replaceWith(msjPorc); return false;
		}
	}


	if(montoCredito!='0' && montoCredito != '')	 {
		if ( (totalAsignado/requerido) >= montoCredito) {
			porcentaje = (totalAsignado*100)/montoCredito;
			var msj='<td id="tdmensaje"> <label for="lblgarantia"><h3>Las garantías ya cubren el monto de crédito</h3> </label> </td> ';
			$('#tdmensaje').replaceWith(msj);
			msjPorc = '<td id="tdPorcentaje"><label for="lblgarantia"><h3>'+  porcentaje.toFixed(2) +' %</h3> </label>  </td> ';
			$('#tdPorcentaje').replaceWith(msjPorc);
			return true;
		}
		else{
			porcentaje = (totalAsignado*100)/montoCredito;
			msjPorc = '<td id="tdPorcentaje"><label for="lblgarantia"><h3>'+  porcentaje.toFixed(2)  +' %</h3> </label>  </td> ';
			$('#tdPorcentaje').replaceWith(msjPorc); 	return false;
		}
	}
	return false;
}

// FUNCION OBTENER GARANTIA
function obtenerGarantia(idControl){
	var camposLista = new Array();
	var parametrosLista = new Array();
	var clienteID=$('#clienteID').val();
	var prospectoID=$('#prospectoID').val();

	camposLista[0] = "observaciones";
	camposLista[1] = "clienteID";
	camposLista[2] = "prospectoID";

	parametrosLista[0] = document.getElementById(idControl).value;
	parametrosLista[1] = clienteID;
	parametrosLista[2] = prospectoID;
	if(clienteID!='0' || clienteID != ''){
		var tipoLista='1';
		if(document.getElementById(idControl).value != ""){
			lista(idControl, '1', tipoLista, camposLista, parametrosLista, 'listaGarantias.htm');
		}
	}
	if(prospectoID!='0' || prospectoID != ''){
		var tipoLista='2';
		if(document.getElementById(idControl).value != ""){
			lista(idControl, '1', tipoLista, camposLista, parametrosLista, 'listaGarantias.htm');
		}
	}
}

// FUNCION CONSULTA SI YA FUE ASIGNADA LA GARANTIA A OTRA SOLICITUD
function consultaSiFueAsignadaGarantia(idControl) {
	var jqGarantia = eval("'#garantiaID" + idControl + "'");
	var solicitudGarantia =$('#solicitudCreditoID').val();
	var jqObservaciones =eval("'#obserbaciones" + idControl + "'");
	var jqValorComercial=eval("'#valorComercial" + idControl + "'");
	var jqMontoAsignado=eval("'#montoAsignado" + idControl + "'");

	var garantiaID = $(jqGarantia).val();
	var tipoConExisteGarantia = 6;
	var garantiaBean = {
			'solicitudCreditoID' :solicitudGarantia,
			'creditoID':0,
			'garantiaID'	:garantiaID
	};


	if(garantiaID != '' && !isNaN(garantiaID)){// consulta
		garantiaServicioScript.consultaGarantia(tipoConExisteGarantia,garantiaBean,function(data) {
			if(data!=null){
					mensajeSis("La garantía se encuentra asignada a la Solicitud: "+ data.solicitudCreditoID);
					$(jqGarantia).val('');
					$(jqObservaciones).val('');
					$(jqValorComercial).val('');
					$(jqMontoAsignado).val('');
					$(jqGarantia).focus();

					agregaTotales();

			}else{
				consultaSiPerteneceACredito(idControl);

			}
		});
	} // fin cunsulta


}

// FUNCION CONSULTA SI LA GARANTIA EXISTE EN UN CREDITO VIGENTE
function consultaSiPerteneceACredito(idControl) {

	// consulta si la garantia existe en un credito vigente
	var jqGarantia = eval("'#garantiaID" + idControl + "'");
	var solicitudGarantia =$('#solicitudCreditoID').val();
	var jqObservaciones =eval("'#obserbaciones" + idControl + "'");
	var jqValorComercial=eval("'#valorComercial" + idControl + "'");
	var jqMontoAsignado=eval("'#montoAsignado" + idControl + "'");

	var estatusVigente='V';
	var estatusAutorizado='A';
	var garantiaID = $(jqGarantia).val();
	var tipoConExisteGarantia = 5;
	var garantiaBean = {
			'solicitudCreditoID' :solicitudGarantia,
			'creditoID':0,
			'garantiaID'	:garantiaID
	};


	if(garantiaID != '' && !isNaN(garantiaID)){// consulta
		garantiaServicioScript.consultaGarantia(tipoConExisteGarantia,garantiaBean,function(data) {

			if(data!=null){
				if ( data.estatus == estatusVigente || data.estatus == estatusAutorizado){
					mensajeSis("La garantía se encuentra asignada al crédito: "+ data.creditoID);
					$(jqGarantia).val('');
					$(jqObservaciones).val('');
					$(jqValorComercial).val('');
					$(jqMontoAsignado).val('');
					$(jqGarantia).val('');

					agregaTotales();
				}else{
					consultaGarantia(idControl);
				}
			}else{
				consultaGarantia(idControl);
			}
		});
	} // fin cunsulta
}

// FUNCION CONSULTA GARANTIA
function consultaGarantia(idControl) {

	var jqGarantia = eval("'#garantiaID" + idControl + "'");
	var jqObservaciones =eval("'#obserbaciones" + idControl + "'");
	var jqValorComercial=eval("'#valorComercial" + idControl + "'");
	var jqMontoDisponible=eval("'#montoDisponible" + idControl + "'");
	var jqMontoGarantia = eval("'#montoGarantia" + idControl + "'");
	var jqMontoAvaluado = eval("'#montoAvaluado" + idControl + "'");
	var jqEstatusSolicitud = eval("'#estatusSolicitud" + idControl + "'");
	var monto =  eval("'#montoAsignado" + idControl + "'");
	var garantiaID = $(jqGarantia).val();
	var tipConPrincipal = 1;
	var garantiaBean = {
		'garantiaID' : garantiaID,
		'solicitudCreditoID' : $('#solicitudCreditoID').val()
	};

	if(garantiaID != '' && !isNaN(garantiaID)){// consulta
		garantiaServicioScript.consultaGarantia(tipConPrincipal,garantiaBean,function(data) {

			if(data!=null){
				var mostrarDatos=true;
				if(mostrarDatos==true){
					$(jqEstatusSolicitud).val('N');
					$(jqObservaciones).val(data.observaciones);
					$(jqValorComercial).val(data.valorComercial);
					$(jqMontoDisponible).val(data.montoDisponible);
					$(jqMontoGarantia).val(data.montoGarantia);
					$(jqMontoAvaluado).val(data.montoAvaluado);
					$(jqValorComercial).formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
					$(monto).focus();
					$(monto).val('');
					agregaTotales();
				}
			}else{
				mensajeSis("No se encontro la garantía.");
				$(jqGarantia).val('');
				$(jqObservaciones).val('');
				$(jqValorComercial).val('');
				$(monto).val('');
				$(jqGarantia).focus();
				agregaTotales();

			}
		});
	} // fin cunsulta
}

// FUNCION QUE VALIDA EL MONTO ASIGNADO NO SEA MAYOR AL VALOR COMERCIAL DE LA GARANTIA
function validaMontoAsignado(numeroFila){
	// consultaGarantia(numeroFila );
	var jqGarantia = eval("'#garantiaID" + numeroFila + "'");
	var jqMonto = eval("'#montoAsignado" + numeroFila + "'");
	var jqMontoDisponible = eval("'#montoDisponible" + numeroFila + "'");
	var jqMontoGarantia = eval("'#montoGarantia" + numeroFila + "'");
	var jqMontoAvaluado = eval("'#montoAvaluado" + numeroFila + "'");
	var montoGarantia = $(jqMontoGarantia).val();
	var montoAvaluado = $(jqMontoAvaluado).val();
	var montoDisponible = $(jqMontoDisponible).val();
	var jqEstatusSolicitud = eval("'#estatusSolicitud" + numeroFila + "'");
	$(jqEstatusSolicitud).val('N');

	if($(jqMonto).asNumber() > $(jqMontoDisponible).asNumber() && $(jqEstatusSolicitud).val() == 'N'){
		if(montoDisponible <= 0){
			montoDisponible = 0.00;
		}

		mensajeSis( '<p align="left">'+" La Garantía <b>No. "+ $(jqGarantia).val() +"</b> no cuenta Con Monto Suficiente.<br>"+
					"<b>Monto Garantía:</b>   $"+ parseFloat(montoGarantia).toFixed(2)+"<br>"+
					"<b>Monto Asignado:</b>   $"+ parseFloat(montoAvaluado).toFixed(2)+"<br>"+
					"<b>Monto Disponible:</b> $"+ parseFloat(montoDisponible).toFixed(2)+"<br>"+'</p>');
		$(jqMontoDisponible).focus();
		$(jqMonto).val(montoDisponible);
		$(jqMonto).formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
		agregaTotales();

	}else{
		if( $(jqMonto).val()!='' && $(jqMonto).val()!='0' ){
			if( $(jqGarantia).val()!='' && $(jqGarantia).val()!='0' ){
				agregaTotales();
			}
			else{
				mensajeSis('No existe garantía');
				$(jqGarantia).focus();
			}

		}
	}
}


function validaEstatus(){
		$("input[name=lestatusSolicitud]").each(function(i){

				var jqValida = eval("'#" + this.id + "'");
				var id = jqValida.replace(/\D/g,'');
				var valor = $(jqValida).val();
				if (valor == 'O') {
					$("#"+id).attr('disabled',true);
				}

			});
}

// FUNCION DE EXITO
function funcionExito(){
	var jQmensaje = eval("'#ligaCerrar'");
	if($(jQmensaje).length > 0) {
	mensajeAlert=setInterval(function() {
		if($(jQmensaje).is(':hidden')) {
			clearInterval(mensajeAlert);


			inicializaForma('formaGenerica','solicitudCreditoID');
			limpiarParametrosPantalla();
			$('#solicitudCreditoID').focus();
			deshabilitaBoton('agregar', 'submit');
			deshabilitaBoton('grabar', 'submit');
			deshabilitaBoton('autorizar', 'submit');
		}
        }, 50);
	}
}

// FUNCION DE ERROR
function funcionError(){

}