<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head>
</head>

<body>
	<c:set var="tipoLista"  value="${listaResultado[0]}"/>
	<c:set var="listaPaginada" value="${listaResultado[1]}" />
	<c:set var="listaResultado" value="${listaPaginada.pageList}"/>


	<c:choose>
		<c:when test="${tipoLista == '2'}">
			<table  id="gvMain">
				<thead>
					<tr class="GridViewScrollHeader">
						<td nowrap="nowrap">
							Solicitud
						</td>
						<td nowrap="nowrap">
							Cliente
						</td>
						<td nowrap="nowrap">
							Nombre	
						</td>	
						<td nowrap="nowrap">
							Cr&eacute;dito
						</td>
						<td nowrap="nowrap">
							Cliente Riesgo
						</td>
						<td nowrap="nowrap">
							Nombre
						</td>	
						<td nowrap="nowrap">
							Monto Ac. Cr.
						</td>	
						<td nowrap="nowrap">
							Parentesco
						</td>	
						<td nowrap="nowrap">
							Estatus
						</td>	
						<td nowrap="nowrap">
							Clave
						</td>										
						<td nowrap="nowrap">
							Motivo
						</td>
						<td nowrap="nowrap">
							Riesgo Com&uacute;n
						</td>

						<td nowrap="nowrap">
							Comentarios
						</td>
						<td nowrap="nowrap">
							Comentarios Monitor
						</td>
						<td nowrap="nowrap">
							Procesado
						</td>						
					</tr>
					<tr class="GridViewScrollHeaderSelecciona">
						<td nowrap="nowrap"></td>
						<td nowrap="nowrap"></td>
						<td nowrap="nowrap"></td>
						<td nowrap="nowrap"></td>
						<td nowrap="nowrap"></td>
						<td nowrap="nowrap"></td>
						<td nowrap="nowrap"></td>
						<td nowrap="nowrap"></td>
						<td nowrap="nowrap"></td>
						<td nowrap="nowrap"></td>
						<td nowrap="nowrap"></td>
						<td nowrap="nowrap"></td>
						<td nowrap="nowrap"></td>
						<td nowrap="nowrap" align="right" id="lblEncabezado">
							Selecciona Todas:
						</td>
						<td nowrap="nowrap" align="center" id="CheckSelecTodasEnc">
							<input type="checkbox" id="selecTodas" name="selecTodas" onclick="seleccionaTodas()" value="" />
						</td>										
					</tr>
				</thead>

				<c:forEach items="${listaResultado}" var="riesgoComunLis" varStatus="status">
					<tr id="renglons${status.count}" name="renglons" class="GridViewScrollItem" onclick="trSelected(this.id)">
						<td nowrap="nowrap">
							<input type="text" id="solicitudCreditoID${status.count}" name="lisSolicitudCreditoID" width="150px" size="12" value="${riesgoComunLis.solicitudCreditoID}" readOnly="true"  />							
						</td>
						<td nowrap="nowrap">
							<input type="hidden" id="clienteID${status.count}" name="lisClienteID" size="10" value="${riesgoComunLis.clienteID}" readOnly="true"  />
							<input type="text" id="clienteIDDesc${status.count}" size="10" value="${riesgoComunLis.clienteIDDesc}" readOnly="true"  />	

						</td >	
						<td nowrap="nowrap">
							<input type="text" id="nombreCliente${status.count}" name="lisNombreCliente" size="30" value="${riesgoComunLis.nombreCliente}" readOnly="true" />	

						</td>
						<td nowrap="nowrap">
							<input type="text" id="creditoID${status.count}" name="lisCreditoID" size="12" value="${riesgoComunLis.creditoID}" readOnly="true"  />							
						</td>				
						<td nowrap="nowrap">
							<input type="text" id="clienteIDRel${status.count}" name="lisClienteIDRel" size="16" align="center" value="${riesgoComunLis.clienteIDRel}" readOnly="true"  />	

						</td>	
						<td nowrap="nowrap">
							<input type="text" id="nombreClienteRel${status.count}" name="lisNombreClienteRel" size="35" value="${riesgoComunLis.nombreClienteRel}" readOnly="true"   />	

						</td>
						<td nowrap="nowrap">
							<input id="montoAcumulado${status.count}" name="lisMontoAcumulado" size="18" type="text"  esMoneda="true" readOnly="true" style="text-align: right;"  value="${riesgoComunLis.montoAcumulado}" />
						</td>
						<td nowrap="nowrap">
							<input id="descParen${status.count}" name="lisDescParen" size="15" type="text"  readOnly="true"  value="${riesgoComunLis.descParen}" />
						</td>	
						<td nowrap="nowrap">
							<input type="text" id="estatusDes${status.count}" name="lisEstatusDesc" size="15" value="" readOnly="true"  />
							<input type="hidden" id="estatus${status.count}" name="lisEstatus" size="25" value="${riesgoComunLis.estatus}" readOnly="true"  />	

						</td>	
						<td nowrap="nowrap">
							<input type="text" id="clave${status.count}" name="lisClave" size="10" maxlength = "2" value="${riesgoComunLis.clave}" onkeypress="validaSoloNumeros()"  />	

						</td>					
						<td nowrap="nowrap">
							<input type="text" id="motivo${status.count}" name="lisMotivo" size="28" value="${riesgoComunLis.motivo}" readOnly="true"  />	

						</td>					
						<td nowrap="nowrap">
							<input type="hidden" id="esRiesgo${status.count}" name="lisEsRiesgo" size="3" value="${riesgoComunLis.esRiesgo	}"  />							
							<input type="radio"  id="riesgoSI${status.count}"  name="opcRadio${status.count}" value = "S" tabindex="2" onclick="seleccionaSI(this.id)" >
							<label for="nueva">Si </label>&nbsp;&nbsp;
							<input type="radio" id="riesgoNO${status.count}" name="opcRadio${status.count}" value = "N"  onclick="seleccionaNO(this.id)" tabindex="3">
							<label for="reposicion">No</label>

						</td>													  						  			
						<td nowrap="nowrap">
							<textarea id="comentarios${status.count}" name="lisComentarios" COLS="28" ROWS="2" onBlur=" ponerMayusculas(this)" readOnly="true"   maxlength = "500"  autocomplete="off"> ${riesgoComunLis.comentarios}</textarea>
							<textarea id="comentario${status.count}" name="lisComentario" COLS="28" ROWS="2" style="display:none;" onBlur=" ponerMayusculas(this)"  maxlength = "500"  autocomplete="off"> ${riesgoComunLis.comentarios}</textarea>
						</td>	
						<td nowrap="nowrap">
							<textarea id="comentariosMonitor${status.count}" name="lisComentariosMonitor" COLS="28" ROWS="2" onBlur=" ponerMayusculas(this)"  maxlength = "200"  autocomplete="off">${riesgoComunLis.comentariosMonitor}</textarea>
						</td>
						<td nowrap="nowrap"  id="CheckSelecTodas">
							<input type="checkbox" id="checkProc${status.count}" name="checkProc"  readOnly="true" value="${riesgoComunLis.procesado}" onclick="verificaProcesado(this.id)"/>
							<input  type="hidden" id="procesado${status.count}" name="lisProcesado"  value="${riesgoComunLis.procesado}" size="10"/>
						</td> 	
						<td nowrap="nowrap">
							<input type="hidden" id="consecutivoID${status.count}" name="lisConsecutivoID" size="10" value="${riesgoComunLis.consecutivoID}" readOnly="true"  />							
						</td>

					</tr>					
				</c:forEach>
			</table>
		</c:when>
	</c:choose>

<c:if test="${!listaPaginada.firstPage}">
	<input onclick="generaSeccion('previous')" type="button" id="anterior" value="" class="btnAnterior" />
</c:if>
<c:if test="${!listaPaginada.lastPage}">
	<input onclick="generaSeccion('next')" type="button" id="siguient" value="" class="btnSiguiente" />
</c:if>

</body>
</html>	

<script type="text/javascript">
	var gridViewScroll = null;
</script>