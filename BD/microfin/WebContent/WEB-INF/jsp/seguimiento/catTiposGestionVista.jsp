<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%> 

<html>
	<head>
		<script type="text/javascript" src="dwr/interface/catTiposGestionServicio.js"></script>
		<script type="text/javascript" src="js/seguimiento/catTiposGestion.js"></script>
	</head>
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="catTiposGestores" >
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="ui-widget ui-widget-header ui-corner-all">Tipos de Gesti&oacute;n</legend>
					<table border="0" width="100%">
						<tr>
							<td class="label" nowrap="nowrap">
								<label for="tipoGestionID">Tipo Gesti&oacute;n:</label>
			      			</td>
			 				<td>
		       		 			<input type="text" id="tipoGestionID" name="tipoGestionID" path="tipoGestionID" size="6" tabindex="1" />
							</td>
						</tr>
						<tr>
							<td class="label" nowrap="nowrap">
					  			<label for="descripcion">Descripci&oacute;n: </label>
				   			</td>
							<td nowrap="nowrap">
								<input type="text" id="descripcion" name="descripcion"  onblur="ponerMayusculas(this)" maxlength="150"  size="70" tabindex="2" />
							</td>
						</tr>
						<tr>
							<td class="label" nowrap="nowrap">
					  			<label for="descripcion">Tipo Asignaci&oacute;n: </label>
				   			</td>
							<td>
								<select id="tipoAsigna" name="tipoAsigna" tabindex="4">
									<option value="">SELECCIONAR</option>
									<option value="C">COMERCIO</option>
									<option value="T">TERRITORIO</option>
								</select>
							</td>
						</tr>
						<tr>
							<td class="label" >
								<label for="lblTipoTarjeta">Estatus:</label></td>
			 				<td>
		       		 			<select id="estatus" name="estatus" tabindex="5">
		       		 				<option value="">SELECCIONAR</option>
		       		 				<option value="A">ACTIVO</option>
		       		 				<option value="C">CANCELADO</option>
		       		 			</select>
							</td>
						</tr>
					</table>
					<table align="right">
						<tr>
							<td align="right">
								<input type="submit" id="agrega" name="agrega" class="submit" tabindex="6" value="Agregar" />
								<input type="submit" id="modifica" name="modifica" class="submit" tabindex="7" value="Modificar" />
								<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />
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
	</body>
	<div id="mensaje" style="display: none;"></div>
</html>