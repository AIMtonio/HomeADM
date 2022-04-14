<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
<head>

	<script type="text/javascript" src="dwr/interface/tipoInversionesServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>
	<script type="text/javascript" src="js/inversiones/tipoInversiones.js"></script>

<title>Catalogo Tipos de Inversion</title>
</head>
<body>

<div id="contenedorForma">
	<fieldset class="ui-widget ui-widget-content ui-corner-all" >
	<legend class="ui-widget ui-widget-header ui-corner-all">Tipos de Inversiones</legend>
	
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="tipoInversionBean" >
				
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td><label>N&uacute;mero:</label></td>
						<td><form:input id="tipoInvercionID" name="tipoInvercionID" path="tipoInvercionID" size="7" autocomplete="off"/></td>
					</tr>
					
					<tr>
						<td colspan='2'>&nbsp;</td>
					</tr>
					
					<tr>
						<td><label>Descripci&oacute;n:</label></td>
						<td><form:input id="descripcion" name="descripcion" path="descripcion" size="60" autocomplete="off"
							onblur="ponerMayusculas(this)" /></td>
						<td class="separador"></td>
						<td><label>Tipo Moneda:</label></td>
						<td><form:select name="monedaSelect" id="monedaSelect" path="monedaId">
							</form:select></td>
					</tr>
					
						
					<tr>
						<td ><label>Tipo de Reinversi&oacute;n:</label></td>
						<td>	<table border="0">
									<tr>
										<td>
											<form:input type="radio" name="reinvertir" id="reinvertir1" value="S"  path="reinversion"/><label>Reinvertir al vencimiento<br>
											<form:input type="radio" name="reinvertir" id="reinvertir2" value="N"  path="reinversion"/>No reinvertir</label>
										</td>
										<td><form:select id="tipoReinversion" name="tipoReinversion" path="reinvertir" /></td>
										<td>&nbsp;</td>
										
									</tr>
								</table>
						</td>
																<td>&nbsp;</td>

						<td class="pagoPeriodico"><label>Pago Peri&oacute;dico:</label></td>
						<td>	<table border="0" class="pagoPeriodico">
									<tr>
										<td>
											<form:input type="radio" name="pagoPeriodico" id="pagoPeriodicoSi" value="S"  path="pagoPeriodico"/><label>Si<br>
											<form:input type="radio" name="pagoPeriodico" id="pagoPeriodicoNo" value="N"  path="pagoPeriodico"/>No</label>
										</td>
										
										
									</tr>
								</table>
						</td>
					</tr>

					
					
					<!--NUEVA SECCION PARA RECA-->
					<tr>
						<td colspan="5">
							<br>
							<fieldset class="ui-widget ui-widget-content ui-corner-all">        
								<legend>RECA-CONDUSEF</legend>            
				  				<table border="0" cellpadding="3" cellspacing="0" width="100%"> 
									<tr> 
								     	<td class="label"> 
								         	<label for="lblNumRegistroRECA">No. Registro RECA:</label> 
								     	</td> 
								     	<td> 
								         	<form:input type="text" id="numRegistroRECA" name="numRegistroRECA" path="numRegistroRECA" size="50" onblur="ponerMayusculas(this)"/> 
								     	</td> 
								     	<td class="separador"></td> 
									
								     	<td class="label"> 
								         	<label for="lblFechaInscripcion">Fecha Inscripci&oacute;n: </label> 
								     	</td> 
								     	<td> 
								        	<form:input type="text" id="fechaInscripcion" name="fechaInscripcion" path="fechaInscripcion" size="20" iniForma='false' esCalendario="true"/> 
								    	</td> 
									</tr> 
								 	<tr> 
							      		<td class="label"> 
							         		<label for="lblNombreComercial">Nombre Comercial:</label> 
							    		</td> 
							     		<td> 
							         		<form:input type="text" id="nombreComercial" name="nombreComercial" path="nombreComercial" size="50" onblur="ponerMayusculas(this)"/> 
							     		</td> 
									</tr> 
								</table> 
							</fieldset>
						</td>
					</tr>
					
					
					<tr>
						<td colspan="5">
							<br>
								<fieldset class="ui-widget ui-widget-content ui-corner-all">            
								<legend>Regulatorios</legend>            
								   <table border="0" cellpadding="3" cellspacing="0" width="100%"> 
								   	<tr> 
									     <td class="label"> 
									         <label for="claveCNBV">Clave Producto:</label> 
									     </td> 
									     <td> 
									         <form:input type="text" id="claveCNBV" name="claveCNBV" path="claveCNBV" size="15"
									         		 maxlength="10"/> 
									     </td> 
									     <td class="separador"></td> 
										
									     <td class="label"> 
									         <label for="claveCNBVAmpCred">Clave Prod. Ampara Crédito: </label> 
									     </td> 
									     <td> 
									          <form:input type="text" id="claveCNBVAmpCred" name="claveCNBVAmpCred" path="claveCNBVAmpCred" size="15"
									         		 maxlength="10"/> 
									     </td> 
									    </tr> 
							
										
									</table> 
							</fieldset>
						</td>
					</tr>
					
						       		
		
		

					<tr>
						<td colspan="5">
						<br>
							<table align="right" boder='0'>
								<tr>
									<td align="right">
										<input type="submit" id="agrega" name="agrega" class="submit" value="Agregar" />
										<input type="submit" id="modifica" name="modifica" class="submit"  value="Modificar"/>
										<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
							
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
</body>
</html>