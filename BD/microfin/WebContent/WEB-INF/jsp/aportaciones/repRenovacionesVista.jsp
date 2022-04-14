<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
 <%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>   
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/condicionesVencimServicio.js"></script>
   	 	<script type="text/javascript" src="js/aportaciones/repRenovaciones.js"></script>  
	</head>
<body> 
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="aportacionesBean">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Renovaciones</legend>
		<table border="0" cellpadding="0" cellspacing="0" width="600px">
			<tr> 
				<td> 
					<fieldset class="ui-widget ui-widget-content ui-corner-all">                
					<legend><label>Par&aacute;metros</label></legend>         
          				<table  border="0"  width="560px">
							<tr>			
								<td class="label">
									<label for="fechaInicial">Fecha Inicial: </label> 
								</td>
								<td>
									<input id="fechaInicial" name="fechaFinal"  size="12" tabindex="1" type="text" esCalendario="true"/>				
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
							         	<option value="R">RENOVADAS</option>
							         	<option value="N">NO RENOVADAS</option>
								      </select>   
							     </td>
							</tr>
							
							<tr>
								<td class="label"><label><s:message code="safilocale.cliente"/>: </label></td>
								<td>
									<input type="text" id="clienteID" name="clienteID"  size="10" tabindex="5" />
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
									<input type="radio" id="pdf" name="pdf" value="1" tabindex="6" />
									<label>PDF</label>
									<br>
									<input type="radio" id="excel" name="generaRpt" value="1" tabindex="6"/>
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