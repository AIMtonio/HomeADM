<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
      	<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/catalogoAlmacenesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/paramGuardaValoresServicio.js"></script>
		<script type="text/javascript" src="js/guardaValores/catalogoAlmacenesVista.js"></script>
	</head>
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="catalogoAlmacenesBean">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Cat&aacute;logo Almacenes</legend>
					<table width="100%">
						<tr>
							<td class="label">
								<label for="almacenID">N&uacute;mero: </label>
							</td>
							<td >
								<form:input type="text" id="almacenID" name="almacenID" path="almacenID" size="11" maxlength="11" tabindex="1"  autocomplete="off"/>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="nombreAlmacen">Nombre Almac&eacute;n: </label>
							</td>
							<td >
								<form:input type="text" id="nombreAlmacen" name="nombreAlmacen" path="nombreAlmacen" size="62" maxlength="50" tabindex="2"  autocomplete="off" onBlur=" ponerMayusculas(this)"/>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="estatus">Estatus: </label>
							</td>
							<td >
								<form:select id="estatus" name="estatus" path="estatus" tabindex="3">
									<form:option value="">SELECCIONAR</form:option>
									<form:option value="A">ACTIVO</form:option>
									<form:option value="I">INACTIVO</form:option>
								</form:select>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="sucursalID">Sucursal: </label>
							</td>
							<td >
								<form:input type="text" id="sucursalID" name="sucursalID" path="sucursalID" size="11"  maxlength="11" tabindex="4"  autocomplete="off"/>
								<input type="text" id="nombreSucursal" name="nombreSucursal" size="50" maxlength="50"  disabled="true" readOnly="true"/>
							</td>
						</tr>
						<br>
						<table align="right">
							<tr>
								<td align="right">
									<input type="submit" id="agrega" name="agrega" class="submit" value="Agregar"  tabindex="5"/>
									<input type="submit" id="modifica" name="modifica" class="submit"  value="Modificar" tabindex="6"/>
								</td>
							</tr>
						</table>
					</table>
					<br>
					<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
				</fieldset>
			</form:form>
		</div>
		<div id="cargando" style="display: none;"></div>
		<div id="cajaLista" style="display: none;">
			<div id="elementoLista"></div>
		</div>
	</body>
	<div id="mensaje" style="display: none;"></div>
	</body>
</html>