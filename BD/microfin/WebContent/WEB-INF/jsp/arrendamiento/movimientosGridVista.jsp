<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="listaPaginada" value="${listaResultado[1]}" />
<c:set var="numErr2">${listaResultado[2]}</c:set>
<c:set var="mesErr" value="${listaResultado[3]}" />
<c:set var="listaResultado" value="${listaPaginada.pageList}" />

<input type="hidden" id="numeroErrorList" name="numeroErrorList" value="${numErr2}" />
<input type="hidden" id="mensajeErrorList" name="mensajeErrorList" value="<c:out value="${mesErr}"/>" />
<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend>Movimientos registrados</legend>
		<c:if test="${numErr2 == 0}">
			<table id="tablaMovsCA"  border="0" cellpadding="0" cellspacing="1" width="825px" style="display:block; overflow: auto;">
				<tr>
	                <td class="ui-widget ui-widget-header ui-corner-all" align="center"><label for="lblFechaMovimiento" style="color: #ffffff">Fecha Registro</label></td>
	                <td class="ui-widget ui-widget-header ui-corner-all" align="center"><label for="lblUsuarioMovimiento" style="color: #ffffff">Usuario</label></td>
	                <td class="ui-widget ui-widget-header ui-corner-all" align="center"><label for="lblArrendaAmortiID" style="color: #ffffff">Cuota</label></td>
	                <td class="ui-widget ui-widget-header ui-corner-all" align="center"><label for="lblTipoConcepto" style="color: #ffffff">Tipo de Concepto</label></td>
	                <td class="ui-widget ui-widget-header ui-corner-all" align="center"><label for="lblDescriConcepto" style="color: #ffffff">Descripci&oacute;n</label></td>
	                <td class="ui-widget ui-widget-header ui-corner-all" align="center"><label for="lblMontoConcepto" style="color: #ffffff">Monto</label></td>
	                <td class="ui-widget ui-widget-header ui-corner-all" align="center"><label for="lblNaturaleza" style="color: #ffffff">Naturaleza</label></td>
	            </tr>
	            
	            <c:forEach items="${listaResultado}" var="movsCA" varStatus="status">
					<tr id="renglon${status.count}" name="renglon${status.count}">
			            <td><input id="fechaMovimiento${status.count}" name="fechaMovimiento" size="13" type="text" value="${movsCA.fechaMovimiento}" readonly="readonly" style="text-align: center; font-size: smaller;" class="ui-widget ui-widget-content ui-corner-all"/></td>
			            <td><input id="usuarioMovimiento${status.count}" name="usuarioMovimiento" size="20" type="text" value="${movsCA.usuarioMovimiento}" readonly="readonly" style="text-align: center; font-size: smaller;" class="ui-widget ui-widget-content ui-corner-all"/></td>
			            <td><input id="arrendaAmortiID${status.count}" name="arrendaAmortiID" size="8" type="text" value="${movsCA.arrendaAmortiID}" readonly="readonly" style="text-align: center; font-size: smaller;" class="ui-widget ui-widget-content ui-corner-all"/></td>
			            <td><input id="tipoConcepto${status.count}" name="tipoConcepto" size="20" type="text" value="${movsCA.tipoConcepto}" readonly="readonly" style="text-align: center; font-size: smaller;" class="ui-widget ui-widget-content ui-corner-all"/></td>
			            <td><input id="descriConcepto${status.count}" name="descriConcepto" size="20" type="text" value="${movsCA.descriConcepto}" readonly="readonly" style="text-align: center; font-size: smaller;" class="ui-widget ui-widget-content ui-corner-all"/></td>
			            <td><input id="montoConcepto${status.count}" name="montoConcepto" size="15" type="text" value="${movsCA.montoConcepto}" readonly="readonly" style="text-align: right; font-size: smaller;" class="ui-widget ui-widget-content ui-corner-all" esMoneda="true"/></td>
			            <td><input id="naturaleza${status.count}" name="naturaleza" size="12" type="text" value="${movsCA.naturaleza}" readonly="readonly" style="text-align: center; font-size: smaller;" class="ui-widget ui-widget-content ui-corner-all" /></td>
					</tr>
				</c:forEach>
				</table>
			</c:if>
		<c:if test="${!listaPaginada.firstPage}">
			<input onclick="movimientos('previous')" type="button" value="" id="anterior" class="btnAnterior" />
		</c:if>
		<c:if test="${!listaPaginada.lastPage}">
			<input onclick="movimientos('next')" type="button" id="siguiente" value="" class="btnSiguiente" />
		</c:if>
		
		<script type="text/javascript">
	
		/**
		* Metodo para visualizar los movimientos 
		* de Cargo y Abono registrados
		*/
		function movimientos(pageValor){
			var params = {};
			params['tipoLista'] = 1;
			params['arrendaID'] = $('#arrendaID').val();
			params['page'] 		= pageValor ;
					
			$.post("movimientosCargoAbono.htm",params,function(data) {
				if(data.length >0 || data != null) { 
					$('#contenedorMovimientos').html(data);
					agregaFormatoControles('formaGenerica');
					$('#contenedorMovimientos').show();
				}
			});
		} //fin metodo: amortizaciones 
	</script>
</fieldset>