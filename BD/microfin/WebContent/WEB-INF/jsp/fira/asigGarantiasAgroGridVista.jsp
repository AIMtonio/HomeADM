<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="listaResultado" value="${listaResultado[0]}"/>
<div id="tableCon">
	<table id="miTabla" width="100%">
		<tr>
			<td> </td>
			<td class="label">
				<label for="lblgarantia">Garant&iacute;a: </label>
			</td>
			<td class="label">
				<label for="lblgarantia">Observaciones: </label>

			</td>
			<td class="label">
				<label for="lblgarantia">Valor Comercial: </label>
			</td>
			<td class="label">
				<label for="lblgarantia">Valor Asignado: </label>
			</td>
			<td class="label">
				<label for="lblgarantia">Sustituye GL: </label>
			</td>
		</tr>
		<c:forEach items="${listaResultado}" var="movsInter" varStatus="status">
			<tr id="renglon${status.count}" name="renglon">
				<td>
					<input type="text" id="consecutivoID${status.count}" name="consecutivoID" size="3" value="${status.count}" autocomplete="off" />
				</td>
				<td>
					<input type="text" id="garantiaID${status.count}"  value="${movsInter.garantiaID}" name="lgarantiaID" size="13" path="lgarantiaID"  autocomplete="off" onKeyUp="obtenerGarantia('garantiaID${status.count}');" onblur="consultaGarantia('${status.count}');"  />
					<input type="hidden" id="estatus${status.count}"  value="${movsInter.estatus}" name="lestatus"   path="lestatus"       />
				</td>
				<td>
					<textarea  id="obserbaciones${status.count}" name="lobserbaciones"   autocomplete="off" COLS="50" ROWS="1"  readOnly="true">${movsInter.observaciones} </textarea>
				</td>
				<td>
					<input type="text" id="valorComercial${status.count}"  value="${movsInter.valorComercial}" name="lvalorComercial"  style="text-align:right;" esMoneda="true" readOnly="true"/>
				</td>
				<td>
					<input type="text" id="montoAsignado${status.count}" value="${movsInter.montoAsignado}"  esMoneda="true"  style="text-align:right;"  onblur="validaMontoAsignado('${status.count}');" name="lmontoAsignado" path="lmontoAsignado" />
				</td>
				<td>
					<select id="sustituyeGL${status.count}" name="lsustituyeGL" tabindex="5" path="lsustituyeGL">
						<option value="">SELECCIONAR</option>
						<option value="S"
						>SI</option>
						<option value="N"
						>NO</option>
					</select>
					<script type="text/javascript">
						$('#sustituyeGL${status.count}').val('${movsInter.sustituyeGL}');
					</script>
				</td>
				<td align="center">
					<c:if test="${movsInter.estatus == 'A'}">
						<input type="button" name="elimina" id="${status.count}" class="btnElimina" onclick="eliminaDetalle(this)"/>
						<input type="button" name="agrega" id="agrega${status.count}" class="btnAgrega" onclick="agregaNuevoDetalle()"/>
					</c:if>
				</td>
				<td>
					<input  type="hidden" id="estatusSolicitud${status.count}" name="lestatusSolicitud" size="50" value="${movsInter.estatusSolicitud}" readOnly="true" readOnly="true"/>
					<input  type="hidden" id="montoDisponible${status.count}" name="lisMontoDisponible" value="${movsInter.montoDisponible}" style="text-align:right;" readOnly="true" />
					<input  type="hidden" id="montoGarantia${status.count}" name="lisMontoGarantia" value="${movsInter.montoGarantia}" style="text-align:right;" readOnly="true" />
					<input  type="hidden" id="montoAvaluado${status.count}" name="lisMontoAvaluado" value="${movsInter.montoAvaluado}" style="text-align:right;" readOnly="true" />
				</td>
			</tr>
			<c:set var="cont" value="${status.count}"/>
		</c:forEach>
	</table>
	<input type="hidden" value="${cont}" name="numeroDetalle" id="numeroDetalle" />
</div>