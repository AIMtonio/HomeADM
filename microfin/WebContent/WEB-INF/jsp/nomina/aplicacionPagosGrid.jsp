<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="tipoLista"  	value="${listaResultado[0]}"/>
<c:set var="listaPaginada" 	value="${listaResultado[1]}"/>
<c:set var="numPagina"	  	value="${listaResultado[2]}"/>
<c:set var="totalPagina"	value="${listaResultado[3]}"/>
<c:set var="listaPagoNominaBean" value="${listaPaginada.pageList}"/>

<%!int numTab = 7;%>
<div>
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Pagos de Cr&eacute;dito N&oacute;mina</legend>
		<br>
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td class="label" nowrap="nowrap">
					<label for="lblFolio">Folio</label>
				</td>
				<td class="separador"></td>
				<td nowrap="nowrap" class="label">
					<label for="lblFechaOperacion">Fecha de Carga</label>
				</td>
				<td class="separador"></td>
				<td nowrap="nowrap" class="label">
					<label for="lblFechaOperacion">Empleado</label>
				</td>
				<td class="separador"></td>
				<td nowrap="nowrap" class="label">
					<label for="lblFechaOperacion">CréditoID</label>
				</td>
				<td class="separador"></td>
				<td class="label" nowrap="nowrap">
					<label for="lblMonto">Monto</label>
				</td>
				<td class="separador"></td>
				<td class="label" nowrap="nowrap">
					<label for="lblrefer">Seleccionar</label>
				</td>
			</tr>
			<c:forEach items="${listaPagoNominaBean}" var="pagoNominaBean" varStatus="iteracion">
				<tr>
					<td nowrap="nowrap">
						<input type="text" id="folioNominaID${iteracion.count}" name="listaFolioNominaID" tabindex="<%=numTab++%>" size="5" value="${pagoNominaBean.folioNominaID}" readonly="readonly" />
					</td>
					<td class="separador"></td>
					<td nowrap="nowrap">
						<input type="text" id="fechaCarga${iteracion.count}" name="listaFechaCarga" tabindex="<%=numTab++%>" size="12" value="${pagoNominaBean.fechaCarga}" readonly="readonly"/>
					</td>
					<td class="separador"></td>
					<td nowrap="nowrap">
						<input type="text" id="clienteID${iteracion.count}" name="listaClienteID" tabindex="<%=numTab++%>" size="11" value="${pagoNominaBean.clienteID}" readonly="readonly"/>
					</td>
					<td class="separador"></td>
					<td nowrap="nowrap">
						<input type="text" id="creditoID${iteracion.count}" name="listaCreditoID" tabindex="<%=numTab++%>" size="11" value="${pagoNominaBean.creditoID}" readonly="readonly"/>
					</td>
					<td class="separador"></td>
					<td nowrap="nowrap">
						<input type="text" id="montoPagos${iteracion.count}" name="listaMontoPagos" esMoneda="true" tabindex="<%=numTab++%>" size="12" value="${pagoNominaBean.montoPagos}" readonly="readonly" style="text-align: right"/>
					</td>
					<td class="separador"></td>
					<td align="center"  nowrap="nowrap">
						<input type="checkbox" id="seleccionaCheck${iteracion.count}" name="seleccionaCheck" onclick="sumaCheck(this.id, ${iteracion.count})" tabindex="<%=numTab++%>" ${pagoNominaBean.esSeleccionado == 'S' ? "checked" : ""} />
						<input type="hidden" id="seleccionado${iteracion.count}" name="listaSeleccionados" value="N"/>
						<input type="hidden" id="esSeleccionado${iteracion.count}" name="listaEsSeleccionado" value="${pagoNominaBean.esSeleccionado}" />
						<input type="hidden" id="consecutivoID${iteracion.count}" name="listaConsecutivoID" value="${pagoNominaBean.consecutivoID}" />
					</td>
				</tr>
			</c:forEach>
		</table>
		<br>
		<br>
		<table align="center">
			<tr>
				<td>
					<c:if test="${!listaPaginada.firstPage}">
						<input onclick="cargaGrid('primero')" type="button" id="primero" value="" class="btnPrimero" tabindex="<%=numTab++%>" />
					</c:if>
				</td>
				<td >
					<c:if test="${!listaPaginada.firstPage}">
						<input onclick="cargaGrid('anterior')" type="button" id="anterior" value="" class="btnAnterior" tabindex="<%=numTab++%>" />
					</c:if>
				</td>
				<td>
					<c:if test="${totalPagina>1}">
						<label class="label">${numPagina}</label>
						<label class="label">/</label>
						<label class="label">${totalPagina}</label>
					</c:if>
				</td>
				<td>
					<c:if test="${!listaPaginada.lastPage}">
						<input onclick="cargaGrid('siguiente')" type="button" id="siguiente" value="" class="btnSiguiente" tabindex="<%=numTab++%>" />
					</c:if>
				</td>
				<td>
					<c:if test="${!listaPaginada.lastPage}">
						<input onclick="cargaGrid('ultimo')" type="button" id="ultimo" value="" class="btnUltimo" tabindex="<%=numTab++%>" />
					</c:if>
				</td>
			</tr>
		</table>
		<input type="hidden" id="numTab" size="10" value="<%=numTab++%>" />
	</fieldset>
</div>
<script type="text/javascript">

	$('input[name=listaMontoPagos]').each(function() {
		$(this).formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
	});


	function cargaGrid(pageValor) {
		var lista = ${tipoLista};
		var totalAcumulado = $('#totalPagos').asNumber();
		var EstFolio = $('#estatusPagoInst').val();

		var params = {};
		params['numFolio'] = $('#numFolio').val();
		params['tipoLista'] = lista;
		params['page'] = pageValor;
		params['institNominaID'] = $('#institNominaID').val();


		var listaEsSeleccionado = '';
		$("input[name='listaEsSeleccionado']").each(function(){
			listaEsSeleccionado = listaEsSeleccionado+$(this).val()+",";
		});

		var listaConsecutivoID = '';
		$("input[name='listaConsecutivoID']").each(function(){
			listaConsecutivoID = listaConsecutivoID+$(this).val()+",";
		});

		params['listaConsecutivoID'] = listaConsecutivoID;
		params['listaEsSeleccionado'] = listaEsSeleccionado;
		$('#gridPagosPendientes').hide();

		bloquearPantalla();
		$.post("aplicacionPagossGrid.htm", params, function(data) {
			desbloquearPantalla();
			if (data.length > 0) {
				$('#gridPagosPendientes').html(data);
				$('#gridPagosPendientes').show();
				habilitaControl('seleccionaTodos');
				validaTotales('', 0, '', '');

			} else {
				$('#gridPagosPendientes').html("");
				$('#gridPagosPendientes').show();
				$('#seleccionaTodos').attr('checked', false);
				deshabilitaControl('seleccionaTodos');
			}
		});
	}
</script>