	<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="productoNomina" value="${listaResultado[1]}"/>
<c:set var="listaResultado" value="${listaResultado[0]}"/>
<c:set var="calcInteres" value="${listaResultado[0].calcInt}"/>
<div id="esquemaGristasas" style="width:100%;">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend>Esquemas de Tasas del Producto</legend>
		<div  style="width:100%; height:285px; overflow: scroll;">
		<table id="tablaDeTasas" border="0" cellpadding="0" width="100%" >
			<tr> 
				<td class="label" align="center"> 
					<label for="lblminimo">M&iacute;nimo de <br>Cr&eacute;ditos </label> 
				</td> 
				<td class="label" align="center"> 
					<label for="lblMaximo">M&aacute;ximo de <br>Cr&eacute;ditos </label> 
				</td> 
				<td class="label" align="center"> 
					<label for="lblCalificacion">Calificaci&oacute;n </label> 
				</td>
				<td class="label" align="center"> 
					<label for="lblMontoInf">Monto Inferior </label> 
				</td> 
				<td class="label" align="center"> 
					<label for="lblMontoSup">Monto Superior </label> 
				</td>
				<td class="label" align="center"> 
					<label for="lblPlazoID">Plazo del Producto </label> 
				</td>
				<c:if test="${productoNomina == 'S'}" >
					<td class="label" align="center"> 
						<label>Empresa N&oacute;mina</label> 
					</td>
				</c:if>
				<td class="label" align="center">
					<label for="lblTasaFija">Tasa ${ calcInteres==1 ? "Fija" : "Base"} </label>
				</td>
				<td class="label" align="center"> 
					<label for="lblSobreTasa">Sobre Tasa </label> 
				</td>
				<td class="label" align="center"> 
					<label>Nivel </label> 
				</td>
			</tr>
			<c:forEach items="${listaResultado}" var="esquema" varStatus="status">
				<tr id="renglon${status.count}" name="renglon">
					<td align="center"><input  id="minCredito${status.count}" name="minCredito" path="minCredito" value="${esquema.minCredito}" size="8" style="text-align:right;" disabled="true" /></td> 
					<td align="center"><input  id="maxCredito${status.count}" name="maxCredito" path="maxCredito" value="${esquema.maxCredito}" size="8" style="text-align:right;" disabled="true" /></td> 
					<td align="center"><input  id="calificacion${status.count}" name="calificacion" path="calificacion" value="${esquema.calificacion}" size="18"  disabled="true" />  </td> 
					<td align="center"><input  id="montoInferior${status.count}" name="montoInferior" path="montoInferior"  value="${esquema.montoInferior}" esMoneda="true" style="text-align:right;" size="18"  disabled="true" />  </td> 
					<td align="center"><input  id="montoSuperior${status.count}" name="montoSuperior" path="montoSuperior"  value="${esquema.montoSuperior}" esMoneda="true" style="text-align:right;" size="18"  disabled="true" />  </td> 
					<td align="center"><input  id="plazoID${status.count}" name="plazoID" path="plazoID"  value="${esquema.plazoID}"  size="12"  disabled="true" />  </td>
					<c:if test="${productoNomina == 'S'}">
						<td align="center" nowrap="nowrap">
							<input  id="nombreInstGrid${status.count}" name="nombreInstGrid" path="nombreInst" size="20" value="${esquema.nombreInst}" disabled="true" />
						</td>
					</c:if>
					<td align="center"><input  id="tasaFija${status.count}" name="tasaFija" path="tasaFija" size="8"   value="${esquema.tasaFija}" size="8" style="text-align:right;" disabled="true" />  </td> 
					<td align="center"><input  id="sobreTasa${status.count}" name="sobreTasa" path="sobreTasa" size="8" value="${esquema.sobreTasa}" size="8" style="text-align:right;" disabled="true" /></td>
					<td align="center">
						<input type="hidden" id="nivelID${status.count}" name="nivelID" path="nivelID" value="${esquema.nivelID}" disabled="true" />
						<input  id="descripcionNivel${status.count}" name="lisdescripcionNivel" path="descripcionNivel" value="${esquema.descripcionNivel}" disabled="true" />
					</td> 
				</tr>
			</c:forEach>
	</table>
	</div>
	<input type="hidden" value="${cont}" name="numeroDetalle" id="numeroDetalle" />
	</div>