<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	
		<head>	
			<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
			<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
	 		<script type="text/javascript" src="js/cliente/reporteClientesCancela.js"></script>		
		</head>
	<body>
			
			<div id="contenedorForma">
				<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="clientesCancelaBean">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">		
				<legend class="ui-widget ui-widget-header ui-corner-all">Pagos Cancelaci&oacute;n <s:message code="safilocale.cliente"/></legend>	
					<fieldset class="ui-widget ui-widget-content ui-corner-all">		
					<legend >Par&aacute;metros</legend>		
						<table border="0" cellpadding="0" cellspacing="0" width="100%">
							<tr>
							      <td class="label"> 
							         <label for="fechaInicio">Fecha Inicio: </label> 
							      </td>
							      <td>
							         <input type="text" id="fechaInicio" name="fechaInicio" size="12" autocomplete="off" esCalendario="true" tabindex="1" />  
							      </td> 
							      <td class="separador"></td> 	
						 	</tr> 
							<tr>
						      <td class="label"> 
						         <label for=""fechaFinal"">Fecha Final: </label> 
						    	</td>
						      <td>
						         <input type="text" id="fechaFin" name="fechaFin" autocomplete="off" esCalendario="true" size="12" tabindex="2" />    
						      </td> 
						      <td class="separador"></td> 
						 	</tr>
						 	<tr>
						      <td class="label"> 
						         <label for="clienteID"><s:message code="safilocale.cliente"/>: </label> 
						      </td>
						      <td>
						         <input type="text" id="clienteID" name="clienteID" size="12" tabindex="3" value="0"/> 
						          <input type="text" id="clienteIDDes" name="clienteIDDes" size="65" value="TODOS" readonly="true" disabled="true"/> 
						      </td> 
						      <td class="separador"></td>   
						 	</tr> 
						 	<tr id="trSucursal">
						      <td class="label"> 
						         <label for="sucursalID">Sucursal <s:message code="safilocale.cliente"/>: </label> 
						      </td>
						      <td>
						         <input type="text" id="sucursalID" name="sucursalID" size="12" tabindex="4" value="0"/> 
						          <input type="text" id="sucursalIDDes" name="sucursalIDDes" size="40" value="TODAS" readonly="true" disabled="true"/> 
						      </td> 
						      <td class="separador"></td>   
						 	</tr> 							 		
						 </table>	
				</fieldset>		
						 
					 <br>
							 
						<table align="right">
							<tr>
								<td>
									<a id="ligaGenerar" href="/reporteClientesCancela.htm" target="_blank" >  		 
										<input type="button" id="generar" name="generar" class="submit" tabIndex="8" value="Generar" />
									</a>
								</td>
							</tr>
						</table>	
					
					</form:form> 
				</fieldset>
			</div> 
			
			<div id="cargando" style="display: none;"></div>
			<div id="cajaLista" style="display: none;">
			<div id="elementoLista"/> </div>
	</body>
	<div id="mensaje" style="display: none;"/>
</html>