<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>

	<head>	
	  <script type="text/javascript" src="dwr/interface/campaniasServicio.js"></script>
	  <script type="text/javascript" src="dwr/interface/tipoCampaniasServicio.js"></script>
	  <script type="text/javascript" src="dwr/interface/smsPlantillaServicio.js"></script>  
      <script type="text/javascript" src="js/sms/campanias.js"></script>       
	</head>
<body>

<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="smsCapaniasBean">
<fieldset class="ui-widget ui-widget-content ui-corner-all">		
<legend class="ui-widget ui-widget-header ui-corner-all">Alta de Campa&ntilde;as</legend>			
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
	 	<tr>
	 		<td class="label">
				<label for="Campania">Número de Campa&ntilde;a: </label>
			</td> 
			<td >
				
				<form:input type="text" id="campaniaID" name="campaniaID" tabindex="1" path="campaniaID" size="6" autocomplete="off" maxlength="10" /> 
				 <a href="javaScript:" onClick="ayudaCR();">
				  	<img src="images/help-icon.gif" >
				</a>
			</td>
			<td class="separador"></td>
			<td class="label">
				<label for="nombre">Nombre:</label>
			</td>
			<td>				
				<form:textarea id="nombre" name="nombre" path="nombre" COLS="40" ROWS="1" tabindex="2"  onBlur="ponerMayusculas(this)" autocomplete="off" maxlength="50"/>
			</td>				
	 	</tr>
	 	<tr>
	 		<td class="label">
				<label for="lblTipo"> Tipo: </label>
			</td>
			<td >
				<form:input id="tipo" name="tipo" path="tipo" tabindex="3"  size="8" autocomplete="off" maxlength="10"/>
				<input type= "text" id="nomTipo" name="nomTipo" tabindex="4"  size="40" disabled="true" />
			</td>
		</tr>
		
		<tr>
			<td class="label">
				<label for="lblClasificacion">Clasificación: </label>
			</td>
			<td >
				 <form:select id="clasificacion" name="clasificacion" path="clasificacion"  tabindex="5" disabled="true" >
				 	<form:option value="">SELECCIONAR</form:option>
				   	<form:option value="E">ENTRADA</form:option>
				   	<form:option value="S">SALIDA</form:option>
					<form:option value="I">INTERACTIVA</form:option>
				</form:select>
			</td>
			<td class="separador"></td>
			
			<td class="label">
				<label for="lblCategoria">Categoría:</label>
			</td>
			<td>
				 <form:select id="categoria" name="categoria" path="categoria"  tabindex="6" disabled="true" >
					<form:option value="">SELECCIONAR</form:option>
				   	<form:option value="A">AUTOMATICA</form:option>
				   	<form:option value="E">POR EVENTO</form:option>
					<form:option value="C">CAMPAÑA</form:option>
				</form:select>
			</td>
			
		</tr>			
		<tr>			
			<td class="label">
				<label for="lblTipo"> Fecha Límite de Respuesta: </label>
			</td>
			<td >
				<form:input id="fechaLimiteRes" name="fechaLimiteRes" path="fechaLimiteRes" tabindex="7"  size="15" esCalendario="true" autocomplete="off"/>
			</td>	
			
			<td class="separador"></td>
			<td class="label">
				<label id= "msg" for="nombre" style="display: none;">Mensaje Recepción:</label>
			</td>
			<td>			
				<form:textarea type="hidden" id="msgRecepcion"  name="msgRecepcion" path="msgRecepcion" COLS="40" ROWS="1" tabindex="8"  onBlur=" ponerMayusculas(this)" style="display: none;" autocomplete="off" maxlength="50"/>
			</td>				
		</tr>		 		
		 <tr>			
			<td class="label">
				<label for="plantillaID" style="display: none;" id="plantilla">Plantilla:</label>
			</td>
			<td>
				 <form:select  id="plantillaID" name="plantillaID" path="plantillaID" tabindex="9" type="select" style="display: none;">
					<form:option value=" ">SELECCIONAR</form:option>
				</form:select> 												   
			</td>							
		</tr>		
			<input type="hidden" id="codigosRespuesta" name="codigosRespuesta" size="100" />	
		<tr>
			<td colspan="7">
				<div id="gridCodigosResp" style="display: none;"/>							
			</td>	
		</tr>
		
	</table>

		<table align="right">
			<tr>
				<td align="right">
					<input type="submit" id="agregar" name="agregar" class="submit" value="Agregar" tabindex="20"/>
					 <input type="submit" id="modificar" name="modificar" class="submit" value="Modificar" tabindex="21"/>
					 <input type="submit" id="eliminar" name="eliminar" class="submit" value="Eliminar" tabindex="22"/>  
					<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
				</td>
			</tr>
		</table>	 
</form:form> 
</div> 
<div id="cargando" style="display: none;">	
</div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"/>
	<div id="ContenedorAyuda" style="display: none;">
</div>
</body>
<div id="mensaje" style="display: none;"/>
</html>