<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>  

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="campoLista" value="${listaResultado[1]}"/>
<c:set var="horaseg" value="${listaResultado[2]}"/>

<table id="tablaLista" >
	<c:choose>
		<c:when test="${tipoLista == '1'}">
			<tr><td></td><td></td><td></td><td></td></tr>
			<tr><td colspan = "2"><input id="muestraOculta" type="button" onclick="if($('#mapaColores').is(':visible')){$('#mapaColores').hide();$('#muestraOculta').val('Muestra Notación');}else{$('#mapaColores').show();$('#muestraOculta').val('Oculta Notación');}" value="Muestra Notación"/></td></tr>
			<tr id="mapaColores" style="display:none">
			<td colspan="4">
				<table>
					<tr>
					<td colspan="4">
					<font size=2>Notación para Identificar los Colores</font>
					</td>
					</tr>
					<tr>
					<td bgcolor="#39DA69" width="5%"></td>
					<td >
					<font size=2>Aplicación de Recursos a Conceptos de Crédito</font>
					</td>
					<td bgcolor="#06BAA8" width="5%"></td>
					<td>
					<font size=2>Desarrollo de Proyecto (Avance de Obra/Comercialización)</font>
					</td>
					</tr>
					<tr>
					<td bgcolor="#FBFFA3"></td>
					<td>
					<font size=2>Cobranza Preventiva</font>
					</td>
					<td bgcolor="#0BFDF9"></td>
					<td>
					<font size=2>Cobranza Administrativa</font>
					</td>
					</tr>
					<tr>
					<td bgcolor="#D7D7D7"></td>
					<td>
					<font size=2>Cobranza Extrajudicial</font>
					</td>
					<td bgcolor="#FFC186"></td>
					<td>
					<font size=2>Cobranza Judicial</font>
					</td>
					</tr>
					<tr>
					<td bgcolor="#567890"></td>
					<td>
					<font size=2>Supervisión de Acreditados</font>
					</td>
					<td bgcolor="#9F7EFA"></td>
					<td>
					<font size=2>Auditoría Interna/Externa</font>
					</td>
					</tr>
					<tr>
					<td bgcolor="#DACEFA"></td>
					<td>
					<font size=2>PLD Seguimiento</font>
					</td>
					<td bgcolor="#FA7474"></td>
					<td>
					<font size=2>Encuesta de Abandono</font>
					</td>
					</tr>
					<tr>
					<td bgcolor="#F98F62"></td>
					<td>
					<font size=2>Encuesta de Satisfacción</font>
					</td>
					<td bgcolor="#16A0AA"></td>
					<td>
					<font size=2>Cobranza Telefónica (Preventiva)</font>
					</td>
					</tr>
					<tr>
					<td bgcolor="#39BCFD"></td>
					<td>
					<font size=2>Cobranza Telefónica (Administrativa)</font>
					</td>
					<td bgcolor="#2C71CB"></td>
					<td>
					<font size=2>Cobranza Telefónica (Extrajudicial)</font>
					</td>
					</tr>
				</table>
			</td>
			</tr> 
			 
			<tr id="encabezadoLista">
				<td>Hora</td>
				<td>Descripción (Clic sobre la actividad para ver detalle)</td>
				
			</tr>
			<c:forEach items="${horaseg}" var="horas" >
				<tr onclick="detalleLista(${horas.segtoPrograID});">
					<td>${horas.horaProgramada}</td>
					<td style="cursor: pointer">${horas.descripcion}</td>
					<c:choose>
						<c:when test="${horas.alcance == 'G'}"> 
							<td><img src="images/AlertIcon.png" width="20" height="20" alt="Necesita Atencion Del Gestor"></img></td>
						</c:when>
					</c:choose>
					<c:choose>
						<c:when test="${horas.estatus == 'T'}"> 
							<td><img src="images/palomita.png" width="20" height="20" alt="Tarea Terminada"></img></td>
						</c:when>
					</c:choose>
					<c:choose>
						<c:when test="${horas.estatus == 'V'}">
							<td><img src="images/icono-x.png" width="20" height="20" alt="Tarea Vencida"></img></td>
						</c:when>
					</c:choose>
					<c:choose>
						<c:when test="${horas.estatus == 'F'}">
							<td><img src="images/help-icon.gif" width="20" height="20" alt="Tarea Pendiente"></img></td>
						</c:when>
					</c:choose>
				</tr>
			</c:forEach>
		</c:when>

		<c:when test="${tipoLista == '2'}">
			<tr id="encabezadoLista">
				<td>Seguimiento</td>
				<td>Descripci&oacute;n</td>
				<td>Fecha</td>
			</tr>
			<c:forEach items="${horaseg}" var="filas" >
				<tr onclick="cargaValorLista('${campoLista}', '${filas.segtoPrograID}');">
					<td>${filas.segtoPrograID}</td>
					<td>${filas.descripcion}</td>
					<td>${filas.horaProgramada}</td>
				</tr>
			</c:forEach>
		</c:when>
		<c:when test="${tipoLista == '3'}"> 
			<c:forEach items="${horaseg}" var="filas" >
				<tr onclick="cargaValorLista('${campoLista}', '${filas.segtoPrograID}');">
					<td>
					<input name = "segmentoID" id="'${filas.segtoPrograID}'" value = "'${filas.segtoPrograID}'" ></input>
					<input name = "fecha" id="fecha'${filas.segtoPrograID}'" value = "'${filas.fechaProgramada}'"></input>
					<input name = "hora" value = "hora'${filas.horaProgramada}'"></input>
					<input name = "descripcion" value = "descripcion'${filas.descripcion}'"></input>
					<input name = "recomendacion" value = "recomendacion'${filas.recomendacionSegtoID}'"></input>
					</td>
				</tr>
			</c:forEach>
		</c:when>
  	</c:choose>
</table>