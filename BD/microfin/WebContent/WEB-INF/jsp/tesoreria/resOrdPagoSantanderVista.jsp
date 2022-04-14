<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
 <%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>   
<html>
	<head> 
		<script type="text/javascript" src="dwr/interface/resOrdPagoSantaServicio.js"></script>       	 		   
      	<script type="text/javascript" src="js/tesoreria/resOrdPagoSantanderVista.js"></script>  				
	</head>      
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="cuentasSantander">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend class="ui-widget ui-widget-header ui-corner-all">Respuesta Orden de Pago Santander</legend>
			
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>       
					<table  border="0"  width="100%">
						<tr>
							<td class="label">
								<label for="rutaArchOrdPago">Resp. de Santander, Ordenes de Pago: </label>
							</td>
							<td >
								<input id="rutaArchOrdPago" name="rutaArchOrdPago" path="rutaArchOrdPago" size="60" type="text" readonly/>	
								<input type="button" id="subirOrdPago" name="subirOrdPago" class="submit" value="Adjuntar" />
							</td>					
						</tr>
						<tr>			
							<td class="label">
								<label for="movLiquidados">Movimientos Liquidados: </label> 
							</td>
							<td>
								<input id="movLiquidados" name="movLiquidados" path="movLiquidados" size="30" type="text" readonly/>	
							</td>	
						</tr>				
						<tr>			
						<td class="label">
								<label for="movPendientes">Movimientos en Pendientes: </label> 
							</td>
							<td>
								<input id="movPendientes" name="movPendientes" path="movPendientes" size="30" type="text" readonly/>	
							</td>	
						</tr>	
						<tr>			
							<td class="label">
								<label for="movVencidos">Movimientos Vencidos: </label> 
							</td>
							<td>
								<input id="movVencidos" name="movVencidos" path="movVencidos" size="30" type="text" readonly/>	
							</td>	
						</tr>
						<tr>				
							<td class="label">
								<label for="movCancelados">Movimientos Cancelados: </label> 
							</td>
							<td>
								<input id="movCancelados" name="movCancelados" path="movCancelados" size="30" type="text" readonly/>	
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