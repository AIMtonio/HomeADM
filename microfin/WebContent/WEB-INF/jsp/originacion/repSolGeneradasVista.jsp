<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>   
<html>
	<head>
     	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>   
		<script type="text/javascript" src="dwr/interface/destinosCredServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/promotoresServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/prospectosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/solicitudCredServicio.js"></script>
		<script type="text/javascript" src="js/originacion/repSolGeneradas.js"></script>  
	</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="repsolicitudCredito">
<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Reporte Solicitudes de Cr&eacute;dito Generadas</legend>
	<table border="0"  width="100%">
		<tr>
		 <td>
			<fieldset class="ui-widget ui-widget-content ui-corner-all">                
			<legend><label>Par&aacute;metros</label></legend>         
	        <table  border="0"  width="560px">
			<tr> 
				<td class="label"> 
			    	<label for=fechaInicio>Fecha Inicio:</label> 
				</td> 		     		
			    <td>
			    	<input  type="text" id="fechaInicio" name="fechaInicio" size="12" esCalendario="true" tabindex="1"/> 
			   	</td> 	
			</tr>
			<tr> 
				<td class="label"> 
			    	<label for=fechaInicio>Fecha Fin:</label> 
				</td> 		     		
			    <td>
			    	<input  type="text" id="fechaFin" name="fechaFin"  esCalendario="true" tabindex="2" size="12"/> 
			   	</td> 	
			</tr>		
			<tr> 
				<td class="label"> 
    				<label for="sucursalID">Sucursal:</label> 
				</td> 		     		
    			<td nowrap="nowrap">		         			
         			<input  type="text" id="sucursalID" name="sucursalID"  size="15"    tabIndex="3" />
         			<input  type="text" id="nombreSucursal" name="nombreSucursal" size="55"   readOnly="true" disabled="true"/>	 
			   	</td> 			   	
			</tr>
			<tr>
				<td class="label" nowrap="nowrap"> 
	    			<label for="productoCreditoID">Producto Crédito: </label> 
				</td> 
	    		<td nowrap="nowrap"> 
	    			<input  type="text" id="producCreditoID" name="producCreditoID" size="15"  value="0" tabIndex="4" />
	    			<input  type="text" id="nombreProducto" name="nombreProducto" size="55" value="TODOS"  readOnly="true" disabled="true"/>
				</td>
			</tr>
			<tr>
				<td class="label"> 
	    			<label for="usuario">Usuario: </label> 
				</td>
				<td nowrap="nowrap">
					<input type="text" id="usuarioID" name="usuarioID" size="15"  value="0" tabIndex="5" />	
					<input type="text" id="nombreUsuario" name="nombreUsuario" size="55"  value="TODOS" readOnly="true" disabled="true"/>			 
				</td>								
			</tr>	
			<tr>
				<td class="label"> 
	    			<label for="usuario">Cliente: </label> 
				</td>
				<td nowrap="nowrap">
					<input type="text" id="clienteID" name="clienteID" size="15"  value="0" tabIndex="6" />	
					<input type="text" id="nombreCliente" name="nombreCliente" size="55"  value="TODOS" readOnly="true" disabled="true"/>			 
				</td>								
			</tr>	
			<tr>
				<td class="label"> 
	    			<label for="usuario">Prospecto: </label> 
				</td>
				<td nowrap="nowrap">
					<input type="text" id="prospectoID" name=""prospectoID"" size="15"  value="0" tabIndex="7" />	
					<input type="text" id="nombreProspecto" name="nombreProspecto" size="55"  value="TODOS" readOnly="true" disabled="true"/>			 
				</td>								
			</tr>
			<tr>
				<td class="label"><label>Estatus: </label></td>
				<td>
					<form:select id="estatus" name="estatus" path="estatus" tabindex="8">
					<form:option value="T">TODOS</form:option>
					<form:option value="I">INACTIVA</form:option>
					<form:option value="L">LIBERADA</form:option>
					<form:option value="A">AUTORIZADA</form:option>
					<form:option value="C">CANCELADA</form:option>
					<form:option value="R">RECHAZADA</form:option>
					<form:option value="D">DESEMBOLSADA</form:option>
					</form:select>
				</td>
			</tr>	
			</table>
			</fieldset>  
			</td>
			<td class="label" valign="top">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">                
				<legend><label>Presentación: </label></legend>
				<input type="radio" id="pdf" name="pdf" value="pdf"  checked>
				<label> PDF </label>
				</fieldset>
			</td>
			</tr>	
			<tr>
				<td class="separador"></td>	
				<td colspan="5" align="right">
					<input type="button" id="generar" name="generar" class="submit" tabIndex = "9" value="Generar" />
					<input type="hidden" id="tipoReporte" name="tipoReporte" class="submit" />
					<input type="hidden" id="tipoLista" name="tipoLista" />
					<input type="hidden" id="alertSocio" name="alertSocio" value="<s:message code="safilocale.cliente"/>"/>
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