<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="listaResultado"  value="${listaResultado}"/>
<%! int counter = 100; %>
<%! int numFilas = 0; %>
<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Esquema por Producto de Cr&eacute;dito</legend>
			<table id="tbParametrizacion" border="0">
				<thead>
				<tr>
					<td style="width: 10px">
						<!-- validaParametrizacion(this.id) -->
						<input type="button" class="submit" value="Agregar" id="btnAgregar" tabindex="<%=counter %>" onclick="agregarAccesorio(this.id)"/>
					</td>
				</tr>
				<tr>
					<td id="colLblCon" nowrap="nowrap">
							<label>Convenio </label>
					</td>
					<td id="colLblSpa"></td>
					<td nowrap="nowrap">
							<label>Plazo </label>
					</td>
					<td></td>
					<td>
						<label>Ciclo Ini.</label>
					</td>
					<td></td>
					<td>
						<label>Ciclo Fin.</label>
					</td>
					<td></td>
					<td nowrap="nowrap">
						<label>Monto Min.</label>
					</td>
					<td></td>
					<td nowrap="nowrap">
						<label>Monto Max.</label>
					</td>
					<td></td>
					<td nowrap="nowrap">
							<label>Monto / Porcentaje </label>
					</td>
					<td></td>
					<td nowrap="nowrap">
							<label>Nivel </label>
					</td>
				</tr>
				</thead>
				<tbody>
					<c:forEach items="${listaResultado}" var="detalle" varStatus="status">
					<% counter++; %>
					
					<tr id="tr${status.count}" name="trAccesorios">
						<td id="colConvenio${status.count}" nowrap="nowrap" >
							<script type="text/javascript">
								var convenioCons = ${status.count};
								var valueConvenio = ${detalle.convenioID};
								var selecteds = ${detalle.conveniosSeleccionadosID};
								muestraConvenios(convenioCons,valueConvenio,selecteds);
								asignaTotalConveniosSeleccionados(convenioCons,'convenioID${status.count}');
							</script> 
							<select MULTIPLE id="convenioID${status.count}" tabindex="<%=counter %>" name="convenioID" path="convenioID" size="11" onblur="asignaTotalConveniosSeleccionados(${status.count},this.id)" onchange="validaSeleccion(this.id)"/>
							<input type="hidden" id="numTotalConvenios${status.count}" name="numTotalConvenios"/>
							<input type="hidden" id="numConveniosSeleccionados${status.count}" name="numConveniosSeleccionados" value="${detalle.numConveniosSeleccionados}"/>
						</td>
						<td id="colSpace${status.count}"></td>
						<td nowrap="nowrap">
							<script type="text/javascript">
								var plazoCons = ${status.count};
								var valuePlazo = ${detalle.plazoID};
								var selecteds = ${detalle.plazosSeleccionadosID};
								muestraPlazos(plazoCons,valuePlazo,selecteds);
								asignaTotalPlazosSeleccionados(plazoCons,'plazoID${status.count}');
							</script> 
							<select MULTIPLE id="plazoID${status.count}" tabindex="<%=counter %>" name="plazoID" path="plazoID" size="11" onblur="asignaTotalPlazosSeleccionados(${status.count},this.id)" onchange="validaSeleccion(this.id)"/>
							<input type="hidden" id="numTotalPlazos${status.count}" name="numTotalPlazos"/>
							<input type="hidden" id="numPlazosSeleccionados${status.count}" name="numPlazosSeleccionados" value="${detalle.numPlazosSeleccionados}"/>
						</td>
						<td></td>
						<td>
							<input type="text" id="cicloIni${status.count}" name="cicloIni" path="cicloIni" tabindex="<%=counter %>" value="${detalle.cicloIni}" maxlength="10" onkeypress="return validaNumero(event)" size="6"/>
						</td>
						<td></td>
						<td>
							<input type="text" id="cicloFin${status.count}" name="cicloFin" path="cicloFin" tabindex="<%=counter %>" value="${detalle.cicloFin}" maxlength="10" onkeypress="return validaNumero(event)" size="6" onblur="validaCiclo(this.id)"/>
						</td>
						<td></td>
						<td>
							<input type="text" id="montoMin${status.count}" name="montoMin" path="montoMin" tabindex="<%=counter %>" value="${detalle.montoMin}" style="text-align: right;" size="15" maxlength="16" onkeypress="return validaNumero(event)" onblur="formatoTexto(this)" esMoneda="true"/>
						</td>
						<td></td>
						<td>
							<input type="text" id="montoMax${status.count}" name="montoMax" path="montoMax" tabindex="<%=counter %>" value="${detalle.montoMax}" style="text-align: right;" size="15" maxlength="16" onkeypress="return validaNumero(event)" onblur="formatoTexto(this)" esMoneda="true"/>
						</td>
						<td></td>
						<td>
							<input type="text" id="montoPorcentaje${status.count}" name="montoPorcentaje" path="montoPorcentaje" tabindex="<%=counter %>" value="${detalle.montoPorcentaje}" style="text-align: right;" size="15" maxlength="10" onkeypress="return validaNumero(event)" onblur="formatoTexto(this)" esMoneda="true"/>
						</td>
						<td></td>
						<td>
							<script type="text/javascript">
								var nivelCons = ${status.count};
								var valueNivel = ${detalle.nivelID};
								muestraNiveles(nivelCons,valueNivel);
							</script> 
							<select id="nivelID${status.count}" tabindex="<%=counter %>" name="nivelID" path="nivel"></select>
						</td>
						<td></td>
						<td nowrap="nowrap">
							<input type="button" id="eliminar${status.count}" name="eliminar" value="" class="btnElimina" onclick="eliminarParam('tr${status.count}')" tabindex="<%=counter %>"/>
							<input type="button" id="agrega${status.count}" name="agrega" value="" class="btnAgrega" onclick="agregarAccesorio(this.id)" tabindex="<%=counter %>"/>
						</td>
					</tr>
					</c:forEach>
				</tbody>
			</table>
			<table align="right">
			<tr>
				<td align="right">
					<input type="submit" id="grabarGrid" name="grabarGrid" class="submit" onclick=" validaTransaccion(this)" value="Grabar" tabindex="300"/>
					<input type="text"   id="empresaNominaID" name = "empresaNominaID" value="" hidden="true"/>
				</td>
			</tr>
		</table>
</fieldset>
<script type="text/javascript">
if($('#estatusProducCredito').val() == 'I'){
	deshabilitaBoton('btnAgregar','submit');
}else{
	habilitaBoton('btnAgregar','submit');
}
	deshabilitaBoton('modificar','submit');
</script>
<input type="hidden" id="numTab" value="<%=counter %>"/>
<input type="hidden" id="numeroFila" value="<%=numFilas %>"/>