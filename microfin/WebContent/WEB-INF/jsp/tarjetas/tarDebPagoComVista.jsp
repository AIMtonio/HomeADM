<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>	
		<script type="text/javascript" src="dwr/interface/tarjetaDebitoServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/tipoTarjetaDebServicio.js"></script>	
			
		<script type="text/javascript" src="js/tarjetas/tarDebPagoCom.js"></script>          
	</head>
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="tarjetaDebito">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">                
					<legend class="ui-widget ui-widget-header ui-corner-all">Cobro de Anualidad de Tarjeta</legend>
					<table border="0" width="100%">
						<tr>
							<td class="label"> 
		    					<label for="fechaSistema">Fecha Actual: </label>
							</td>
							<td>
								<input type="text" id="fechaSistema" name="fechaSistema" path="fechaSistema" tabindex="1" size="12" readonly="true" />
							</td>
						</tr>
						<tr>
			   				<td class="label"> 
			    				<label for=tipoTarjetaDebID>Tipo de Tarjeta:</label> 
							</td> 
				   			<td>
								<form:select id="tipoTarjetaDebID" name="tipoTarjetaDebID" path="tipoTarjetaDebID" tabindex="2"></form:select>
							</td>	
		 				</tr> 						 			
						
						<!-- campos ocultos -->									
						<input type="hidden" id="nombreUsuario" name="nombreUsuario" path="nombreUsuario"  size="15"/>
					</table>
					<br/>
					
					<table id="descrip proceso Batch">
		        		<tr>
		 					<td> 		 						
		    					<div class="label">
		    						<label class="label">Este proceso realiza el cobro de la comisi&oacute;n de las Tarjetas de D&eacute;bito activas que cumplen</label>
										<br/>
										<label class="label">con los plazos parametrizados.</label>
										<br/>
										<label class="label">Al finalizar el proceso puede imprimir el reporte de Cobros de Anualidad del d&iacute;a. </label>					
		    					</div>
							</td>
		 					</td>
		 					<td>
		 					</td>
		 				</tr>
		 			</table>
					
					<br/>
					<br/>
					
					<table align="right">
						<tr>
							<td align="right">				
								<input type="submit" id="procesar" class="submit" value="Procesar" tabindex="3"/>	
								<input type="hidden" id="tipoActualizacion" name="tipoActualizacion"/>						
							</td>
							<td align="right">				
								<a id="ligaGenerar" href="/reporteTarDebPagoCom.htm" target="_blank" >  		 
										<input type="button" id="imprimir" name="generar" class="submit" tabIndex="4" value="Imprimir Bit&aacute;cora" />
								</a>
								<input type="hidden" id="tipoActualizacion" name="tipoActualizacion"/>						
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