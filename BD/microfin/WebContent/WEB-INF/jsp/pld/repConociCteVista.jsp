<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
 <%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>   
<html>
	<head>
      
     <script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>  
   	 <script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
     <script type="text/javascript" src="dwr/interface/promotoresServicio.js"></script> 
   	 <script type="text/javascript" src="js/pld/conocimientoCliente.js"></script>  
	</head>
      
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="RepConocimientoCteBean">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Conocimiento Cliente</legend>
		<table border="0" cellpadding="0" cellspacing="0" width="600px">
			<tr> 
				<td> 
					<fieldset class="ui-widget ui-widget-content ui-corner-all">                
					<legend><label>Parámetros</label></legend>         
          				<table  border="0"  width="560px">
							<tr>		
								<td class="label"> 
						        	<label for="clientelb">Cliente: </label> 
						    	</td> 	
						   		<td nowrap= "nowrap"> 
							         <input id="clienteID" name="clienteID"  size="11" tabindex="3" /> 
							         <input type="text" id="nombreCliente" name="nombreCliente" size="50"  tabindex="4" readOnly="true"/>   
						  		</td> 
							</tr>
						</table>
						
						<table>
							<tr>
								<td>
									<fieldset class="ui-widget ui-widget-content ui-corner-all">                
										<legend><label>Presentaci&oacute;n</label></legend>
											<input type="radio" id="pdf" name="generaRpt" value="pdf" />
											<label> PDF </label>
									</fieldset>
								</td>      
							</tr>
						</table>
					</fieldset> 
				</td> 
			</tr>
					
			<tr>
				<td align="right">
					<input type="hidden" id="tipoReporte" name="tipoReporte" class="submit" />
					<input type="hidden" id="tipoLista" name="tipoLista" />
					<input type="hidden" id="alertSocio" name="alertSocio" value="<s:message code="safilocale.cliente"/>"/>
					<a id="ligaGenerar" href="/conocimientoCliente.htm" target="_blank" >  		 
						 <input type="button" id="generar" name="generar" class="submit" 
								 tabIndex = "48" value="Generar" />
					</a>
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