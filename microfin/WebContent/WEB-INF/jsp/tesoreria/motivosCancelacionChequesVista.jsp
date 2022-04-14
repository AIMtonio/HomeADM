<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<html>
	<head>
		<script type="text/javascript" src="js/soporte/mascara.js"></script>
		<script type="text/javascript" src="dwr/interface/motivoCancelacionChequesServicio.js"></script>
		<script type="text/javascript" src="js/tesoreria/motivosCancelacionCheques.js"></script>  
	</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="motivoCancelacionCheques">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">		
			<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Motivos de Cancelaci&oacute;n de Cheques</legend>
			<br> 		
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend>Motivos</legend>
						<input type="button" id="agregarMotivo" name="agregarMotivo" value="Agregar" onClick="agregarMotivos();" class="submit" tabindex="1" />
						<input type="hidden" id="datosGrid" name="datosGrid" size="100" />	
						<div id="divMotivosCancelacion" style="display: none;"></div>
				</fieldset>				
				<br>
				<table border="0" width="100%">
				<tr>
					<td align="right">
						<input type="submit" id="grabar" name="grabar" class="submit" value="Grabar" tabindex="2" />
						<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="1"/>						
					</td>
				</tr>
			</table>	
			</fieldset>
	</form:form>
	</div>
		<div id="cargando" style="display: none;">	
	</div>
	<div id="cajaLista" style="display: none;">
		<div id="elementoLista"></div>
	</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>