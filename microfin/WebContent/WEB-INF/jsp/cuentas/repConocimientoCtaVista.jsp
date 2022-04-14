<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/conocimientoCtaServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script>
 	   	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
		<script type="text/javascript" src="js/cuentas/repConoCta.js"></script>
	</head>
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="ctasPersonaBean" target="_blank">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">                
					<legend class="ui-widget ui-widget-header ui-corner-all">Reporte de Conocimiento de Cuenta</legend>
					<table border="0" cellpadding="0" cellspacing="0" width="100%">   
						<tr> 
		     				<td class="label"> 
		         				<label for="lblCuentaAhoID">Cuenta: </label> 
				   			</td>
				   			<td>
				      			<form:input id="cuentaAhoID" name="cuentaAhoID"  path="cuentaAhoID" size="13" tabindex="1"/>  
				   			</td>  
		         			<td class="separador"></td> 				
						</tr> 			
						<tr>
							<td class="label"> 
		         				<label for="lblClienteID"><s:message code="safilocale.cliente"/>: </label> 
		     				</td> 
		     				<td> 
					         	<input id="clienteID" name="clienteID" size="11" tabindex="4" readOnly="true" disabled = "true"/>
		         				<input id="nombreCte" name="nombreCte"size="40" type="text" tabindex="5" readOnly="true" disabled = "true"/>
		     				</td>
		     				<td class="separador"></td> 
		     				<td class="label"> 
		         			<td class="label"> 
								<label for="tipoPersona">Tipo Persona: </label> 
							</td>
							<td class="label"> 
								<input type="text" id="descTipoPersona" name="descTipoPersona" readonly="true" size="22" />
								<input type="hidden" id="tipoPersona" name="tipoPersona" readonly="true"/>
							</td>			
		 				</tr> 
					</table>
					<table align="right">
						<tr>
							<td align="right">
       	 						<input type="submit" id="ver" name="ver" class="submit" value="Ver" style="display:none"/>
       	 		 				<a id="enlace" href="RepConocimientoCtaPDF.htm" target="_blank" >
		             				<button type="button" class="submit" id="pdf" >Ver</button>
	             				</a>
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