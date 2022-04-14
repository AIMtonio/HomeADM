<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head>

</head>
<body>

<c:set var="listaPuntosConcepto"  value="${listaResultado}"/>				 
		
			<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%">
				<tbody>	
					<tr>
						<td class="label"  align="center"> </td>
						<td class="label"  align="center"> <label for="rangoInferior">&nbsp;&nbsp;&nbsp;&nbsp;Rango Inferior &nbsp;&nbsp;&nbsp;&nbsp;</label> </td>
						<td class="label"  align="center"> <label for="rangoSuperior">&nbsp;&nbsp;&nbsp;&nbsp; Rango Superior &nbsp;&nbsp;&nbsp;&nbsp;</label> </td>
						<td class="label"  align="center"> <label for="puntos">&nbsp;&nbsp;&nbsp;&nbsp; Puntos &nbsp;&nbsp;&nbsp;&nbsp;</label> </td>
						<td class="label"  align="center"> </td>
					</tr>					
					<c:forEach items="${listaPuntosConcepto}" var="rango" varStatus="status">
						<tr id="renglon${status.count}" name="renglon">
							<td align="center">
								<input type="hidden" id="consecutivoID${status.count}" name="lPuntosConcepID" size="6" value="${status.count}" />			
						  	</td> 
						  	<td align="center"> 
								<input  type="text" id="rangoInferior${status.count}" name="lRangoInferior" size="10" value="${rango.rangoInferior}" esMoneda="true" style="text-align:right;" onBlur="validarRangos(this.id)"/> 							 							
						  	</td> 
						  	<td align="center"> 
								<input  type="text" id="rangoSuperior${status.count}" name="lRangoSuperior" size="10" value="${rango.rangoSuperior}" esMoneda="true" style="text-align:right;" onBlur="validarRangos(this.id)"/> 							 							
						  	</td>
						  	<td align="center"> 
								<input  type="text" id="puntos${status.count}" name="lPuntos" size="10" value="${rango.puntos}" esMoneda="true" style="text-align:right;" onBlur="validarPuntos(this.id)"/> 							 							
						  	</td> 	
						  	<td align="center">
						  		<input type="button" name="eliminar" id="${status.count}"  value="" class="btnElimina" onclick="eliminarFila(this.id)" />
						  		 <input type="button" name="agrega" id="agrega${status.count}"  value="" class="btnAgrega" onclick="agregarFila()"/>
						  	</td>						  						
						</tr>
					</c:forEach>
				
			</tbody>

			</table>
			<table align="right">
				<tr>
					<td align="right">
						<input type="submit" id="grabarPuntos" class="submit" value="Grabar"  onclick="setTipoTransaccion()" />
						<input type="hidden" id="tipoTransaccionPuntos" name="tipoTransaccion" value=""/>							
					</td>					
				</tr>
			</table>	
		<input type="hidden" value="0" name="numero" id="numero" />
</body>
</html>
