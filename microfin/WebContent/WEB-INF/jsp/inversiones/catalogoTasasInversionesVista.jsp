<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<html>
<head>

	<script type="text/javascript" src="dwr/interface/tipoInversionesServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/tasasInversionServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/diasInversionServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/montosInversionServicio.js"></script>
	
	<script type="text/javascript" src="js/inversiones/tasasInversion.js"></script>

<title>Tasas de Inversiones</title>
</head>
<body>

	<div id="contenedorForma">
	<fieldset class="ui-widget ui-widget-content ui-corner-all" >
	<legend class="ui-widget ui-widget-header ui-corner-all">Tasas de Inversi&oacute;n</legend>
	
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="tasasInversionBean" >
				
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td><form:input type="hidden" id="tasaInversionID" name="tasaInversionID" path="tasaInversionID" size="4"  autocomplete="off" /></td>
						<td colspan="3"></td>
					</tr>
					<tr>
						<td><label>Tipo de Inversi&oacute;n</label></td>
						<td><form:input id="tipoInvercionID" name="tipoInvercionID" path="tipoInvercionID" size="7"  autocomplete="off"/>
							<input type="hidden" id="descripcionCon" name="descripcionCon"  size="50" readOnly="true" />
							<input type="text" id="descripcion" name="descripcion"  size="50" readOnly="true" disabled="true" /></td>
						<td colspan="2"></td>
					</tr>
					<tr>
						<td><label>Moneda</label></td>
						<td><label id="moneda"></label></td>
					</tr>
					<tr>
						<td><label>Reinversi&oacute;n: </label></td>
						<td><label id="reinversion"></label></td>
					</tr>
					<tr>
						<td><label>Tipo de Reinversi&oacute;n:</label></td>
						<td><label id="tipoReinversion"></label></td>
					</tr>
					<tr><td colspan='4'>&nbsp;</td></tr>
					<tr>
						<td><label>Plazos:</label></td>
						<td><form:select id="diaInversionID" name="diaInversionID" path="diaInversionID" >
								<form:option value="-1">SELECCIONAR</form:option>
							</form:select></td>
						<td colspan="2"></td>
					</tr>
					<tr>
						<td><label>Montos:</label></td>
						<td> <form:select id="montoInversionID" name="montoInversionID" path="montoInversionID" >
								<form:option value="-1" >SELECCIONAR</form:option>
							</form:select></td>
						<td colspan="2"></td>
					</tr>
					<tr>
						<td><label>Tasa Anualizada:</label></td>
						<td><form:input id="conceptoInversion" name="conceptoInversion" path="conceptoInversion" size="5" autocomplete="off" style="text-align: right;"/>
						<label for="lblconceptoInversion">%</label>
						</td>	
						<td colspan="2"></td>		
					</tr>
					<tr>
					<td><label>GAT Informativo:</label></td>
			     	<td><form:input type="text" id="gatInformativo" name="gatInformativo" path="gatInformativo" size="5" autocomplete="off" style="text-align: right;" onkeypress="return validaDigitosConNegat(event)"/>
			         	<label for="lblGatInformativo">%</label>
			     	</td>
			     		</tr>
					<tr>
						<td colspan="4">
							<table align="right" boder='0'>
								<tr>
									<td align="right">
										<input type="submit" id="agrega" name="agrega" class="submit" value="Agregar" />
										<input type="submit" id="modifica" name="modifica" class="submit"  value="Modificar"/>
										
										<a id="enlace" href="http://localhost:8080/" target="_blank">														    							   
                     						<button type="button" class="submit" id="imprimir" ">
                              					Imprimir
                      						</button>
                      					</a>										

										<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
										<input type="hidden" id="estatusTipoInver" name="estatusTipoInver"/>
							
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