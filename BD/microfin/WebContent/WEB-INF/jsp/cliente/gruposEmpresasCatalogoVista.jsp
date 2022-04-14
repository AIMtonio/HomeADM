<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<html>
<head>
	 <script type="text/javascript" src="dwr/interface/gruposEmpServicio.js"></script>
	 <script type="text/javascript" src="js/cliente/gruposEmp.js"></script>
	


	<title>Grupos de Empresas</title>
	</head>
	<body>
	<div id="contenedorForma">
	<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="empresa">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">		
	<legend class="ui-widget ui-widget-header ui-corner-all">Grupos de Empresas</legend>			
	<table border="0" width="950px">

		<tr>
			<td class="label">
				<label for="tipoPersona">N&uacute;mero:</label>
			</td>
			<td>
				<form:input id="GrupoEmpID" name="GrupoEmpID" path="grupoEmpID" size="8" tabindex="1" maxlength="11"/>
			</td>
			<td class="separador"></td>
			<td class="label">
				<label for="tipoPersona">Nombre:</label>
			</td>
			<td>
				<form:input id="NombreGrupo" name="NombreGrupo" path="nombreGrupo" size="40" tabindex="2" maxlength="100"/>
			</td>
		</tr>
		<tr>
			<td class="label">
				<label for="tipoPersona">Observaciones:</label>
			</td>
			<td>
				<form:textarea id="Observacion" name="Observacion" path="observacion" COLS="50" ROWS="5" tabindex="3" maxlength="100" />
			</td>
		</tr>
	</table>

	<table align="right">
		<tr>
			<td align="right">
				<input type="submit" id="agrega" name="agrega" class="submit" value="Agregar" tabindex="4"/>
				<input type="submit" id="modifica" name="modifica" class="submit" value="Modificar" tabindex="5"/>
				<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />						
			</td>
		</tr>
	</table>	
</fieldset>
	
</form:form>
</div>
<div id="cargando" style="display: none;">	
</div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"/>
</div>
</body>
<div id="mensaje" style="display: none;"/>
</html>
