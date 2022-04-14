<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
 <%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>   
<html>
	<head>
      
     <script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>  
   	 <script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
     <script type="text/javascript" src="dwr/interface/promotoresServicio.js"></script> 
   	 <script type="text/javascript" src="js/cliente/repSeguroCliente.js"></script>  
	</head>
      
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="clienteBean">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Seguro <s:message code="safilocale.cliente"/></legend>
		<table border="0" cellpadding="0" cellspacing="0" width="600px">
			<tr> 
				<td> 
					<fieldset class="ui-widget ui-widget-content ui-corner-all">                
					<legend><label>Parámetros</label></legend>         
          				<table  border="0"  width="560px">
							<tr>
								<td class="label">
									<label for="creditoID">Fecha de Inicio: </label>
								</td>
								<td >
									<input id="fechaInicio" name="fechaInicio"  size="12" 
					         			tabindex="1" type="text"  esCalendario="true" />	
								</td>					
							</tr>
							<tr>			
								<td class="label">
									<label for="creditoID">Fecha de Fin: </label> 
								</td>
								<td>
									<input id="fechaFin" name="fechaFin"  size="12" 
					         			tabindex="2" type="text" esCalendario="true"/>				
								</td>	
							</tr>
						   	<tr>		
								<td class="label"> 
						        	<label for="clientelb"><s:message code="safilocale.cliente"/>: </label> 
							     </td> 	
							     <td nowrap= "nowrap"> 
							         <input id="clienteID" name="clienteID"  size="11" tabindex="3" /> 
							         <input type="text" id="nombreCliente" name="nombreCliente" size="39"  tabindex="4"
							           readOnly="true"/>   
							     </td> 					
							</tr>
							<tr>
								<td>
									<label>Sucursal:</label>
								</td>
								<td><select id="sucursal" name="sucursal"  tabindex="5" >
							         <option value="Todos ">Todas</option>
								      </select>									 
								</td>
							<tr>
								<td class="label">
									<label for="promotorInicial">Promotor:</label>
								</td>
								<td nowrap= "nowrap">
									<input id="promotorID" name="promotorID"  tabindex="6" 	size="11"/>
									<input type="text"id="nombrePromotorI" name="nombrePromotorI" size="39" tabindex="7"   />
								</td>
				        	</tr>		
					        <tr>
								<td class="label">
									<label for="estatus"> Estatus:</label>
								</td>
								<td>
									<form:select id="estatus" name="estatus" path="estatus" tabindex="8">
									<form:option value="">Todos</form:option>
									<form:option value="C">Cobrado</form:option>
							     	<form:option value="V">Vigente</form:option>
									</form:select>
								</td>		
								
							</tr>
						</table>
					</fieldset>  
				</td>  
      			
				<td> 
					<table width="200px" style="height: 100%" border ="0"> 
						<tr>
							<td >
								<fieldset class="ui-widget ui-widget-content ui-corner-all">                
									<legend><label>Presentaci&oacute;n</label></legend>
									<input type="radio" id="pdf" name="generaRpt" value="pdf" />
									<label> PDF </label>
				            		<br>
								</fieldset>
							</td>      
						</tr>
						<tr>
							<td class="label" id="tdPresenacion" ">
							<br>
							<br>
							<br>
							<br>
							</td>  
						</tr> 
						<tr>
							<td align="right">
								<input type="hidden" id="tipoReporte" name="tipoReporte" class="submit" />
								<input type="hidden" id="tipoLista" name="tipoLista" />
								<a id="ligaGenerar" href="/repSeguroCliente.htm" target="_blank" >  		 
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