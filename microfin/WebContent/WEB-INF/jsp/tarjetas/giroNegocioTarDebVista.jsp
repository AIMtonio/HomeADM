<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<html>
<head>
<script type="text/javascript"	src="dwr/interface/tipoTarjetaDebServicio.js"></script>

<script type="text/javascript" src="dwr/interface/giroNegocioTarDebServicio.js"></script>
<script type="text/javascript"	src="js/tarjetas/giroNegocioTarDeb.js"></script> 

</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="giroNegocioTarDebBean">
<fieldset class="ui-widget ui-widget-content ui-corner-all">
<legend class="ui-widget ui-widget-header ui-corner-all">Giros de Negocio</legend>
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td class="label" ><label for="lblGiro">Número de Giro:</label>
			        </td >
			 		<td >
		       		 	<input type="text" id="giroID" name="giroID" path="giroID" size="20" tabindex="1" />
					
					</td >
					 <td class="separador"></td> 	
					<td   class="label">
					  	<label for="descripcion">Descripción: </label>
				   </td>
				
					<td>
						<input type="text" id="descripcion" name="descripcion" maxlength="200" onblur="ponerMayusculas(this)"  size="30" tabindex="2"    />	
					</td>
				</tr>
				<tr>
				<td class="label" ><label for="lblNombreCorto">Nombre Corto:</label>
			        </td >
			 		<td >
		       		 	<input type="text" id="nombreCorto" name="nombreCorto" maxlength="30" size="20" tabindex="3" onblur="ponerMayusculas(this)"  />
					</td>
				 <td class="separador"></td> 
					<td class="label">
			
					<label > Estatus: </label>
			    </td>
				<td >
					  <select id="estatus" name="estatus"  tabindex="4" >
					   <option value="">SELECCIONA</option>
					  <option value="A">ACTIVA</option>
					  <option value="C">CANCELADO</option>
					  </select>
				</td>
			</tr>
		</table>
		<table align="right">
			<tr>
				<td align="right">
					<input type="submit" id="agrega" name="agrega" class="submit" tabindex="5" value="Agregar"   /> 
					<input type="submit" id="modifica" name="modifica" class="submit" tabindex="6" value="Modificar"   /> 
					<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />							
				</td>
			</tr>
		</table>
</fieldset>
		
</form:form>
</div>
<div id="cargando" style="display: none;"></div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"></div>
</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>