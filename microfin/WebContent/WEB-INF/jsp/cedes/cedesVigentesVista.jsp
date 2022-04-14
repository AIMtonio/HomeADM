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
   	 	<script type="text/javascript" src="js/cedes/cedesVigentes.js"></script>  
	</head>
<body> 
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="clienteBean">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Reporte CEDES Vigentes</legend>
		<table border="0" cellpadding="0" cellspacing="0" width="600px">
			<tr> 
				<td> 
					<fieldset class="ui-widget ui-widget-content ui-corner-all">                
					<legend><label>Parámetros</label></legend>         
          				<table  border="0"  width="560px">
							<tr>			
								<td class="label">
									<label for="fechaReporte">Fecha: </label> 
								</td>
								<td>
									<input id="fechaReporte" name="fechaReporte"  size="12" tabindex="1" type="text" esCalendario="true"/>				
								</td>	
							</tr>
						   	<tr>		
								<td class="label"> 
						        	<label for="tiposCedes">Tipo CEDE: </label> 
							     </td> 	
							     <td nowrap= "nowrap">
							         <select id="tiposCedes" name="tiposCedes"  tabindex="2" >
							         	<option value="0">TODOS</option>
								      </select>   
							     </td>
							</tr>
							<tr>
								<td class="label"><label>Promotor: </label></td>
								<td> 
							        <input type="text" id="promotorID" name="promotorID"  size="10" tabindex="3" maxlength="9" />
									<input type="text" id="nombrePromotor" name="nombrePromotor"  size="50" readOnly="true"/>   
							     </td>
							</tr>
							<tr>
								<td class="label"> 
						        	<label for="sucursalID">Sucursal: </label> 
							     </td> 	
							     <td nowrap= "nowrap">
							         <select id="sucursalID" name="sucursalID"  tabindex="4" >
							         	<option value="0">TODAS</option>
								      </select>   
							     </td>
							</tr>
							<tr>
								<td class="label"><label><s:message code="safilocale.cliente"/>: </label></td>
								<td>
									<input type="text" id="clienteID" name="clienteID"  size="10" tabindex="5" maxlength="9" />
									<input type="text" id="nombreCliente" name="nombreCliente"  size="50" readOnly="true"/>
								</td>
							</tr>
						</table>
					</fieldset>  
				</td>  	
				
				</tr>	
				
				<table width="200px" style="height: 100%" border ="0"> 
						<tr>
							<td >
								<fieldset class="ui-widget ui-widget-content ui-corner-all">                
									<legend><label>Presentaci&oacute;n</label></legend>
									<input type="radio" id="pdf" name="pdf" value="1" tabindex="6" checked/>
									<label>PDF</label>
									<br>
									<input type="radio" id="excel" name="generaRpt" value="1" tabindex="6" checked/>
									<label>Excel</label>
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