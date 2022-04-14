<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<c:set var="tipoLista" value="${listaResultado[0]}" />
<c:set var="listaClasifClavePresupCovSol" value="${listaResultado[1]}" />
<c:set var="listaCasaComercial" value="${listaResultado[2]}" />

<c:choose>
	<c:when test="${tipoLista != '0'}">
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
			<legend>Informaci&oacute;n Econ&oacute;mica </legend>
				<tbody>
					<c:forEach items="${listaClasifClavePresupCovSol}" var="clasifClavePresupConvSol" varStatus="status">
						<div class="myDiv2">
							<table id="miTabla" align="center" >
								<tr id="renglonClasif${status.count}" name="renglonClasif">
									<td nowrap="nowrap" >
										<input type="hidden"  id="nomClasifClavPresupID${status.count}" name="nomClasifClavPresupID" size="20" value="${clasifClavePresupConvSol.nomClasifClavPresupID}" readOnly="true"/>
										<input type="text"  id="descripcion${status.count}" name="descripcionClasifClave" size="71" value="${clasifClavePresupConvSol.descripcion}"  onBlur="ponerMayusculas(this)" disabled="true" class="imput" style="background-color: #DADFDE; text-align: left; color: black;"  />
									</td>
								</tr>
								<tr >
									<td>
										<div id="gridClavePresupConv${status.count}" style="display: none; width: 480px; height: 250px; overflow-y: auto;"></div>
									</td>
								</tr>
								<c:set var="numeroClaveConvSol" value="${status.count}" />
							</table>
						</div>
					</c:forEach>

					<div class="myDiv2">
						<table id="miTabla" align="center" >
							<tr>
								<td nowrap="nowrap" >
									<input type="hidden"  id="resguardo" name="resguardo" size="20" value="RG" readOnly="true"/>
									<input type="text" id="descResguardo" name="descResguardo" size="71" value="RESGUARDOS" onBlur="ponerMayusculas(this)" disabled="true" class="imput" style="background-color: #DADFDE; text-align: left; color: black;"/>
								</td>
							</tr>
							<tr>
								<td>
									<div style="width: 480px; height: 250px">
										<table align="center">
											<tr>
												<td class="label" align="left" style="font-weight: bold;">
													<label for="lblClave" style="color: black;">CLAVE </label>
												</td>
												<td class="label" align="left" style="font-weight: bold;">
													<label for="lblDescripcion" style="color: black;">DESCRIPCI&Oacute;N</label>
												</td>
												<td class="label" align="left" style="font-weight: bold;">
													<label for="lblInporte" style="color: black;">&nbsp;&nbsp;IMPORTE</label>
												</td>
											</tr>

											<tr>
												<td>
													<input type="hidden" id="resguardoRG" name="resguardoRG" size="8"  value="RG" readOnly="true" />
													<input type="text"  id="claveRG" name="claveRG" size="10" value="-------" style="text-align: left; border: 0;" onBlur="ponerMayusculas(this)" readOnly="true"/>
												</td>

												<td>
													<input type="text" id="descripcionRG" name="descripcionRG" style="text-align: left; border: 0;" size="35" value="RESGUARDOS" readOnly="true"/>
												</td>

												<td>
													<input type="text"  id="importeRG" name="importeRG" size="12" style="text-align: right" esMoneda="true" readOnly="true"/>
												</td>
											</tr>

											<tr>
												<td>
												</td>
												<td align="right" style="font-weight: bold;">
													<label style="color: black;" for="lbltotalImporte">TOTAL: $</label>
												</td>
												<td >
													<input type="text" id="totalImporteRG" name="totalImporteRG" size="12" readonly="true" style="text-align: right" esMoneda="true" value="0" />
												</td>
											</tr>
										</table>
									</div>
								</td>
							</tr>
						</table>
					</div>

					<div class="myDiv2" id="divDeudaComercial">
						<table id="miTabla" align="center" >
							<tr>
								<td nowrap="nowrap" >
									<input type="hidden"  id="deudaCasaComercial" name="deudaCasaComercial" size="20" value="DC" readOnly="true"/>
									<input type="text" id="descDeudaCasaComercial" name="descDeudaCasaComercial" size="71" value="DEUDAS CASAS COMERCIALES" onBlur="ponerMayusculas(this)" disabled="true" class="imput" style="background-color: #DADFDE; text-align: left; color: black;"/>
								</td>
							</tr>

							<tr>
								<td>
									<div style="width: 480px; height: 250px">
										<table align="center">
											<tr>
												<td class="label" align="left" style="font-weight: bold;">
													<label for="lblClave" style="color: black;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
												</td>
												<td class="label" align="left" style="font-weight: bold;">
													<label for="lblDescripcion" style="color: black;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
												</td>
												<td class="label" align="left" style="font-weight: bold;">
													<label for="lblInporte" style="color: black;">&nbsp;&nbsp;IMPORTE</label>
												</td>
											</tr>

											<c:forEach items="${listaCasaComercial}" var="deudaComercial" varStatus="statusDC">
												<tr id="renglonDC${statusDC.count}" name="renglonDC">
													<td>
														<input type="hidden"  id="casaComercialID{statusDC.count}" name="casaComercialID" size="20" value="${deudaComercial.casaComercialID}" readOnly="true"/>
														<input type="text"  id="claveDC{statusDC.count}" name="claveDC" size="10" value="" style="text-align: left; border: 0;" onBlur="ponerMayusculas(this)" readOnly="true"/>
													</td>

													<td>
														<input type="text" id="descripcionDC${statusDC.count}" name="descripcionDC" style="text-align: left; border: 0;" size="35" value="${deudaComercial.nombreCasaCom}" readOnly="true"/>
													</td>
													<td>
														<input type="text" id="importeDC${statusDC.count}" name="importeDC" size="12" style="text-align: right" esMoneda="true" value="${deudaComercial.montoCasaComercial}" readOnly="true"/>
													</td>
												</tr>
												<c:set var="numDeudaComer" value="${statusDC.count}" />
											</c:forEach>

											<tr>
												<td>
												</td>
												<td align="right" style="font-weight: bold;">
													<label style="color: black;" for="lbltotalImporte">TOTAL: $</label>
												</td>
												<td >
													<input type="text" id="totalImporteDC" name="totalImporteDC" size="12" readonly="true" style="text-align: right" esMoneda="true" value="0" />
													<input type="hidden" id="resguardoDC" name="resguardoDC" size="8"  value="DC" readOnly="true" />
													<input type="hidden" value="${numDeudaComer}" name="numeroDC" id="numeroDC" />
												</td>
											</tr>
										</table>
									</div>
								</td>
							</tr>
						</table>
					</div>
				</tbody>
				<input type="hidden" value="${numeroClaveConvSol}" name="numero" id="numero" />
		</fieldset>
	</c:when>
