<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<c:set var="tipoLista" value="${listaResultado[0]}" />
<c:set var="listaCta" value="${listaResultado[1]}" />

<c:choose>
	<c:when test="${tipoLista == '23'}">
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
			<legend>Cuentas </legend>
			<table id="miTablaCtas">
				<tbody>
					<tr>
						<td class="label" align="center" style="font-weight: bold;">
							<label for="lblClavePresupID">N&uacute;mero de Cuenta </label>
						</td>
						<td class="label" align="center" style="font-weight: bold;">
							<label for="lblTipoClavePresupID">Tipo Cuenta </label>
						</td>
						<td class="label" align="center" style="font-weight: bold;">
							<label for="lblClave">Saldo Disponible</label>
						</td>
						<td class="label" align="center" style="font-weight: bold;">
							<label for="lblDescripcion">Saldo Comisi&oacute;n Pendiente</label>
						</td>
					</tr>
					<c:forEach items="${listaCta}" var="cuentas" varStatus="status">
						<tr id="renglon${status.count}" name="renglon">
							<td>
								<input type="text" id="cuentaAhoID${status.count}" name="cuentaAhoID" size="12"
									value="${cuentas.cuentaAhoID}" readOnly="true" style="text-align: right;"/>
							</td>
							<td>
								<input type="text" id="descripcionTipoCta${status.count}" name="descripcionTipoCta" size="25"
									value="${cuentas.descripcionTipoCta}" readOnly="true" style="text-align: left;"/>
							</td>
							<td>
								<input type="text" id="saldoDispon${status.count}" name="saldoDispon" size="15"
									value="${cuentas.saldoDispon}" readOnly="true" esMoneda="true" style="text-align: right;" />
							</td>
							<td>
								<input type="text" id="saldoPendiente${status.count}" name="saldoPendiente" size="15"
									value="${cuentas.saldoPendiente}" readOnly="true" esMoneda="true" style="text-align: right;"/>
								<input type="checkbox" id="seleccionado${status.count}" name="seleccionado" value="B" maxlength="45"  disabled="disabled" style="display: none;"/>
								<input type="button" id="estatusBloq${status.count}"  name="estatusBloq" size="45"
									onclick="accionImgCandado('miTablaCtas', 'seleccionado', 'estatusBloq','${status.count}','gridComisionesSaldoPromedio'), consultaComicionesPendientesGrid('${cuentas.cuentaAhoID}','seleccionado${status.count}');" maxlength="45" onblur=""
									style="cursor: auto; color: transparent;"/>
							</td>
						</tr>
						<c:set var="numeroTotalCondona" value="${status.count}" />
					</c:forEach>
					<input type="hidden" value="${numeroTotalCondona}" name="numeroTotalCondona" id="numeroTotalCondona" />
				</tbody>

			</table><br>
		</fieldset>
	</c:when>

</c:choose>

<script type="text/javascript" >
	inicializaImgCandado('miTablaCtas', 'seleccionado', 'estatusBloq');
</script>