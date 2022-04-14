<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>


<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="listaResultado" value="${listaResultado[1]}"/>

<form id="pagoRemesasTraspasosSpeiBean" name="pagoRemesasTraspasosSpeiBean">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<table id="tablaGrid" border="0" cellpadding="0" cellspacing="0" width="100%">
			<c:choose>
				<c:when test="${tipoLista == '1'}">
				  	<tr id="encabezadoLista">
				  		<th style="visibility: hidden;"></th>
				  		<th style="visibility: hidden;"></th>
				  		<th style="visibility: hidden;"></th>
						<th>Num</th>
						<th>Cuenta Destino</th>
						<th>Nombre Beneficiario</th>
						<th align="center">Monto</th>
						<th align="center"><input type="checkbox" id="seleccionaTodos" name="seleccionaTod" onchange="seleccionarTodos(this)"></th>
					</tr>
					<tbody id="tbodyRemesas">
						<c:forEach items="${listaResultado}" var="pagoRem" varStatus="status">
							<tr id="renglon${status.count}" name="renglon">
								<td style="visibility: hidden;">
									<input id="speiTransID${status.count}" name="speiTransID" size="3" value="${pagoRem.speiTransID}"
										readOnly="true" disabled="true" type="hidden" style='text-align:left;' />
								</td>
								<td style="visibility: hidden;">
									<input id="cuentaAho${status.count}" name="cuentaAho" size="3" value="${pagoRem.cuentaAho}"
										readOnly="true" disabled="true" type="hidden" style='text-align:left;' />
								</td>
								<td style="visibility: hidden;">
									<input id="clienteID${status.count}" name="clienteID" size="3" value="${pagoRem.clienteID}" readOnly="true"
										disabled="true" type="hidden" style='text-align:left;' />
									<input id="banco${status.count}" name="banco" value="${pagoRem.banco}" type="hidden"/>
									<input id="sucursal${status.count}" name="sucursal" value="${pagoRem.sucursal}" type="hidden"/>
								</td>
								<td>
									<input id="consecutivoID${status.count}" name="consecutivoID" size="6" value="${status.count}"
										readOnly="true" disabled="true" type="text" style='text-align:left;' />
								</td>
								<td>
									<input type="text" id="clabeCli${status.count}" name="clabeCli" size="26" value="${pagoRem.clabeCli}"
										readOnly="true" disabled="true" style='text-align:left;' />
								</td>
								<td>
									<input type="text" id="nombreCli${status.count}" name="nombreCli" size="46" value="${pagoRem.nombreCli}"
										readOnly="true" disabled="true" style='text-align:left;' />
								</td>
								<td>
									<input type="text" id="monto${status.count}" name="monto" size="15" esMoneda="true" class="montoRemesa"
										value="${pagoRem.monto}" readOnly="true" style='text-align:right;' />
								</td>

								<td align="center"><input type="checkbox" id="enviar${status.count}" class="checkRemesa" name="enviar"
										onchange="sumarRemesas()" style='text-align:center;' />
								</td>
							</tr>

							<tr>
								<td>
									<input id="nombreRemesedora${status.count}" name="nombreRemesedora" value="${pagoRem.nombreRemesedora}" type="hidden"/>
									<input id="razonSocialRemesedora${status.count}" name="razonSocialRemesedora" value="${pagoRem.razonSocialRemesedora}" type="hidden"/>
									<input id="clienteIDRemesedora${status.count}" name="clienteIDRemesedora" value="${pagoRem.clienteIDRemesedora}" type="hidden"/>
									<input id="tipoCuentaRemesedora${status.count}" name="tipoCuenta" value="${pagoRem.tipoCuentaRemesedora}" type="hidden"/>
									<input id="cuentaRemesedora${status.count}" name="cuentaRemesedora" value="${pagoRem.cuentaRemesedora}" type="hidden"/>
								</td>
							</tr>
						</c:forEach>
					</tbody>
				</c:when>
			</c:choose>
		</table>
	</fieldset>
</form>