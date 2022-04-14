<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>

	<head>	 
		<link rel="stylesheet" type="text/css" href="css/jquery.lightbox-0.5.css" media="screen" /> 
		<script type="text/javascript" src="dwr/interface/checkListCedesServicio.js"></script>	
		<script type="text/javascript" src="dwr/interface/cedesServicio.js"></script>
	    <script type="text/javascript" src="dwr/interface/tipoInversionesServicio.js"></script>
	    
	  	<script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script>  
		<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/clienteArchivosServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/tiposDocumentosServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/cedesFileServicio.js"></script>  
		<script type="text/javascript" src="js/jquery.lightbox-0.5.pack.js"></script>
		<script type="text/javascript" src="dwr/interface/tiposCuentaServicio.js"></script> 
		
		
		<script type="text/javascript" src="js/cedes/checkListCedes.js"></script>   		     
	</head>
   
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="checkListCedes">

<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">CheckList</legend>
	
	<fieldset class="ui-widget ui-widget-content ui-corner-all">		
	<legend>CEDES</legend>
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr>
		 <td> <table>
			<tr>
				<td class="label"> 
			    	<label for="Cedeslb">Cede: </label> 
				</td>
				<form:input id="productoID" name="productoID" path="productoID" size="6" tabindex="1" type="hidden" /> 				
				
				<td>
				<input type="text" id="cedeID" name="cedeID" size="13" tabindex="1" /> 
				<input id="descripcion" name="descripcion" size="50" type="text" readOnly="true" disabled="true"/>			 
				</td>
				 <td class="separador"></td> 
				<td class="label"> 
			    	<label for="fechaRegistro">Fecha Registro: </label> 
			   	</td> 
			    <td> 
			     	<input type="text" id="fechaRegistro" name="fechaRegistro"  size="20" readOnly="true" disabled="true"/> 
			  	</td>
			</tr>
			<tr> 
				<td class="label"> 
			    	<label for=clientelb>Cliente:</label> 
				</td> 		     		
			    <td>
			    	<input  type="text" id="clienteID" name="clienteID"  size="13" readOnly="true" disabled="true"/> 
			        	 <input id="nombreCliente" name="nombreCliente" size="50" type="text" readOnly="true" disabled="true"/>
			   	</td> 	
			    <td class="separador"></td> 
			   	<td class="label"> 
			    	<label for="estatuslb">Estatus: </label> 
				</td> 
			    <td> 
			    	<input type="text" id="estatus" name="estatus"  size="20" readOnly="true" disabled="true" /> 	
				</td>
			</tr>
			
			<tr>
				<td class="label"> 
			    	<label for="fechaRegistro">Fecha Inicio: </label> 
			   	</td> 
			    <td> 
			     	<input type="text" id="fechaInicio" name="fechaInicio"  size="20" readOnly="true" disabled="true"/> 
			  	</td>
			  	<td class="separador"></td> 
			  	<td class="label"> 
			    	<label for="fechaRegistro">Fecha Vencimiento: </label> 
			   	</td> 
			    <td> 
			     	<input type="text" id="fechaVencimiento" name="fechaVencimiento"  size="20" readOnly="true" disabled="true"/> 
			  	</td>
			</tr>
			
				<tr>
				
			  	<td class="label"> 
			    	<label for="montolb">Monto: </label> 
			   	</td> 
			    <td> 
			     	<input type="text" id="monto" name="monto"  size="20" readOnly="true" disabled="true"  esMoneda="true"/> 
			  	</td>
			</tr>
			
			
				</table>
				</td>
				</tr>


		<tr> 
			<td>
		
			</td>	
  		</tr>
  	</table>		
	</fieldset>
	

	<table border="0" cellpadding="0" cellspacing="0" width="100%">			
		<tr>
			<td colspan="7">
				<input type="hidden" id="datosGrid" name="datosGrid" size="100" />	
				<div id="gridSolicitudCheckList" name="gridSolicitudCheckList" style="display: none;"></div>							
			</td>	
		</tr>
	</table>
		
	<br>
	<table align="right">
		<tr>			
		<td class="label">
		    <input type="button" class="submit" id="pdf" value="Expediente"/>	
		</td> 
		
			<td class="label">
		    		<input type="button" class="submit" id="listaDocs" value="Lista Docs"/>	
		</td> 
			<td align="right">												
				<input type="submit" id="grabar" name="grabar" class="submit" value="Grabar"/>					
				<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>						
			</td>
		</tr>
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