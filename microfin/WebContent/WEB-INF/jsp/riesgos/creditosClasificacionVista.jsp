<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>  
<html>

	<head>
 	   <script type="text/javascript" src="dwr/interface/creditosClasificacionServicio.js"></script>   
      <script type="text/javascript" src="js/riesgos/creditosClasificacion.js"></script>  		
	</head>
      
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="creditosClasificacion">

<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Cr&eacute;ditos por Clasificaci&oacute;n </legend>
		<table border="0"  width="100%">
			 <tr> <td>        
          <table border="0"  width="100%">
				<tr>
					<td class="label">
						<label for="">Fecha Operaci&oacute;n: </label>
						<input id="fechaOperacion" name="fechaOperacion" size="12" tabindex="1" type="text" esCalendario="true" />	
					</td>				
				</tr>
				</table>
			<br>
			 <table  border="0"  width="100%">
				<tr>
					<td>
						<fieldset class="ui-widget ui-widget-content ui-corner-all">                
						<legend>Monto de Cartera Acumulado del D&iacute;a de Ayer</legend>
							<table>
								<tr>
									<td class="label">
										<label for="">Monto de Cartera por Clasificaci&oacute;n: </label>
									</td>
									<td>
										<input id="montoCarteraAnterior" name="montoCarteraAnterior" size="20" type="text" readonly="true" style="text-align: right;"/>	
									</td>			
								</tr>
								<tr>
									<td class="label">
										<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Consumo: </label>
									</td>
									<td>
										<input id="creditoConsumo" name="creditoConsumo" size="20" type="text" readonly="true" style="text-align: right;"/>	
									</td>			
								</tr>
								<tr>
									<td class="label">
										<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Comercial: </label>
									</td>
									<td>
										<input id="creditoComercial" name="creditoComercial" size="20" type="text"  readonly="true" style="text-align: right;"/>	
									</td>			
								</tr>
								<tr>
									<td class="label">
										<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Vivienda: </label>
									</td>
									<td>
										<input id="creditoVivienda" name="creditoVivienda" size="20" type="text" readonly="true" style="text-align: right;"/>	
									</td>			
								</tr>
								<tr>
									<td class="label">
										<label for="">Saldo Total de la Cartera de Cr&eacute;dito: </label>
									</td>
									<td>
										<input id="saldoCarteraCredito" name="saldoCarteraCredito" size="20" type="text" readonly="true" style="text-align: right;"/>	
									</td>				
								</tr>
								<tr>
									<td class="label">
										<label for="">Resultado Porcentual: </label>
									</td>			
								</tr>
								<tr>
									<td class="label">
										<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Consumo: </label>
									</td>
									<td>
										<input id="porcentualConsumo" name="porcentualConsumo" size="12" type="text" readonly="true" style="text-align: right;"/>	
						         		<label> %</label>
									</td>			
								</tr>
								<tr>
									<td class="label">
										<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Comercial: </label>
									</td>
									<td>
										<input id="porcentualComercial" name="porcentualComercial" size="12" type="text" readonly="true" style="text-align: right;"/>	
						         		<label> %</label>
									</td>			
								</tr>
								<tr>
									<td class="label">
										<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Vivienda: </label>
									</td>
									<td>
										<input id="porcentualVivienda" name="porcentualVivienda" size="12" type="text" readonly="true" style="text-align: right;"/>
						         		<label> %</label>	
									</td>			
								</tr>
								<tr>
									<td class="label">
										<label for="">Par&aacute;metro de Porcentaje: </label>
									</td>				
								</tr>
								<tr>
									<td class="label">
										<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Consumo: </label>
									</td>
									<td>
										<input id="porcentajeConsumo" name="porcentajeConsumo" size="12" type="text" readonly="true" style="text-align: right;"/>
						         		<label> %</label>	
									</td>			
								</tr>
								<tr>
									<td class="label">
										<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Comercial: </label>
									</td>
									<td>
										<input id="porcentajeComercial" name="porcentajeComercial" size="12" type="text" readonly="true" style="text-align: right;"/>	
						         		<label> %</label>
									</td>			
								</tr>
								<tr>
									<td class="label">
										<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Vivienda: </label>
									</td>
									<td>
										<input id="porcentajeVivienda" name="porcentajeVivienda" size="12" type="text" readonly="true" style="text-align: right;"/>	
						         		<label> %</label>
									</td>			
								</tr>
								<tr>
									<td class="label">
										<label for="">Diferencia al L&iacute;mite Establecido: </label>
									</td>				
							   </tr>
							   	<tr>
									<td class="label">
										<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Consumo: </label>
									</td>
									<td>
										<input id="limiteConsumo" name="limiteConsumo" size="12" type="text" readonly="true" style="text-align: right;"/>	
						         		<label> %</label>
									</td>			
								</tr>
								 <tr>
									<td class="label">
										<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Comercial: </label>
									</td>
									<td>
										<input id="limiteComercial" name="limiteComercial" size="12" type="text" readonly="true" style="text-align: right;"/>
						         		<label> %</label>	
									</td>			
								</tr>
								 <tr>
									<td class="label">
										<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Vivienda: </label>
									</td>
									<td>
										<input id="limiteVivienda" name="limiteVivienda" size="12" type="text" readonly="true" style="text-align: right;"/>	
						         		<label> %</label>
									</td>			
								</tr>
							</table> 
	 					</fieldset>
					  </td>
						<td>
						<fieldset class="ui-widget ui-widget-content ui-corner-all">                
							<legend>Saldo de Cartera Acumulado al D&iacute;a de Ayer</legend>
								<table>
								<tr>
									<td class="label">
										<label for="">Saldo de Cartera por Clasificaci&oacute;n: </label>
									</td>
									<td>
										<input id="saldoCartera" name="saldoCartera" size="20" type="text"  readonly="true" style="text-align: right;"/>	
									</td>			
								</tr>
								<tr>
									<td class="label">
										<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Consumo: </label>
									</td>
									<td>
										<input id="credConsumo" name="credConsumo" size="20" type="text"  readonly="true" style="text-align: right;"/>	
									</td>			
								</tr>
								<tr>
									<td class="label">
										<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Comercial: </label>
									</td>
									<td>
										<input id="credComercial" name="credComercial" size="20" type="text"  readonly="true" style="text-align: right;"/>	
									</td>			
								</tr>
								<tr>
									<td class="label">
										<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Vivienda: </label>
									</td>
									<td>
										<input id="credVivienda" name="credVivienda" size="20" type="text"  readonly="true" style="text-align: right;"/>	
									</td>			
								</tr>
								<tr>
									<td class="label">
										<label for="">Saldo Total de la Cartera de Cr&eacute;dito: </label>
									</td>
									<td>
										<input id="saldoTotalCartera" name="saldoTotalCartera" size="20" type="text"  readonly="true" style="text-align: right;"/>	
									</td>				
								</tr>
								<tr>
									<td class="label">
										<label for="">Resultado Porcentual: </label>
									</td>			
								</tr>
								<tr>
									<td class="label">
										<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Consumo: </label>
									</td>
									<td>
										<input id="porcentConsumo" name="porcentConsumo" size="12" type="text" readonly="true" style="text-align: right;"/>	
						         		<label> %</label>
									</td>			
								</tr>
								<tr>
									<td class="label">
										<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Comercial: </label>
									</td>
									<td>
										<input id="porcentComercial" name="porcentComercial" size="12" type="text" readonly="true" style="text-align: right;"/>	
						         		<label> %</label>
									</td>			
								</tr>
								<tr>
									<td class="label">
										<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Vivienda: </label>
									</td>
									<td>
										<input id="porcentVivienda" name="porcentVivienda" size="12" type="text" readonly="true" style="text-align: right;"/>
						         		<label> %</label>	
									</td>			
								</tr>
								<tr>
									<td class="label">
										<label for="">Par&aacute;metro de Porcentaje: </label>
									</td>				
								</tr>
								<tr>
									<td class="label">
										<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Consumo: </label>
									</td>
									<td>
										<input id="porcConsumo" name="porcConsumo" size="12" type="text" readonly="true" style="text-align: right;"/>
						         		<label> %</label>	
									</td>			
								</tr>
								<tr>
									<td class="label">
										<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Comercial: </label>
									</td>
									<td>
										<input id="porcComercial" name="porcComercial" size="12" type="text" readonly="true" style="text-align: right;"/>	
						         		<label> %</label>
									</td>			
								</tr>
								<tr>
									<td class="label">
										<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Vivienda: </label>
									</td>
									<td>
										<input id="porcVivienda" name="porcVivienda" size="12" type="text" readonly="true" style="text-align: right;"/>	
						         		<label> %</label>
									</td>			
								</tr>
								<tr>
									<td class="label">
										<label for="">Diferencia al L&iacute;mite Establecido: </label>
									</td>				
							   </tr>
							   	<tr>
									<td class="label">
										<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Consumo: </label>
									</td>
									<td>
										<input id="diferenciaConsumo" name="diferenciaConsumo" size="12" type="text" readonly="true" style="text-align: right;"/>	
						         		<label> %</label>
									</td>			
								</tr>
								 <tr>
									<td class="label">
										<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Comercial: </label>
									</td>
									<td>
										<input id="diferenciaComercial" name="diferenciaComercial" size="12" type="text" readonly="true" style="text-align: right;"/>
						         		<label> %</label>	
									</td>			
								</tr>
								 <tr>
									<td class="label">
										<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Vivienda: </label>
									</td>
									<td>
										<input id="diferenciaVivienda" name="diferenciaVivienda" size="12" type="text" readonly="true" style="text-align: right;"/>	
						         		<label> %</label>
									</td>			
								</tr>
  						</table> 
			 		  </fieldset>
				  	</td>
				 </tr>
			   </table>
 			</td>  
   		  </tr>
		</table>
		<br>
		<table border="0"  width="100%">	
			<tr>
				<td colspan="4">
					<table align="right" border='0'>
						<tr>
							<td align="right">
							<a id="ligaGenerar" href="credPorClasificacionRep.htm" target="_blank" >  		 
								 <input type="button" id="generar" name="generar" class="submit" tabindex = "2" value="Exportar EXCEL" />
							</a>
							</td>
						</tr>
					</table>		
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