<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>

<html>
<head>
</head>

<body>
	<br/>
	<c:set var="tipoLista"  value="${listaResultado[0]}"/>
	<c:set var="listaResultado" value="${listaResultado[1]}"/>
	
	<table id="miTabla" border="0" >
		<c:choose>
			<c:when test="${tipoLista == '45'}">
				<tbody>						
					<c:forEach items="${listaResultado}" var="creditosLis" varStatus="estado">	
						<tr id="renglons${estado.count}" name="renglons">											 
						  	<td>
						  		<input  id="creditoID${status.count}" name="lcreditos" size="13" value="${creditosLis.creditoID}" readOnly="true" style="text-align:center;"  />
						  	</td>
						  	<td>
						  		<input  id="cuentaID${status.count}" name="lcuentas" size="13" value="${creditosLis.cuentaID}" readOnly="true" style="text-align:center;"  />
						  	</td>	
						  	<td>
						  		<input  id="comFaltaPago${status.count}" name="lcomFaltaPago${status.count}" size="13" value="${creditosLis.comFaltaPago}" readOnly="true" style="text-align:center;"  />
						  	</td>
						  	<td>
						  		<input  id="comSeguroCuota${status.count}" name="lcomSeguroCuota${status.count}" size="13" value="${creditosLis.comSeguroCuota}" readOnly="true" style="text-align:center;"  />
						  	</td>	
						  	<td>
						  		<input  id="comAperturaCred${status.count}" name="lcomAperturaCred${status.count}" size="13" value="${creditosLis.comAperturaCred}" readOnly="true" style="text-align:center;"  />
						  	</td>
						  	<td>
						  		<input  id="comAnualLin${status.count}" name="lcomAnualLin${status.count}" size="13" value="${creditosLis.comAnualLin}" readOnly="true" style="text-align:center;"  />
						  	</td>				 	  				
						</tr>					
					</c:forEach>
				</tbody>
			</c:when>
		</c:choose>
	</table>
	
	
</body>
</html>