<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>  
<html>
	<head>
 	   <script type="text/javascript" src="dwr/interface/creditosZonaGeograficaServicio.js"></script>   
      <script type="text/javascript" src="js/riesgos/creditosZonaGeografica.js"></script>  	
	</head>
      
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="zonaGeografica">
<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Cr&eacute;ditos Zona Geogr&aacute;fica </legend>
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
			
			 <table  border="0"  width="100%">
				<tr>
					<td>
						<fieldset class="ui-widget ui-widget-content ui-corner-all">                
						<legend>Monto de Cartera Acumulado del D&iacute;a de Ayer</legend>
							<table>
								<tr>
									<td class="label">
										<label for="">Monto de Cartera por Zona Geogr&aacute;fica: </label>
									</td>
									<td>
										<input id="montoCarteraZona" name="montoCarteraZona" size="20" type="text"  readonly="true" style="text-align: right;"/>	
									</td>			
								</tr>
								<tr>
									<td class="label">
										<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Puebla: </label>
									</td>
									<td>
										<input id="carteraPuebla" name="carteraPuebla" size="20" type="text"  readonly="true" style="text-align: right;"/>	
									</td>			
								</tr>
								<tr>
									<td class="label">
										<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Oaxaca: </label>
									</td>
									<td>
										<input id="carteraOaxaca" name="carteraOaxaca" size="20" type="text"  readonly="true" style="text-align: right;"/>	
									</td>			
								</tr>
								<tr>
									<td class="label">
										<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Veracruz: </label>
									</td>
									<td>
										<input id="carteraVeracruz" name="carteraVeracruz" size="20" type="text"  readonly="true" style="text-align: right;"/>	
									</td>			
								</tr>
								<tr>
									<td class="label">
										<label for="">Saldo Total de la Cartera de Cr&eacute;dito: </label>
									</td>
									<td>
										<input id="saldoCarteraCredito" name="saldoCarteraCredito" size="20" type="text"  readonly="true" style="text-align: right;"/>	
									</td>				
								</tr>
								<tr>
									<td class="label">
										<label for="">Resultado Porcentual: </label>
									</td>			
								</tr>
								<tr>
									<td class="label">
										<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Puebla: </label>
									</td>
									<td>
										<input id="porcentualPuebla" name="porcentualPuebla" size="12" 
						         			type="text" readonly="true" style="text-align: right;"/>	
						         		<label> %</label>
									</td>			
								</tr>
								<tr>
									<td class="label">
										<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Oaxaca: </label>
									</td>
									<td>
										<input id="porcentualOaxaca" name="porcentualOaxaca" size="12" 
						         			type="text" readonly="true" style="text-align: right;"/>	
						         		<label> %</label>
									</td>			
								</tr>
								<tr>
									<td class="label">
										<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Veracruz: </label>
									</td>
									<td>
										<input id="porcentualVeracruz" name="porcentualVeracruz" size="12" 
						         			type="text" readonly="true" style="text-align: right;"/>
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
										<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Puebla: </label>
									</td>
									<td>
										<input id="porcentajePuebla" name="porcentajePuebla" size="12" type="text" readonly="true" style="text-align: right;"/>
						         		<label> %</label>	
									</td>			
								</tr>
								<tr>
									<td class="label">
										<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Oaxaca: </label>
									</td>
									<td>
										<input id="porcentajeOaxaca" name="porcentajeOaxaca" size="12" type="text" readonly="true" style="text-align: right;"/>	
						         		<label> %</label>
									</td>			
								</tr>
								<tr>
									<td class="label">
										<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Veracruz: </label>
									</td>
									<td>
										<input id="porcentajeVeracruz" name="porcentajeVeracruz" size="12" type="text" readonly="true" style="text-align: right;"/>	
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
										<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Puebla: </label>
									</td>
									<td>
										<input id="limitePuebla" name="limitePuebla" size="12" type="text" readonly="true" style="text-align: right;"/>	
						         		<label> %</label>
									</td>			
								</tr>
								 <tr>
									<td class="label">
										<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Oaxaca: </label>
									</td>
									<td>
										<input id="limiteOaxaca" name="limiteOaxaca" size="12" type="text" readonly="true" style="text-align: right;"/>
						         		<label> %</label>	
									</td>			
								</tr>
								 <tr>
									<td class="label">
										<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Veracruz: </label>
									</td>
									<td>
										<input id="limiteVeracruz" name="limiteVeracruz" size="12" type="text" readonly="true" style="text-align: right;"/>	
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
										<label for="">Saldo de Cartera por Zona Geogr&aacute;fica: </label>
									</td>
									<td>
										<input id="saldoCarteraZona" name="saldoCarteraZona" size="20" type="text"  readonly="true" style="text-align: right;"/>	
									</td>			
								</tr>
								<tr>
									<td class="label">
										<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Puebla: </label>
									</td>
									<td>
										<input id="carteraPue" name="carteraPue" size="20" type="text"  readonly="true" style="text-align: right;"/>	
									</td>			
								</tr>
								<tr>
									<td class="label">
										<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Oaxaca: </label>
									</td>
									<td>
										<input id="carteraOax" name="carteraOax" size="20" type="text"  readonly="true" style="text-align: right;"/>	
									</td>			
								</tr>
								<tr>
									<td class="label">
										<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Veracruz: </label>
									</td>
									<td>
										<input id="carteraVer" name="carteraVer" size="20" type="text"  readonly="true" style="text-align: right;"/>	
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
										<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Puebla: </label>
									</td>
									<td>
										<input id="porcentualPue" name="porcentualPue" size="12" 
						         			type="text" readonly="true" style="text-align: right;"/>	
						         		<label> %</label>
									</td>			
								</tr>
								<tr>
									<td class="label">
										<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Oaxaca: </label>
									</td>
									<td>
										<input id="porcentualOax" name="porcentualOax" size="12" 
						         			type="text" readonly="true" style="text-align: right;"/>	
						         		<label> %</label>
									</td>			
								</tr>
								<tr>
									<td class="label">
										<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Veracruz: </label>
									</td>
									<td>
										<input id="porcentualVer" name="porcentualVer" size="12" 
						         			type="text" readonly="true" style="text-align: right;"/>
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
										<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Puebla: </label>
									</td>
									<td>
										<input id="porcentajePue" name="porcentajePue" size="12" type="text" readonly="true" style="text-align: right;"/>
						         		<label> %</label>	
									</td>			
								</tr>
								<tr>
									<td class="label">
										<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Oaxaca: </label>
									</td>
									<td>
										<input id="porcentajeOax" name="porcentajeOax" size="12" type="text" readonly="true" style="text-align: right;"/>	
						         		<label> %</label>
									</td>			
								</tr>
								<tr>
									<td class="label">
										<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Veracruz: </label>
									</td>
									<td>
										<input id="porcentajeVer" name="porcentajeVer" size="12" type="text" readonly="true" style="text-align: right;"/>	
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
										<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Puebla: </label>
									</td>
									<td>
										<input id="limitePue" name="limitePue" size="12" type="text" readonly="true" style="text-align: right;"/>	
						         		<label> %</label>
									</td>			
								</tr>
								 <tr>
									<td class="label">
										<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Oaxaca: </label>
									</td>
									<td>
										<input id="limiteOax" name="limiteOax" size="12" type="text" readonly="true" style="text-align: right;"/>
						         		<label> %</label>	
									</td>			
								</tr>
								 <tr>
									<td class="label">
										<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Veracruz: </label>
									</td>
									<td>
										<input id="limiteVer" name="limiteVer" size="12" type="text" readonly="true" style="text-align: right;"/>	
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
		
		<table border="0"  width="100%">	
			<tr>
				<td colspan="4">
					<table align="right" border='0'>
						<tr>
							<td align="right">
							<a id="ligaGenerar" href="credZonaGeograficaRep.htm" target="_blank" >  		 
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