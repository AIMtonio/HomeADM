<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<c:set var="tipoLista" value="${listaResultado[0]}" />
<c:set var="listaComisiones" value="${listaResultado[1]}" />

<c:choose>
	<c:when test="${tipoLista == '1'}">

			<table id="miTabla">
				<tbody>
					<tr>
						<td class="label" align="center" style="font-weight: bold;">
							<label for="lblClavePresupID">Fecha </label>
						</td>
						<td class="label" align="center" style="font-weight: bold;">
							<label for="lblTipoClavePresupID">Cuenta </label>
						</td>
						<td class="label" align="center" style="font-weight: bold;">
							<label for="lblClave">Tipo Comisión</label>
						</td>
						<td class="label" align="center" style="font-weight: bold;">
							<label for="lblDescripcion">Saldo Comisión</label>
						</td>
						<td class="label" align="center" style="font-weight: bold;">
							<label for="lblDescripcion">Descripción</label>
						</td>
						<td class="label" align="center" style="font-weight: bold;">
							<label for="lblDescripcion">Motivo Condonación</label>
						</td>
						<td class="label" align="center" style="font-weight: bold;">
							<label for="lblDescripcion">Tipo Condonación</label>
						</td>
						<td>
							<input type="checkbox" id="selecTodos" name="selecTodos" value="" numReg="${status.count}" onClick="seleccionarChecks('lseleccionado','selecTodos',0,'lseleccionadoCheck')"/>
						</td>
					</tr>
					<c:forEach items="${listaComisiones}" var="comisionSaldoProm" varStatus="status">
						<tr id="renglon${status.count}" name="renglon">
							<td>
								<input type="hidden" id="lcomisionID${status.count}" name="lcomisionID" value="${comisionSaldoProm.comisionID}" readOnly="true" />
								<input type="text" id="fecha${status.count}" name="fecha" size="10"
									value="${comisionSaldoProm.fechaCorte}" readOnly="true" style="text-align: center;"/>
							</td>
							<td>
								<input type="text" id="cuentaAhoID${status.count}" name="lcuentaAhoID" size="11"
									value="${comisionSaldoProm.cuentaAhoID}" readOnly="true" style="text-align: right;"/>
							</td>
							<td>
								<input type="text" id="tipoComision${status.count}" name="ltipoMotivo" size="40"
									value="${comisionSaldoProm.tipoComision}" readOnly="true" style="text-align: left;"/>
							</td>
							<td>
								<input type="text" id="saldoComision${status.count}" name="lsaldoComision" size="15"
									value="${comisionSaldoProm.totalSaldoCom}" readOnly="true" esMoneda="true" style="text-align: right;"/>
							</td>
							<td>
								<input type="text" id="descripcion${status.count}" name="descripcion" size="30"
									value="${comisionSaldoProm.descripcion}" readOnly="true" style="text-align: left;"/>
							</td>
							<td>
								<input type="text" id="lmotivoProceso${status.count}" name="lmotivoProceso" size="50"
									value="" style="text-align: left;"  maxlength="200"/>
							</td>
							<td>
								<select id="ltipoProceso${status.count}" name="ltipoProceso"></select>
							</td>
							<td>
								<input type="checkbox" id="lseleccionado${status.count}" numReg="${status.count}" name="lseleccionado" value="N" onClick="seleccionarChecks('lseleccionado','selecTodos','${status.count}','lseleccionadoCheck')"/>
								<input type="hidden" id="lseleccionadoCheck${status.count}" name="lseleccionadoCheck" value="N"/>
							</td>
						</tr>
						<c:set var="totalDetSalPend" value="${status.count}" />
					</c:forEach>
					<input type="hidden" value="${totalDetSalPend}" name="totalDetSalPend" id="totalDetSalPend" />
				</tbody>
			</table><br>
	</c:when>
		<c:when test="${tipoLista == '2'}">
			<table id="miTabla">
				<tbody>
					<tr>
						<td class="label" align="center" style="font-weight: bold;">
							<label for="lblClavePresupID">Fecha </label>
						</td>
						<td class="label" align="center" style="font-weight: bold;">
							<label for="lblTipoClavePresupID">Cuenta </label>
						</td>
						<td class="label" align="center" style="font-weight: bold;">
							<label for="lblClave">Tipo Cuenta</label>
						</td>
						<td class="label" align="center" style="font-weight: bold;">
							<label for="lblDescripcion">Comisión</label>
						</td>
						<td class="label" align="center" style="font-weight: bold;">
							<label for="lblDescripcion">IVA Comisión</label>
						</td>
						<td class="label" align="center" style="font-weight: bold;">
							<label for="lblDescripcion">Motivo Reversa</label>
						</td>
						<td class="label" align="center" style="font-weight: bold;">
							<label for="lblDescripcion">Tipo Reversa</label>
						</td>
						<td>
							<input type="checkbox" id="selecTodos" name="selecTodos" value="" onClick="seleccionarChecks('lseleccionado','selecTodos')"/>
						</td>
					</tr>
					<c:forEach items="${listaComisiones}" var="comisionSaldoProm" varStatus="status">
						<tr id="renglon${status.count}" name="renglon">
							<td>
								<input type="hidden" id="lcobroID${status.count}" name="lcobroID" value="${comisionSaldoProm.cobroID}" readOnly="true" />
								<input type="hidden" id="lcomisionID${status.count}" name="lcomisionID" value="${comisionSaldoProm.comisionID}" readOnly="true" />
								<input type="text" id="fecha${status.count}" name="fecha" size="11"
									value="${comisionSaldoProm.fechaCobro}" readOnly="true" style="text-align: center;"/>
							</td>
							<td>
								<input type="text" id="cuentaAhoID${status.count}" name="lcuentaAhoID" size="11"
									value="${comisionSaldoProm.cuentaAhoID}" readOnly="true" style="text-align: right;"/>
							</td>
							<td>
								<input type="text" id="tipoComision${status.count}" name="ltipoMotivo" size="40"
									value="${comisionSaldoProm.tipoComision}" readOnly="true" style="text-align: left;"/>
							</td>
							<td>
								<input type="text" id="saldoComision${status.count}" name="lsaldoComision" size="15"
									value="${comisionSaldoProm.comSaldoPromCob}" readOnly="true" esMoneda="true" style="text-align: right;"/>
							</td>
							<td>
								<input type="text" id="IVAComSalPromCob${status.count}" name="lIVAsaldoComision" size="15"
									value="${comisionSaldoProm.IVAComSalPromCob}" readOnly="true" esMoneda="true" style="text-align: right;"/>
							</td>
							<td>
								<input type="text" id="lmotivoProceso${status.count}" name="lmotivoProceso" size="50"
									value="" style="text-align: left;" maxlength="200"/>
							</td>
							<td>
								<select id="ltipoProceso${status.count}" name="ltipoProceso"></select>
							</td>
							<td>
								<input type="checkbox" id="lseleccionado${status.count}" numReg="${status.count}" name="lseleccionado" value="N" onClick="seleccionarChecks('lseleccionado','selecTodos','${status.count}','lseleccionadoCheck')"/>
								<input type="hidden" id="lseleccionadoCheck${status.count}" name="lseleccionadoCheck" value="N"/>
							</td>
						</tr>
						<c:set var="totalSalPromPag" value="${status.count}" />
					</c:forEach>
					<input type="hidden" value="${totalSalPromPag}" name="totalSalPromPag" id="totalSalPromPag" />
				</tbody>
			</table><br>
	</c:when>
</c:choose>

<script type="text/javascript">
	if($("#totalDetSalPend").asNumber()>0){
		listaComboCatCondonacion($("#totalDetSalPend").asNumber());
	}
	if($("#totalSalPromPag").asNumber()>0){
		listaComboCatReversa($("#totalSalPromPag").asNumber());
	}

</script>