</c:choose>

<script type="text/javascript">
	consultaClavePresupConvGrid();
	consultaDeudaComercial();
	sumaTotalImporteRG();

	/* ============ METODO DE CONSULTA DE GRID DE CLAVES PRESUPUESTALES ========= */
	function consultaClavePresupConvGrid(){
		var institNominaID = $('#institNominaID').val();
		var convenioNominaID = $('#convenioNominaID').val();

		contador = 1;
		$('tr[name=renglonClasif]').each(function() {
			var numero = this.id.substr(13,this.id.length);
			var jqIdAsi = eval("'nomClasifClavPresupID" + numero+ "'");
			var nomClasifClavPresupID = document.getElementById(jqIdAsi).value;

			var divGridClave = eval("'gridClavePresupConv" + numero+ "'");

			var params = { };

			if ($('#estatus').val() == "A" ) {
				params['tipoLista'] = 2;
				params['nomCapacidadPagoSolID'] = $('#nomCapacidadPagoSolID').val();
			}else{
				params['tipoLista'] = 4;
			}

			params['nomClasifClavPresupID'] = nomClasifClavPresupID;
			params['institNominaID'] = institNominaID;
			params['convenioNominaID'] = convenioNominaID;

			$.post("clavesConvCapacidadPagoConvGrid.htm", params, function(data){
				if(data.length > 0) {
					$('#' + divGridClave).html(data);
					$('#' + divGridClave).show();
					consultaMontosPresupPorSolicitud(nomClasifClavPresupID);
					agregaFormatoControles(divGridClave);
				}else{
					$('#' + divGridClave).html("");
					$('#' + divGridClave).show();
				}
			});
			contador = parseInt(contador + 1);
		});
	}

	/* =========== METODO DE CONSULTA DE MONTO COMERCIAL ============*/
	function consultaDeudaComercial(){
		var tipoCredito =  $('#tipoCreditoID').val();

		if(tipoCredito != "N"){
			var numeroDC =  $('#numeroDC').val();
			var totalImporteDC = parseFloat(0);
			var importeDC  = parseFloat(0);

			for(var i = 1; i <= numeroDC; i++){
				importeDC  = parseFloat(0);
				var jqImporteDC = eval("'importeDC" + i + "'");
					importeDC = document.getElementById(jqImporteDC).value;
					importeDC = importeDC.replace(/,/g, "");

				if(importeDC != "" && importeDC != null && importeDC > 0 ){
					importeDC = parseFloat(importeDC);
				}else{
					importeDC = parseFloat(0);
				}
				totalImporteDC = totalImporteDC + importeDC;
			}

			$('#totalImporteDC').val(totalImporteDC);
			$('#totalImporteDC').formatCurrency({
				positiveFormat: '%n',
				roundToDecimalPlace: 2
			});
			$('#divDeudaComercial').show();
		}else{
			$('#divDeudaComercial').hide();
		}
	}

	/* ============== METODO DE MONTO RESGUARDO ========= */
	function sumaTotalImporteRG(){
		var montoResguardo = $('#montoResguardoConvenio').val();
			montoResguardo = montoResguardo.replace(",","");

		var numero = $('#resguardoRG').val();

		if(numero == "RG"){
			$('#importeRG').val(montoResguardo);
			$('#importeRG').formatCurrency({
				positiveFormat: '%n',
				roundToDecimalPlace: 2
			});

			$('#totalImporteRG').val(montoResguardo);
			$('#totalImporteRG').formatCurrency({
				positiveFormat: '%n',
				roundToDecimalPlace: 2
			});
		}
	}

	/* =========== METODO DE CONSULTA DE LOS MONTOS DE CLAVES YA REGISTRADO ============== */
	function consultaMontosPresupPorSolicitud(nomClasifClavPresupID){
		var nomCapacidadPagoSolID = $('#nomCapacidadPagoSolID').val();
		if (nomCapacidadPagoSolID > 0){
			var importeTotal = parseFloat(0);
			contador = 1;
			$('tr[name=renglonClave]').each(function() {
				var jqIdAsiNomClavePresupID = eval("'" + nomClasifClavPresupID + "nomClavePresupID" + contador+ "'");

				var jqIdAsiImporte = eval("'" + nomClasifClavPresupID + "importe" + contador+ "'");
				var nomClavePresupID = document.getElementById(jqIdAsiNomClavePresupID).value;

				var jqTotalImporte = eval("'totalImporte" + nomClasifClavPresupID+ "'");

				var detCapacidadPagoSolBeanCon = {
					'clavePresupID' : nomClavePresupID,
					'nomCapacidadPagoSolID' : nomCapacidadPagoSolID,
					'clasifClavePresupID' : nomClasifClavPresupID
				};

				if (nomClavePresupID != '' && !isNaN(nomClavePresupID)) {
					nomDetCapacidadPagoSolServicio.consulta(1, detCapacidadPagoSolBeanCon,{ async: false,callback : function(detCapacidadPago) {
						if (detCapacidadPago != null) {
							$('#' + jqIdAsiImporte).val(detCapacidadPago.monto);
							importeTotal = importeTotal + parseFloat(detCapacidadPago.monto);
						}else{
							$('#' + jqIdAsiImporte).val("0.00");
						}
					}});
				}

				$('#' + jqTotalImporte).val(importeTotal);
				$('#' + jqTotalImporte).formatCurrency({
					positiveFormat: '%n',
					roundToDecimalPlace: 2
				});
				contador = parseInt(contador + 1);
			});
		}
	}

</script>


<style>
	.myDiv {
		text-align: center;
		width: 500px;
	}

	.myDiv2 {
		text-align: center;
		float:left;
		width: 500px;
		margin: 2px;
		border: #C1C6C6 1px solid;
	}

	.myDiv3 {
		text-align: center;
		float:right;
	}

	.imput{
		text-align: center;
		font-weight: bold;
		height: 25px;
	}

</style>