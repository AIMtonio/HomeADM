<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
<head>

</head>
<body>
</br>

<c:set var="listaResultado"  value="${listaResultado}"/>

<form id="gridResumenAct" name="gridResumenAct">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend>Estadísticas</legend>	

			<table class="altColorFilasTabla" id="alternacolor" border="4" cellpadding="3" cellspacing="0">
				<tbody>	
					<tr id="encabezadoGrid" >
			     		<td width="75%"> 
					   <b><center>	Estatus </center>	</b>
						</td>
						<td width="13%"> 
					    <b><center>		Total </center>	</b>
						</td>
				  		<td width="12%">  
			          <b><center>		Porcentaje </center>	</b>
			     		</td> 
					</tr>
					 <tr name="renglon">
			     		<td > 
					   	ENVIADOS
						</td>
						<td > 
					   	<center>	${listaResultado[0].totalEnviados}</center>	
						</td>
				  		<td> 
			         	<center>	100 % </center>	
			     		</td> 
					</tr> 
					
					<c:forEach items="${listaResultado}" var="resumenAct" varStatus="status">
						<tr id="renglon${status.count}" name="renglon">
						  	<td> 
						  		<dd> 
								${resumenAct.estatus}
								</dd>
						  	</td>
						  	<td> 
								<center>	${resumenAct.numero}</center>	
						  	</td>
						  	<td> 
								<center>	${resumenAct.porcentaje} % </center>	
						  	</td>
						</tr>
					</c:forEach>
					 <tr name="renglon">
			     		<td > 	
					   	PROGRAMADOS
						</td>
						<td > 
					   	<center>	${listaResultado[0].programados}</center>	
						</td>
				  		<td> 
			         <center>		100 % </center>	
			     		</td> 
					</tr> 
				</tbody>
				
			</table>
				
		</fieldset>
	
</form>
</body>
</html>
