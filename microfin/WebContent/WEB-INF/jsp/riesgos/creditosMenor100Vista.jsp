<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>  
<html>
	<head>
 	   <script type="text/javascript" src="dwr/interface/creditosMenor100Servicio.js"></script>   
      <script type="text/javascript" src="js/riesgos/creditosMenor100.js"></script> 		
	</head>
      
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="pagosMenor100">

<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Cr&eacute;ditos < 100,000 </legend>
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
										<label for="">Monto de Cartera <= $ 100,000.00: </label>
									</td>
									<td>
										<input id="montoCarteraAnterior" name="montoCarteraAnterior" size="20" type="text"  readonly="true" style="text-align: right;"/>	
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
						<legend>Saldo de Cartera Acumulado al D&iacute;a de Ayer</legend>
							<table>
								<tr>
									<td class="label">
										<label for="">Saldo de Cartera <= $ 100,000.00: </label>
									</td>
									<td>
										<input id="saldoCartera" name="saldoCartera" size="20" type="text"  readonly="true" style="text-align: right;"/>	
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
									<td>
										<input id="resultadoPorcCredito" name="resultadoPorcCredito" size="12" type="text" readonly="true" style="text-align: right;"/>	
						         		<label> %</label>
									</td>			
								</tr>
								<tr>
									<td class="label">
										<label for="">Par&aacute;metro de Porcentaje: </label>
									</td>
									<td>
										<input id="parametroPorcCredito" name="parametroPorcCredito" size="12" type="text" readonly="true" style="text-align: right;"/>
						         		<label> %</label>	
									</td>					
								</tr>
								<tr>
									<td class="label">
										<label for="">Diferencia al L&iacute;mite Establecido: </label>
									</td>
									<td>
										<input id="difLimiteEstabCredito" name="difLimiteEstabCredito" size="12" type="text" readonly="true" style="text-align: right;"/>	
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
							<a id="ligaGenerar" href="credMenor100Rep.htm" target="_blank" >  		 
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
