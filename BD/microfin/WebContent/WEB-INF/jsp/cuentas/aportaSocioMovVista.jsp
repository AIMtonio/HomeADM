<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>

	<head>		
			<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>	
		<script type="text/javascript" src="dwr/interface/aportacionSocial.js"></script>
 	   <script type="text/javascript" src="dwr/interface/aportacionSocial.js"></script>        
	   <script type="text/javascript" src="js/cuentas/aportacionSocioMov.js"></script>	      
	</head>
   
<body>
<input type="hidden" id="tipoCliente" value="<s:message code="safilocale.cliente"/>" />
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="aportacionSocio"> 
<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Aportaciones Socios</legend> 
		<fieldset class="ui-widget ui-widget-content ui-corner-all">                
			<legend>Datos del Socio</legend>	
				<table border="0" width="100%">    	
					<tr>	   	
				     	<td class="label" > 
				         <label for="lblclienteID"><s:message code="safilocale.cliente"/>: </label> 
				     	</td> 
				     	<td nowrap="nowrap"> 
				        <form:input  type="text" id="clienteID" name="clienteID" path="clienteID" size="15" iniForma = 'false'
				        			tabindex="1" />
				        <input id="nombreCliente" name="nombreCliente"size="60" iniForma = 'false' 
				         	type="text" readOnly="true" disabled="true" tabindex="2"/>
				     	</td> 	
			     		<td class="separador"></td>
			     		<td class="separador"></td>
				     						     	
					</tr>
					
				   <tr>
						<td class="label"> 
				         <label for="lblsaldo">Monto Aportado: </label> 
				     	</td> 
				     	<td> 
				        <form:input id="saldo" name="saldo" size="15" iniForma = 'false' path="saldo"
				        		type="text" readOnly="true" disabled="true" style="text-align: right" />
				     	</td> 
				     
				   </tr> 
				   <tr>
						<td class="label" nowrap="nowrap"> 
				         <label for="lblsaldo">Fecha Imp. Certificado: </label> 
				     	</td> 
				     	<td> 
				        <form:input id="fechaImp" name="fechaImp" size="15" iniForma = 'false' path="fechaImp"
				        		type="text" readOnly="true" disabled="true" style="text-align: right"/>
				     	</td> 
				     
				   </tr> 					    				  				   
					<tr>
						<td colspan="5">
							<table align="right">
								<tr> 
									<td align="right">	
										<button type="button" class="submit" id="consultar">Consultar</button> 		
									</td>
								</tr> 
							</table>		
						</td>
					</tr> 
				</table>
		</fieldset>   
	
	   
		<div id="gridAportacionMovimientos" style="display: none;">
		</div>
				
		<table border="0"  width="100%"> 
			<tr>
				<td colspan="5">
					<table align="right">
					<tr>
						<td>
							
                     		<button type="button" class="submit" id="solicitar" style="display: none;">
                              Solicitud de Baja
                      		</button>
									
								
                     		<button type="button" class="submit" id="imprimir" style="display: none;">
                              Certificado
                      		</button>
											
							</td>
						</tr>
					</table>			
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
