<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html> 
	<head>	
		<script type="text/javascript" src="dwr/interface/calendarioProdServicio.js"></script>  
	   	<script type="text/javascript" src="dwr/interface/plazosCredServicio.js"></script> 
      	<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>   
       	<script type="text/javascript" src="js/originacion/calendarioProd.js"></script>    
	</head>
   
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="calendarioProd">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend class="ui-widget ui-widget-header ui-corner-all">Calendario por Producto de Cr&eacute;dito</legend>
			<table border="0" width="100%">
				<tr>
					<td class="label"> 
		         		<label for="productoCreditoID">Producto de Cr&eacute;dito: </label> 
		     		</td> 
		     		<td colspan="4"> 
		         		<form:input id="productoCreditoID" name="productoCreditoID" path="productoCreditoID" size="6" 
		         			tabindex="2" />
		         		<input type= "text" id="descripProducto" name="descripProducto"size="45" type="text" 
		         			readonly="true"  />
		     		</td> 
				</tr>
				<tr>
				   <td class="label"> 
						<label for="fecInHabTomar">En Fecha Inh&aacute;bil Tomar: </label> 
				   </td>
		     		<td class="label">  
						<form:radiobutton id="fecInHabTomar" name="fecInHabTomar" path="fecInHabTomar" value="S" tabindex="4" checked="checked" />
							<label for="fecInHabTomar">D&iacute;a H&aacute;bil Siguiente</label>
						</br>
						<form:radiobutton id="fecInHabTomar2" name="fecInHabTomar2" path="fecInHabTomar" value="A" tabindex="5"/>
							<label for="fecInHabTomar2">D&iacute;a H&aacute;bil Anterior</label>
					</td>
		     		<td class="separador"></td>
		     		<td class="label">
						<label for="ajusFecExigVenc"> Ajustar Fecha Exigíble a &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</br>Vencimiento: </label> 
					</td>
		     		<td class="label">  
						<form:radiobutton id="ajusFecExigVenc" name="ajusFecExigVenc" path="ajusFecExigVenc" value="S" tabindex="6" checked="checked" />
							<label for="ajusFecExigVenc">Si</label>&nbsp;
						<form:radiobutton id="ajusFecExigVenc2" name="ajusFecExigVenc2" path="ajusFecExigVenc" value="N" tabindex="7"/>
							<label for="ajusFecExigVenc2">No&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
					</td> 
				</tr>
				<tr> 
					<form:radiobutton id="ajusFecUlAmoVen" name="ajusFecUlAmoVen" path="ajusFecUlAmoVen" value=" " type="hidden" checked="checked" />
					<td class="label" id="lblIrregular"> 
		 				<label for="permCalenIrreg1">Permite Calendario Irregular: </label> 
					</td>
		     		<td class="label" id="radioIrregular">
						<input type="radio" id="permCalenIrreg1" name="permCalenIrreg1" value="S" tabindex="10"  />
						<label for="permCalenIrreg1">Si</label>&nbsp;
						<input type="radio" id="permCalenIrreg2" name="permCalenIrreg2" value="N" tabindex="11" />
						<label for="permCalenIrreg2">No</label>
						<form:input type="hidden" id="permCalenIrreg" name="permCalenIrreg" path="permCalenIrreg" size="15"  readonly="true"/>
					</td>
					<td class="separador" id="tdSeparador"></td>
					<td class="label" id="lblPrimerAmor">
		         		<label for="diasReqPrimerAmor">D&iacute;as Req. Primer Amortizaci&oacute;n: </label>
		     		</td>
		     		<td class="label" id="reqPrimerAmor">
		     			<form:input id="diasReqPrimerAmor" name="diasReqPrimerAmor" path="diasReqPrimerAmor" size="6" tabindex="11" maxlength="7" onkeypress="return validaSoloNumero(event,this);" autocomplete="off"/>
		         	</td>     		
		 		</tr>   
		 		<tr> 
		 			<td class="label"> 
		 				<label for="iguaCalenIntCap">Igualdad en Calendario</br>de Inter&eacute;s y Capital: </label> 
					</td>
		     		<td class="label">  
						<form:radiobutton id="iguaCalenIntCap" name="iguaCalenIntCap" path="iguaCalenIntCap" value="S" tabindex="12" checked="checked" />
							<label for="iguaCalenIntCap">Si</label>&nbsp;
						<form:radiobutton id="iguaCalenIntCap2" name="iguaCalenIntCap2" path="iguaCalenIntCap" value="N" tabindex="13"/>
							<label for="iguaCalenIntCap2">No</label>
					</td>
		     		<td class="separador"></td> 
					<td class="label"> 
		         		<label for="tipoPagoCapital">Tipo Pago Capital: </label> 
		     		</td> 
					<td>
		     			<select multiple   id="tipoPagoCapital" name="tipoPagoCapital" path="tipoPagoCapital" tabindex="14"  size="4">
					    	<option value="C">CRECIENTES</option>
					        <option value="I">IGUALES</option>
						</select>	 					 
					</td>
				</tr> 
				<tr> 
		 			<td class="label">
						<label for="frecuencias">Frecuencias: </label> 
					</td>
		   			<td> 
		   				<select MULTIPLE id="frecuencias" name="frecuencias" path="frecuencias" tabindex="15" size="11">		   					
				     		<option value="S">SEMANAL</option>
				     		<option value="D">DECENAL</option>
				     		<option value="C">CATORCENAL</option>
							<option value="Q">QUINCENAL</option> 
							<option value="M">MENSUAL</option>
							<option value="B">BIMESTRAL</option>
							<option value="T">TRIMESTRAL</option>
							<option value="R">TETRAMESTRAL</option>
							<option value="E">SEMESTRAL</option>
							<option value="A">ANUAL</option>
							<option value="P">PERIODO</option>
							<option value="U">PAGO &Uacute;NICO</option>
					     </select>
					</td>
		     		<td class="separador"></td> 
					<td class="label"> 
				   		<label for="plazoID">Plazo: </label> 
				   	</td>   	
				   <td> 
		         	<select MULTIPLE id="plazoID" name="plazoID" path="plazoID" tabindex="16" size="11">
					      </select>	
		     		</td> 
		     	</tr> 
				<tr>
					<td class="label">
							<label for="tipoDispersion">Tipo Dispersi&oacute;n: </label> 
						</td>
					<td>
						<select multiple id="tipoDispersion" name="tipoDispersion" path="tipoDispersion" tabindex="17" size="5">
				     			<option value="S">SPEI</option>
				     			<option value="C">CHEQUE</option>
								<option value="O">ORDEN DE PAGO</option> 
								<option value="E">EFECTIVO</option>
								<option value="A">TRAN. SANTANDER</option>
					    </select>
					  </td>
					 <td class="separador"></td>
					<td colspan="2">
				 	<div id="capital" style="display: none;" > 
					<table border="0" width="100%">
			     		<tr> 	
				 			<td class="label" width="65%" nowrap="nowrap"> 
				 				<label for="diaPagoCapital">D&iacute;a Pago Capital: </label> 
							</td>
				     		<td class="label" nowrap="nowrap">  
								<form:radiobutton id="diaPagoCapital" name="diaPagoCapital" path="diaPagoCapital" value="F" tabindex="18" checked="checked" />
									<label for="diaPagoCapital">&Uacute;ltimo D&iacute;a Mes</label>&nbsp;
							</td>
						</tr>
						<tr> 	
				 			<td class="separador"></td> 
				     		<td class="label" >  
								<form:radiobutton id="diaPagoCapital2" name="diaPagoCapital2" path="diaPagoCapital" value="D" tabindex="19"/>
									<label for="diaPagoCapital2">D&iacute;a del Mes</label>
							</td>
						</tr>
						<tr> 	
				 			<td class="separador"></td> 
				 			<td class="label" > 
								<form:radiobutton id="diaPagoCapital3" name="diaPagoCapital3" path="diaPagoCapital" value="A" tabindex="20"/>
									<label for="diaPagoCapital3">D&iacute;a Aniversario</label>
							</td>
						</tr>
						<tr> 	
				 			<td class="separador"></td> 
				 			<td class="label" > 
								<form:radiobutton id="diaPagoCapital4" name="diaPagoCapital4" path="diaPagoCapital" value="I" tabindex="21"/>
									<label for="diaPagoCapital4">Indistinto</label>
							</td>
						</tr>
					</table>
					</div>	
					</td>
				</tr>
				<tr>
					<td colspan="2">
					 <div id="interes" style="display: none;" > 
						<table border="0" width="100%">
							<tr> 
								<td class="label" width="38%" nowrap="nowrap"> 
					 				<label for="diaPagoInteres">D&iacute;a Pago Inter&eacute;s: </label> 
								</td>
					     		<td class="label" >  
									<form:radiobutton id="diaPagoInteres" name="diaPagoInteres" path="diaPagoInteres" value="F" tabindex="22" checked="checked" />
										<label for="diaPagoInteres">&Uacute;ltimo D&iacute;a Mes</label>&nbsp;
								</td> 
							</tr>
							<tr> 
								<td class="separador"></td> 
					     		<td class="label">  
									<form:radiobutton id="diaPagoInteres2" name="diaPagoInteres2" path="diaPagoInteres" value="D" tabindex="23"/>
										<label for="diaPagoInteres2">D&iacute;a del Mes</label>
								</td> 
							</tr>
							<tr> 
								<td class="separador"></td> 
					     		<td class="label">  
									<form:radiobutton id="diaPagoInteres3" name="diaPagoInteres3" path="diaPagoInteres" value="A" tabindex="24"/>
										<label for="diaPagoInteres3">D&iacute;a Aniversario</label>
								</td> 
							</tr>
							<tr> 
								<td class="separador"></td> 
					     		<td class="label">  
									<form:radiobutton id="diaPagoInteres4" name="diaPagoInteres4" path="diaPagoInteres" value="I" tabindex="25"/>
										<label for="diaPagoInteres4">Indistinto </label>
								</td> 
							</tr>
						</table>
					</div>  
					</td>
					<td class="separador"></td> 
					<td colspan="2">
					 	<div id="diaPagoQuincDiv" style="display: none;"> 
							<table border="0" width="100%">
								<tr>
						 			<td class="label" width="58%" nowrap="nowrap"> 
						 				<label for="diaPagoQuincenalD">D&iacute;a Pago Quincenal: </label> 
									</td>
						     		<td class="label" nowrap="nowrap">  
										<form:radiobutton id="diaPagoQuincenalD" name="diaPagoQuincenal" path="diaPagoQuincenal" value="D" tabindex="19"/>
											<label for="diaPagoQuincenalD">D&iacute;a Quincena</label><a href="javaScript:" onclick="infoDiaQuinc()"> <img src="images/help-icon.gif"></a>
									</td>
								</tr>
								<tr>
						 			<td class="separador"></td> 
						 			<td class="label" > 
										<form:radiobutton id="diaPagoQuincenalQ" name="diaPagoQuincenal" path="diaPagoQuincenal" value="Q" tabindex="20"/>
											<label for="diaPagoQuincenalQ">Quincena</label>
									</td>
								</tr>
								<tr>
						 			<td class="separador"></td> 
						 			<td class="label" > 
										<form:radiobutton id="diaPagoQuincenalI" name="diaPagoQuincenal" path="diaPagoQuincenal" value="I" tabindex="21"/>
											<label for="diaPagoQuincenalI">Indistinto</label>
									</td>
								</tr>
							</table>
						</div>
					</td>
				</tr>
				<tr>
					<td colspan="5" align="right">
						<input type="submit" id="grabar" name="grabar" class="submit" value="Grabar" tabindex="26"  />
						<input type="submit" id="modificar" name="modificar" class="submit" value="Modificar" tabindex="27"  />
						<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="tipoTransaccion"/>				
					</td>
				</tr>	
			</table>
</fieldset>
</form:form>
</div>
<div id="info" style="display: none"></div>
<div id="cargando" style="display: none;">	
</div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"></div>
</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>