<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>

<html> 
<head>
	<style type="text/css">
		/* Define the hover highlight color for the table row */
	    .selectableTable tr:hover {
	    	color:#000000;
	    	background-color:  #6acdea;
	    }
	    .trhover {
	    	color:#000000;
	        background-color:  #6acdea;
	    }
	</style>
	<script type="text/javascript">
		function tblConfiguracionServicioRowChanged(indiceFila) {
			$('#formaGenerica').validate().resetForm();
			var tabla = document.getElementById("tblServicios");
            var filas = tabla.getElementsByTagName("tr");
            var fila = {};
            for (var i = 0; i < filas.length; i++) {
                $(filas[i]).removeClass("trhover")
                if(indiceFila == i) {
                	fila = filas[i - 1];
                }
            }

			$(fila).addClass("trhover");
			var servicioID = $("#servicioID" + indiceFila).val();
			var clasificacionServ = $("#clasificacionServ" + indiceFila).val();
			console.log("servicioID:" + servicioID + " clasificacionServ:" + clasificacionServ);
			$.consultaConfiguracionServicio(servicioID, clasificacionServ);
		}
	</script>
</head>

<body>
	<c:set var="tipoLista"  value="${listaResultado[0]}"/>
	<c:set var="listaPaginada" value="${listaResultado[1]}" />
	<c:set var="cantidadRegistros" value="${listaResultado[2]}"/>
	<c:set var="listaResultado" value="${listaPaginada.pageList}"/>
	
	
	<table id="tblConfigServicios" border="0" cellpadding="0" cellspacing="0" width="100%" height="0%">
		<c:choose>
			<c:when test="${tipoLista == '1'}">
				<table cellspacing="0" cellpadding="0" width="100%" >
					<tr id="encabezadoLista">
						<td class="label" align="center">ServicioID</td>
						<td class="label" align="center">Servicio</td>
						<td class="label" align="center">TipoServicio</td>
					</tr>
				</table>
				<tr>
					<td>
						<div style="width:100%; height:100%; overflow:auto;">
							<table id="tblServicios" class="selectableTable" cellspacing="0" cellpadding="0" width="100%" >
								<c:choose>
									<c:when test="${cantidadRegistros > 0}">
										<c:forEach items="${listaResultado}" var="configServicio" varStatus="status">
											<tr id="renglons${status.count}" name="renglons" onclick="tblConfiguracionServicioRowChanged(${status.count})">
												<td nowrap="nowrap" width="33%">
													<label>${configServicio.servicioID}</label>
													<input type="hidden" id="servicioID${status.count}" value="${configServicio.servicioID}" />
												</td>
												<td width="33%">
													<label>${configServicio.servicio}</label>
												</td>
												<td width="33%">
													<label>${configServicio.nomClasificacion}</label>
													<input type="hidden" id="clasificacionServ${status.count}" value="${configServicio.clasificacionServ}" />
												</td>
											</tr>
										</c:forEach>
									</c:when>
									<c:otherwise>
										<tr><td colspan="3" align="center"><label>No se encontraron registros</label></td></tr>
									</c:otherwise>
								</c:choose>
							</table>  
						</div>
					</td>
				</tr>
			</c:when>			
		</c:choose>
	</table>
</body>
</html>