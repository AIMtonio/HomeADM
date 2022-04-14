<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>

	<c:set var="listaPaginada" value="${listaResultado[0]}" />
	<c:set var="listaResultado" value="${listaPaginada.pageList}"/>

<div id="tablaAutoriza">
	<table id="miTablaAutoriza" border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr align="center">
			<td class="label" ><label for="lblNumero">N&uacute;mero</label></td>
			<td class="label" ><label for="lblCuenta">Cuenta Cargo</label></td>
			<td class="label" ><label for="lblClienteID">Nombre <s:message code="safilocale.cliente"/></label></td>
			<td class="label" ><label for="lblCuenta">Cuenta Contable</label></td>
			<td class="label" ><label for="lblNombreCte">Descripci&oacute;n</label></td>
			<td class="label" ><label for="lblReferencia">Referencia</label></td>
			<td class="label" ><label for="lblTipoMov">Forma Pago</label></td>
			<td class="label" ><label for="lblConcepDisp">Concepto Dispersi&oacute;n</label></td>
			<td class="label" ><label for="lblTipoChequera">Formato <br>Cheque</label></td>
			<td class="label" ><label for="lblMonto">Monto</label></td>
			<td class="label" ><label for="lblClabe">Cuenta CLABE<br> Núm. de Cheque <br> Núm. Tarjeta/Cta Cheques<br>Ref. Orden Pago</label></td>
			<td class="label" ><label for="lblNombreBen">Nombre del<br>Beneficiario</label></td>
			<td class="label" ><label for="lblFfechaEnvio">Fecha de<br>Envio</label></td>
			<td class="label" ><label for="lblRFC">RFC</label></td>
			<td class="label" ><label for="lblEstatus">Autorizar</label>
			<br>
				<input type="checkbox" id="seleccionCheck" name="seleccionCheck" checked="checked" onclick="checkTodos()"/>
			</td>
		</tr>

		<c:forEach items="${listaResultado}" var="movsInter" varStatus="status">
			<tr id="renglon${status.count}" name="renglon">
				<td> 
					<input id="consecutivoIDA${status.count}" readOnly="true" name="consecutivoIDA" size="3"  value="${status.count}"  autocomplete="off" /> 
					<input type="hidden" id="tipoMovA${status.count}" name="tipoMovA" value="${movsInter.gridTipoMov}" />   
					<input type="hidden" id="claveDispMovA${status.count}" name="claveDispMovA" value="${movsInter.claveDispersion}" />       							  	
				</td>
				<td> 
					<input id="cuentaAhoIDA${status.count}" readOnly="true"  name="cuentaAhoIDA" size="13"  value="${movsInter.gridCuentaAhoID}"  autocomplete="off" onblur="maestroCuentasDescripcion('cuentaAhoID${status.count}','nombreCte${status.count}','clienteID${status.count}', 'saldo${status.count}');"/> 
					<input type="hidden" id="saldoA${status.count}" name="saldoA" readonly="true" />							  	
				</td> 

				<td>
					<input type="text" id="nombreCteA${status.count}"  readOnly="true" name="nombreCteA"  autocomplete="off" />
					<input type="hidden" id="clienteIDA${status.count}" name="clienteIDA" value="" readonly="true"/>
				</td>
				<td>
					<input id="cuentaCompletaIDA${status.count}" readOnly="true"  name="cuentaCompletaIDA" size="35"  value="${movsInter.cuentaContable}"
					title="${movsInter.descCtaContable}" autocomplete="off"/>
				</td>
				<td>
					<input id="descripcionA${status.count}" readOnly="true" name="descripcionA" size="10"  value="${movsInter.gridDescripcion}" />
				</td>
				<td>
					<input id="referenciaA${status.count}" readOnly="true" name="referenciaA" size="10" value="${movsInter.gridReferencia}" />
				</td>

				<td align="center">
					<c:choose>
						<c:when test="${movsInter.gridFormaPago == '1'}">
							<input id = "labelSpei${status.count}" value="SPEI" readOnly="true"  size="8" ></input>
								<input type="hidden" id="formaPagoA${status.count}" name="formaPagoA" value="1" />
						</c:when>
						<c:when test="${movsInter.gridFormaPago == '2'}">
 							<input id = "labelOrdenPago${status.count}" value="CHEQUE" readOnly="true" size="8"></<input >
 								<input type="hidden" id="formaPagoA${status.count}" name="formaPagoA" value="2" />
 						</c:when>
						<c:when test="${movsInter.gridFormaPago == '3'}">
 							<input id = "labelOrdenPago${status.count}" value="BANCA ELECTRONICA" readOnly="true" size="8"></<input >
 								<input type="hidden" id="formaPagoA${status.count}" name="formaPagoA" value="3" />
 						</c:when>
						<c:when test="${movsInter.gridFormaPago == '4'}">
 							<input id = "labelOrdenPago${status.count}" value="TARJETA EMPRESARIAL" readOnly="true" size="8"></<input >
 								<input type="hidden" id="formaPagoA${status.count}" name="formaPagoA" value="4" />
 						</c:when>
 						<c:when test="${movsInter.gridFormaPago == '5'}">
 							<input id = "labelOrdenPago${status.count}" value="ORDEN DE PAGO" readOnly="true" size="8"></<input >
 								<input type="hidden" id="formaPagoA${status.count}" name="formaPagoA" value="5" />
 						</c:when>
 						<c:when test="${movsInter.gridFormaPago == '6'}">
 							<input id = "labelOrdenPago${status.count}" value="TRAN. SANTANDER" readOnly="true" size="8"></<input > 
 								<input type="hidden" id="formaPagoA${status.count}" name="formaPagoA" value="6" />
 						</c:when>
					</c:choose>
				</td>
				<td>
					<input type="hidden" id="conceptoDisp${status.count}"  name="conceptoDisp" size="30" value="${movsInter.gridConceptoDisp}"/>
					<select id="sConceptoDisp${status.count}" name="sConceptoDisp" tabindex="8" onblur="validarConcepto(${status.count});">
					</select>
				</td>
				<td>
					<input type="hidden" id="tipoChequera${status.count}"  name="tipoChequera" size="20" value="${movsInter.gridTipoChequera}"/>
					<select id="stipoChequera${status.count}" name="stipoChequera" tabindex="8" onblur="validarFolio(${status.count});">
					</select>
				</td>
				<td>
					<input id="montoA${status.count}" readOnly="true"  style="text-align:right;" name="montoA" size="14" value="${movsInter.gridMonto}" onblur="validarMontoAutoriza(${status.count})" />
				</td>
			  	<td>
			  	   <c:choose>
			  	    <c:when test="${movsInter.gridFormaPago == '1'}">
					<input id="cuentaClabeA${status.count}"  readOnly="true"   name="cuentaClabeA" size="20" maxlength="18" value="${movsInter.gridCuentaClabe}"  />
				   </c:when>
				   <c:when test="${movsInter.gridFormaPago == '2'}">
				   <input id="cuentaClabeA${status.count}"    name="cuentaClabeA" size="20" maxlength="20" value="${movsInter.gridCuentaClabe}"  onkeyPress="return ValidadorVerifica(event,'${status.count}' , this);" />
				   </c:when>
				     <c:when test="${movsInter.gridFormaPago == '5'}">
				   <input id="cuentaClabeA${status.count}"    name="cuentaClabeA" size="20" maxlength="25" value="${movsInter.gridCuentaClabe}" onBlur=" ponerMayusculas(this)" onkeyPress="return ValidadorVerifica(event,'${status.count}' , this);"/>
				   </c:when>
				   <c:otherwise>
				   		<input id="cuentaClabeA${status.count}"    name="cuentaClabeA" size="20" maxlength="20" value="${movsInter.gridCuentaClabe}" onkeyPress="return ValidadorVerifica(event,'${status.count}' , this);"/>
				   </c:otherwise>
				   </c:choose>
				</td>
				<td>
					<input type="text" id="nombreBenefiA${status.count}"    name="nombreBenefiA" value="${movsInter.gridNombreBenefi}" />
				</td>
				<td>
					<input id="fechaEnvioA${status.count}" readOnly="true"  name="fechaEnvioA"  size="14"  tabindex="9"  path="fechaEnvio" value="${movsInter.gridFechaEnvio}" readOnly="true" />
				</td>
                <td>
					<input id="rfcA${status.count}" readOnly="true"  name="rfcA" size="12" value="${movsInter.gridRFC}" />
				</td>
				<td align="center">
              		<input type="checkbox" id="autorizaCheck${status.count}" name="autorizaCheck" checked="checked" onclick="verificaAutorizar(${status.count});"/>
					<input type="hidden" id="autorizaCheckHidden${status.count}" name="estatusA" value="A" />
				</td>
			</tr>
			<c:set var="cont" value="${status.count}"/>
		</c:forEach>

	</table>
	<c:if test="${!listaPaginada.firstPage}">
		<input onclick="generaSeccion('previous')" type="button" id="anterior" value="" class="btnAnterior" />
	</c:if>
	<c:if test="${!listaPaginada.lastPage}">
		<input onclick="generaSeccion('next')" type="button" id="siguiente" value="" class="btnSiguiente" />
	</c:if>
	<input type="hidden" value="${cont}" name="numeroDetalleAuto" id="numeroDetalleAuto" />

</div>
