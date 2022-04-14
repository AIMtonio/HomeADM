<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>  
<html>
	<head>
 	   <script type="text/javascript" src="dwr/interface/sumaAhorroInversionServicio.js"></script>  
      <script type="text/javascript" src="js/riesgos/sumaAhorroInversion.js"></script>  	
	</head>
      
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="sumaAhorroInversion">
<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Suma Ahorro Inversi&oacute;n</legend>
		<table border="0" width="100%">
			 <tr> <td>       
          <table  border="0"  width="100%">
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
						<legend>Monto Captado Acumulado del D&iacute;a de Ayer</legend>
							<table>
								<tr>
									<td class="label">
										<label for="">Monto M&aacute;ximo Captado Socio: </label>
									</td>
									<td>
										<input id="montoCaptadoDia" name="montoCaptadoDia" size="20" type="text"  readonly="true" style="text-align: right;"/>	
									</td>				
								</tr>
								<tr>
									<td class="label">
										<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Ahorro Ordinario: </label>
									</td>	
									<td>
										<input id="ahorroOrdinario" name="ahorroOrdinario" size="20" type="text"  readonly="true" style="text-align: right;"/>	
									</td>		
								</tr>
								<tr>
									<td class="label">
										<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Ahorro Vista: </label>
									</td>
									<td>
										<input id="ahorroVista" name="ahorroVista" size="20" type="text"  readonly="true" style="text-align: right;"/>	
									</td>			
								</tr>
								<tr>
									<td class="label">
									<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Inversiones: </label>
									</td>
								<td>
									<input id="depositoInversion" name="depositoInversion" size="20" type="text"  readOnly="true" style="text-align: right;"/>	
								</td>			
								</tr>
								<tr>
									<td class="label">
										<label for="">Monto de Capital Neto Mensual: </label>
									</td>	
									<td>
										<input id="capitalNetoMensual" name="capitalNetoMensual" size="20" type="text"  readonly="true" style="text-align: right;"/>	
									</td>			
								</tr>
								<tr>
									<td class="label">
										<label for="">Resultado Porcentual: </label>
									</td>
									<td>
										<input id="resultadoPorcentual" name="resultadoPorcentual" size="12" type="text" readonly="true" style="text-align: right;"/>	
						         		<label> %</label>
									</td>				
								</tr>
								<tr>
									<td class="label">
										<label for="">Par&aacute;metro de Porcentaje: </label>
									</td>
									<td>
										<input id="parametroPorcentaje" name="parametroPorcentaje" size="12" type="text" readonly="true" style="text-align: right;"/>
						         		<label> %</label>	
									</td>				
								</tr>
								<tr>
									<td class="label">
										<label for="">Diferencia al L&iacute;mite Establecido: </label>
									</td>
									<td>
										<input id="difLimiteEstablecido" name="difLimiteEstablecido" size="12" type="text" readonly="true" style="text-align: right;"/>	
						         		<label> %</label>
									</td>				
							   </tr>
				 			</table> 
				 		</fieldset>
				 	</td>
					<td>
						<fieldset class="ui-widget ui-widget-content ui-corner-all">                
							<legend>Saldo Captado Acumulado al D&iacute;a de Ayer</legend>
								<table>
								<tr>
									<td class="label">
										<label for="">Saldo M&aacute;ximo Captado Socio: </label>
									</td>
									<td>
										<input id="saldoCaptadoDia" name="saldoCaptadoDia" size="20" type="text"  readonly="true" style="text-align: right;"/>	
									</td>				
								</tr>
								<tr>
									<td class="label">
										<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Ahorro Ordinario: </label>
									</td>	
									<td>
										<input id="salAhorroOrdinario" name="salAhorroOrdinario" size="20" type="text"  readonly="true" style="text-align: right;"/>	
									</td>		
								</tr>
								<tr>
									<td class="label">
										<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Ahorro Vista: </label>
									</td>
									<td>
										<input id="salAhorroVista" name="salAhorroVista" size="20" type="text"  readonly="true" style="text-align: right;"/>	
									</td>			
								</tr>
								<tr>
									<td class="label">
										<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Inversiones: </label>
									</td>	
									<td>
										<input id="saldDepInversion" name="saldDepInversion" size="20" type="text"  readOnly="true" style="text-align: right;"/>	
									</td>			
								</tr>
								<tr>
									<td class="label">
										<label for="">Monto de Capital Neto Mensual: </label>
									</td>	
									<td>
										<input id="salCapitalNetoMensual" name="salCapitalNetoMensual" size="20" type="text"  readonly="true" style="text-align: right;"/>	
									</td>			
								</tr>
								<tr>
									<td class="label">
										<label for="">Resultado Porcentual: </label>
									</td>
									<td>
										<input id="saldoPorcentual" name="saldoPorcentual" size="12" type="text" readonly="true" style="text-align: right;"/>	
						         		<label> %</label>
									</td>				
								</tr>
								<tr>
									<td class="label">
										<label for="">Par&aacute;metro de Porcentaje: </label>
									</td>
									<td>
										<input id="saldoPorcentaje" name="saldoPorcentaje" size="12" type="text" readonly="true" style="text-align: right;"/>
						         		<label> %</label>	
									</td>				
								</tr>
								<tr>
									<td class="label">
										<label for="">Diferencia al L&iacute;mite Establecido: </label>
									</td>
									<td>
										<input id="saldoDiferencia" name="saldoDiferencia" size="12" type="text" readonly="true" style="text-align: right;"/>	
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
							<a id="ligaGenerar" href="sumaAhorroInversionRep.htm" target="_blank" >  		 
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