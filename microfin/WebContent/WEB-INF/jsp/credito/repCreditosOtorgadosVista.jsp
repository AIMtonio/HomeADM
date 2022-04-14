<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
 <%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>   
<html>

	<head>	
		<script type="text/javascript" src="dwr/interface/creditosServicio.js"></script>  
        <script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>    
        <script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>    
        <script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>    
        
 		<script type="text/javascript" src="js/credito/reporteCreditosOtorgados.js"></script> 
	</head>
   
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="creditos" target="_blank">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend class="ui-widget ui-widget-header ui-corner-all">Reporte Créditos Otorgados</legend>
         <table border="0" cellpadding="0" cellspacing="0" width="100%">		
         	<tr>
					<td class="label">
						<label for="fecha">Fecha: </label>
					</td>
					<td >
						<input id="fechaInicio" name="fechaInicio" path="fechaInicio" size="12" tabindex="1" type="text"  esCalendario="true" />	
					</td>					
			</tr>
         	<tr>
					<td class="label">
						<label for="sucursal">Sucursal: </label>
					</td> 
					<td >
						<input id="sucursalID" name="sucursalID"   size="12" tabindex="2" value="0" />
						<input type="text" id="nombreSucursal1" name="nombreSucursal1"  value="TODAS" readOnly="true" size="40"/> 
						
					</td>  
			</tr>
		
			<tr>
					<td class="label">
			 			<label for="usuario">Usuario:</label>
					</td> 
		   			<td>
			 			<form:input id="usuario" name="usuario" path="usuario" size="12" value="0"  tabindex="3" />
			 			<input type="text" id="nombreUsuario" name="nombreUsuario" value="TODOS" readOnly="true" size="40" /> 
					</td> 		
			</tr>
			<tr>
					<td class="label">
			 			<label for="tipoCred">Tipo Crédito: </label>
					</td> 
		  			<td>
			  			<form:select id="tipoCredito" name="tipoCredito" path=""  tabindex="4">
			  			<form:option value="0">TODOS</form:option>
						<form:option value="N">NUEVO</form:option>
				     	<form:option value="R">REESTRUCTURA</form:option>
						</form:select>
					</td>		
			</tr>
			<tr>
					<td class="label">
			 			<label for="productoCredito">Producto de Crédito: </label>
					</td> 
		  			<td>
		   				<form:input id="producCreditoID" name="producCreditoID" path="producCreditoID" value="0" size="12" tabindex="5"/>
		   				<input type="text" id="nombreProducto" name="nombreProducto" value="TODOS" readOnly="true" size="40" /> 
					</td>		
			</tr>
	
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td colspan="4">
							<table align="right" border='0'>
								<tr>
									<td >
									<a id="ligaGenerar" href="reporteCredOtorgados.htm" target="_blank" >  		 
										 <input type="button" id="generar" name="generar" class="submit" 
												 tabIndex = "6" value="Generar" />
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