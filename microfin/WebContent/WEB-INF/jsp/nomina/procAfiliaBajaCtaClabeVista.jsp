<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>    
<html>
<head>	

      <script type="text/javascript" src="dwr/interface/procAfiliaBajaCtaClabeServicio.js"></script> 
		      	
      <script type="text/javascript" src="js/nomina/procAfiliaBajaCtaClabe.js"></script> 
      	
</head>
<body>

<div id="contenedorForma">

<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="procAfiliaBajaCtaClabeBean">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">		
		<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Procesar Afiliaci&oacute;n/Bajas Cuenta Clabe</legend>
		
			<table border="0" width="20%">
			  <tr>
				<td class="label" nowrap="nowrap">
					<label for="lblTipo">Tipo:</label>
				</td>
				<td>
					<form:select id="tipo" name="tipo" path="tipo" tabindex="1">
						<form:option value="">SELECCIONAR</form:option> 
						<form:option value="A">ALTA</form:option> 
				    	<form:option value="B">BAJA</form:option>
					</form:select>
				</td>		
			  </tr>
			  <tr>
			  	<td class="label" nowrap="nowrap">
					<label for="lblImportar">Importar Layout Afiliaci&oacute;n:</label>
				</td>
				<td>
					 <input type="button" id="adjuntar" name="adjuntar" class="submit" value="Adjuntar" tabindex="2"  />
				</td>
			  </tr>
			</table> 
			<div id="gridAfiliacionBajasCtaClabe"  style="display:none" ></div>
		  	<table border="0" width="100%">
				<tr>
					<td align="right">
						<input type="submit" id="procesar" name="procesar" class="submit" value="Procesar" tabindex="100" />
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