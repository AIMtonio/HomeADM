<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<c:set var="comApertConvenio"  value="${listaResultado}"/>
<c:set var="indiceTab" value="4"/>
			<table id="tablaGridEsquema" border="0" cellpadding="5" cellspacing="5" width="100%">
					<tr>
						<td align="center"><label>No Convenio</label></td>
						<td align="center"><label>Tipo Forma de Cobro</label></td>
						<td align="center"><label>Tipo Com. x Apertura</label></td>
						<td align="center"><label>Plazo</label></td>
						<td align="center"><label>Monto Min</label></td>
						<td align="center"><label>Monto Max</label></td>
						<td align="center"><label>Valor</label></td>
					</tr>
				<c:forEach items="${listaResultado}" var="esquema" varStatus="estatus">
						<tr id="renglon${estatus.count}" name="renglon">
						<td style="display:none">
						<input type="hidden" id="fila${estatus.count}" name="fila" value="${estatus.count}"/>
						</td>
						 <td valign="top"> 
						 		<c:set var="indiceTab" value="${indiceTab + 1}"/>
						  		<select id="convenioNominaID${estatus.count}"  tabindex="${indiceTab}" name="convenioNominaID"  value="${esquema.convenioNominaID}">
								</select>	
								<script type="text/javascript">
 								var convenioCons = ${estatus.count};
 								var valueConvenio =${esquema.convenioNominaID};
 								funcionMuestraConvenios(convenioCons,valueConvenio);
							   </script>
								<input type="hidden" id="lisConvenioID${estatus.count}" name="lisConvenioID" value="${esquema.convenioNominaID}"/>	
						 </td>
						 <td valign="top"> 
						 <c:set var="indiceTab" value="${indiceTab + 1}"/>
							<select id="formCobroComAper${estatus.count}" name="formCobroComAper"  path="formCobroComAper" tabindex="${indiceTab}" value="${esquema.formCobroComAper}">
								<option value="">SELECCIONAR</option> 
								<option value="F">FINANCIAMIENTO</option> 
							    <option value="D">DEDUCCI&Oacute;N</option>
							    <option value="A">ANTICIPADO</option>
							    <option value="P">PROGRAMADO</option>
							</select>
							<script type="text/javascript">
								var formCobroCons = ${estatus.count};
								var valueFormCobro = "${esquema.formCobroComAper}";
								funcionSetSelectOption('formCobroComAper'+formCobroCons,valueFormCobro);
							</script> 	
						 </td>
						 <td valign="top"> 
						 <c:set var="indiceTab" value="${indiceTab + 1}"/>
							<select id="tipoComApert${estatus.count}" name="tipoComApert"  path="tipoComApert" tabindex="${indiceTab}" value="${esquema.tipoComApert}">
								<option value="">SELECCIONAR</option> 
								<option value="M">MONTO</option> 
								<option value="P">PORCENTAJE</option> 
							</select>	
							<script type="text/javascript">
								var tipoComApertCons = ${estatus.count};
								var valueTipoComApert ="${esquema.tipoComApert}";
								funcionSetSelectOption('tipoComApert'+tipoComApertCons,valueTipoComApert);
							</script> 	
						 </td>
						    <td valign="top"> 
						    	<script type="text/javascript">
						    	var plazoCons = ${estatus.count};
								var valuePlazo = ${esquema.plazoID};
								var selecteds = ${esquema.lisPlazoID};
								funcionMuestraPlazos(plazoCons,valuePlazo,selecteds);
							</script>
							<c:set var="indiceTab" value="${indiceTab + 1}"/>
						 		<select multiple id="plazoID${estatus.count}" name="plazoID" size="5" tabindex="${indiceTab}"  onchange="funcionSelecPlazos(this.id, ${estatus.count});">
								</select>	
						  		<input type="hidden" id="lisPlazoID${estatus.count}" name="lisPlazoID" value="${esquema.lisPlazoID}"/>	
						    </td>
					     <td class="label" valign="top"> 
					     <c:set var="indiceTab" value="${indiceTab + 1}"/>
					     	<input type="text" onkeyPress="return Validador(event);" esMoneda="true" id="montoMin${estatus.count}" tabindex="${indiceTab}" name="montoMin" size="15" value="${esquema.montoMin}"/>
					     </td>
					     <td class="label" valign="top"> 
					     <c:set var="indiceTab" value="${indiceTab + 1}"/>
					     	<input type="text" onkeyPress="return Validador(event);" esMoneda="true" id="montoMax${estatus.count}" tabindex="${indiceTab}" name="montoMax" size="15" value="${esquema.montoMax}"/>
					     </td>
					     <td class="label" valign="top"> 
					     <c:set var="indiceTab" value="${indiceTab + 1}"/>
					     	<input type="text" onkeyPress="return Validador(event);" esMoneda="true" id="valor${estatus.count}" tabindex="${indiceTab}" name="valor" size="15" value="${esquema.valor}"/>
					     </td>
						    <td valign="top">
						    <c:set var="indiceTab" value="${indiceTab + 1}"/>
							<input type="button"  id="eliminar${estatus.count}" tabindex="${indiceTab}"  value="" class="btnElimina"  onclick="funcionEliminarRegistro('renglon${estatus.count}')"  />
							<c:set var="indiceTab" value="${indiceTab + 1}"/>
							<input type="button" tabindex="${indiceTab}" name="agrega" id="agrega${estatus.count}"  value="" class="btnAgrega" onclick="funcionAgregarNuevoRegistro()"/>
							
							</td>
						</tr>								
					</c:forEach>			
			</table>
