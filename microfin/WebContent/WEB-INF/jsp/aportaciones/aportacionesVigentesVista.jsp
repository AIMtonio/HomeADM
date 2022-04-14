<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
 <%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>   
<html>
	<head>
     	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>  
     	<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
     	<script type="text/javascript" src="dwr/interface/promotoresServicio.js"></script>
     	<script type="text/javascript" src="dwr/interface/tiposAportacionesServicio.js"></script> 
   	 	<script type="text/javascript" src="js/aportaciones/aportacionesVigentes.js"></script>  
	</head>
<body> 
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="clienteBean">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Reporte Aportaciones</legend>
		<table border="0" cellpadding="0" cellspacing="0" width="600px">
			<tr> 
				<td> 
					<fieldset class="ui-widget ui-widget-content ui-corner-all">                
					<legend><label>Par&aacute;metros</label></legend>         
          				<table  border="0"  width="560px">
							
							<!-- TIPO REPORTE -->
							<tr>		
								<td class="label"> 
						        	<label for="tipoReporte">Tipo Reporte: </label> 
							     </td> 	
							     <td nowrap= "nowrap">
							         <select id="tipoReporte" name="tipoReporte"  tabindex="1" >
							         	<option value="1">FECHA CORTE</option>
							         	<option value="2">PERIODO</option>
								      </select>   
							     </td>
							</tr>
							
							<!-- FECHA REPORTE -->
							<tr id="trFechaReporte">			
								<td class="label">
									<label id="lblFechaReporte" for="fechaReporte">Fecha: </label> 
								</td>
								<td>
									<input id="fechaReporte" name="fechaReporte"  size="12" tabindex="2" type="text" esCalendario="true"/>	
								</td>	
							</tr>
							
							<!-- FECHA FIN -->
							<tr id="trFechaFin">			
								<td class="label">
									<label for="fechaFin">Fecha Fin: </label> 
								</td>
								<td>
									<input id="fechaFin" name="fechaFin"  size="12" tabindex="4" type="text" esCalendario="true"/>	
								</td>	
							</tr>
							
							<!-- ESTATUS -->
							<tr>		
								<td class="label"> 
						        	<label for="estatus">Estatus: </label> 
							     </td> 	
							     <td nowrap= "nowrap">
							         <select id="estatus" name="estatus"  tabindex="5" >
							         	<option value="T">TODOS</option>
							         	<option value="N">VIGENTE</option>
							         	<option value="P">PAGADO</option>
							         	<option value="C">CANCELADO</option>
							         	<option value="V">PREVENCIDO</option>
								      </select>   
							     </td>
							</tr>
							
							<!-- TIPO APORTACIÓN -->
						   	<tr>		
								<td class="label"> 
						        	<label for="tiposAportaciones">Tipo Aportaci&oacute;n: </label> 
							     </td> 	
							     <td nowrap= "nowrap">
							         <select id="tiposAportaciones" name="tiposAportaciones"  tabindex="6" >
							         	<option value="0">TODOS</option>
								      </select>   
							     </td>
							</tr>
							<tr>
								<td class="label"><label>Promotor: </label></td>
								<td> 
							        <input type="text" id="promotorID" name="promotorID"  size="10" tabindex="7" maxlength="9" /> 
									<input type="text" id="nombrePromotor" name="nombrePromotor"  size="40" readOnly="true"/>   
							     </td>
							</tr>
							<tr>
								<td class="label"> 
						        	<label for="sucursalID">Sucursal: </label> 
							     </td> 	
							     <td nowrap= "nowrap">
							         <select id="sucursalID" name="sucursalID"  tabindex="8" >
							         	<option value="0">TODAS</option>
								      </select>   
							     </td>
							</tr>
							<tr>
								<td class="label"><label><s:message code="safilocale.cliente"/>: </label></td>
								<td>
									<input type="text" id="clienteID" name="clienteID"  size="10" tabindex="9" /> 
									<input type="text" id="nombreCliente" name="nombreCliente"  size="40" readOnly="true"/>
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