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
		<script type="text/javascript" src="js/originacion/repBitacoraSol.js"></script>  
	</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="repBitacoraSolBean">
<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Reporte Bit&aacute;cora de Solicitud de Cr&eacute;dito </legend>
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
				<td class="label">
					<label for="promotor">Promotor:</label>
				</td>
				<td  colspan="4">
					<form:input id="promotorID" name="promotorID" path="promotorID" size="6" tabindex="4"/>
					<input type="text" id="nombrePromotor" name="nombrePromotor" size="39" tabindex="10" disabled= "true" readOnly="true" />	 
				</td>
			</tr>			
			<tr>
				<td class="label" nowrap="nowrap"> 
	    			<label for="productoCreditoID">Producto Crédito: </label> 
				</td> 
	    		<td nowrap="nowrap"> 
	    			<input  type="text" id="producCreditoID" name="producCreditoID" size="15"  value="0" tabIndex="4" />
	    			<input  type="text" id="nombreProducto" name="nombreProducto" size="55" readOnly="true" disabled="true"/>
				</td>
			</tr>
			</table>
			</fieldset>  
			</td>
			<td class="label" valign="top">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">                
				<legend><label>Presentación: </label></legend>
				<input type="radio" id="excel" name="tipoReporte" tabindex="4"/>
				<label> Excel </label>
				</fieldset>
			</td>
			</tr>	
			<tr>
				<td class="separador"></td>	
				<td colspan="5" align="right">
				<a id="ligaGenerar" href="/RepBitacoraSol" target="_blank" >  		 
					<input type="button" id="generar" name="generar" class="submit" tabIndex="5" value="Generar" />
				</a>
				<input type="hidden" id="tipoLista" name="tipoLista" />
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