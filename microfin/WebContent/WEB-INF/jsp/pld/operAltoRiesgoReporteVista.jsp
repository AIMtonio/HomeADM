<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<link type="text/css" href="css/redmond/jquery-ui-1.8.13.custom.css" rel="stylesheet" />      
		<link rel="stylesheet" type="text/css" href="css/forma.css" media="all"  >   
     	<script type="text/javascript" src="dwr/engine.js"></script> 
      	<script type="text/javascript" src="dwr/util.js"></script>
      	<script type="text/javascript" src="js/forma.js"></script> 
	  	<script type="text/javascript" src="js/pld/opeAltoRiesgo.js"></script>
	</head>   
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="opeAltoRiesgo" target="_blank">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">                
					<legend class="ui-widget ui-widget-header ui-corner-all">Operación De Alto Riesgo</legend>
					<table border="0" cellpadding="0" cellspacing="0" width="100%">   
						<tr> 
		     				<td class="label"> 
		         				<label for="lblCuentaAhoID">Fecha Inicio: </label> 
				   			</td>
				   			<td>
				      			<form:input id="fechaInicio" name="fechaInicio"  path="fechaInicio" esCalendario="true"  size="13" tabindex="1"/>
				   			</td>
		         			<td class="separador"></td>
		 				</tr>
						<tr> 
		     				<td class="label"> 
		         				<label for="lblCuentaAhoID">Fecha Final: </label> 
				   			</td>
				   			<td>
				      			<input id="fechaFin" name="fechaFin"  path="fechaFin" esCalendario="true" size="13" tabindex="2"/>  
				   			</td>
		         			<td class="separador"></td>
		 				</tr> 
		 				<tr>
		 					<td class="label"> 
		         				<label for="lblCuentaAhoID">Sucursal: </label> 
				   			</td>
		 					<td>
		 						<select id="titulo" name="titulo" path="titulo" tabindex="3" >
									<option value="1">REFORMA</option>
						     		<option value="2">CENTRO</option>
							    	<option value="3">STA ROSA</option>
							    	<option value="4">XOXO</option>
									<option value="4">MONTOYA</option>
									<option value="6">ETLA</option>
									<option value="7">CENTRAL</option>
								</select>
							</td>
				 		</tr>
		 				<tr>
		 					<td class="label"> 
		         				<label for="lblCuentaAhoID">Proceso: </label> 
				   			</td>
		 					<td>
		 						<select id="tituloq" name="tituloq" path="tituloq" tabindex="4" >
									<option value="EI">Entrevista inicial</option>
							     	<option value="N/A">No aplica</option>
								   	<option value="VAP">Visita de acompa&ntilde;amiento</option>
								    <option value="VDP">Visita de seguimiento DPLD</option>
									<option value="VOC">Visita soli. por Oficial</option>
									<option value="VFF">Visita soli. por funcionario</option>
								</select>
							</td>
		 				</tr>
		 				<tr> 
		 					<td class="label"> 
		         				<label for="lblCuentaAhoID">Motivo: </label> 
				   			</td>
		 					<td>
		 						<select id="tituloq" name="tituloq" path="tituloq" tabindex="4">
									<option value="3SD">Actuacion por Cta de tercero </option>
						     		<option value="AEC">Operación extrañamente</option>
							   		<option value="DOC">Dudas en la autenticidad</option>
							    	<option value="EPT">Cambio de perfil transaccional</option>
									<option value="PPE">PEP Extranjero</option>
									<option value="PPN">PEP Nacional</option>
									<option value="RAP"><s:message code="safilocale.cliente"/> con Alto Riesgo Preexistente</option>
								</select>
							</td>
		 				</tr>
					</table>
					<table align="right">
						<tr>
							<td align="right">
       	 						<input type="submit" id="ver" name="ver" class="submit" value="Pantalla" />
       	 		 				<a id="enlace" href="RepConocimientoCtaPDF.htm" target="_blank">
       	 		 					<input type="hidden" id="botonAuxiliar" name="botonAuxiliar">
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