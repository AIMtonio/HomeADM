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
	<c:set var="regulatorioI0391"  value="${listaResultado}"/>
		
		<input type="button" id="agregaDias" value="Agregar" class="botonGral" tabindex="2" onClick="agregarRegistro()"/>

		<input type="hidden" id="menuID" name="menuID" value="1"/>
		 	<div>
		 		<br>
				<table id="miTabla" class="tablaRegula"  border="0" cellpadding="0" cellspacing="0" style="width: 3200px;">
					<tbody>	
						
						<tr>
							<td class="label"> 
						   		<label for="lblEntidad">Entidad con la que se realiza la inversión</label> 
							</td>
							<td class="label"> 
						   		<label for="lblEmisora">Emisora</label> 
							</td>
							<td class="label"> 
						   		<label for="lblSerie">Serie</label> 
							</td>
							<td class="label"> 
						   		<label for="lblFormaAdqui">Forma de Adquisición</label> 
							</td>
							<td class="label"> 
						   		<label for="lblFormaAdqui">Tipo Instrumento</label> 
							</td>
							<td class="label"> 
						   		<label for="lblClasifConta">Clasificación Contable</label> 
							</td>
							<td class="label"> 
						   		<label for="lblFechaContra">Fecha de Contratación</label> 
							</td>
							<td class="label"> 
						   		<label for="lblFechaVencim">Fecha de Vencimiento</label> 
							</td>
							<td class="label"> 
						   		<label for="lblNumeroTitu">Número de Títulos</label> 
							</td>
							<td class="label"> 
						   		<label for="lblCostoAdqui">Costo de Adquisición</label> 
							</td>
							<td class="label"> 
						   		<label for="lblTasaInteres">Tasa de Interés,<br> cupón o premio</label> 
							</td>
							<td class="label"> 
						   		<label for="lblGrupoRiesgo">Grupo de Riesgo</label> 
							</td>
							<td class="label"> 
						   		<label for="lblValuacion">Valuación Directa Vector</label> 
							</td>
							<td class="label"> 
						   		<label for="lblResValuacion">Resultado por Valuación</label> 
							</td>

							<td class="label"> 
						   		<label for="lbl"></label> 
							</td>
						</tr>					
						<c:forEach items="${regulatorioI0391}" var="registro" varStatus="status">
							<tr id="renglon${status.count}" name="renglon">
								<td nowrap>
								<input type="hidden" id="consecutivoID${status.count}" name="consecutivoID" size="6" 
											value="${status.count}" />	
								<input type="text" id="entidad${status.count}" maxlength="150"  name="lEntidad" size="8" onkeyup="buscaEntidad(this.id)"
																				onblur="consultaEntidad(this.id)" value="${registro.entidad}" class="display: inline-block" />	
								<input type="text" id="nombreentidad${status.count}" readonly="" disabled="" name="nombreentidad" size="30" value="${registro.entidad}" class="display: inline-block" />
								</td>
								<td nowrap>
								<input type="text" id="emisora${status.count}" maxlength="7"  name="lEmisora"  onblur="ponerMayusculas(this);" size="10" value="${registro.emisora}"/>
								</td>
								<td nowrap>
								<input type="text" id="serie${status.count}" maxlength="10" name="lSerie" onblur="ponerMayusculas(this);" size="10" value="${registro.serie}"/>
								</td>
								<td nowrap>
								<input type="hidden" id="sformaAdqui${status.count}"  name="sformaAdqui" size="20" value="${registro.formaAdqui}"/>
									<select name="lFormaAdqui" id="formaAdqui${status.count}" onchange="validaReporto(this.id);" >
									</select>
								</td>
								<td nowrap>
								<input type="hidden" id="stipoInstru${status.count}"  name="stipoInstru" size="20" value="${registro.tipoInstru}"/>
									<select name="lTipoInstru" id="tipoInstru${status.count}" >
									</select>
								</td>
								<td nowrap>
								<input type="hidden" id="sclasfConta${status.count}"  name="sclasfConta" size="20" value="${registro.clasfConta}"/>
									<select name="lClasfConta" id="clasfConta${status.count}" >
									</select>
								</td>
								<td nowrap>
								<input type="text" id="fechaContra${status.count}" maxlength="8" name="lFechaContra" size="12" onblur="esFechaValida(this.value,this.id)" value="${registro.fechaContra}" />
								</td>
								<td nowrap>
								<input type="text" id="fechaVencim${status.count}"  maxlength="8" name="lFechaVencim" size="12" onblur="esFechaValida(this.value,this.id)" value="${registro.fechaVencim}" />
								</td>
								<td nowrap>
								<input type="text" id="numeroTitu${status.count}" maxlength="21" name="lNumeroTitu" size="20" onkeyPress="return validaSoloNumeros(event);" style="text-align:right;" value="${registro.numeroTitu}"/>
								</td>
								<td nowrap>
								<input type="text" id="costoAdqui${status.count}" maxlength="21" name="lCostoAdqui" size="20" onkeyPress="return validaSoloNumeros(event);" style="text-align:right;" value="${registro.costoAdqui}"/>
								</td>
								<td nowrap>
								<input type="text" id="tasaInteres${status.count}" maxlength="6" path="lTasaInteres" name="lTasaInteres" style="text-align:right;" onBlur="evaluaTasa(this)" size="12" value="${registro.tasaInteres}"/><label class="label">%</label>
								</td>
								<td nowrap>
								<input type="hidden" id="sgrupoRiesgo${status.count}"  name="sgrupoRiesgo" size="10" value="${registro.grupoRiesgo}"/>
									<select name="lGrupoRiesgo" id="grupoRiesgo${status.count}" >
									</select>
								</td>
								<td nowrap>
								<input type="text" id="valuacion${status.count}" maxlength="21" name="lValuacion" size="21" style="text-align:right;" onkeyPress="return validaSoloNumeros(event);" value="${registro.valuacion}"/>
								</td>
								<td nowrap>
								<input type="text" id="resValuacion${status.count}" maxlength="21" name="lResValuacion" size="21" style="text-align:right;" onkeyPress="return validaSoloNumeros(event);" onblur="validaValor(this.id);" value="${registro.resValuacion}"/>
								</td>

							  	<td nowrap>
							  		<input type="button" name="eliminar" id="${status.count}"  value="" class="btnElimina" onclick="eliminarRegistro(this.id)" />
							  		 <input type="button" name="agrega" id="agrega${status.count}"  value="" class="btnAgrega" onclick="agregarRegistro()"/>
							  	</td>
							  						
							</tr>
							 
							
						</c:forEach>
					
					</tbody>

				</table>
				<br>
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
