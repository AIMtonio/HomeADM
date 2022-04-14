<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%> 

<html>
	<head>
		<script type="text/javascript" src="dwr/interface/solicitudCredServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
		
		<script type="text/javascript" src="js/originacion/riesgoComun.js"></script>
	</head>
	
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="riesgoComun" >
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Posible Riesgo Com&uacute;n/Persona Relacionada</legend>
						<table >
							<tr>
								<td class="label" nowrap="nowrap"> 
						    		<label for="lblSolicitudID">Solicitud de Crédito:</label> 
						 		</td> 
						    	<td> 
						   			<form:input id="solicitudCreditoID" name="soicitudCreditoID" autocomplete = "off" path="solicitudCreditoID" size="12"  /> 
								</td>
							</tr>
							<tr>
								<td class="label"> 
					         		<label for="clienteID" id="LblCliente">Cliente: </label> 
					     		</td> 
					     		<td> 
					         		 <form:input type="text" id="clienteID" name="clienteID"  readOnly="true" path="clienteID" size="12" disabled="disabled" />  
					         		 <input  type="text" id="nombreCliente" name="nombreCliente" path="nombreCliente" readOnly="true" size="48" disabled="disabled" />   
					     		</td>					     		
							</tr>							
							
						</table>	

						<fieldset class="ui-widget ui-widget-content ui-corner-all" id="fieldsetLisSol" style="width: 1000px; height: 400px;  overflow-y: scroll; display: none; " >
						<legend >Coincidencias	</legend>	
						<table align="right">
							<tr>
								<div id="divGridTiposRespuesta"></div>	
											
							</tr>
						</table>												
					</fieldset>
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