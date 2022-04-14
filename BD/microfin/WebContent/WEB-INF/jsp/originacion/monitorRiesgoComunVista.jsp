<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%> 

<html>
	<head>
		<script type="text/javascript" src="dwr/interface/solicitudCredServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/creditosServicio.js"></script>
		<script type="text/javascript" src="js/gridviewscroll.js"></script>
		
		<script type="text/javascript" src="js/originacion/monitorRiesgoComun.js"></script>
	</head>
	
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="monitorRiesgoComun" >
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Monitor de Riesgo Com&uacute;n/Persona Relacionada</legend>			
						<table>
							<tr>							
								<td class="label" nowrap="nowrap" align="right"> 
						    		<label for="lblSaldoInsolutoCartera">Saldo Insoluto de Cartera:</label> 
						 			<form:input id="saldoInsolutoCartera" name="saldoInsolutoCartera" esMoneda="true" readOnly="true" style="text-align: right;" autocomplete = "off" path="saldoInsolutoCartera" size="15" disabled="disabled" /> 
								</td>
							</tr>
							<tr>												
								<td class="label" nowrap="nowrap" align="right"> 
					         		<label for="sumatoriaCreditos" >Sumatoria de Creditos: </label> 
					     			<form:input type="text" id="sumatoriaCreditos" esMoneda="true" style="text-align: right;" name="sumatoriaCreditos"  readOnly="true" path="sumatoriaCreditos" size="15" disabled="disabled" />  
					     		</td>					     		
							</tr>
							<tr>
								<td>
									<fieldset class="ui-widget ui-widget-content ui-corner-all" id="fieldsetLisRiesgos" >
									<legend >Coincidencias	</legend>	
										<div id="divGridSolRiesgos" style="width: 100%;"></div>	
									</fieldset>	
								</td>									
							</tr>			
							
						</table>	
						
					<table align="right">
						<tr>
							<td align="right" colspan="2">	
								<input type="submit" id="agregar" name="agregar" class="submit" value="Grabar" tabindex="101" />
								<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>											
							</td>			
						</tr>
					</table>	
					
				</fieldset>		
			</form:form>
		</div>
		
	<div id="cargando" style="display: none;"></div>
	<div id="cajaLista" style="display: none;overflow:">
		<div id="elementoLista"></div>
	</div>
		
	</body>
	<div id="mensaje" style="display: none;"></div>
</html>