<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>   
<html>
	<head>
     	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>  
     	<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
     	<script type="text/javascript" src="dwr/interface/promotoresServicio.js"></script>
     	<script type="text/javascript" src="dwr/interface/tiposCedesServicio.js"></script> 
   	 	<script type="text/javascript" src="js/cedes/cedesPorAutorizar.js"></script>  
	</head> 
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="cedesBean">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Reporte CEDES Por Autorizar</legend>
		<table border="0" width="600px">
			<tr> 
				<td> 
					<fieldset class="ui-widget ui-widget-content ui-corner-all">                
					<legend><label>Par&aacute;metros</label></legend>         
          				<table  border="0"  width="560px">
							<tr>			
								<td class="label">
									<label for="fechaReporte">Fecha: </label> 
								</td>
								<td>
									<input id="fechaReporte" name="fechaReporte"  size="10" tabindex="1" type="text" esCalendario="true" readOnly="true"/>				
								</td>
							</tr>
						   	<tr>		
								<td class="label"> 
						        	<label for="tiposCedes">Tipo CEDE: </label> 
							    </td> 	
								<td nowrap="nowrap">
									<form:input id="tipoCedeID" name="tipoCedeID" path="tipoCedeID" tabIndex = "2" type="text" size="10" maxlength="11" autocomplete="off" />
									<input type="text" id="descripcion" name="descripcion"  size="50" readonly="true"/>
								</td>
							</tr>
							<tr>
								<td class="label"><label>Promotor: </label></td>
								<td> 
							        <input type="text" id="promotorID" name="promotorID"  size="10" tabindex="3" type="text"/>
									<input type="text" id="nombrePromotor" name="nombrePromotor"  size="50" readOnly="true"/>   
							    </td>
							</tr>
							<tr>
								<td class="label"> 
						        	<label for="sucursalID">Sucursal: </label> 
							    </td>
								<td>
									<input id="sucursalID" name="sucursalID" size="10" tabindex="4" type="text"/>
									<input type="text" id="nombreSucursal" name="nombreSucursal" size="50" readOnly="true" />	   										 
								</td>
							</tr>
							<tr>
								<td class="label"><label><s:message code="safilocale.cliente"/>: </label></td>
								<td>
									<input type="text" id="clienteID" name="clienteID"  size="10" tabindex="5" type="text"/>
									<input type="text" id="nombreCliente" name="nombreCliente"  size="50" readOnly="true"/>
								</td>
							</tr>
						</table>
					</fieldset>  
				</td>  	
				
				</tr>	
				
				<table width="200px" style="height: 100%" border ="0"> 
						<tr>
							<td>
								<fieldset class="ui-widget ui-widget-content ui-corner-all">                
									<legend><label>Presentaci&oacute;n</label></legend>
									<input type="radio" id="pdf" name="tipoReporte" value="1" tabindex="6" checked/>
									<label for="pdf">PDF</label>
									<br>
									<input type="radio" id="excel" name="tipoReporte" value="2" tabindex="7"/>
									<label for="excel">Excel</label>
				            		<br>
								</fieldset>
								<input type="hidden" name="reporte" id="reporte" />
								<input type="hidden" name="lista" id="lista" />
							</td>      
						</tr>	
				</table>
				<table  width="595px">
					<tr>
						<td align="right">
							<input type="button" id="generar" name="generar" class="submit" tabIndex="8" value="Generar" />
							<input type="hidden" id="socioCliente" name="socioCliente" value="<s:message code="safilocale.cliente"/>" />
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