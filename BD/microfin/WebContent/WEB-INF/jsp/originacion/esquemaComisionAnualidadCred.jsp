<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>Esquema Comisi&oacute;n Anualidad Cr&eacute;dito</title>
	<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/esquemaComAnualServicio.js"></script>
	<script type="text/javascript" src="js/originacion/esquemaComisionAnualidadCred.js"></script>
	<script type="text/javascript" src="js/utileria.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="esquemaComAnual">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Esquema Comisi&oacute;n Anualidad Cr&eacute;dito</legend>
				<table border="0" width="100%">
					<tr>
						<td class="label"><label for="lblProductoCredito">Producto de Cr&eacute;dito: </label></td>
						<td nowrap="nowrap">
							<form:input type="text" id="producCreditoID" name="producCreditoID" path="producCreditoID" size="6" tabindex="1" iniforma="false" maxlength="11" />
							<input type="text" id="descripProducto" name="descripProducto" size="50" type="text" readOnly="true" disabled="true" iniforma="false" />
						</td>
					<tr>
						<td class="label" nowrap="nowrap"><label>Cobra Comisi&oacute;n:</label></td>
						<td>
							<form:select id="cobraComision" name="cobraComision" path="cobraComision" tabindex="2" style="width:110px">
								<option value="">SELECCIONAR</option>
								<option value="S">SI</option>
								<option value="N">NO</option>
							</form:select>
						</td>
						<td class="separador"></td>
						<td class="label" nowrap="nowrap"><label>Tipo Comisi&oacute;n:</label></td>
						<td>
							<form:select id="tipoComision" name="tipoComision" path="tipoComision" tabindex="3" style="width:110px">
								<option value="">SELECCIONAR</option>
								<option value="P">Porcentaje</option>
								<option value="M">Monto</option>
							</form:select>
						</td>
					</tr>
					<tr>
						<td class="label" nowrap="nowrap"><label>Base C&aacute;lculo:</label></td>
						<td>
							<form:select id="baseCalculo" name="baseCalculo" path="baseCalculo" tabindex="4" style="width:150px">
								<option value="">SELECCIONAR</option>
								<option value="M">Monto Crédito Original</option>
								<option value="S">Saldo Insoluto</option>
							</form:select>
						</td>
						<td class="separador"></td>
						<td class="label" nowrap="nowrap"><label>Comisi&oacute;n:</label></td>
						<td class="label" nowrap="nowrap">
							<span id="esMonto">
								<form:input type="text" id="montoComision" path="montoComision" size="12" maxlength="18" tabindex="5" esMoneda="true" style="text-align: right;"/>
							</span>
							<span id="esPorcentaje" style="display:none">
								<form:input type="text" id="porcentajeComision" path="porcentajeComision" size="12" maxlength="8" tabindex="5" onkeypress="return ingresaSoloNumeros(event,2,this.id)"/>
								<label>%</label>
							</span>
						</td>
					</tr>
					<tr>
						<td class="label" nowrap="nowrap"><label>D&iacute;as Gracia:</label></td>
						<td>
							<form:input type="text" id="diasGracia" path="diasGracia" size="12" maxlength="3" tabindex="6"/>
						</td>
					</tr>
					<tr>
						<td align="right" colspan="5">
							<input id="grabar" type="button" class="submit" value="Grabar" tabindex="7"/>
							<input id="modificar" type="button" class="submit" value="Modificar" tabindex="8"/>
							<input id="tipoTransaccion" type="hidden" name="tipoTransaccion"/>
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
	<div id="mensaje" style="display: none;"></div>
</body>
</html>