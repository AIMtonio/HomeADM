<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
<head>
 	  <script type="text/javascript" src="dwr/interface/preguntaServicio.js"></script> 	 
 	  <script type="text/javascript" src="js/soporte/mascara.js"></script>
      <script type="text/javascript" src="js/bancaMovil/preguntaCatalogo.js"></script>
</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="pregunta">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">		
	<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Cat&aacute;logo de Preguntas Secretas</legend>
	<table border="0" cellpadding="0" width="70">
		<tr>
			<td class="label">
				<label for="preguntaSecretaID">Numero: </label>
			</td>
			<td>
				<form:input id="preguntaSecretaID" name="preguntaSecretaID" path="preguntaSecretaID" size="12" tabindex="1" maxlength="20"  />
			</td>
			<td class="separador"></td>
			</tr>
			<tr>
			<td class="label">
				<label for="redaccion">Pregunta: </label>
			</td>
			<td>
				<textarea id="redaccion" name="redaccion" path="redaccion" cols="50" rows="4"  
							  onblur=" ponerMayusculas(this)" tabindex="2" maxlength = "200"></textarea>
			</td>
		<tr>
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr>
			<td align="right">
				<input type="submit" id="agrega" name="agrega" class="submit" value="Agregar"  tabindex="81"/>
				<input type="submit" id="modifica" name="modifica" class="submit" value="Modificar"  tabindex="82"/>
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

<div id="cargando" style="display: none;"></div>
<div id="cajaLista" style="display: none;overflow:">
	<div id="elementoLista"></div>
</div>
<div id="cajaListaCte" style="display: none;overflow-y: scroll;height:200px;">
	<div id="elementoListaCte"></div>
</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>
