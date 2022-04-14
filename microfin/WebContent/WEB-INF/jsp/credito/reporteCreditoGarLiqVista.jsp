<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%> 
<html>

	<head>	
		<script type="text/javascript" src="dwr/interface/creditosServicio.js"></script>  
        <script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>    
        <script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>    
        <script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>    
        
 		<script type="text/javascript" src="js/credito/reporteCreditoGarLiq.js"></script> 
	</head>
   
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="creditosRepBean" target="_blank">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend class="ui-widget ui-widget-header ui-corner-all">Reporte Créditos Con Garantía Líquida</legend>
         <table border="0" cellpadding="0" cellspacing="0" width="100%">		
         	<tr>
         	<td>
         	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
							<legend><label>Par&aacute;metros</label></legend>         
	          				<table  border="0"  width="560px">
	          
			<tr>
					<td class="label">
			 			<label for="cliente"><s:message code="safilocale.cliente"/>:</label>
					</td> 
		   			<td>
			 			<form:input id="clienteID" name="clienteID" path="clienteID" size="12" value="0"  tabindex="1" />
			 			<input type="text" id="nombreCliente" name="nombreCliente" value="TODOS" readOnly="true" size="40" /> 
					</td> 		
			</tr>
			<tr>
					<td class="label">
						<label for="sucursal">Sucursal: </label>
					</td> 
					<td >
						<input id="sucursal1" name="sucursal1"   size="12" tabindex="2"  />
						<input type="text" id="nombreSucursal1" name="nombreSucursal1"    readOnly="true" size="40"/> 
						
					</td>  
			</tr>
			<tr>
					<td class="label">
			 			<label for="credito">Crédito: </label>
					</td> 
		  			<td>
		   				<form:input id="creditoID" name="creditoID" path="creditoID" value="0" size="12" tabindex="3"/>
		   				<input type="text" id="nombreClienteCre" name="nombreClienteCre" value="TODOS" readOnly="true" size="40" /> 
					</td>		
			</tr>
			</table>
			</fieldset>  
		</td>
		</tr>
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					
					<tr>
						<td colspan="4">
							<table align="right" border='0'>
								<tr>
									<td >

									<a id="ligaGenerar" href="RepCredGarLiq.htm" target="_blank" >  		 
										 <input type="button" id="generar" name="generar" class="submit" 
												 tabIndex = "5" value="Generar" />
									</a>
									
									</td>
								</tr>
								
							</table>		
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