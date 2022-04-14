<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>  
<html>
	<head>
 	   <script type="text/javascript" src="dwr/interface/sumaTiposAhorroServicio.js"></script>   
 	   <script type="text/javascript" src="dwr/interface/estimacionPreventivaServicio.js"></script> 
      <script type="text/javascript" src="js/riesgos/sumasTiposAhorro.js"></script>  	
	</head>
      
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="sumaTiposAhorro">

<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Suma Tipos Ahorro</legend>
			<table border="0"  width="100%">
			 <tr> <td>   
  			<table  border="0"  width="100%">
				<tr>
					<td class="label">
						<label for="">Fecha Operaci&oacute;n: </label>
						<input id="fechaOperacion" name="fechaOperacion" size="12" tabindex="1" type="text" esCalendario="true" />	
					</td>				
				</tr>
			</table>
	 	<tr> <td>        
          <table  border="0"  width="100%">
          	<tr>
				<td>
					<fieldset class="ui-widget ui-widget-content ui-corner-all">                
					<legend>Monto Captado Acumulado del D&iacute;a de Ayer</legend>
						<table>
							<tr>
								<td class="label">
									<label for="">Monto Captado: </label>
								</td>
								<td>
								<input id="montoCaptadoDia" name="montoCaptadoDia" size="20" type="text"  readonly="true" style="text-align: right;"/>	
								</td>			
							</tr>
							<tr>
								<td class="label">
									<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Ahorro de Menores: </label>
								</td>
								<td>
									<input id="ahorroMenores" name="ahorroMenores" size="20" type="text"  readOnly="true" style="text-align: right;"/>	
								</td>			
							</tr>
							<tr>
								<td class="label">
									<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Ahorro Ordinario: </label>
								</td>
								<td>
									<input id="ahorroOrdinario" name="ahorroOrdinario" size="20" type="text"  readOnly="true" style="text-align: right;"/>	
								</td>			
							</tr>
							<tr>
								<td class="label">
									<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Ahorro Vista: </label>
								</td>
								<td>
									<input id="ahorroVista" name="ahorroVista" size="20" type="text"  readOnly="true" style="text-align: right;"/>	
								</td>			
							</tr>
							<tr>
								<td class="label">
									<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Cuentas sin Movimientos: </label>
								</td>
								<td>
									<input id="cuentaSinMov" name="cuentaSinMov" size="20" type="text"  readOnly="true" style="text-align: right;"/>	
								</td>			
							</tr>
							<tr>
								<td class="label">
									<label for="">Total de Dep&oacute;sitos de Inversiones: </label>
								</td>	
								<td>
									<input id="depositoInversion" name="depositoInversion" size="20" type="text"  readOnly="true" style="text-align: right;"/>	
								</td>			
							</tr>
							<tr>
								<td class="label">
									<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Monto Plazo 30: </label>
								</td>
								<td>
									<input id="montoPlazo30" name="montoPlazo30" size="20" type="text"  readonly="true" style="text-align: right;"/>	
								</td>			
							</tr>
							<tr>
								<td class="label">
									<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Monto Plazo 60: </label>
								</td>
								<td>
									<input id="montoPlazo60" name="montoPlazo60" size="20" type="text"  readonly="true" style="text-align: right;"/>	
								</td>			
							</tr>
							<tr>
								<td class="label">
									<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Monto Plazo 90: </label>
								</td>
								<td>
									<input id="montoPlazo90" name="montoPlazo90" size="20" type="text"  readonly="true" style="text-align: right;"/>	
								</td>			
							</tr>
							<tr>
								<td class="label">
									<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Monto Plazo 120: </label>
								</td>	
								<td>
									<input id="montoPlazo120" name="montoPlazo120" size="20" type="text"  readonly="true" style="text-align: right;"/>	
								</td>			
							</tr>
							<tr>
								<td class="label">
									<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Monto Plazo 180: </label>
								</td>
								<td>
									<input id="montoPlazo180" name="montoPlazo180" size="20" type="text"  readonly="true" style="text-align: right;"/>	
								</td>			
							</tr>
							<tr>
								<td class="label">
									<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Monto Plazo 360: </label>
								</td>
								<td>
									<input id="montoPlazo360" name="montoPlazo360" size="20" type="text"  readonly="true" style="text-align: right;"/>	
								</td>				
							</tr>
							<tr>
								<td class="label">
									<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Intereses: </label>
								</td>
								<td>
									<input id="montoInteresMensual" name="montoInteresMensual" size="20" type="text"  readOnly="true" style="text-align: right;"/>	
								</td>				
							</tr>
							<tr>						
								<td class="label">
									<label for="">Total de Ahorro Vista/Ordinario: </label>
								</td>
								<td>
									<input id="montoVistaOrdinario" name="montoVistaOrdinario" size="20" type="text"  readOnly="true" style="text-align: right;"/>	
								</td>					
							</tr>
							<tr>
								<td class="label">
									<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Resultado Porcentual: </label>
								</td>			
								<td>
									<input id="porcentualAhorroVista" name="porcentualAhorroVista" size="12" type="text" readOnly="true" style="text-align: right;"/>	
									<label> %</label>
								</td>			
							</tr>
							<tr>
								<td class="label">
									<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;L&iacute;mite Porcentual: </label>
								</td>				
								<td>
									<input id="diferenciaAhorroVista" name="diferenciaAhorroVista" size="12" type="text" value = ""readOnly="true" style="text-align: right;"/>
									<label> %</label>
								</td>			
							</tr>
							<tr>						
								<td class="label">
									<label for="">Total de Ahorro a Plazo: </label>
								</td>
								<td>
									<input id="montoInversion" name="montoInversion" size="20" type="text"  readOnly="true" style="text-align: right;"/>	
								</td>					
							</tr>
							<tr>
								<td class="label">
									<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Resultado Porcentual: </label>
								</td>			
								<td>
									<input id="porcentualInversiones" name="porcentualInversiones" size="12" type="text" readOnly="true" style="text-align: right;"/>	
									<label> %</label>
								</td>			
							</tr>
							<tr>
								<td class="label">
									<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;L&iacute;mite Porcentual: </label>
								</td>				
								<td>
									<input id="diferenciaInversiones" name="diferenciaInversiones" size="12" type="text" value = ""readOnly="true" style="text-align: right;"/>
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
											<label for="">Saldo Captado: </label>
										</td>	
										<td>
										<input id="saldoCaptadoDia" name="saldoCaptadoDia" size="20" type="text"  readonly="true" style="text-align: right;"/>	
										</td>			
									 </tr>
									 <tr>
										<td class="label">
											<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Ahorro de Menores: </label>
										</td>
										<td>
											<input id="salAhorroMenores" name="salAhorroMenores" size="20" type="text"  readOnly="true" style="text-align: right;"/>	
										</td>			
									</tr>
									<tr>
										<td class="label">
											<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Ahorro Ordinario: </label>
										</td>
										<td>
											<input id="salAhorroOrdinario" name="salAhorroOrdinario" size="20" type="text"  readOnly="true" style="text-align: right;"/>	
										</td>			
									</tr>
									<tr>
										<td class="label">
											<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Ahorro Vista: </label>
										</td>
										<td>
											<input id="salAhorroVista" name="salAhorroVista" size="20" type="text"  readOnly="true" style="text-align: right;"/>	
										</td>			
									</tr>
									<tr>
										<td class="label">
											<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Cuentas sin Movimientos: </label>
										</td>
										<td>
											<input id="salCuentaSinMov" name="salCuentaSinMov" size="20" type="text"  readOnly="true" style="text-align: right;"/>	
										</td>			
									</tr>
									<tr>
										<td class="label">
											<label for="">Total de Dep&oacute;sitos de Inversiones: </label>
										</td>	
										<td>
											<input id="saldDepInversion" name="saldDepInversion" size="20" type="text"  readOnly="true" style="text-align: right;"/>	
										</td>			
									</tr>
									<tr>
										<td class="label">
											<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Saldo Plazo 30: </label>
										</td>
										<td>
											<input id="saldoPlazo30" name="saldoPlazo30" size="20" type="text"  readonly="true" style="text-align: right;"/>	
										</td>			
									</tr>
									<tr>
										<td class="label">
											<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Saldo Plazo 60: </label>
										</td>
										<td>
											<input id="saldoPlazo60" name="saldoPlazo60" size="20" type="text"  readonly="true" style="text-align: right;"/>	
										</td>			
									</tr>
									<tr>
										<td class="label">
											<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Saldo Plazo 90: </label>
										</td>
										<td>
											<input id="saldoPlazo90" name="saldoPlazo90" size="20" type="text"  readonly="true" style="text-align: right;"/>	
										</td>			
									</tr>
									<tr>
										<td class="label">
											<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Saldo Plazo 120: </label>
										</td>	
										<td>
											<input id="saldoPlazo120" name="saldoPlazo120" size="20" type="text"  readonly="true" style="text-align: right;"/>	
										</td>			
									</tr>
									<tr>
										<td class="label">
											<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Saldo Plazo 180: </label>
										</td>
										<td>
											<input id="saldoPlazo180" name="saldoPlazo180" size="20" type="text"  readonly="true" style="text-align: right;"/>	
										</td>			
									</tr>
									<tr>
										<td class="label">
											<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Saldo Plazo 360: </label>
										</td>
										<td>
											<input id="saldoPlazo360" name="saldoPlazo360" size="20" type="text"  readonly="true" style="text-align: right;"/>	
										</td>				
									</tr>
									<tr>
										<td class="label">
											<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Intereses: </label>
										</td>
										<td>
											<input id="saldoInteresMensual" name="saldoInteresMensual" size="20" type="text"  readOnly="true" style="text-align: right;"/>	
										</td>				
									</tr>
									<tr>
									<tr>						
										<td class="label">
											<label for="">Total de Ahorro Vista/Ordinario: </label>
										</td>
										<td>
											<input id="saldoVistaOrdinario" name="saldoVistaOrdinario" size="20" type="text"  readOnly="true" style="text-align: right;"/>	
										</td>					
									</tr>
									<tr>
										<td class="label">
											<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Resultado Porcentual: </label>
										</td>			
										<td>
											<input id="salPorcentualAhorroVista" name="salPorcentualAhorroVista" size="12" type="text" readOnly="true" style="text-align: right;"/>	
											<label> %</label>
										</td>			
									</tr>
									<tr>
										<td class="label">
											<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;L&iacute;mite Porcentual: </label>
										</td>				
										<td>
											<input id="salDiferenciaAhorroVista" name="salDiferenciaAhorroVista" size="12" type="text" value = ""readOnly="true" style="text-align: right;"/>
											<label> %</label>
										</td>			
									</tr>
									<tr>						
										<td class="label">
											<label for="">Total de Ahorro a Plazo: </label>
										</td>
										<td>
											<input id="saldoInversion" name="saldoInversion" size="20" type="text"  readOnly="true" style="text-align: right;"/>	
										</td>					
									</tr>
									<tr>
										<td class="label">
											<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Resultado Porcentual: </label>
										</td>			
										<td>
											<input id="salPorcentualInversiones" name="salPorcentualInversiones" size="12" type="text" readOnly="true" style="text-align: right;"/>	
											<label> %</label>
										</td>			
									</tr>
									<tr>
										<td class="label">
											<label for="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;L&iacute;mite Porcentual: </label>
										</td>				
										<td>
											<input id="salDiferenciaInversiones" name="salDiferenciaInversiones" size="12" type="text" value = ""readOnly="true" style="text-align: right;"/>
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
							<a id="ligaGenerar" href="sumaTiposAhorroRep.htm" target="_blank" >  		 
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