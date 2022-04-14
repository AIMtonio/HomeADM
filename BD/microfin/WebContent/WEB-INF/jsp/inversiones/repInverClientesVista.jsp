<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
<head>
   		<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
   		<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
		<script type="text/javascript" src="js/inversiones/repInverClientes.js"></script>
		
</head>
<body>
	<div id="contenedorForma">
		<fieldset class="ui-widget ui-widget-content ui-corner-all" >
			<legend class="ui-widget ui-widget-header ui-corner-all">Reporte de Inversiones por <s:message code="safilocale.cliente"/></legend>
			<form id="formaGenerica" name="formaGenerica" method="POST" commandName="inverClientes" target="_blank">
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td>
						<fieldset class="ui-widget ui-widget-content ui-corner-all">                
						<legend><label>Par&aacute;metros</label></legend>         
          				<table  border="0"  width="560px">
							<tr>
								<td>
									<label for="lblsucursal">Sucursal:</label>
								</td>
								<td>
									<input type="text" id="sucursalID" name="sucursalID" size="11" tabindex="1" />
								</td>
								<td colspan="3"></td>
							</tr>	
							<tr>
								<td>
									
								</td>
								<td>
								<input type="text" id="nombreSucursal" name="nombreSucursal" size="55" readonly="true">
								</td>
								<td colspan="3"></td>
							</tr>			
							<tr>
								<td>
									<label for="lblClienteID"><s:message code="safilocale.cliente"/>: </label> 
								</td>
								<td>
									<input type="text"  id="clienteID" name="clienteID"  size="11" tabindex="2" />								 
								</td>
								<td colspan="3"></td>
							</tr>
							<tr>
								<td>
								</td>
								<td>
									<input type="text"  id="nombreCte" name="nombreCte" size="55"  readOnly="true" /> 
								</td>
								<td colspan="3"></td>
							</tr>
						</table>
						</fieldset>  
					</td> 
					<td> 	
						<table width="200px"> 
							<tr>
						
							<td class="label" style="position:absolute;top:12%;">
							<fieldset class="ui-widget ui-widget-content ui-corner-all">                
							<legend><label>Presentaci&oacute;n</label></legend>
									<input type="radio" id="pdf" name="pdf" value="pdf" tabindex="3"/>
									<label> PDF </label>
						            <br>
						            <input type="radio" id="excel" name="excel" value="excel" tabindex="4"/>
									<label> Excel </label>
						            <br>
									<input type="radio" id="pantalla" name="pantalla" value="pantalla" tabindex="5">
								<label> Pantalla </label>				 	
								</fieldset>
								<input type="hidden" name="reporte" id="reporte" />
							</td>      
							</tr>
						</table>
					</td>
				<tr>
			</table>
			<br>
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>								
					<td align="right" colspan="4">
						<a id="ligaImp" href="InverClientes.htm" target="_blank" >
		             		<button type="button" class="submit" id="imprimir" style="" tabindex="6">
		              		Imprimir
		             		</button> 
	           			</a>					
					</td>
				</tr>
			</table>
		</form>
			</fieldset>
		</div>
		<div id="cajaLista" style="display: none;">
			<div id="elementoLista"/>
		</div>
	</body>
</html>