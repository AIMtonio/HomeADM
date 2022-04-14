<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<c:set var="listaResultado"  value="${listaResultado}"/>
<%! int numFilas = 0; %>
<%! int counter = 4; %>

<div id="tablaAportaciones">
	<table id="tbAportaciones" border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td class="label" style=""  nowrap="nowrap" ><label for="cuenta">Cuenta</label></td>
				<td class="label" style=""  nowrap="nowrap" ><label for="nombreAportante">Nombre Aportante</label></td>
				<td class="label" style=""  nowrap="nowrap" ><label for="CLABE">CLABE</label></td>
				<td class="label" style=""  nowrap="nowrap" ><label for="beneficiario">Beneficiario</label></td>
				<td class="label" style=""  nowrap="nowrap" ><label for="institucion">Instituci&oacute;n</label></td>
				<td class="label" style=""  nowrap="nowrap" ><label for="capital">Capital</label></td>
				<td class="label" style=""  nowrap="nowrap" ><label for="interes">Inter&eacute;s</label></td>
				<td class="label" style=""  nowrap="nowrap" ><label for="ISR">ISR</label></td>
				<td class="label" style=""  nowrap="nowrap" ><label for="Total">Total</label></td>
				<td class="label" style=""  nowrap="nowrap" ><label for="pendiente">Pendiente</label></td>
				<td class="label" style=""  nowrap="nowrap" ><label for="monto">Monto</label></td>
				<td class="label" style="text-align: center;" ><label for="autorizar">Todos<br><input type="checkbox" id="seleccionarTodas" onclick="marcarTodasCheck('autoriza',this.id);habilitaBoton('grabar');habilitaBoton('procesar');"/></label></td>
				<td class="label" style="" ><label></label></td>
			</tr>
			<c:forEach items="${listaResultado}" var="detalle" varStatus="status">
				<% numFilas=numFilas+1; %>
				<% counter++; %>
				<tr id="trAp${detalle.aportacionID}${detalle.amortizacionID}${status.count}" name="trAp">
					<td nowrap="nowrap" ><input id="cuentaAhoID${detalle.aportacionID}${detalle.amortizacionID}${status.count}" readOnly="true" name="cuentaAhoID" size="13" value="${detalle.cuentaAhoID}" autocomplete="off" /></td>
					<td nowrap="nowrap" ><input type="text" id="nombreCompleto${detalle.aportacionID}${detalle.amortizacionID}${status.count}" name="nombreCompleto" size="30" value="${detalle.nombreCompleto}" maxlength="100" disabled="disabled"/></td>


					<td nowrap="nowrap" ><input type="text" id="clabe${detalle.aportacionID}${detalle.amortizacionID}${status.count}" tabindex="<%=counter %>" name="clabe" size="31" maxlength="30" value="${detalle.clabe}" onKeyUp="obtenerCuentaExt('${detalle.aportacionID}${detalle.amortizacionID}${status.count}');" onblur="validaCampoRep('clabe${detalle.aportacionID}${detalle.amortizacionID}${status.count}','cuentaAhoID${detalle.aportacionID}${detalle.amortizacionID}${status.count}');consultaClabe('clabe${detalle.aportacionID}${detalle.amortizacionID}${status.count}','trAp${detalle.aportacionID}${detalle.amortizacionID}${status.count}');"  /></td>


					<td nowrap="nowrap"><input type="text" id="beneficiario${detalle.aportacionID}${detalle.amortizacionID}${status.count}" tabindex="-1" name="beneficiario" size="38" value="${detalle.beneficiario}" disabled="disabled"/></td>

					<td nowrap="nowrap" ><input type="hidden" id="institucionID${detalle.aportacionID}${detalle.amortizacionID}${status.count}" tabindex="-1" name="institucionID" size="10" value="${detalle.institucionID}" disabled="disabled"/><input type="text" id="nombreInstitucion${detalle.aportacionID}${detalle.amortizacionID}${status.count}" tabindex="-1" name="nombreInstitucion" size="25" value="${detalle.nombre}" disabled="disabled"/></td>
					<td nowrap="nowrap" ><input type="text" id="capital${detalle.aportacionID}${detalle.amortizacionID}${status.count}" tabindex="-1" name="capital" size="18" value="${detalle.capital}"  disabled="disabled" style="text-align: right;" esMoneda="true"/></td>
					<td nowrap="nowrap" ><input type="text" id="interes${detalle.aportacionID}${detalle.amortizacionID}${status.count}" tabindex="-1" name="interes" size="15" value="${detalle.interes}"  disabled="disabled" style="text-align: right;" esMoneda="true"/></td>
					<td nowrap="nowrap" ><input type="text" id="interesRetener${detalle.aportacionID}${detalle.amortizacionID}${status.count}" tabindex="-1" name="interesRetener" size="15" value="${detalle.interesRetener}"  disabled="disabled" style="text-align: right;" esMoneda="true"/></td>
					<td nowrap="nowrap" ><input type="text" id="total${detalle.aportacionID}${detalle.amortizacionID}${status.count}" tabindex="-1" name="total" size="20" value="${detalle.total}"  disabled="disabled" style="text-align: right;" esMoneda="true"/></td>
					<td style="text-align: center;" nowrap="nowrap" >
						<c:choose>

							<c:when test="${detalle.total == '0.00'}">
								<input type="text" id="montoPendiente${detalle.aportacionID}${detalle.amortizacionID}${status.count}" tabindex="-1" name="pendiente" size="20" value="0.00"  disabled="disabled" style="text-align: right;" esMoneda="true"/>
							</c:when>
							<c:otherwise>
								<input type="text" id="montoPendiente${detalle.aportacionID}${detalle.amortizacionID}${status.count}" tabindex="-1" name="pendiente" size="20" value="${detalle.montoPendiente}"  disabled="disabled" style="text-align: right;" esMoneda="true"/>
								<input type="hidden" id="totalMontoPendiente${detalle.aportacionID}${detalle.amortizacionID}${status.count}" tabindex="-1" name="totalMontoPendiente" size="20" value="${detalle.totalMontoPendiente}"  disabled="disabled" style="text-align: right;" esMoneda="true"/>
							</c:otherwise>
						</c:choose>
					</td>
					<td nowrap="nowrap" ><input type="text" id="monto${detalle.aportacionID}${detalle.amortizacionID}${status.count}" tabindex="<%=counter %>" name="monto" size="20" maxlength="20" value="${detalle.monto}" style="text-align: right;" esMoneda="true" onblur="validaMonto('clienteID${detalle.aportacionID}${detalle.amortizacionID}${status.count}', 'cuentaAhoID${detalle.aportacionID}${detalle.amortizacionID}${status.count}','monto${detalle.aportacionID}${detalle.amortizacionID}${status.count}')"/>
					</td>
					<td style="text-align: center;" nowrap="nowrap" >
						<c:choose>
							<c:when test="${detalle.estatus == 'S'}">
								<input type="checkbox" id="autoriza${detalle.aportacionID}${detalle.amortizacionID}${status.count}" name="autoriza" tabindex="<%=counter %>" checked="checked" onclick="habilitaBoton('grabar');habilitaBoton('procesar');" />
							</c:when>
							<c:otherwise>
								<input type="checkbox" id="autoriza${detalle.aportacionID}${detalle.amortizacionID}${status.count}" name="autoriza" tabindex="<%=counter %>" onclick="habilitaBoton('grabar');habilitaBoton('procesar');" />
							</c:otherwise>
						</c:choose>
					</td>
					<td nowrap="nowrap" >
								<input type="button" id="agregar${detalle.aportacionID}${detalle.amortizacionID}${status.count}" name="agregar" value="" class="btnAgrega" onclick="consultaBeneficiarios('benefGrid${status.count}','trAp${detalle.aportacionID}${detalle.amortizacionID}${status.count}',${detalle.clienteID},${detalle.aportacionID},${detalle.amortizacionID})" tabindex="<%=counter %>"/>
					</td>
						<input type="hidden" id="clienteID${detalle.aportacionID}${detalle.amortizacionID}${status.count}" name="clienteID" value="${detalle.clienteID}"/>
						<input type="hidden" id="aportacionID${detalle.aportacionID}${detalle.amortizacionID}${status.count}" name="aportacionID" size="15" value="${detalle.aportacionID}"/>
						<input type="hidden" id="amortizacionID${detalle.aportacionID}${detalle.amortizacionID}${status.count}" name="amortizacionID" size="15" value="${detalle.amortizacionID}" />
						<input type="hidden" id="cuentaTranID${detalle.aportacionID}${detalle.amortizacionID}${status.count}"  name="cuentaTranID" size="15" value="${detalle.cuentaTranID}" />
						<input type="hidden" id="tipoCuentaID${detalle.aportacionID}${detalle.amortizacionID}${status.count}"  name="tipoCuentaID" size="15" value="${detalle.tipoCuentaID}" />
						<input type="hidden" id="esPrincipal${detalle.aportacionID}${detalle.amortizacionID}${status.count}" name="esPrincipal" size="2" value="${detalle.esPrincipal}" disabled="true"/>
					<td class="separador"></td>
				</tr>
				<tr>
					<td colspan="13">
						<div id="benefGrid${status.count}"></div>
					</td>
				</tr>

			</c:forEach>
	</table>
</div>
<script type="text/javascript" >

	$('#btnAgregar').focus();
	var totalDispersiones = getRenglones('trAp');
	$('#totalDispersiones').val(totalDispersiones);
	if(Number(totalDispersiones) == 0){
		mostrarDispersiones(false);
		mensajeSis('No hay Aportaciones por Dispersar.');
		deshabilitaBoton('grabar');
	} else {
		desbloquearPantalla();
		mostrarDispersiones(true);
		habilitaBoton('grabar');
	}
	consultaTotales();
	agregaFormatoControles('formaGenerica');

</script>
<input type="hidden" id="numTab" value="<%=counter %>"/>
<input type="hidden" id="numeroFila" value="<%=numFilas %>"/>
<% numFilas=0; %>
<% counter=4; %>