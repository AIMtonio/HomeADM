<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/gruposFamiliarServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/parentescosServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/gruposFamiliarServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/cuentasTransferServicio.js"></script>	                                                                                                                                                                                                                                                                                 
	<script type="text/javascript" src="js/aportaciones/dispersionesAport.js"></script>

	<script type="text/javascript" src="js/utileria.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="aportDispersionesBean">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Montos y Beneficiarios a Dispersar</legend>
				<table border="0" width="100%">
					<tr>
						<td class="label" nowrap="nowrap">
							<label for="">Aportaciones Pendientes de Dispersi&oacute;n:&nbsp;</label>
							<input type="button" class="submit" value="Importar" id="importar" tabindex="1" />
						</td>
					</tr>
					<tr class="trDispersiones" style="display: none;">
						<td colspan="5" valign="top">
							</br>
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
								<legend class="">Montos y Beneficiarios</legend>
								<table border="0">
									<tr>
										<td class="label" nowrap="nowrap">
											<label for="">Aportante:</label>
										</td>
										<td colspan="4">
											<input type='text' id="clienteID" name="clienteID" path="clienteID" size="15" tabindex="2"/>
											<input type='text' id="nombreCompleto" name="nombreCompleto" size="35" readonly="readonly"/>
											<input type="button" class="submit" value="Filtrar" id="filtrar" tabindex="3" />
										</td>
									</tr>
								</table>
								<fieldset id="fieldDispersion" class="ui-widget ui-widget-content ui-corner-all"  style="display:none">
									<div id="gridDispersiones" style=" height:100%; overflow: auto;" ></div>
								</fieldset>
								<table id="tbTotales" style="margin-left:auto;margin-right:0px" border="0"  cellspacing="3" cellpadding="0" width="50%">
									
									
									<tr>
										<td  class="label"><label for="totales"><h4>Totales:</h4></label></td>
										<td ><input type="text" style="text-align: right;" id="totalCapital" name="totalCapital" esMoneda="true" value="" size="18" disabled="disabled"></td>
										<td ><input type="text" style="text-align: right;" id="totalInteres" name="totalInteres" esMoneda="true" value="" size="15" disabled="disabled"></td>
										<td ><input type="text" style="text-align: right;" id="totalesISR" name="totalesISR" esMoneda="true" value="" size="15" disabled="disabled"></td>
										<td ><input type="text" style="text-align: right;" id="totalesGeneral" name="totalesGeneral" esMoneda="true" value="" size="20" disabled="disabled"></td>
										<td ><input type="text" style="text-align: right;" id="pendienteGral" name="pendienteGral" esMoneda="true" value="" size="20" disabled="disabled"></td>
										<td ><input type="text" style="text-align: right;" id="montoGeneral" name="montoGeneral" esMoneda="true" value="" size="18" disabled="disabled"></td>
										<td class="label">
											<label></label>
										</td>
										<td class="label">
											<label></label>
										</td>
										<td class="separador"></td>
										</tr>
								</table>
								<table style="margin-left:auto;margin-right:0px" border="0">
									<tr>
										<td nowrap="nowrap">
											<input type="button" class="submit" value="Grabar" id="grabar" name="grabar" tabindex="601" onclick="grabarDisper(event,2)" />
											<input type="button" class="submit" value="Finalizar" id="procesar" name="procesar" tabindex="603" onclick="grabarDisper(event,3)" />
											<input type="button" class="submit" value="Cancelar" id="cancelar" name="cancelar" tabindex="601" onclick="cancelarDispersion()" />
										</td>
									</tr>
								</table>
							</fieldset>
						</td>
					</tr>
					<tr>
						<td style="text-align: right;">
							<input id="detalleAport" type="hidden" name="detalleAport" />
							<input id="detalleBenef" type="hidden" name="detalleBenef" />
							<input id="tipoTransaccion" type="hidden" name="tipoTransaccion" />
							<input id="numTransaccion" type="hidden" name="numTransaccion" />
							<input id="totalDispersiones" type="hidden" name="totalDispersiones" />
						</td>
					</tr>
				</table>
			</fieldset>
		</form:form>
	</div>
	<div id="cargando" style="display: none;"></div>
	<div id="cajaLista" style="display: none;overflow:">
		<div id="elementoLista"></div>
	</div>
	<div id="cajaListaCte" style="display: none;overflow-y: scroll;height=150px;"></div>
	<div id="elementoListaCte"></div>
	<div id="mensaje" style="display: none;"></div>
</body>
</html>