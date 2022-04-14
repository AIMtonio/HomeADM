<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>	     
 		<script type="text/javascript" src="dwr/interface/inflacionProyecServicio.js"></script>
 		<script type="text/javascript" src="js/tesoreria/inflacionProyectada.js"></script>
	</head>
	<body>
	<div id="contenedorForma">
		<fieldset class="ui-widget ui-widget-content ui-corner-all">                
			<legend class="ui-widget ui-widget-header ui-corner-all">Inflación Anual Proyectada a 12 Meses</legend>
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="inflacionProyec">         
 				<table border="0" cellpadding="0" cellspacing="0" width="100%">     
					<tr>
						<td class="label"> 
							<label for="valorGatHis">Valor Histórico: </label> 
						</td>
					    <td> 
							<form:input type="text"  id="valorGatHis" name="valorGatHis" path="valorGatHis" readOnly="true" size="12" tabindex="15" maxlength="5"/>							
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="valorGatAct">Valor Actual: </label> 
						</td>    	 
						<td>
							<form:input type="text" id="valorGatAct" name="valorGatAct" path="valorGatAct"  size="12" tabindex="16" maxlength="5"/> 			
						</td>
						
					</tr>  						 
										    				    			     							
				</table>
               	<br>
				<table border="0" cellpadding="0" cellspacing="0" width="100%" align="right">  
					<tr>
						<td align="right">
					    	<input type="submit" id="actualiza" name="actualizar" class="submit" value="Actualizar" tabindex="17"/>							
							<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
						</td>
					</tr>
				</table>
		 	</form:form> 
		</fieldset>
	</div>
	<div id="cargando" style="display: none;">	
	</div>
	<div id="cajaLista" style="display: none;">
		<div id="elementoLista"></div>
	</div>
	<div id="mensaje" style="display: none;"> </div>
	<div id="ContenedorAyuda" style="display: none;">
		<div id="elementoLista"/>
	</div>	
	</body>
</html>