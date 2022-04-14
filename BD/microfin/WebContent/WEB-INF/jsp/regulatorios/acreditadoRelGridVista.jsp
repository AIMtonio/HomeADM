<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>

<html>
<head>

<style>
	#cajaTipoRelacion{
		box-shadow: 0px 0px 4px rgba(52, 57, 58, 0.77);
	}
	.tablaLista{
		font-size: 0.8em; 
		background: #fff;
		

	}
	.tablaLista td:hover{
		
	}

	.tablaLista td{
		border-bottom: 1px solid #929494;
		padding: 4px; 
		cursor: pointer;
	}

	.hoverTbl{
		background: #3980cb;
		color: #fff;
	}

	#miTabla textarea {
	    resize: none;
	}

</style>

</head>

<body>
<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="listaResultado" value="${listaResultado[1]}"/>

		<table id="miTabla" border="0">
			<c:choose>
				<c:when test="${tipoLista == '1'}">
				<tbody>	
					<tr align="center">
						<td class="label">
							<label><s:message code="safilocale.cliente"/></label>
						</td>
						<td class="label">
							<label>Empleado</label>
						</td>
						<td class="label">
							<label>Nombre</label>
						</td>
						<td class="label">
							<label>Puesto</label>
						</td>
						<td class="label">
							<label>Tipo Acreditado Relacionado</label>
						</td>
					</tr>
					
					<c:forEach items="${listaResultado}" var="acreditadoLis" varStatus="status">
					<tr id="renglons${status.count}" name="renglons">
						<td>
							<input type="hidden" id="consecutivo${status.count}" name="consecutivo" size="4" value="${status.count}" />
							<input type="text" id="clienteID${status.count}" name="lisClienteID" size="13" value="${acreditadoLis.clienteID}" tabindex="${status.count}" maxlength = "10" autocomplete="off"  onKeyUp="listaClientes(this.id);" onblur="consultaCliente(this.id);"/>							
						</td>
						<td>
							<input type="text" id="empleadoID${status.count}" name="lisEmpleadoID" size="13" value="${acreditadoLis.empleadoID}" tabindex="${status.count}" maxlength = "10" autocomplete="off" onKeyUp="listaEmpleados(this.id);" onblur="consultaEmpleado(this.id);"/>							
						</td>						 
						<td> 
							<input  type="text" id="nombre${status.count}" name="lisNombre" size="45" value="${acreditadoLis.nombre}" tabindex="${status.count}" onblur="ponerMayusculas(this)" autocomplete="off" readOnly="true" disabled="true"/> 							 							
						</td>						 
						<td> 
							<input  type="text" id="puesto${status.count}" name="lisPuesto" size="45" value="${acreditadoLis.puesto}" tabindex="${status.count}" onblur=" ponerMayusculas(this)" autocomplete="off" readOnly="true" disabled="true"/> 						 							
						</td>						
						<td>
							<input type="hidden" id="tipoAcredRel${status.count}" name="tipoAcredRel" size="10" value="${acreditadoLis.claveRelacionID}"  />
							<input type="hidden" id="claveRelacionID${status.count}" name="lisClaveRelacionID" size="10" value="${acreditadoLis.claveRelacionID}"  />																
							<textarea id="descripcionClave${status.count}" name="descripcionClave" onclick="muestraListaRelacion('claveRelacionID${status.count}','descripcionClave${status.count}')"  tabindex="${status.count}"  cols="80" rows="3" readonly="" style="background: #ddd; width: 510px" onblur="ocultaLista()">SELECCIONAR</textarea>

							<!--<select id="claveRelacionID${status.count}" name="lisClaveRelacionID" type="select"  tabindex="${status.count}" style="width:250px">
								<option value="">SELECCIONAR</option>							
							</select>-->
						</td>
						<td> 
							<input type="button" name="eliminar" id="${status.count}"  class="btnElimina" onclick="eliminarParametro(this.id)"  tabindex="${status.count}"/>
						</td> 
						<td>
							<input type="button" name="agregar" id="agregar${status.count}" class="btnAgrega" onclick="agregaNuevoParametro()"  tabindex="${status.count}"/>
						</td>
					</tr>
					</c:forEach>
				</tbody>
			</c:when>
		</c:choose>
	</table>
	
</body>
</html>	