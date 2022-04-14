<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>    
<html>
<head>	

      <script type="text/javascript" src="dwr/interface/procesaDomiciliacionPagosServicio.js"></script> 
		      	
      <script type="text/javascript" src="js/nomina/procesaDomiciliacionPagos.js"></script> 
      	
</head>
<body>

<div id="contenedorForma">

<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="procesaDomiciliacionPagosBean">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">		
		<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Procesa Domiciliaci&oacute;n Pagos</legend>
		
			<table border="0" width="20%">
			  <tr>
			  	<td class="label" nowrap="nowrap">
					<label for="lblImportar">Importar Layout:</label>
				</td>
				<td>
					 <input type="button" id="adjuntar" name="adjuntar" class="submit" value="Adjuntar" tabindex="2"  />
				</td>
			  </tr>
			</table> 
			<div id="gridProcesaDomiciliacionPagos"  style="display:none" ></div>
		  	<table border="0" width="100%">
				<tr>
					<td align="right">
						<input type="submit" id="procesar" name="procesar" class="submit" value="Procesar" tabindex="100" />
						<input type="submit" id="generar" name="generar" class="submit" value="Generar Layout" tabindex="101" />
						<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />
						<input type="hidden" id="fechaSistema" name="fechaSistema" />
						<input type="hidden" id="fechaSistema" name="fechaSistema" />
						<input type="hidden" id="consecutivo" name="consecutivo" />
						<input type="hidden" id="folioID" name="folioID" />
						<input type="hidden" id="numTransaccion" name="numTransaccion" />
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