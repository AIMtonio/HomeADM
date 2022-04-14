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

<c:set var="pasoVencido"  value="${listaResultado}"/>
		
		<input type="button" id="agregaDias" value="Agregar" class="botonGral" tabindex="2" onClick="agregarDiasPasoVencido()"/>
			<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%">
				<tbody>	
					<tr>
						<td class="label"> 
					   		<label for="lblFrecuencia">Frecuencia</label> 
						</td>
						<td class="label"> 
					   		<label for="lblDias">Dias Paso Vencido</label> 
						</td>
						<td class="label"> 
					   		<label for="lbl"></label> 
						</td>
					</tr>					
					<c:forEach items="${pasoVencido}" var="dias" varStatus="status">
						<tr id="renglon${status.count}" name="renglon">
							<td>
								<input type="hidden" id="consecutivoID${status.count}" name="consecutivoID" size="6" 
										value="${status.count}" />	
																			
						  	
								<input type="hidden" id="frecuencias${status.count}" name="lfrecuencias" value="${dias.frecuencia}" >
								<select id="frecuencia${status.count}" name="lfrecuencia"  type="select" onBlur="verificaSeleccionado(this.id)" >
										<option value="">Seleccione</option>	
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
										<option value="U">PAGO ÚNICO</option>	
										<option value="L">LIBRE</option>
										<option value="I">PAGO ÚNICO/INT. PERIODICO</option>								
								</select>   
						  	</td> 
						  	<td> 
								<input  type="text" id="diasPasoVencido${status.count}" name="ldiasPasoVencido" size="10" 
										value="${dias.diasPasoVencido}" /> 							 							
						  	</td> 	
						  	<td>
						  		<input type="button" name="eliminar" id="${status.count}"  value="" class="btnElimina" onclick="eliminarDiasPasoVencido(this.id)" />
						  		 <input type="button" name="agrega" id="agrega${status.count}"  value="" class="btnAgrega" onclick="agregarDiasPasoVencido()"/>
						  	</td>
						  						
						</tr>
						
						
					</c:forEach>
				
				</tbody>

			</table>
			<table align="right">
			<tr>
				<td align="right">
					<input type="submit" id="grabar" name="grabar" class="submit" value="Grabar"  />
					<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="tipoTransaccion"/>
					<input type="hidden" id="tipoBaja" name="tipoBaja" value="tipoBaja"/>								
				</td>
				
			</tr>
		</table>	
			 <input type="hidden" value="0" name="numero" id="numero" />


</body>
</html>
