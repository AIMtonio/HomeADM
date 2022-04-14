<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
 <%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>   
<html>
	<head>        	 		   
      	<script type="text/javascript" src="js/tesoreria/cuentasSantanderVista.js"></script>  				
	</head>      
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="cuentasSantander">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend class="ui-widget ui-widget-header ui-corner-all">Alta Cuentas Disp. Santander</legend>
			
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>       
					<table  border="0"  width="100%">
						<tr>
							<td class="label">
								<label for="creditoID">Fecha de Inicio: </label>
							</td>
							<td >
								<input id="fechaInicio" name="fechaInicio" path="fechaInicio" size="12" type="text"  esCalendario="true" />	
							</td>					
						</tr>
						<tr>			
							<td class="label">
								<label for="creditoID">Fecha de Fin: </label> 
							</td>
							<td>
								<input id="fechaFin" name="fechaFin" path="fechaFin" size="12" type="text" esCalendario="true"/>				
							</td>	
						</tr>				
					</table>
			    </tr>	     
			</table><br>	
			<table border="0" cellpadding="0" cellspacing="0" width="100%">			
				<tr>
					<td colspan="5" align="right">
						<input type="submit" id="grabar" name="grabar" class="submit" value="Generar"/>
						<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="0"/>
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