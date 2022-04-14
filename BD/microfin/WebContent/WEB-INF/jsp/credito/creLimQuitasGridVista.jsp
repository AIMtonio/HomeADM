<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
 <%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>


<c:set var="listaResultado" value="${listaResultado[0]}"/>
	<div id="divPuestos">
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
			<legend><label>Detalle Puestos</label> </legend>
			<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%"> 
				<tr>
					<td class="label">
						<label for="lblnumCtaAhorro">Puesto</label>
					</td>

					<td class="label">
						<label for="lblnumCtaAhorro">Capital <br> Monto</label>
					</td>

					<td class="label">
						<label for="lblnumCtaAhorro">%</label>
					</td>

					<td class="label">
						<label for="lblnumCtaAhorro">Interés <br> Monto</label>
					</td>

					<td class="label">
						<label for="lblnumCtaAhorro">%</label>
					</td>

					<td class="label">
						<label for="lblnumCtaAhorro">Moratorios <br> Monto</label>
					</td>

					<td class="label">
						<label for="lblnumCtaAhorro">%</label>
					</td>

					<td class="label">
						<label for="lblnumCtaAhorro">Accesorios <br> Monto</label>
					</td>

					<td class="label">
						<label for="lblnumCtaAhorro">%</label>
					</td>

					<td class="label">
						<label for="lblnumCtaAhorro">Notas de <br> cargos <br> Monto</label>
					</td>

					<td class="label">
						<label for="lblnumCtaAhorro">%</label>
					</td>

					<td class="label">
						<label for="lblnumCtaAhorro"># Cond. por <br> Crédito</label>
					</td>
				</tr>

				<c:forEach items="${listaResultado}" var="det" varStatus="status">
					<tr id="renglon${status.count}" name="renglon">
						<td>
							<input type="text" id="clavePuestoID${status.count}" name="clavePuestoIDLis" onkeyup="muestralistaPuestos('clavePuestoID${status.count}')" onblur="validaPuestos('clavePuestoID${status.count}','descriPuesto${status.count}')" size="15" value="${det.clavePuestoID}" maxlength="15" />
							<input type="text" id="descriPuesto${status.count}" name="descriPuesto" disabled="true" size="35" value=""/>
							<input type="hidden" id="numTransaccion${status.count}" name="numTransaccion" value="${det.numTransaccion}" />
						</td>

						<td>
							<input type="text" id="limMontoCap${status.count}" name="limMontoCapLis" esMoneda="true" onkeypress="return Validador(event, this);" style="text-align:right;" path="limMontoCap" size="15" value="${det.limMontoCap}" maxlength="15" />
						</td>

						<td>
							<input type="text" id="limPorcenCap${status.count}" name="limPorcenCapLis" onBlur="validaPorcentaje(this);" onkeypress="return Validador(event, this);" style="text-align:right;" path="limPorcenCap" size="7" value="${det.limPorcenCap}" maxlength="7"/>
						</td>

						<td>
							<input type="text" id="limMontoIntere${status.count}" name="limMontoIntereLis" esMoneda="true" onkeypress="return Validador(event, this);" style="text-align:right;" path="limMontoIntere" size="15"value="${det.limMontoIntere}" maxlength="15"/>
						</td>

						<td>
							<input type="text" id="limPorcenIntere${status.count}" name="limPorcenIntereLis"  onBlur="validaPorcentaje(this);" onkeypress="return Validador(event, this);" style="text-align:right;" path="limPorcenIntere" size="7" value="${det.limPorcenIntere}" maxlength="7" />
						</td>

						<td>
							<input type="text" id="limMontoMorato${status.count}" name="limMontoMoratoLis" esMoneda="true"  onkeypress="return Validador(event, this);" style="text-align:right;" path="limMontoMorato" size="15" value="${det.limMontoMorato}" maxlength="15" />
						</td>

						<td><input type="text" id="limPorcenMorato${status.count}"    name="limPorcenMoratoLis"   onBlur="validaPorcentaje(this);" onkeypress="return Validador(event,  this);" style="text-align:right;" path="limPorcenMorato" size="7"  value="${det.limPorcenMorato}" maxlength="7" />
						</td>

						<td>
							<input type="text" id="limMontoAccesorios${status.count}" name="limMontoAccesoriosLis" esMoneda="true" onkeypress="return Validador(event, this);" style="text-align:right;" path="limMontoAccesorios"  size="15" value="${det.limMontoAccesorios}" maxlength="15" />
						</td>

						<td>
							<input type="text" id="limPorcenAccesorios${status.count}" name="limPorcenAccesoriosLis"  onBlur="validaPorcentaje(this);" onkeypress="return Validador(event, this);" style="text-align:right;" path="limPorcenAccesorios"  size="7" value="${det.limPorcenAccesorios}" maxlength="7" />
						</td>

						<td>
							<input type="text" id="limMontoNotasCargos${status.count}" name="limMontoNotasCargosLis" esMoneda="true" onkeypress="return Validador(event, this);" style="text-align:right;" path="limMontoNotasCargos"  size="15" value="${det.limMontoNotasCargos}" maxlength="15" />
						</td>

						<td>
							<input type="text" id="limPorcenNotasCargos${status.count}" name="limPorcenNotasCargosLis"  onBlur="validaPorcentaje(this);" onkeypress="return Validador(event, this);" style="text-align:right;" path="limPorcenNotasCargos"  size="7" value="${det.limPorcenNotasCargos}" maxlength="7" />
						</td>

						<td>
							<input type="text" id="numMaxCondona${status.count}" name="numMaxCondonaLis" onkeypress="return Validador(event, this);" style="text-align:right;" path="numMaxCondona"  size="7" value="${det.numMaxCondona}" maxlength="7" />
						</td>

						<td align="center">
							<input type="button" name="elimina" id="${status.count}" class="btnElimina" onclick="eliminaDetalle(${status.count})"/>
							<input type="button" name="agrega" id="agrega${status.count}" class="btnAgrega" onclick="agregaNuevoDetalle()"/>
						</td>
					</tr>
					<c:set var="cont" value="${status.count}"/>
				</c:forEach>
			</table>
			<input type="hidden" value="${cont}" name="numeroDetalle" id="numeroDetalle" />
		</fieldset>
	</div>


