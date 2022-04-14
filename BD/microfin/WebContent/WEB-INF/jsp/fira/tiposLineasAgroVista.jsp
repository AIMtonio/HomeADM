<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/tiposLineasAgroServicio.js"></script>
		<script type="text/javascript" src="js/fira/tiposLineasAgro.js"></script>
	</head>
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="tiposLineasAgroBean">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="ui-widget ui-widget-header ui-corner-all">Tipos de L&iacute;neas de Cr&eacute;dito</legend>
					<table width="100%">
						<tr>
							<td>
								<label for="tipoLineaAgroID">No. Tipo de L&iacute;nea:</label>
							</td>
							<td>
								<form:input id="tipoLineaAgroID" type="text" name="tipoLineaAgroID" path="tipoLineaAgroID" size="15" autocomplete="off" tabindex="1"/>
							</td>
							<td class="separador"></td>
							<td>
								<label for="nombre">Nombre:</label>
							</td>
							<td>
								<form:input id="nombre" type="text" name="nombre" path="nombre" size="40" autocomplete="off" maxlength="100" onblur="ponerMayusculas(this)" tabindex="2"/>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="lblMoneda">Tipo:</label>
							</td>
							<td >
								<form:select id="esRevolvente" name="esRevolvente" path="esRevolvente"   tabindex="3" disabled = "true">
								<form:option value="S">REVOLVENTE</form:option>
								</form:select>
							</td>
							<td class="separador"></td>
							<td>
								<label for="montoLimite"> Monto L&iacute;mite:</label>
							</td>
							<td>
								<form:input id="montoLimite" type="text" name="montoLimite" style="text-align: right; color: black;"  value="" path="montoLimite" size="15" autocomplete="off" onkeypress=" return ingresaSoloNumeros(event,2,this.id); " esMoneda="true" tabindex="4" maxlength="14" onkeyPress="return validador(event);"/>
							</td>
						</tr>
						<tr>
							<td>
								<label for="plazoLimite"> Plazo L&iacute;mite(Meses):</label>
							</td>
							<td>
								<form:input id="plazoLimite" type="text" name="plazoLimite" maxlength="4" path="plazoLimite" size="15" autocomplete="off" esNumero="true" onkeypress=" return ingresaSoloNumeros(event,2,this.id);"  tabindex="5" onkeyPress="return validador(event);"/>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="lblManejaComAdmon">Comisi&oacute;n por Adm&oacute;n:</label>
							</td>
							<td >
								<form:select id="manejaComAdmon" name="manejaComAdmon" path="manejaComAdmon"   tabindex="6" disabled = "false">
								<option value="">SELECCIONAR</option>
								<form:option value="N">NO</form:option>
								<form:option value="S">SI</form:option>
								</form:select>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="lblManejaComGaran">Comisi&oacute;n por serv. de Garant&iacute;a:</label>
							</td>
							<td >
								<form:select id="manejaComGaran" name="manejaComGaran" path="manejaComGaran" tabindex="7"   disabled = "false">
								<option value="">SELECCIONAR</option>
								<form:option value="N">NO</form:option>
								<form:option value="S">SI</form:option>
								</form:select>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="productosCredito">Productos de Cr&eacute;dito </label>
							</td>
							<td>
								<select MULTIPLE id="productosCredito" name="productosCredito" path="productosCredito" tabindex="8" size="6">
								 </select>
							</td>
						</tr>
						<tr>
							<td class="label">
							<label for="lblEstatus">Estatus: </label>
							</td>
							<td >
								<form:select id="estatus" name="estatus" path="estatus" tabindex="9" disabled = "false" maxlength="4">
									<form:option value="A">ACTIVO</form:option>
									<form:option value="I">INACTIVO</form:option>
								</form:select>
							</td>
						</tr>
						<tr>
							<td colspan="5">
								<br>
								<table align="right" boder='0'>
									<tr>
										<td align="right">
											<input type="submit" id="agrega" name="agrega" class="submit" value="Agregar" tabindex="10"/>
											<input type="submit" id="modifica" name="modifica" class="submit" value="Modificar" tabindex="11"/>
											<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</fieldset>
			</form:form>
		</div>
		<div id="cargando" style="display: none;"></div>
		<div id="cajaLista" style="display: none;">
			<div id="elementoLista"></div>
		</div>
		<div id="mensaje" style="display: none;"></div>
	</body>
</html>