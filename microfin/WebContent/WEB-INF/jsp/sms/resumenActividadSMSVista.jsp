<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>

	<head>	
	  <script type="text/javascript" src="dwr/interface/tipoCampaniasServicio.js"></script>
	  <script type="text/javascript" src="dwr/interface/campaniasServicio.js"></script>
      <script type="text/javascript" src="js/sms/resumenActividad.js"></script> 
      
	</head>
<body>

<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="resumenActividadSMS">
<fieldset class="ui-widget ui-widget-content ui-corner-all">		
<legend class="ui-widget ui-widget-header ui-corner-all">Resumen de Actividad</legend>			
	<table >
	 	<tr>
	 		<td class="label">
				<label for="Campania">Número de Campa&ntilde;a: </label>
			</td> 
			<td >
				<form:input type="text" id="campaniaID" name="campaniaID" tabindex="1" path="campaniaID" size="15" maxlength="10"/>
				<input type= "text" id="nomCampania" name="nomCampania" tabindex="6"  size="32" disabled="true" /> 
			</td>
			<td class="separador"></td>
			<td class="label">
				<label for="lblClasificacion">Clasificación: </label>
			</td>
			<td >
				 <form:select id="clasificacion" name="clasificacion" path="clasificacion"  tabindex="3" disabled="true">
				   	<form:option value="E">ENTRADA</form:option>
				   	<form:option value="S">SALIDA</form:option>
					<form:option value="I">INTERACTIVA</form:option>
				</form:select>
			</td>		
	 	</tr>

		<tr>
			<td class="label">
				<label for="lblCategoria">Categoría:</label>
			</td>
			<td>
				 <select id="categoria" name="categoria"  tabindex="4" disabled="true" >
				   	<option value="A">AUTOMATICA</option>
				   	<option value="E">POR EVENTO</option>
					<option value="C">CAMPAÑA</option>
				</select>
			</td>		
			<td class="separador"></td>		
			<td class="label">
				<label for="lblTipo"> Tipo: </label>
			</td>
			<td >
				<form:input id="tipo" name="tipo" path="tipo" tabindex="5"  size="10" disabled="true"/>
				<input type= "text" id="nomTipo" name="nomTipo" tabindex="6"  size="32" disabled="true" />
			</td>
		</tr>
		
	 	<tr>
			<td colspan="7">
				<div id="gridResumenActividad" style="width: 560px; display: block;"/>	
				<div id="gridCodigosResp" style="width: 560px; display: block;"/>													
			</td>	
		</tr>
	</table>
	
			
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