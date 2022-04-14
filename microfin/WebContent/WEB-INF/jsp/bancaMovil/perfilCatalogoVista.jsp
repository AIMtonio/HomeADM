<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
<head>

 	  <script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
 	  <script type="text/javascript" src="dwr/interface/paramGeneralesServicio.js"></script>
 	  <script type="text/javascript" src="dwr/interface/perfilServicio.js"></script> 
	 
 	  <script type="text/javascript" src="js/soporte/mascara.js"></script>
      <script type="text/javascript" src="js/bancaMovil/perfilCatalogo.js"></script>
</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="perfil">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">		
	<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Perfiles</legend>
	<table border="0"  cellspacing="0" width="100%">
		<tr>
			<td class="label">
				<label for="perfilID">No. Perfil: </label>
			</td>
			<td>
				<input id="perfilID" name="perfilID" path="perfilID" size="12" maxlength="20" tabindex="1" iniForma="false" />
			</td>
			<td class="separador"></td>
			<td class="label">
				<label for="nombrePerfil">Nombre: </label>
			</td>
		  	<td nowrap="nowrap">
				<input type="text" id="nombrePerfil" name="nombrePerfil" onBlur="ponerMayusculas(this)" size="37" maxlength="50" tabindex="2"/>
			</td>
		</tr>
		
		<br>
		
		<tr>
			<td class="label">
				<label for="descripcion">Descripción: </label>
			</td>
			<td>
				<textarea id="descripcion" name="descripcion"  onBlur="ponerMayusculas(this)" path="descripcion" cols="50" rows="4"  
							  onblur=" ponerMayusculas(this)" tabindex="3" maxlength = "199"></textarea>
			</td>
			
		</tr>
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr>
			<td align=right>
				<input type="submit" id="agrega" name="agrega" class="submit" value="Agregar"  tabindex="4"/>
				<input type="submit" id="modifica" name="modifica" class="submit" value="Modificar"  tabindex="5"/>
				<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
				<input type="hidden" id="empresa" name="empresa"/>
				<input type="hidden" id="ocupaTab" name="ocupaTab"/>
			</td>
		</tr>
		</table>
	</table>
	</fieldset>
	
</form:form>
</div>

<div id="cajaLista" style="display: none;overflow:">
	<div id="elementoLista"></div>
</div>
<div id="cajaListaCte" style="display: none;overflow-y: scroll;height:200px;">
	<div id="elementoListaCte"></div>
</div>

</body>

<div id="mensaje" style="display: none;"></div>
</html>