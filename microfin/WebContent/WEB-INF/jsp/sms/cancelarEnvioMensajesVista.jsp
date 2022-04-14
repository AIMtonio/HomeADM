<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>

	<head>	
	  <script type="text/javascript" src="dwr/interface/campaniasServicio.js"></script>
	  <script type="text/javascript" src="dwr/interface/tipoCampaniasServicio.js"></script>
      <script type="text/javascript" src="js/sms/cancelaEnvio.js"></script> 
      
	</head>
<body>

<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="smsEnvioMensajeBean">
<fieldset class="ui-widget ui-widget-content ui-corner-all">		
<legend class="ui-widget ui-widget-header ui-corner-all">Cancelar Envío de Mensajes</legend>			
	<table>
	 	<tr>
	 		<td class="label">
				<label for="Campania">Número de Campa&ntilde;a: </label>
			</td> 
			<td >
				
				<form:input type="text" id="campaniaID" name="campaniaID" tabindex="1" path="campaniaID" size="10"
				maxlength="10"/> 
				<input type="text" id="nombre" name="nomCampania" tabindex="2" size="45" disabled="true" />
			</td>
			<td class="separador"></td>
						
	 	</tr>
	 	<tr>
			<td class="label">
				<label for="lblClasificacion">Clasificación: </label>
			</td>
			<td >
				 <select id="clasificacion" name="clasificacion" tabindex="3" disabled = "true" >
				   	<option value="E">ENTRADA</option>
				   	<option value="S">SALIDA</option>
					<option value="I">INTERACTIVA</option>
				</select>
			</td>
			<td class="separador"></td>
			<td class="label">
				<label for="lblCategoria">Categoría:</label>
			</td>
			<td>
				 <select id="categoria" name="categoria"  tabindex="4" disabled = "true"  >
				   	<option value="A">AUTOMATICA</option>
				   	<option value="E">POR EVENTO</option>
					<option value="C">CAMPAÑA</option>
				</select>
			</td>	
		</tr>
		
		<tr>
			<td class="label">
				<label for="lblTipo"> Tipo: </label>
			</td>
			<td >
				<input type="text" id="tipo" name="tipo"  tabindex="5"  size="10" disabled="true" maxlength="10" />
				<input type= "text" id="nomTipo" name="nomTipo" tabindex="6"  size="45" disabled="true" />
			</td>
			<td class="separador"></td>
			<td class="label">
				<label for="lblEstatus"> Estatus: </label>
			</td>
			<td>
				<input type= "text" id="estatus" name="estatus"  tabindex="7"  size="12" disabled="true" />
			</td>
		</tr>
		<tr>
			<td class="label">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">                
				<legend><label>Opcion de Cancelación:</label></legend>
					<form:input type="radio" id="soloMensajes" name="soloMensajes" path="msjenviar" value="1" tabindex="8" />
					<label> Solo Mensajes </label>	<br>
						<form:input type="radio" id="Ambos" name="Ambos" path="msjenviar" value="2" tabindex="9" />
					<label> Mensajes y Campaña </label>	
				</fieldset>
			</td>
		</tr>
	</table>
	
		<table align="right">
			<tr>
				<td align="right">
					<input type="submit" id="cancelar" name="cancelar" class="submit" value="Cancelar" tabindex="6"/>
					<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
					<form:input  type="hidden" id="fechaCancelacion" name="fechaCancelacion" path="fechaRealEnvio"  />
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