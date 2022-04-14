<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head>
<!--  declaracion del recurso que se nombro en el xml para consultas -->
<script type="text/javascript" src="dwr/interface/rolesServicio.js"></script>

</head>
<body>
<br/>

<c:set var="frecTimbrarProduc"  value="${listaResultado}"/>
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend>Productos</legend>
		<input type="button" id="agregarFrec" name="agregarFrec" value="Agregar" class="botonGral" tabindex="3"  onClick="agregarNuevaFrecProduc()"/>
			<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%">
				<tbody>
					<tr border="0" cellpadding="0" cellspacing="0" width="100%">
						<td class="label" align="center">
					   		<label for="lbProductoCred">Número</label>
						</td>
						<td class="label" align="center">
					   		<label for="lblDescripcion">Producto de Crédito</label>
						</td>

						<td class="label">
					   		<label for="lbl"></label>
						</td>
					</tr>
					<c:forEach items="${frecTimbrarProduc}" var="frecTimbrar" varStatus="status">
						<tr id="renglon${status.count}" name="renglon">
							<td>
								<input type="hidden" id="consecutivoID${status.count}" name="consecutivoID" size="12"
										value="${status.count}"  />
								<input type="text" id="producCreditoID${status.count}" name="lproducCreditoID" size="12" value="${frecTimbrar.producCreditoID}" onkeypress="listaProductos(this.id)" onblur="validaProducCredi(this.id);"
								border="0" cellpadding="0" cellspacing="0" width="100%" align="center"/>
							</td>
						  	<td>
								<input  type="text" id="descripcion${status.count}" name="ldescripcion" size="60" readOnly="true"	value="${frecTimbrar.descripcion}" border="0" cellpadding="0" cellspacing="0" width="100%" align="center"/>
						  	</td>
						  	<td>
						  		<input type="button" name="eliminar" id="${status.count}"  value="" class="btnElimina" onclick="eliminarProducCredi(this.id)" />
						  		<input type="button" name="agrega" id="agrega${status.count}"  value="" class="btnAgrega" onclick="agregarNuevaFrecProduc()"/>
						  	</td>
						  	<input type="hidden" id="consecutivoID${status.count}" name="consecutivoID" size="6" value="${status.count}" />
						  	<input type="hidden" id="frecuencias${status.count}" name="lfrecuencias" value="${frecuencias.producCreditoID}" />

						</tr>


					</c:forEach>

				</tbody>

			</table>
			</fieldset>

			 <input type="hidden" value="0" name="numero" id="numero" />


</body>
</html>