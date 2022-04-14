<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>   
  	    <script type="text/javascript" src="dwr/interface/estimacionPreventivaServicio.js"></script>  
		<script type="text/javascript" src="js/credito/estimacionPreventiva.js"></script>  
	</head>
<body>

<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="estimacionPreventivaBean">
<fieldset class="ui-widget ui-widget-content ui-corner-all">		
<legend class="ui-widget ui-widget-header ui-corner-all">Generación de Estimación Preventiva</legend>			
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
	 	<tr>
	 		<td class="label">
				<label for="lblFecha">Fecha: </label>
			</td> 
			<td>		
				<form:input type="text" id="fechaCorte" name="fechaCorte" tabindex="1" path="fechaCorte" size="15" esCalendario= "true"/>
			</td>
		</tr>
		<tr>
			<td class="label">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend><label>Aplicación Contable</label></legend>
					<form:input type="radio" id="aplicacionContable" name="aplicacionContable" path="aplicacionContable" value="S" /><label for="lblAplicaSi">Si</label>
					<form:input type="radio" id="aplicacionContable" name="aplicacionContable" path="aplicacionContable" value="N" checked="true"/><label for="lblAplicaNo">No</label>
				</fieldset>
			</td>	
		</tr>
	</table>
	<table align="right">
		<tr>
			<td align="right">
				<input type="submit" id="generar" name="generar" class="submit" value="Generar" tabindex="6"/>
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