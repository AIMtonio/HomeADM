<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
 <%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>   
<html>
<head> 

	<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script> 
	<script type="text/javascript" src="dwr/interface/operDispersionServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/solicitudCredServicio.js"></script>
	<script type="text/javascript" src="js/tesoreria/repDispOrdenPago.js"></script>  	
				
</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="repDispOrdenPagoBean">

<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Reporte Dispersi&oacute;n por Orden de Pago</legend>
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
									<input id="fechaInicio" name="fechaInicio" size="12" 
					         			tabindex="1" type="text"  esCalendario="true" />	
								</td>					
							</tr>
							<tr>			
								<td class="label">
									<label for="creditoID">Fecha de Fin: </label> 
								</td>
								<td>
									<input id="fechaFin" name="fechaFin" size="12" tabindex="2" type="text" esCalendario="true"/>				
								</td>	
							</tr>
							<tr>		
								<td>
									<label>Solicitud:</label>
								</td>
								<td>
									<input type="text" name="solicitudCreditoID" id="solicitudCreditoID" size="15" tabindex="3" />	 						
								</td>
							</tr>
							<tr>
								<td>
									<label>Estatus:</label> 
								</td>
								<td><select id="estatus" name="estatus"  tabindex="4" >
							         <option value="">TODOS</option>
							         <option value="G">GENERADA</option>
							         <option value="E">ENVIADA</option>
							         <option value="V">VENCIDO</option>
							         <option value="M">MODIFICADO</option>
							         <option value="C">CANCELADO</option>
							         <option value="O">EJECUTADO</option>
							         <option value="P">EN PROCESO</option>
							         <option value="R">PROGRAMADO</option>
							         </select>									 
								</td>
							</tr>
							<tr>
								<td>
									<label>Sucursal:</label>
								</td>
								<td>
					         		<input type="text" id="sucursalID" name="sucursalID" size="5"  tabindex="5" />
					         		<input id="nombreSucursal" name="nombreSucursal" path="nombreSucursal" size="50" readonly="true" disabled="disabled"/>
							    </td>
							</tr>				
			  			</table>
		  			</fieldset>
  				</td>  
				<td>
				<table width="120px"> 
							<tr>
								<td class="label" style="position:absolute;top:12%;">
								<fieldset class="ui-widget ui-widget-content ui-corner-all">                
								<legend><label>Presentaci&oacute;n</label></legend>
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
				<table  width="100%">
					
					<tr>
						<td>
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