<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
	<script type="text/javascript" src="dwr/interface/serviciosAdicionalesServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/clasificaTipDocServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script> 
	<script type="text/javascript"	src="dwr/interface/institucionNomServicio.js"></script>
	<script type="text/javascript" src="js/originacion/serviciosAdicionalesControlador.js"></script>
	
	<title>Servicios Adicionales</title>
</head>
<body>
	<div id="contenedorForma">
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
			<legend class="ui-widget ui-widget-header ui-corner-all">Servicios Adicionales</legend>
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="serviciosAdicionales" target="_blank">
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td class="label" nowrap="nowrap"><label for="lblServicioID">Servicio: </label></td>
					   	<td nowrap="nowrap">
					   		<form:input type="text" id="servicioID" path="servicioID" name="servicioID" size="9" iniForma="false" tabindex="1"/>
					   	</td>
					  	<td class="separador">&nbsp;</td>
					   	<td class="label" nowrap="nowrap"><label for="lblDescripcion">Descripción del servicio: </label></td>
					   	<td nowrap="nowrap">
					   		<form:input type="text" id="descripcion" path="descripcion" name="descripcion" size="44" tabindex="2" maxlength="100"/>					   	</td>
					</tr>
					<tr>
						<td class="label" nowrap="nowrap"><label for="ValidaDocs">Valida Tipo de Documento: </label></td>
						<td nowrap="nowrap">
							<form:select id="validaDocs" name="validaDocs" path="validaDocs" tabindex="3">
								<form:option value="S">SI</form:option>
								<form:option value="N">NO</form:option>
							</form:select>
						</td>
						<td class="separador">&nbsp;</td>
						<td class="label lblTipoDeDocumento" nowrap="nowrap"><label for="lblTipoDeDocumento">Tipo de Documento: </label></td>
						<td nowrap="nowrap" class="lblTipoDeDocumento">
							<form:input type="text" id="tipoDocumento" name="tipoDocumento" path="tipoDocumento" size="9" tabindex="4"/>
							<input type="text" id="desTipoDocumento" name="desTipoDocumento" size="34" readonly="true" disabled="disabled" tabindex=""/>
						</td>
					</tr>
					<tr>
						<td class="label" nowrap="nowrap"><label for="lblProducCreditoID">Producto de Crédito: </label></td>
						<td nowrap="nowrap">
							<form:select id="producCreditoID" name="producCreditoID" path="producCreditoID" tabindex="5" size="10">
								<form:option value=" ">TODOS</form:option>
							</form:select>
						</td>
						<td class="separador">&nbsp;</td>
						<td class="label" nowrap="nowrap">
							<div class="lblInstitNominaID">
								<label for="lblInstitNominaID">Empresa Nómina: </label>
							</div>
						</td>	
						<td nowrap="nowrap">
							<div class="lblInstitNominaID">
								<form:select id="institNominaID" name="institNominaID" path="institNominaID" tabindex="6" size="10">
									
								</form:select>
							</div>
						</td>
					</tr>
				</table>
				<!-- Botones -->
				<br>
				<table align="right" border='0'>
					<tr>
						<td align="right">
							<div id="contenedorBotones">
								<input type="submit" id="agregar" name="agregar" class="submit" value="Agregar" tabindex="7"/>
								<input type="submit" id="modificar" name="modificar" class="submit" value="Modificar" tabindex=8""/>
								<input type="submit" id="eliminar" name="eliminar" class="submit" value="Eliminar" tabindex="9"/>
								<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
							</div>
						</td>
					</tr>
				</table>
			</form:form>
		</fieldset>
	</div>
	<div id="cargando" style="display: none;"></div>
	<div id="cajaLista" style="display: none;">
		<div id="elementoLista"></div>
	</div>
	</body>
	<div id="mensaje" style="display: none;"></div>		
</body>
</html>