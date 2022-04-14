<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>

	<head>	
		<script type="text/javascript" src="dwr/interface/solicitudCredServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/cuentasTransferServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/instruccionDispersionServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/perfilesAnalistasCreServicio.js"></script>
		<script type="text/javascript" src="js/originacion/instruccionDispersionGrid.js"></script>
		<script type="text/javascript" src="js/originacion/instruccionDispersion.js"></script>
       
	</head>
   
<body>
<div id="contenedorForma">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend class="ui-widget ui-widget-header ui-corner-all">Instrucciones de dispersi&oacute;n</legend>	
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="instruccionDispersion">
																			  		
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td class="label" nowrap="nowrap">
						<label for="lblSolicitudCredito">Solicitud de Cr&eacutedito: </label>
					</td>
					<td>
						<input type="text" id="solicitudCreditoID" name="solicitudCreditoID" path="solicitudCreditoID" size="12" autocomplete="false" tabindex="1" />
					</td>
												
				</tr>
				<tr>
					<td class="label" nowrap="nowrap">
						<label for="lblSolicitudCredito">Cliente: </label>
					</td>
					<td nowrap="nowrap">
						<input type="text" id="clienteID" name="clienteID" path="clienteID" size="12" readonly="true" disabled="disabled" />
						<input type="text" id="nombreCte" name="nombreCte" path="nombreCte"size="50" readonly="true" disabled="disabled" />
					</td>
				</tr>
				<tr>
					<td class="label">
						<label for="lblsolicitado">Monto Solicitado(Sin Comisiones): </label>
					</td>
					<td>
						<input type="text" id="montoSolici" name="montoSolici" size="18" esMonto="true" style="text-align: right;" readonly="true" disabled="disabled" />
					</td>
				</tr>							
		 	</table>
			

</form:form>

<form:form id="formaGenerica1" name="formaGenerica1" method="POST" commandName="instruccionDispersion" action="/microfin/instruccionDispersionGrid.htm">	
	<div id="divGridInstruccion" style="display: none;" ></div>			
</form:form>


</div>
</fieldset>

<div id="cargando" style="display: none;">	
</div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"/>
</div>
</body>
<div id="mensaje" style="display: none;"/>
</html>