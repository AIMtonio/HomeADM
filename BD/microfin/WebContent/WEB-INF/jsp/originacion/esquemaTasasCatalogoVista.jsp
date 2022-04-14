<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>	
		<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/esquemaTasasServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/calendarioProdServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/plazosCredServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/formTipoCalIntServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/tasasBaseServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/institucionNomServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/nivelCreditoServicio.js"></script>
		<script type="text/javascript" src="js/originacion/esquemaTasas.js"></script>
	</head>
<body>
<div id="contenedorForma">
	<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="esquemaTasas">
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
			<legend class="ui-widget ui-widget-header ui-corner-all">Esquema de Tasas</legend>
				<table border="0" width="100%">
					<tr>
						<td class="label">
							<label for="sucursalID">Sucursal: </label>
						</td>
						<td>
							<select id="sucursalID" name="sucursalID" path="sucursalID" tabindex="1" iniforma="false" style="width:100%;">
								<option value="0">SELECCIONA</option>
							</select>
						</td>
						<td class="separador"></td>
						<td class="label" nowrap="nowrap">
							<label for="productoCreditoID">Producto de Cr&eacute;dito: </label>
						</td>
						<td nowrap="nowrap">
							<form:input id="productoCreditoID" name="productoCreditoID" path="productoCreditoID" size="12" tabindex="2" iniforma="false" maxlength="11"/>
							<input type= "text" id="descripProducto" name="descripProducto"size="50" type="text" tabindex="3" readOnly="true" disabled = "true" iniforma="false"/>
						</td>
					</tr>
					<tr>
						<td nowrap="nowrap" class="label">
							<label for="minCredito">M&iacute;nimo de Cr&eacute;ditos: </label>
						</td>
						<td>
							<form:input id="minCredito" name="minCredito" style="text-align:right;" path="minCredito" size="16" maxlength="11" tabindex="5" iniforma="false" />
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="maxCredito">M&aacute;ximo Cr&eacute;ditos: </label>
						</td>
						<td>
							<form:input id="maxCredito" name="maxCredito" style="text-align:right;" path="maxCredito" size="12" tabindex="6" iniforma="false"/>
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="calificacion">Calificaci&oacute;n: </label>
						</td>
						<td>
							<form:select id="calificacion" name="calificacion" path="calificacion" tabindex="7" iniforma="false" >
								<form:option value="N">NO ASIGNADA</form:option>
								<form:option value="A">EXCELENTE</form:option>
								<form:option value="B">BUENA</form:option>
								<form:option value="C">REGULAR</form:option>
							</form:select>
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="montoInferior">Monto Inferior: </label>
						</td>
						<td>
							<form:input id="montoInferior" name="montoInferior" style="text-align:right;" path="montoInferior" size="12" maxlength="12" tabindex="8" esMoneda="true" iniforma="false" />
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="montoSuperior">Monto Superior: </label>
						</td>

						<td>
							<input id="montoSuperior" name="montoSuperior" style="text-align:right;" path="montoSuperior" size="16" esMoneda="true"	maxlength="20" tabindex="9" type="text" iniforma="false" />
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="plazoID">Plazos del Producto: </label>
						</td>
						<td>
							<select id="plazoID" name="plazoID" path="plazoID" tabindex="10" iniforma="false" style="width:80px;">
								<option value="T">TODOS</option>
							</select>
						</td>
					</tr>
					<tr class="classInstitucionNomina">
						<td class="classInstitucionNomina label" nowrap="nowrap" style="display:none;"><label for="institNominaID">Empresa de N&oacute;mina:</label></td>
						<td class="classInstitucionNomina" nowrap="nowrap" style="display:none;">
							<input type="text" id="institNominaID" name="institNominaID" size="5" tabindex="11" maxlength = "11"/>
							<input type="text" id="nombreInstit" name="nombreInstit" size="30" maxlength="120" readOnly="true"/>
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="tasaFija">Tasa Fija: </label>
						</td>
						<td>
							<form:input id="tasaFija" name="tasaFija" style="text-align:right;" path="tasaFija" size="16" maxlength="10" tabindex="12" />
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="sobreTasa">Sobre Tasa: </label>
						</td>
						<td>
							<input id="sobreTasa" name="sobreTasa" style="text-align:right;" path="sobreTasa" size="12" tabindex="13" type="text" />
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="calcInteres">C&aacute;lculo de Inter&eacute;s: </label>
						</td>
						<td>
							<form:select id="calcInteres" name="calcInteres" path="" tabindex="14" disabled="true" style="width:100%;">
								<form:option value="">SELECCIONAR</form:option>
							</form:select>
						</td>
						<td class="separador"></td>
						<td class="label" name="tasaBase1">
						<label for="TasaBase">Tasa Base: </label>
						</td>
						<td name="tasaBase2">
							<input type="text" id="tasaBase" name="tasaBase" path="" size="8" readonly="true" disabled="true" tabindex="15"  />
							<input type="text" id="desTasaBase" name="desTasaBase" size="25" readonly="true" disabled="true" tabindex="16"/>
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="nivelID">Nivel: </label>
						</td>
						<td>
							<form:select id="nivelID" name="nivelID" path="nivelID" tabindex="17">
								<form:option value="0">TODAS</form:option>
							</form:select>
						</td>	
						<td class="separador"></td>
						<td class="label" name="tasaBase3">
							<label for="valorTasaBase">Valor: </label>
						</td>
						<td nowrap="nowrap" name="tasaBase4">
							<input type="text" id="valorTasaBase" name="valorTasaBase" path="" size="8" tabindex="17" esTasa="true" disabled="true" style="text-align: right;"/>
							<label for="porcentaje">%</label>
						</td>
					</tr>
					
				</table>
				<input type="hidden" id="numeroDetalle" name="numeroDetalle" value="0"/>
				<table border="0" width="100%">
					<tr>
						<td colspan="5">
							<table align="right">
								<tr>
									<td align="right">
										<input type="submit" id="grabar" name="grabar" class="submit" value="Grabar" tabindex="18"  />
										<input type="submit" id="eliminar" name="eliminar" class="submit" value="Eliminar" tabindex="19"  />
										<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="tipoTransaccion"/>				
									</td>
								</tr>
							</table>
						</td>
					</tr>	
				</table>
				<br>
				<div id="esquemaGristasas"></div>	
			</fieldset>
		</form:form>
	</div>
<div id="cargando" style="display: none;"></div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"/>
</div>
</body>
<div id="mensaje" style="display: none;"/>
</html>