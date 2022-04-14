<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
 <%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>   
<html>
	<head>        	 		   
      	<script type="text/javascript" src="js/tesoreria/resCuentasSantanderVista.js"></script>  				
	</head>      
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="cuentasSantander">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend class="ui-widget ui-widget-header ui-corner-all">Respuesta Alta de Cuentas Santander</legend>
			
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>       
					<table  border="0"  width="100%">
						<tr>
							<td class="label">
								<label for="creditoID">Archivo Ctas. Activas: </label>
							</td>
							<td >
								<input id="rutaArchCtasActivas" name="rutaArchCtasActivas" path="rutaArchCtasActivas" size="60" type="text" readonly/>	
								<input type="button" id="subirCtasActivas" name="subirCtasActivas" class="submit" value="Adjuntar" />
							</td>					
						</tr>
						<tr>			
							<td class="label">
								<label for="creditoID">Archivo Ctas. Pendientes: </label> 
							</td>
							<td>
								<input id="rutaArchCtasPendientes" name="rutaArchCtasPendientes" path="rutaArchCtasPendientes" size="60" type="text" readonly/>	
								<input type="button" id="subirCtasPendientes" name="subirCtasPendientes" class="submit" value="Adjuntar" />			
							</td>	
						</tr>				
					</table>
			    </tr>	     
			</table><br>	
			<table border="0" cellpadding="0" cellspacing="0" width="100%">			
				<tr>
					<td colspan="5" align="right">
						<input type="submit" id="procesar" name="procesar" class="submit" value="Procesar"/>
						<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="0"/>
						<input type="hidden" id="fechaSistema" name="fechaSistema" value=""/>
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