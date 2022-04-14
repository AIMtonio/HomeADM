<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>   
  	    <script type="text/javascript" src="dwr/interface/parametrosSMSServicio.js"></script> 
		<script type="text/javascript" src="js/sms/parametrosSMS.js"></script>  
	</head>
<body>

<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="parametrosSMS">
<fieldset class="ui-widget ui-widget-content ui-corner-all">		
<legend class="ui-widget ui-widget-header ui-corner-all">Parámetros SMS</legend>			
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
	 	<tr>
	 		<td class="label">
				<label for="Telefono1">Módem 1: </label>
			</td> 
			<td >		
				<form:input type="text" id="numeroInstitu1" name="numeroInstitu1" tabindex="1" path="numeroInstitu1" size="15"/>
				
			</td>
			<td class="separador"></td>
			<td class="label">
				<label for="Telefono2">Módem 2: </label>
			</td> 
			<td >		
				<form:input type="text" id="numeroInstitu2" name="numeroInstitu2" tabindex="2" path="numeroInstitu2" size="15"/>
			</td>
		</tr>
	 	<tr>
	 		<td class="label">
				<label for="Telefono3">Módem 3: </label>
			</td> 
			<td >		
				<form:input type="text" id="numeroInstitu3" name="numeroInstitu3" tabindex="3" path="numeroInstitu3" size="15"/>
			</td>
	 		<td class="separador"></td>
			<td class="label">
				<label for="rutaMasivos">Ruta de Archivos: </label>
			</td>
			<td>
				<form:input id="rutaMasivos" name="rutaMasivos" path="rutaMasivos"    size="50"  tabindex="4"/> 
			</td>
		</tr>
		<tr>			
		
			<td class="label">
				<label for="numDigitosTel">No. Dígitos Celular: </label>
			</td>
			<td>
				<form:input id="numDigitosTel" name="numDigitosTel" path="numDigitosTel"    size="6" tabindex="5"/> 
			</td>
			<td class="separador"></td>
			<td class="label">
				<label for="numMsmEnv">No.MSG X Minuto: </label>
			</td>
			<td>
				<form:input id="numMsmEnv" name="numMsmEnv" path="numMsmEnv"    size="6" tabindex="6"/> 
			</td>
		</tr>
		<tr>			
			<td class="label"> 
				<label for="lblCoicidencia">Enviar SMS Plantilla no Existente: </label> 
			</td>   	
			<td>
				<form:input type="radio" id="enviarSiNoCoici" name="enviarSiNoCoici" path="enviarSiNoCoici" value="S" tabindex="7" />
				<label for="lblenviarSiNoCoici">Si</label>&nbsp&nbsp;
				<form:input type="radio"  id="enviarSiNoCoici1" name="enviarSiNoCoici" path="enviarSiNoCoici" value="N" tabindex="8"/>
				<label for="lblenviarSiNoCoici1">No</label>					
			</td>	
		</tr>
		
	</table>

		<table align="right">
			<tr>
				<td align="right">					
					 <input type="submit" id="modificar" name="modificar" class="submit" value="Modificar" tabindex="10"/>					 
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
	