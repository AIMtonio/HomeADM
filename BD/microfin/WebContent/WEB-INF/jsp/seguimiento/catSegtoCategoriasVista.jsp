<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%> 

<html>
	<head>
		<script type="text/javascript" src="dwr/interface/catTiposGestionServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/catSegtoCategoriasServicio.js"></script>
		<script type="text/javascript" src="js/seguimiento/catSegtoCategorias.js"></script>
	</head>
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="catTiposGestores" >
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="ui-widget ui-widget-header ui-corner-all">Categor&iacute;as de Seguimiento</legend>
					<table border="0" width="100%">
						<tr>
							<td class="label" nowrap="nowrap">
								<label for="categoriaID">N&uacute;m. Categor&iacute;a:</label>
			      			</td>
			 				<td>
		       		 			<input type="text" id="categoriaID" name="categoriaID" path="categoriaID" size="6" tabindex="1" />
							</td>
						</tr>
						<tr>
							<td class="label" nowrap="nowrap">
					  			<label for="descripcion">Descripci&oacute;n: </label>
				   			</td>
							<td>
								<input type="text" id="descripcion" name="descripcion"  onblur="ponerMayusculas(this)" maxlength="150"  size="70" tabindex="2" />
							</td>
							<td class="separador"></td>
							<td class="label" nowrap="nowrap">
								<label for="nombreCorto">Nombre Corto:</label>
							</td>
							<td>
								<input type="text" id="nombreCorto" name="nombreCorto" size="45" onblur="ponerMayusculas(this)" tabindex="3" maxlength="45"/>
							</td>
						</tr>
						<tr>
							<td class="label"  nowrap="nowrap">
								<label for="tipoGestionID">Tipo Gesti&oacute;n:</label>
							</td>
			 				<td>
		       		 			<input type="text" id="tipoGestionID" name="tipoGestionID" path="tipoGestionID" size="6" tabindex="4" />
		       		 			<input type="text" id="descGestion" name="descGestion" readonly="true" size="58" disabled="true" />
							</td>
							<td class="separador"></td>
							<td class="label"  nowrap="nowrap">
					  			<label for="tipoCobranza">Tipo Cobranza:</label>
				   			</td>
							<td>
								<select id="tipoCobranza" name="tipoCobranza" tabindex="5">
									<option value="">SELECCIONAR</option>
									<option value="S">SI</option>
									<option value="N">NO</option>
								</select>
							</td>
						</tr>
						<tr>
							<td class="label" >
								<label for="estatus">Estatus:</label>
							</td>
			 				<td>
		       		 			<select id="estatus" name="estatus" tabindex="6">
		       		 				<option value="">SELECCIONAR</option>
		       		 				<option value="V">VIGENTE</option>
		       		 				<option value="C">CANCELADO</option>
		       		 			</select>
							</td>
						</tr>
					</table>
					<table align="right">
						<tr>
							<td align="right">
								<input type="submit" id="agrega" name="agrega" class="submit" tabindex="7" value="Agregar" />
								<input type="submit" id="modifica" name="modifica" class="submit" tabindex="8" value="Modificar" />
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