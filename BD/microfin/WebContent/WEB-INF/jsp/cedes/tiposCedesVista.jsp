<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
	
		<script type="text/javascript" src="dwr/interface/tiposCedesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>    	
		<script type="text/javascript" src="dwr/interface/actividadesServicio.js"></script>
		<script type="text/javascript" src="js/cedes/tiposCedes.js"></script>
	</head>
	<body>
 
		<div id="contenedorForma">
			<fieldset class="ui-widget ui-widget-content ui-corner-all" >
				<legend class="ui-widget ui-widget-header ui-corner-all">Tipos de CEDES</legend>
				<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="tiposCedesBean" >
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td><label>N&uacute;mero:</label></td>
							<td><form:input id="tipoCedeID" name="tipoCedeID" path="tipoCedeID" size="7" autocomplete="off" tabindex="1"/></td>
						</tr>
						<tr>
							<td colspan='2'>&nbsp;</td>
						</tr>
						<tr>
							<td><label>Descripci&oacute;n:</label></td>
							<td><form:input id="descripcion" name="descripcion" path="descripcion" size="80" autocomplete="off"
								onblur="ponerMayusculas(this)" tabindex="2" /></td>
						</tr>
						<tr>
							<td><label>Tipo Moneda:</label></td>
							<td><form:select name="monedaSelect" id="monedaSelect" path="monedaId" tabindex="3">
								</form:select></td>
						</tr>				
						<tr>
							<td><label>Permite Especificar Tasa:</label></td>
							<td>	
								<table border="0">
									<tr>
										<td>
											<form:input type="radio" name="especificaTasa" id="especificaTasaSi" value="S"  path="especificaTasa" tabindex="4"/><label>Si</label>
										</td>									
										<td>
											<form:input type="radio" name="especificaTasa" id="especificaTasaNo" value="N"  path="especificaTasa" tabindex="5" checked="true"/><label></a>No</label>
										</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr id="cedesReinversionTR">
							<td><label>Tipo de Reinversi&oacute;n:</label></td>
							<td>
								<table border="0" >
									<tr>
										<td>
											<form:input type="radio" name="reinvertir" id="reinvertir1" path="reinversion" value="S"  tabindex="6"/><label>Reinvertir al vencimiento<br>
											<form:input type="radio" name="reinvertir" id="reinvertir2" path="reinversion" value="N"  tabindex="7"/>No reinvertir<br>
											<form:input type="radio" name="reinvertir" id="reinvertir3" path="reinversion" value="I"  tabindex="8"/>Indistinto</label>
										</td>
										<td>
											<form:select id="tipoReinversion" name="tipoReinversion" path="reinvertir" tabindex="9" />
										</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr>
							<td colspan='1'>&nbsp;</td>
						</tr>
						<tr>
							<td><label>Monto M&iacute;nimo de Apertura:</label></td>
							<td><input type="text" id="minimoApertura" name="minimoApertura" path="minimoApertura" size="35" esMoneda="true" tabindex="10"></td>
						</tr>					
						<tr>
							<td><label>Permite Anclaje: </label></td>
							<td>	
								<table border="0">
									<tr>
										<td>
											<form:input type="radio" name="anclajeSi" id="anclajeSi" value="S"  path="anclaje" tabindex="11"/><label>Si<br>
										</td>
										<td>
											<form:input type="radio" name="anclajeNo" id="anclajeNo" value="N"  path="anclaje" tabindex="12" checked="true"/><label>No</label>					
										</td>
										<td>&nbsp;</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr id="trMinimoAnclaje">
							<td><label>Monto M&iacute;nimo de Anclaje:</label></td>
							<td><input type="text" id="minimoAnclaje" name="minimoAnclaje" path="minimoAnclaje" size="35" esMoneda="true" tabindex="13"></td>
						</tr>
						<tr id="trTasaMejorada">
							<td ><label>Accede a Tasa Mejorada: </label></td>
							<td>	
								<table border="0">
									<tr>
										<td>
										<form:input type="radio" name="tasaMejorada" id="tasaMejoradaSi" value="S"  path="tasaMejorada" tabindex="14"/><label>Si<br>
										</td>
										<td>
										<form:input type="radio" name="tasaMejorada" id="tasaMejoradaNo" value="N"  path="tasaMejorada" tabindex="15" checked="true"/><label>No</label>														
										</td>
										<td>&nbsp;</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr>
						   	<td class="label">
						   		<label for="lblTasaFijaVariable">C&aacute;lculo Inter&eacute;s:</label>
						   	</td>
			 				<td class="label"> 
			 					<label for="Fija">Tasa Fija</label>
								<form:radiobutton id="tasaF" name="tasaFV" path="tasaFV" value="F" tabindex="16" checked="checked" />
								&nbsp;&nbsp;
								<label for="fisica">Tasa Variable</label> 	
								<form:radiobutton id="tasaV" name="tasaFV" path="tasaFV" value="V" tabindex="17"/>
								
							</td> 
						</tr>
						<tr>
							<td class="label">
								<label>D&iacute;a Inh&aacute;bil:</label>								
							</td>
			 				<td class="label"> 
			 					<label for="sabaDomi">S&aacute;bado y Domingo</label>
								<form:radiobutton id="sabaDomi" name="diaInhabil" path="diaInhabil" value="SD" tabindex="18" checked="checked" />
								&nbsp;&nbsp;
								<label for="soloDomi">S&oacute;lo Domingo</label> 	
								<form:radiobutton id="soloDomi" name="diaInhabil" path="diaInhabil" value="D" tabindex="19"/>								
	 						</td> 
						</tr>	
						<tr>
							<td class="label">
								<label for="tipoPagoInt">Forma Pago Inter&eacute;s: </label> 
							</td>
							<td>
								<select multiple id="tipoPagoInt" name="tipoPagoInt" path="tipoPagoInt" tabindex="20" size="3">
				     				<option value="V">VENCIMIENTO</option>
				     				<option value="F">FIN DE MES</option>
									<option value="P">PERIODO</option> 
					    		</select>
					 		</td>
						</tr>
						<tr>
							<td class="label">
								<label id="lbldiasPeriodo" for="diasPeriodo">No. D&iacute;as Periodo:</label>
							</td>
							<td><form:input id="diasPeriodo" name="diasPeriodo" path="diasPeriodo" size="15" autocomplete="off" tabindex="21" /></td>
						</tr>
						<tr id="lblpagoIntCal" >
							<td class="label">
								<label for="pagoIntCal">Tipo Pago Inter&eacute;s:</label>
							</td>
							<td class="label"> 
			 					<label for="pagoIntCal">Iguales</label>
								<form:radiobutton id="pagoIntCalIgual" name="pagoIntCal" path="pagoIntCal" value="I" tabindex="22" checked="checked" />
								&nbsp;&nbsp;
								<label for="pagoIntCal">Devengado</label> 	
								<form:radiobutton id="pagoIntCalDev" name="pagoIntCal" path="pagoIntCal" value="D" tabindex="23"/>		
								<a href="javaScript:" onClick="ayuda();"><img src="images/help-icon.gif"></a>						
	 						</td> 
						</tr>				
						<tr>
							<td colspan="4">
								<br>
								<table border="0" cellpadding="0" cellspacing="0" width="100%" >
									<tr>
								 		<td colspan="4">
								 			<br>
											<fieldset class="ui-widget ui-widget-content ui-corner-all">            
											<legend>Datos de Perfil</legend>            
												<table border="0" cellpadding="0" cellspacing="0" width="100%"> 
													<tr>
													 	   <td class="label" width="140"> 
													       	<label for="lblGenero">G??nero: </label> 
													     </td> 			   
												    	<td> 
													     	<select MULTIPLE id="genero" name="genero" path="genero" tabindex="38"  >
													     		<option value="M">MASCULINO</option>
													     		<option value="F">FEMENINO</option>
													      	</select>	
													 	</td>
													 	<td class="separador"></td>
													 	<td class="label" width="140"> 
												        	<label for="lblEdoCivil">Estado Civil: </label> 
												     	</td> 			   
												    	<td> 
													     	<select MULTIPLE id="estadoCivil" name="estadoCivil" path="estadoCivil" tabindex="39" size="9" >
													     		<option value="S">SOLTERO (A)</option>
													     		<option value="CS">CASADO BIENES SEPARADOS</option>
													     		<option value="CM">CASADO BIENES MANCOMUNADOS</option>
													     		<option value="CC">CASADO BIENES MANCOMUNADOS CON CAPITULACION</option>
													     		<option value="V">VIUDO (A)</option>
													     		<option value="D">DIVORCIADO</option>
													     		<option value="SE">SEPARADO</option>
													     		<option value="U">UNION LIBRE</option>					     		
															</select>
													 	</td>										
												 	</tr>				 			
												</table> 
												<br>
												<table>
													<tr>
												 		<td><label>Rango de Edad:</label></td>
												 		<td><input type="text" id="minimoEdad" name="minimoEdad" tabindex="40" size="12"> <label>a&nbsp;</label> 
												 			<input type="text" id="maximoEdad" name="maximoEdad" tabindex="41" size="12" ><label> a&ntilde;os</label></td>
													 </tr>
												</table>
												<br>	
												<div id="gridActividadesMBX" style="display: none;"></div>
												<fieldset class="ui-widget ui-widget-content ui-corner-all">            
													<legend>Actividad Econ&oacute;mica</legend>  		
													<table   id="tablaActividades" border="0" cellpadding="2" cellspacing="0" width="100%">
														 <tr>
														 	<td colspan="3"><label>Actividad Econ&oacute;mica</label></td>
														 </tr>
														 <tr>
														 	<td width="20">
														 		<input type="button" id="agregaActividad" name="agregaActividad"  tabindex="42" value="Agregar" class="submit"/>
														 	</td>
														 	<td width="80"></td>
														 	<td></td>
														 </tr>
													 	<tr>
													 		<td><label>Actividad BMX</label> </td>
													 		<td><label>Descripci&oacute;n</label></td>			 		
													 		<td></td>
													 	</tr>				
													</table>					
												</fieldset>  		 			
											</fieldset>
									 	</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr>
							<td colspan="4">
								<fieldset class="ui-widget ui-widget-content ui-corner-all">        
									<legend>RECA-CONDUSEF</legend>            
				  					<table border="0" cellpadding="3" cellspacing="0" width="100%"> 
										<tr> 
									     	<td class="label"> 
									         	<label for="lblNumRegistroRECA">No. Registro RECA:</label> 
									     	</td> 
									     	<td> 
									         	<form:input type="text" id="numRegistroRECA" name="numRegistroRECA" path="numRegistroRECA" size="50"
									         		tabindex="43"/> 
									     	</td> 
									     	<td class="separador"></td> 
										
									     	<td class="label"> 
									         	<label for="lblFechaInscripcion">Fecha Inscripci&oacute;n: </label> 
									     	</td> 
									     	<td> 
									        	<form:input type="text" id="fechaInscripcion" name="fechaInscripcion" path="fechaInscripcion" size="20"
									         		iniForma='false' tabindex="44" esCalendario="true"/> 
									    	</td> 
										</tr> 
									 	<tr> 
								      		<td class="label"> 
								         		<label for="lblNombreComercial">Nombre Comercial:</label> 
								    		</td> 
								     		<td> 
								         		<form:input type="text" id="nombreComercial" name="nombreComercial" path="nombreComercial" size="50"
								         		 onblur="ponerMayusculas(this)" tabindex="45"/> 
								     		</td> 
										</tr> 
									</table> 
								</fieldset>
							</td>
						</tr>
						<tr>
							<td colspan="4">
								<br>
									<fieldset class="ui-widget ui-widget-content ui-corner-all">            
									<legend>Regulatorios</legend>            
									   <table border="0" width="100%"> 
									   	<tr> 
										     <td class="label"> 
										         <label for="claveCNBV">Clave Producto:</label> 
										     </td> 
										     <td> 
										         <form:input type="text" id="claveCNBV" name="claveCNBV" path="claveCNBV" size="15"
										         		 maxlength="10" tabindex="46"/> 
										     </td> 
										     <td class="separador"></td> 
											
										     <td class="label"> 
										         <label for="claveCNBVAmpCred">Clave Prod. Ampara Cr??dito: </label> 
										     </td> 
										     <td> 
										          <form:input type="text" id="claveCNBVAmpCred" name="claveCNBVAmpCred" path="claveCNBVAmpCred" size="15"
										         		 maxlength="10" tabindex="47"/> 
										     </td> 
										    </tr> 
		
										</table> 
								</fieldset>
							</td>
						</tr>
						<tr>
							<td colspan="4">
								<table align="right" boder='0'>
									<tr>
										<td align="right">
											<input type="submit" id="agrega" name="agrega" class="submit" value="Agregar" tabindex="206"/>
											<input type="submit" id="modifica" name="modifica" class="submit"  value="Modificar" tabindex="207"/>
											<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
											<input type="hidden" id="fechaCreacion" name="fechaCreacion" />
								
										</td>
									</tr>
								</table>		
							</td>
						</tr>	
					</table>
				</form:form>
			</fieldset>
		</div>
		<div id="cargando" style="display: none;"></div>
		<div id="cajaLista" style="display: none;">
			<div id="elementoLista"/>
		</div>
		<div id="mensaje" style="display: none;"/>
		<div id="ContenedorAyuda" style="display: none;">
		<div id="elementoLista"/>
</div>
	</body>
</html>
