<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>

	<head>	
	  <script type="text/javascript" src="dwr/interface/campaniasServicio.js"></script>
	  <script type="text/javascript" src="dwr/interface/tipoCampaniasServicio.js"></script>
      <script type="text/javascript" src="js/sms/tiposCampania.js"></script> 
      
	</head>
<body>

<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="smsTiposCampaniasBean">
<fieldset class="ui-widget ui-widget-content ui-corner-all">		
<legend class="ui-widget ui-widget-header ui-corner-all">Alta de Tipos de Campa&ntilde;as</legend>			
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
	 	<tr>
	 		<td class="label">
				<label for="Campania">Número: </label>
			</td> 
			<td >				
				<form:input id="tipoCampaniaID" name="tipoCampaniaID" tabindex="1" path="tipoCampaniaID" size="6" autocomplete="off" maxlength="10"/> 
				 
			</td>
			<td class="separador"></td>
			<td class="label">
				<label for="nombre">Nombre:</label>
			</td>
			<td>				
				<form:textarea id="nombre" name="nombre" path="nombre" COLS="35" ROWS="3" tabindex="2" onBlur=" ponerMayusculas(this)" autocomplete="off" maxlength="50"/>
			</td>				
	 	</tr>
	 	<tr>
			<td class="label">
				<label for="lblClasificacion">Clasificación: </label>
			</td>
			<td >
				 <form:select id="clasificacion" name="clasificacion" path="clasificacion"  tabindex="3" type="select">
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
				 <form:select id="categoria" name="categoria" path="categoria"  tabindex="4" type="select">
				  	<form:option value="">SELECCIONAR</form:option>
				</form:select>
			</td>
		</tr>
		
	</table>
		<br></br>  <br></br> <tr></tr>
		<table align="right">
			<tr>
				<td align="right">
					<input type="submit" id="agregar" name="agregar" class="submit" value="Agregar" tabindex="6"/>
					<input type="submit" id="modificar" name="modificar" class="submit" value="Modificar" tabindex="7"/>
					<input type="submit" id="eliminar" name="eliminar" class="submit" value="Eliminar" tabindex="8"/>						
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
</div>
</body>
<div id="mensaje" style="display: none;"/>
</html>