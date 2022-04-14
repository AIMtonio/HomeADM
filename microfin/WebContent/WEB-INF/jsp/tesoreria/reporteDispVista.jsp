<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
 <%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>   
<html>
<head> 
	<script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script> 
	<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script> 
	<script type="text/javascript" src="dwr/interface/operDispersionServicio.js"></script> 
	<script type="text/javascript" src="dwr/interface/cuentaNostroServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/paramGeneralesServicio.js"></script>
	<script type="text/javascript" src="js/tesoreria/reporteDispersion.js"></script>  	
				
</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="dispBean">

<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Reporte de Dispersi&oacute;n</legend>
			<table border="0" width="100%">
			 <tr>
			 	<td> 
					<fieldset class="ui-widget ui-widget-content ui-corner-all">                
					<legend><label>Parámetros</label></legend>         
			          	<table  border="0"  width="100%">
							<tr>
								<td class="label">
									<label for="creditoID">Fecha de Inicio: </label>
								</td>
								<td >
									<input id="fechaInicio" name="fechaInicio" path="fechaInicio" size="12" 
					         			tabindex="1" type="text"  esCalendario="true" />	
								</td>					
							</tr>
							<tr>			
								<td class="label">
									<label for="creditoID">Fecha de Fin: </label> 
								</td>
								<td>
									<input id="fechaFin" name="fechaFin" path="fechaFin" size="12" tabindex="2" type="text" esCalendario="true"/>				
								</td>	
							</tr>
							<tr>
								<td>
									<label>Estatus Dispersi&oacute;n:</label> 
								</td>
								<td><select id="estatusEnc" name="estatusEnc" path="estatusEnc"  tabindex="3" >
							         <option value="T">TODOS</option>
							         <option value="A">ABIERTAS</option>
							         <option value="C">CERRADAS</option>
							         </select>									 
								</td>
							</tr>
							<tr>
								<td>
									<label>Estatus Movimientos:</label> 
								</td>
								<td><select id="estatusDet" name="estatusDet" path="estatusDet"  tabindex="4" >
							         <option value="T">TODOS</option>
							         <option value="P">PENDIENTE</option>
							         <option value="A">AUTORIZADA</option>
							         </select>									 
								</td>
							</tr>
							<tr id="formaPagoTR">
								<td>
									<label>Forma de Pago:</label>
								</td>
								<td>
									<select id="formaPago" name="formaPago" path="formaPAgo"  tabindex="5" >
							         <option value="0">TODOS</option>
							         <option value="1">SPEI</option>
							         <option value="2">CHEQUE</option>
							         <option value="3">BANCA ELECTRONICA</option>
							         <option value="4">TARJETA EMPRESARIAL</option>
							         <option value="5">ORDEN DE PAGO</option>
							         <option value="6">TRANS. SANTANDER</option>
							         </select>
								</td>
							</tr>
							<tr>		
								<td>
									<label>Instituci&oacute;n:</label>
								</td>
								<td>
									<input type="text" name="institucionID" id="institucionID" size="11" path="institucionID" tabindex="6" />	 						
									<input type="text" name="nombreInstitucion" id="nombreInstitucion" size="50" disabled="true" path="nombreInstitucion" tabindex="5" />	 
								</td>
							</tr>
							<tr>		
								<td>
									<label>Cuenta Bancaria:</label>
								</td>
								<td>
									<input type="text" name="cuentaAhorro" id="cuentaAhorro" size="12" path="cuentaAhorro" tabindex="7" />	 						
									<input type="text" name="nombreSucurs" id="nombreSucurs" size="50" disabled="true" path="nombreSucurs" tabindex="6" />	 
								</td>
							</tr> 
							<tr>
								<td>
									<label>Sucursal:</label>
								</td>
								<td><select id="sucursal" name="sucursal" path="sucursal" tabindex="8" >
							         <option value="0">TODAS</option>
								      </select>									 
								</td>
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
										<input type="radio" id="pdf" name="generaRpt" value="pdf" />
										<label> PDF </label>
							            <br>
										<input type="radio" id="pantalla" name="generaRpt" value="pantalla">
										<label> Pantalla </label>
										<br>
										<input type="radio" id="excel" name="generaRpt" value="excel">
										<label> Excel </label>
									</fieldset>
								</td>      
								</tr>
				</table> </td>
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
								
									<a id="ligaGenerar" href="reporteOperDispersion.htm" target="_blank" >  		 
										 <input type="button" id="generar" name="generar" class="submit" 
												 tabIndex = "48" value="Generar" />
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