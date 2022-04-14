<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
<script type="text/javascript" src="dwr/interface/uniConceptosInvAgroServicio.js"></script>
<script type="text/javascript" src="js/fira/uniConceptosInvAgro.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="uniConceptosInvAgroBean">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Unidades de Conceptos de Inversi&oacute;n</legend>
				<table width="100%">
					<tr>
						<td>
							<label for="uniConceptoInvID">N&uacute;mero:</label>
						</td>
						<td>
							<form:input id="uniConceptoInvID" type="text" name="uniConceptoInvID" path="uniConceptoInvID" size="12" autocomplete="off" tabindex="1"/>
						</td>
						<td class="separador"></td>
						<td>
							<label for="clave">Clave:</label>
						</td>
						<td>
							<form:input id="clave" type="text" name="clave" path="clave" size="60" autocomplete="off" onblur="ponerMayusculas(this)" tabindex="2"/>
						</td>
					</tr>
					<tr>
						<td>
							<label for="unidad">Unidad:</label>
						</td>
						<td>
							<form:input id="unidad" type="text" name="unidad" path="unidad" size="60" autocomplete="off" onblur="ponerMayusculas(this)" tabindex="3"/>
						</td>
					</tr>
					<tr>
						<td colspan="5">
							<br>
							<table align="right" boder='0'>
								<tr>
									<td align="right">
										<input type="submit" id="agrega" name="agrega" class="submit" value="Agregar" tabindex="4"/>
										<input type="submit" id="modifica" name="modifica" class="submit" value="Modificar" tabindex="5"/>
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