<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<html>
<head>

	<script type="text/javascript" src="dwr/interface/segtoRecomendasServicio.js"></script>
	<script type="text/javascript" src="js/seguimiento/segtoRecomendasVista.js"></script>
	
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST"
			commandName="catSegtoRecomendas">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Catálogo
					de Recomendaciones</legend>
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td class="label"><label for="lblRecomendacion">Recomendación:</label>
						</td>
						<td><input type="text" id="recomendacionSegtoID"
							name="recomendacionSegtoID" path="recomendacionSegtoID" size="6"
							tabindex="1" /></td>
					</tr>
					<tr>
						<td class="label"><label for="descripcion">Descripción:
						</label></td>
						<td><input type="text" id="descripcion" name="descripcion"
							onblur="ponerMayusculas(this)" maxlength="200" size="70"
							tabindex="2" /></td>
					</tr>
					<tr>
						<td class="label"><label for="lblAlcance">Alcance:</label></td>
						<td><select id="alcance" name="alcance" tabindex="5">
								<option value="">SELECCIONAR</option>
								<option value="G">GENERAL</option>
								<option value="P">PARTICULAR</option>
						</select></td>
					</tr>
					<tr>
						<td class="label"><label for="lblReqSupervisor">Requiere
								Supervisor:</label></td>
						<td><select id="reqSupervisor" name="reqSupervisor"
							tabindex="5">
								<option value="">SELECCIONAR</option>
								<option value="S">SI</option>
								<option value="N">NO</option>
						</select></td>

					</tr>
					<tr>
						<td class="label"><label for="estatus">Estatus:</label></td>
						<td><select id="estatus" name="estatus" tabindex="6">
								<option value="">SELECCIONAR</option>
								<option value="V">VIGENTE</option>
								<option value="C">CANCELADO</option>
						</select></td>
					</tr>
				</table>
				<table align="right">
					<tr>
						<td align="right"><input type="submit" id="agrega"
							name="agrega" class="submit" tabindex="7" value="Agregar" /> <input
							type="submit" id="modifica" name="modifica" class="submit"
							tabindex="8" value="Modificar" /> <input type="hidden"
							id="tipoTransaccion" name="tipoTransaccion" /></td>
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