<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head>

</head>
<body>
<br/>
  <fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend><label>Reporte</label></legend>
	<c:set var="regulatorioD0842"  value="${listaResultado}"/>
	
		
		<input type="button" id="agregaDias" value="Agregar" class="botonGral" tabindex="2" onClick="agregarRegistro()"/>

		<input type="hidden" id="menuID" name="menuID" value="1"/>
		 	<div >
		 		<br>
				<table id="miTabla" class="tablaRegula"  border="0" cellpadding="0" cellspacing="0" style="width: 3200px;">
					<tbody>	
						
						<tr>
						
							<td class="label"> 
						   		<label for="lblNumeroIden">Número de<br>Identificación</label> 
						   		
							</td>
							<td class="label"> 
						   		<label for="lblTipoPrestamista">Tipo de Prestamista</label> 
							</td>
							<td class="label"> 
						   		<label for="lblClavePrestamista">Clave del Prestamista    </label> 
							</td>
							<td class="label"> 
						   		<label for="lblNumeroContrato">Número de Contrato</label> 
							</td>
							<td class="label"> 
						   		<label for="lblNumeroCuenta">Número de Cuenta</label> 
							</td>
							<td class="label"> 
						   		<label for="lblFechaContra">Fecha de Contratación</label> 
							</td>
							<td class="label"> 
						   		<label for="lblFechaVencim">Fecha de Vencimiento</label> 
							</td>
							<td class="label"> 
						   		<label for="lblTasaAnual">Tasa Anual de Pago</label> 
							</td>
							<td class="label"> 
						   		<label for="lblplazo">Plazo</label> 
							</td>
							<td class="label"> 
						   		<label for="lblPeriodoPago">Periodicidad del Plan<br>de Pagos Acordado</label> 
							</td>
							<td class="label"> 
						   		<label for="lblMontoRecibido">Monto Original Recibido</label> 
							</td>
							<td class="label"> 
						   		<label for="lblTipoCredito">Tipo de Crédito</label> 
							</td>
							<td class="label"> 
						   		<label for="lblDestino">Destino</label> 
							</td>
							<td class="label"> 
						   		<label for="lblTipoGarantia">Tipo de Garantía</label> 
							</td>
							<td class="label"> 
						   		<label for="lblMontoGarantia">Monto o Valor de la Garantía</label> 
							</td>
							<td class="label"> 
						   		<label for="lblFechaPago">Fecha del Pago <br>Inmediato Siguiente </label> 
							</td>
							<td class="label"> 
						   		<label for="lblMontoPago">Monto del Pago<br> Inmediato Siguiente </label> 
							</td>
							<td class="label"> 
						   		<label for="lblClasificaCortLarg">Clasificación de Corto<br> o Largo PLazo </label> 
							</td>
							<td class="label"> 
						   		<label for="lblSalInsoluto">Saldo Insoluto<br> del Préstamo </label> 
							</td>

							<td class="label"> 
						   		<label for="lbl"></label> 
							</td>
						</tr>					
						<c:forEach items="${regulatorioD0842}" var="registro" varStatus="status">
							<tr id="renglon${status.count}" name="renglon">
								<td>
								<input type="hidden" id="consecutivoID${status.count}" name="consecutivoID"  size="6" 
											value="${status.count}" />	
								<input type="text" id="numeroIden${status.count}" maxlength="12"  name="lnumeroIden" onkeyPress="soloLetrasYNum(this,this.id)"  size="12" value="${registro.numeroIden}"/>
								</td>
								<td>
								<input type="hidden" id="stipoPrestamista${status.count}"  name="stipoPrestamista" size="20" value="${registro.tipoPrestamista}"/>
									<select name="ltipoPrestamista" id="tipoPrestamista${status.count}" onblur="validaCampoSelect(this,this.id)">
									</select>
								</td>
								<td>
								<input type="text" id="clavePrestamista${status.count}"  maxlength="25"  name="lclavePrestamista" onkeyup="buscaEntidad(this.id)"  size="15" value="${registro.clavePrestamista}"/>
								</td>
								<td>
								<input type="text" id="numeroContrato${status.count}" maxlength="12"  name="lnumeroContrato"  onkeyPress="soloLetrasYNum(this,this.id)" onblur="ponerMayusculas(this);" size="15" value="${registro.numeroContrato}"/>
								</td>
								
								<td>
								<input type="text" id="numeroCuenta${status.count}" maxlength="12"  name="lnumeroCuenta"  onkeyPress="soloLetrasYNum(this,this.id)" onblur="ponerMayusculas(this);" size="15" value="${registro.numeroCuenta}"/>
								</td>	
								
								<td>
								<input type="text" id="fechaContra${status.count}" maxlength="12" name="lfechaContra" size="12" onblur="esFechaValida(this.value,this.id)" value="${registro.fechaContra}" />
								</td>
								<td>
								<input type="text" id="fechaVencim${status.count}"  maxlength="12" name="lfechaVencim" size="12" onblur="esFechaValida(this.value,this.id)" value="${registro.fechaVencim}" />
								</td>
								<td>
								<input type="text" id="tasaAnual${status.count}" maxlength="8" path="lfasaAnual" name="ltasaAnual"  style="text-align:right;" onblur="validarTasa(this.id,this.value),soloCantidad(this,this.id)" size="12" value="${registro.tasaAnual}"/><label class="label">%</label>
								</td>
								<td>
								<input type="text" id="plazo${status.count}" maxlength="4" name="lplazo" onkeyPress="soloNum(this,this.id)" size="10" style="text-align:right;" value="${registro.plazo}"/>
								</td>
								<td>
								<input type="hidden" id="speriodoPago${status.count}"  name="speriodoPago" size="20" value="${registro.periodoPago}"/>
									<select name="lperiodoPago" id="periodoPago${status.count}" onblur="validaCampoSelect1(this,this.id)">
									</select>
								</td>
								<td>
								<label class="label">$</label><input type="text" id="montoRecibido${status.count}" maxlength="28" onblur="soloCantidad(this,this.id)" name="lmontoRecibido" esMoneda="true" size="20" style="text-align:right;" value="${registro.montoRecibido}"/>
								</td>
								<td>
								<input type="hidden" id="stipoCredito${status.count}"  name="stipoCredito" size="20" value="${registro.tipoCredito}"/>
									<select name="ltipoCredito" id="tipoCredito${status.count}" onblur="validaCampoSelect2(this,this.id)">
									</select>
								</td>
								<td>
								<input type="hidden" id="sdestino${status.count}"  name="sdestino" size="20" value="${registro.destino}"/>
									<select name="ldestino" id="destino${status.count}" onblur="validaCampoSelect3(this,this.id)">
									</select>
								</td>
								<td>
								<input type="hidden" id="stipoGarantia${status.count}"  name="stipoGarantia" size="20" value="${registro.tipoGarantia}"/>
									<select name="ltipoGarantia" id="tipoGarantia${status.count}" onblur="validaCampoSelect4(this,this.id)">
									</select>
								</td>
								<td>
								<label class="label">$</label><input type="text" id="montoGarantia${status.count}" maxlength="28" name="lmontoGarantia" onblur="soloCantidad(this,this.id)" esMoneda="true" size="20" style="text-align:right;" value="${registro.montoGarantia}"/>
								</td>
								<td>
								<input type="text" id="fechaPago${status.count}"  maxlength="12" name="lfechaPago" size="12" onblur="esFechaValida(this.value,this.id)" value="${registro.fechaPago}" />
								</td>
								<td>
								<label class="label">$</label><input type="text" id="montoPago${status.count}" maxlength="28" name="lmontoPago" onblur="soloCantidad(this,this.id)" esMoneda="true"  size="20" style="text-align:right;" value="${registro.montoPago}"/>
								</td>
								<td>
								<input type="hidden" id="sclasificaCortLarg${status.count}"  name="sclasificaCortLarg" size="20" value="${registro.clasificaCortLarg}"/>
									<select name="lclasificaCortLarg" id="clasificaCortLarg${status.count}" onblur="validaCampoSelect5(this,this.id)">
									</select>
								</td>
								<td>
								<input type="text" id="salInsoluto${status.count}" maxlength="28" name="lsalInsoluto" size="20"  onblur="soloCantidad(this,this.id)" esMoneda="true" value="${registro.salInsoluto}"/>
								</td>
							  	<td>
							  	<input type="button" name="eliminar" id="${status.count}"  value="" class="btnElimina" onclick="eliminarRegistro(this.id)" />
							  	 <input type="button" name="agrega" id="agrega${status.count}"  value="" class="btnAgrega" onclick="agregarRegistro()"/>
							  	</td>
							  						
							</tr>
							 
							
						</c:forEach>
					
					</tbody>

				</table>
			
			 </div>
			<table align="right">
			<tr>
				<td align="right">
					<input type="submit" id="grabar" name="grabar" class="submit" value="Grabar"  />
					<button id="generar" name="generar" class="submit" type="button"  >Generar</button>
					<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="1"/>
					<input type="hidden" id="tipoBaja" name="tipoBaja" value="tipoBaja"/>								
				</td>
				
			</tr>
		</table>	
	 	<input type="hidden" value="0" name="numero" id="numero" />

 
</fieldset>
</body>
</html>
