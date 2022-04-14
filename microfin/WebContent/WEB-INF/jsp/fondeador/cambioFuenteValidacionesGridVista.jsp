<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<c:set var="tipoLista" value="${listaResultado[0]}" />
<c:set var="listaPaginada" value="${listaResultado[1]}"/>
<c:set var="listaCredFondeoError" value="${listaPaginada.pageList}" />


<c:choose>
	<c:when test="${tipoLista == '1'}">
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
			<legend>Validaciones </legend>
			<table id="miTabla">
				<tbody>
					<tr>				
						<td class="label" align="center" style="font-weight: bold;"> 
							<label for="lblClavePresupID">Num. Registro</label>
						</td>
						<td class="label" align="center" style="font-weight: bold;">
							<label for="lblTipoClavePresupID">Crédito</label>
						</td>
						<td class="label" align="center" style="font-weight: bold;">
							<label for="lblClave">Tipo </label>
						</td>
						<td class="label" align="center" style="font-weight: bold;">
							<label for="lblDescripcion">Incidencia</label>
						</td>
					</tr>
					
					<c:forEach items="${listaCredFondeoError}" var="credFondeoError" varStatus="status">
						<tr id="renglon${status.count}" name="renglon" class="${credFondeoError.estatus}">
							<td>
								<input type="text" id="filaArchivo${status.count}" name="filaArchivo${status.count}" size="10"  value="${credFondeoError.filaArchivo}" readOnly="true" style="text-align: center;"/>
							</td>
							
							<td>
								<input type="text"  id="creditoID${status.count}" name="creditoID${status.count}" size="20" value="${credFondeoError.creditoID}"  readOnly="true"/>
							</td>

							<td>
								<input type="text" id="estatus${status.count}" name="estatus${status.count}" size="13" value="${credFondeoError.estatus}"  readOnly="true"/>
							</td>

							<td>
								<input type="text"  id="descripcionEstatus${status.count}" name="descripcionEstatus${status.count}" size="50" value="${credFondeoError.descripcionEstatus}" readOnly="true"/>
							</td>
						</tr>
						<c:set var="contador" value="${status.count}"/>
					</c:forEach>
					<input type="hidden" value="${listaCredFondeoError[0].cantError}" name="totalError" id="totalError" />
					<input type="hidden" value="${contador}" name="numero" id="numero" />
				</tbody>	
			</table>
		</fieldset>
	</c:when>
</c:choose>
<c:if test="${!listaPaginada.firstPage}">
	<input onclick="validaFondeo('previous')" type="button" value=""
		id="anterior" class="btnAnterior" />
</c:if>
<c:if test="${!listaPaginada.lastPage}">
	<input onclick="validaFondeo('next')" type="button" id="siguiente"
		value="" class="btnSiguiente" />
</c:if>

<script type="text/javascript">
	function validaFondeo(pageValor) {
		var params = {};
		params['tipoLista'] = 1;
		params['pagina'] = pageValor;

		$.post("camFondeoMasivoListaVal.htm", params, function(data) {
			if (data.length > 0 || data != null) {
				$('#listaValidaciones').html(data);
				$('#listaValidaciones').show();
			}
		});
	} 
</script>

<style type="text/css">
.Error { background-color: #FF3000; }
.Advertencia {background-color: #ffa700;}
</style>
