<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	
		<head>	
			<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
			<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
			<script type="text/javascript" src="dwr/interface/clienteExMenorServicio.js"></script>			
	 		<script type="text/javascript" src="js/cliente/clienteExMenorReporte.js"></script>		
		</head>
	<body>
			
			<div id="contenedorForma">
				<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="clienteExmenorBean">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">		
				<legend class="ui-widget ui-widget-header ui-corner-all">Reporte Haberes de Ex-Menor</legend>	
					<fieldset class="ui-widget ui-widget-content ui-corner-all">		
					<legend ></legend>		
						<table border="0" cellpadding="0" cellspacing="0" width="100%">
							
						 	<tr>
						      <td class="label"> 
						         <label for="clienteID"><s:message code="safilocale.cliente"/>: </label> 
						      </td>
						      <td>
						        <form:input type="text" id="clienteID" name="clienteID" path="clienteID" size="12" tabindex="1"/>
						          <input type="text" id="clienteIDDes" name="clienteIDDes" size="65" readonly="true" /> 
						      </td> 
						      <td class="separador"></td>   
						 	</tr>						 						 		
						 </table>	
				</fieldset>		
						 
					 <br>
							 
						<table align="right">
							<tr>
								<td>
									<a id="ligaGenerar" href="/repExMenorCta.htm" target="_blank" >  		 
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