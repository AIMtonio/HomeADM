<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>


<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="listaResultado" value="${listaResultado[1]}"/>

<form id="autorizaSpeiBean" name="autorizaSpeiBean">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%">
			<c:choose>
				<c:when test="${tipoLista == '1'}">
					<tr>
						<td class="label">
					   		<label for="lblconsecutivo"></label>
						</td>
						<td class="label">
					   		<label for="lblnumero"></label>
						</td>
						<td class="label">
					   		<label for="lblclaveRastreo"></label>
						</td>
					    <td class="label">
					   		<label for="lblClienteID">N&uacute;m. <s:message code="safilocale.cliente"/></label>
						</td>
						 <td class="label">
					   		<label for="lblNombreCliente">Nombre</label>
						</td>
						 <td class="label">
					   		<label for="origen">Origen</label>
						</td>
						<td class="label">
							<label for="lblTotalCargoCuenta">Monto</label>
				  		</td>
				  		<td class="label">
							<label for="lblTipoCuenta">Tipo Cuenta</label>
				  		</td>
				  		<td class="label">
							<label for="lblNomBeneficiario">Banco</label>
				  		</td>
				  		<td class="label">
							<label for="lblNomBeneficiario">Nombre Beneficiario</label>
				  		</td>
				  		<td class="label">
							<label for="lblCuentaBeneficiario">Cuenta Beneficiario</label>
				  		</td>
				  		<td class="label">
							<label for="lblComentario">Comentario</label>
				  		</td>
				  		<td class="label" align="center">
					   		<label for="lblcheckbox"></label>
					   		<input type="checkbox" id="seleccionaTodos" name="seleccionaTod" onclick="selecTodoCheckout(this.id)">
						</td>
				  	</tr>

					<c:forEach items="${listaResultado}" var="pago" varStatus="status">
					<tr id="renglon${status.count}" name="renglon">
						<td>
							<input id="consecutivoID${status.count}"  name="consecutivoID" size="3"
										value="${status.count}" readOnly="true" disabled="true" type="hidden" style='text-align:left;' />
						</td>
							<td>
							<input id="folioSpeiID${status.count}"  name="folioSpeiID" size="3"
										value="${pago.folioSpeiID}" readOnly="true" disabled="true" type="hidden" style='text-align:left;' />
						</td>
							<td>
							<input id="claveRastreo${status.count}"  name="claveRastreo" size="3"
										value="${pago.claveRastreo}" readOnly="true" disabled="true" type="hidden" style='text-align:left;' />
						</td>
						<td>
							<input type="text" id="clienteID${status.count}" name="clienteID" size="18"
										 value="${pago.clienteID}" readOnly="true" disabled="true" style='text-align:left;' />
						</td>
						<td>
							<input type="text" id="nombreOrd${status.count}"  name="nombreOrd" size="40"
										  value="${pago.nombreOrd}"readOnly="true" disabled="true" style='text-align:left;' />
						</td>
						<td>
							<input type="text" id="origenSpei${status.count}"  name="origenSpei" size="20"
										  value="${pago.origenSpei}"readOnly="true" disabled="true" style='text-align:left;' />
						</td>
						<td>
						 	<input type="text" id="monto${status.count}" name="monto" size="15"
										value="${pago.totalCargoCuenta}" readOnly="true" disabled="true" esMoneda="true"  style='text-align:right;' />
						</td>

	    				<td> 	<input type="text" id="tipoCuentaBen${status.count}"  name="tipoCuentaBen" size="20"
									  value="${pago.tipoCuentaBen}" readOnly="true" disabled="true" style='text-align:left;' />

						</td>

						<td>
							<input type="text" id="instiReceptora${status.count}"  name="instiReceptora" size="20"
									  value="${pago.descripcion}" readOnly="true" disabled="true" style='text-align:left;' />
						</td>

						<td>
							<input type="text" id="nombreBeneficiario${status.count}"  name="nombreBeneficiario" size="40"
									  value="${pago.nombreBeneficiario}" readOnly="true" disabled="true" style='text-align:left;' />
						</td>

						<td>
							<input type="text" id="cuentaBeneficiario${status.count}"  name="cuentaBeneficiario" size="22"
									  value="${pago.cuentaBeneficiario}" readOnly="true" disabled="true" style='text-align:left;' />
						</td>

						<td>
							<textarea  id="comentario${status.count}"  name="comentario" size="30" maxlength="100"
									  value="${pago.comentario}"  style="margin: 1px; width: 200px; height: 15px;"  onBlur="ponerMayusculas(this)"/></textarea>


						</td>

				 		<td align="center"><input type="checkbox" id="enviar${status.count}" name="enviar" onclick="habilitaLimpiar(this.id)" />
						</td>


				 	</tr>

					</c:forEach>
				</c:when>
			</c:choose>
		</table>
	</fieldset>
</form>
