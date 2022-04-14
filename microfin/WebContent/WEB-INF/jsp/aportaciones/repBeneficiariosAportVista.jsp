<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
 <%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>   
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/aportDispersionesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/tiposAportacionesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
   	 	<script type="text/javascript" src="js/aportaciones/aportDispersiones.js"></script>  
	</head>
<body> 
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="aportacionesBean">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Reporte de montos y beneficiarios a dispersar</legend>
		<table border="0" cellpadding="0" cellspacing="0" width="600px">
			<tr> 
				<td> 
					<fieldset class="ui-widget ui-widget-content ui-corner-all">                
					<legend><label>Par&aacute;metros</label></legend>         
          				<table  border="0"  width="100%">
							<tr>			
								<td class="label">
									<label for="fechaInicial">Fecha Inicial: </label> 
								</td>
								<td>
									<input id="fechaInicial" name="fechaInicial"  size="12" tabindex="1" type="text" esCalendario="true"/>				
								</td>	
							</tr>
							<tr>			
								<td class="label">
									<label for="fechaFinal">Fecha Final: </label> 
								</td>
								<td>
									<input id="fechaFinal" name="fechaFinal"  size="12" tabindex="1" type="text" esCalendario="true"/>				
								</td>	
							</tr>
						   	<tr>		
								<td class="label"> 
						        	<label for="estatus">Estatus: </label> 
							     </td> 	
							     <td nowrap= "nowrap">
							         <select id="estatus" name="estatus"  tabindex="2" >
							         	<option value="">TODOS</option>
							         	<option value="P">PENDIENTE</option>
							         	<option value="S">REGISTRADO</option>
							         	<option value="M">REGISTRADO CON MONTO PENDIENTE</option>
							         	<option value="C">CANCELADO</option>
							         	<option value="D">FINALIZADO</option>

								      </select>   
							     </td>
							</tr>
			
							<tr>
							<td><label>Producto:</label></td>
							<td><select name="productoID" id="productoID" tabindex="3"></select></td>
							</tr>
							
							<tr>
								<td class="label"><label><s:message code="safilocale.cliente"/>: </label></td>
								<td>
									<input type="text" id="clienteID" name="clienteID"  size="10" tabindex="5" />
									<input type="text" id="nombreCliente" name="nombreCliente"  size="40" readOnly="true"/>
								</td>
							</tr>
						</table>
					</fieldset>  
				</td>  	
				<td class="label" valign="top">
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend>
							<label>Presentaci&oacute;n</label>
						</legend>
						<input type="radio" id="excel" name="generaRpt" value="excel" tabindex="5" checked="checked"> <label> Excel </label>
					</fieldset>
				</td>
				
				</tr>	

				<table  width="100%">
				<tr>
					<td align="right">
						<input type="hidden" id="tipoReporte" name="tipoReporte" class="submit" />
						<input type="hidden" id="tipoLista" name="tipoLista" />
						<a id="ligaGenerar" target="_blank" >  		 
							 <input type="button" id="generar" name="generar" class="submit" 
									 tabIndex="7" value="Generar" />
						</a>
					</td>
				</tr>
				</table>	
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