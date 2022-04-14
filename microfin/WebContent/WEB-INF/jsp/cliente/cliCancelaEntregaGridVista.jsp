<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="clientesCancelaBean" value="${listaResultado[1]}"/>
<br></br>
<fieldset class="ui-widget ui-widget-content ui-corner-all"><legend>Beneficiarios</legend>
	<table id="tablaCliCancelaEntrega">
		<tr id="encabezadoGridEnt">
			<td class="label" align="center"> 
		   		<label for="nombreBeneficiario1">Beneficiario</label> 
			</td>
			<td class="separador"></td>
			<td class="label" align="center"> 
		   		<label for="nombreRecibePago1">Apoderado</label> 
			</td>
			<td class="separador"></td>
			<td class="label" align="center"> 
		   		<label for="porcentaje1">Porcentaje</label> 
			</td>
			<td class="separador"></td>
			<td class="label" align="center"> 
		   		<label for="estatus1">Estatus</label> 
			</td>
			<td class="separador"></td>
			<td class="label" align="center"> 
		   		<label for="monto1">Monto</label> 
			</td>
			<td class="separador"></td>
			<td class="label" align="center"> 
		   		<label for="entregar1">Entregar</label> 
			</td>
		</tr>
		<c:forEach items="${clientesCancelaBean}" var="clientesEntrega"  varStatus="status">
			<tr id="renglon${status.count}" name="renglon">
				<td> 
					<input id="consecutivoID${status.count}"  name="consecutivoID" size="3"  value="${status.count}" readonly="readonly" disabled="disabled" type="hidden"/>
					<input id="nombreBeneficiarioGrid${status.count}"  name="nombreBeneficiarioGrid" size="40"  value="${clientesEntrega.nombreBeneficiario}" readonly="readonly" disabled="disabled" type="text"/>
					<input id="cliCancelaEntregaID${status.count}"  name="cliCancelaEntregaIDGrid" size="40"  value="${clientesEntrega.cliCancelaEntregaID}" readonly="readonly" disabled="disabled" type="hidden"/> 
				</td> 
				<td class="separador"></td>
				<td nowrap="nowrap">
					<c:choose> 
						<c:when test="${clientesEntrega.estatus == 'A'}">
							<input id="nombreRecibePago${status.count}"  name="nombreRecibePago" size="40"  value="${clientesEntrega.nombreBeneficiario}" onblur="ponerMayusculas(this);sumaTotalRecibirCancelacionSocio();" type="text" maxlength="180"/>
						</c:when>
						<c:otherwise>
							<input id="nombreRecibePago${status.count}"  name="nombreRecibePago" size="40"  value="${clientesEntrega.nombreBeneficiario}" onblur="ponerMayusculas(this)" type="text" maxlength="180"
								disabled="disabled" readonly="readonly"/>
						</c:otherwise>
					</c:choose> 
				</td>
				<td class="separador"></td>	
				<td nowrap="nowrap" class="label"> 
					<input id="porcentaje${status.count}"  name="porcentaje" size="5"  value="${clientesEntrega.porcentaje}" readonly="readonly" disabled="disabled" type="text"
						style="text-align: right;"/> 
					<label>%</label>
				</td> 	
				<td class="separador"></td>	
				<td nowrap="nowrap" class="label"> 
					<input id="estatus${status.count}"  name="estatus" size="1"  value="${clientesEntrega.estatus}" readonly="readonly" disabled="disabled" type="hidden"/>
					<input id="estatusDes${status.count}"  name="estatusDes" size="15"  value="${clientesEntrega.estatusDes}" readonly="readonly" disabled="disabled" type="text"/>
				</td> 		
				<td class="separador"></td>	
				<td align="right"> 
					<input id="cantidadRecibir${status.count}"  name="cantidadRecibir" size="18"  value="${clientesEntrega.cantidadRecibir}" readonly="readonly" disabled="disabled" type="text" 
						style="text-align: right;"/>
				</td> 	
				<td class="separador"></td>	
				<td align="center"> 
					<c:choose>
						<c:when test="${clientesEntrega.estatus == 'A' && status.count == 1}">
							<input id="radioEntregar${status.count}" name="radioEntregar"  type="radio" value="S" checked="checked" onclick="sumaTotalRecibirCancelacionSocio();"/>
							<c:set var="varTotalRecibir" value="${clientesEntrega.cantidadRecibir}"/>
							<c:set var="varCliCancelaEntregaID" value="${clientesEntrega.cliCancelaEntregaID}"/>
							<c:set var="varNombreRecibePago" value="${clientesEntrega.nombreBeneficiario}"/>
							<c:set var="varNombreBeneficiario" value="${clientesEntrega.nombreBeneficiario}"/>
							
						</c:when>
						<c:when test="${clientesEntrega.estatus == 'A'}">
							<input id="radioEntregar${status.count}" name="radioEntregar"  type="radio" value="S" onclick="sumaTotalRecibirCancelacionSocio();"/>
						</c:when>
						<c:otherwise>
							<input id="checkEntregar${status.count}" name="checkEntregar"  type="radio" value="N" disabled="disabled" readonly="readonly" onclick="sumaTotalRecibirCancelacionSocio();"/>
						</c:otherwise>
					</c:choose>
				</td> 	
			</tr>
		</c:forEach>
		<tr>
			<td colspan="8" class="label" align="right"> 
	   			<label for="estatus1">Total:</label> 
			</td>
			<td  align="right"> 
				<input id="totalRecibir"  name="totalRecibir" size="18"  value="${varTotalRecibir}" type="hidden"/>
				<input id="totalBeneficio" size="18"  readonly="readonly" disabled="disabled" type="text" style="text-align: right;"/>
				<input id="nombreBeneficiario"  name="nombreBeneficiario" size="18"   value="${varNombreBeneficiario}" readonly="readonly" disabled="disabled" type="hidden"/>
				<input id="cliCancelaEntregaID"  name="cliCancelaEntregaID" size="18"   value="${varCliCancelaEntregaID}" readonly="readonly" disabled="disabled" type="hidden"/>
				<input id="nombreRecibePago"  name="nombreRecibePago" size="18"   value="${varNombreRecibePago}" readonly="readonly" disabled="disabled" type="hidden"/>
			</td> 	
			<td class="separador"></td>	
			<td class="separador"></td>
		</tr>			
	</table>
</fieldset>