<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>   
  	    <script type="text/javascript" src="dwr/interface/smsPlantillaServicio.js"></script>  
		<script type="text/javascript" src="js/sms/smsPlantilla.js"></script>  
	</head>
<body>

<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="smsPlantillaBean">
<fieldset class="ui-widget ui-widget-content ui-corner-all">		
<legend class="ui-widget ui-widget-header ui-corner-all">Registro de Plantillas</legend>			
	<table border="0" width="100%">
	 	<tr>
	 		<td class="label">
				<label for="Campania">Plantilla ID:</label>
			</td> 
			<td>		
				<form:input type="text" id="plantillaID" name="plantillaID" tabindex="1" path="plantillaID" size="3" autocomplete="off" maxlength="10"/>
			</td>
	
			<td class="label">
				<label for="lblRemitente">Nombre: </label>
			</td>
			<td>
				<form:input id="nombre" name="nombre" path="nombre" onblur="ponerMayusculas(this)" size="50" tabindex="2" autocomplete="off" maxlength="45"/> 
			</td>
		</tr>			
		<tr>
			<td class="label">
				<label for="diccionario">Diccionario: </label>
			</td>
			<td>
				<select id="idselect" name="clasificacion"  tabindex="3" onChange="poner_texto()">
				<option value="">SELECCIONAR</option>
				   <option value="&CL" >&CL = Cliente</option>	
				   	<option value="&CR" >&CR =  Crédito </option>				   				  
					<option value="&SU" >&SU = Sucursal </option>
					<option value="&CT">&CT = Cuenta </option>
					<option value="&SL">&SL = Solicitud de Crédito</option>
					<option value="&MC" >&MC = Monto de Crédito</option>
					<option value="&FPV">&FPV = Fecha Próximo Vencimiento</option>
					<option value="&SC" >&SC = Saldo Crédito</option>
					<option value="&MPV" >&MPV = Monto Próximo Vencimiento</option>
					<option value="&DA" >&DA = Dias Atraso</option>
				</select> 
			</td>					
		
			<td class="label">
				<label for="lblDestinatario">Descripción:</label>
			</td>
			<td>
				<form:textarea id="descripcion" name="descripcion" path="descripcion" onblur="ponerMayusculas(this)" tabindex="4" cols="40" rows="5" maxlength="1500" autocomplete="off"/> 
			</td>							
		</tr>
	</table>
		<table align="right">
			<tr>
				<td align="right">
					<input type="submit" id="guardar" name="guardar" class="submit" value="Guardar" tabindex="5"/>
					<input type="submit" id="modificar" name="modificar" class="submit" value="Modificar" tabindex="6"/>
					<input type="submit" id="eliminar" name="eliminar" class="submit" value="Eliminar" tabindex="7"/>
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








