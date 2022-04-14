<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
 <%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>   
<html>
	<head>
	    <script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script>  
	    <script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
	    <script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>
	    <script type="text/javascript" src="dwr/interface/tiposCuentaServicio.js"></script>
	    <script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>  
	    <script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
	    <script type="text/javascript" src="dwr/interface/promotoresServicio.js"></script> 
	    <script type="text/javascript" src="dwr/interface/estadosServicio.js"></script>
	    <script type="text/javascript" src="dwr/interface/municipiosServicio.js"></script>  
	    <script type="text/javascript" src="js/cuentas/repBloqueoSaldos.js"></script>  
	</head>
      
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="bloqueoSaldoPet">
		<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend class="ui-widget ui-widget-header ui-corner-all">Reporte de Bloqueo de Saldos</legend>
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr> 
	 		<td> 
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend><label>Parámetros: </label> </legend>
		 		<table border="0" cellpadding="0" cellspacing="0" width="100%">
		 			<tr>
						<td>
							<label><s:message code="safilocale.cliente"/>:</label>
						</td>
							<td class="separador">
						<td>
							<input type="text" id="clienteID" name="clienteID"  path="clienteID" value="0" tabindex="1" size="13" />		
							<input type="text" id="nombreCliente" name="nombreCliente" value="TODOS" readOnly="true" size="50"/>										 
						</td>
					</tr>	
					<tr>
						<td>
							<label>Sucursal:</label>
						</td>
							<td class="separador">
						<td>
							<input type="text" id="sucursalID" name="sucursalID"  size="13"  path="sucursalID"  readOnly="true" />
							<input type="text" id="nombreSucursal" name="nombreSucursal"  readOnly="true" size="50"/>														 
						</td>
					</tr>						
					<tr>
						<td>
							<label> Cuenta:</label>
						</td>
							<td class="separador">
						<td>
							<input type="text" id="cuentaAhoID" name="cuentaAhoID"  path="cuentaAhoID" value="0" tabindex="3"  size="13"   />	
							<input type="text" id="tipoCuenta" name="tipoCuenta"  value="TODAS" readOnly="true" size="50"/>									 
						</td>
					</tr>	
				</table> 
				
 		 		</fieldset>  
			</td>  
	</tr>
    </table>
  	<br>
		<table width="200px">
				 <tr>
 					<td class="label" > 	
						<fieldset class="ui-widget ui-widget-content ui-corner-all">		
							<legend><label>Presentaci&oacute;n</label></legend>
							<table border="0" cellpadding="0" cellspacing="0" width="100%">
								<tr>
									<td>
										<input type="radio" id="pdf" name="generaRpt" value="pdf"  >
										<label> PDF </label><br>
										<input type="radio" id="excel" name="generaRpt" value="excel" >
										<label> Excel </label>	
									</td>
								</tr>
							</table>	
					</fieldset>
				</td>      
			</tr>			 
		</table>	
		<input type="hidden" id="tipoReporte" name="tipoReporte" class="submit" />
		<input type="hidden" id="tipoLista" name="tipoLista" />
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
	<tr>
		<td colspan="4">
			<table align="right" border='0'>
		<tr>
			<td align="right">
				<a id="ligaGenerar" href="/reporteBloqueoSaldos.htm" target="_blank" >  		 
				<input type="button" id="generar" name="generar" class="submit" tabIndex = "48" value="Generar" /></a>
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
<div id="elementoLista"></div>
</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>