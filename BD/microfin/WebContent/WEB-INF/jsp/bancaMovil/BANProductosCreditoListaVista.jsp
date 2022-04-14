<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="listaResultado"  value="${productosCreditosLis}"/>
<input type="hidden" id="numeroDetalle" name="numeroDetalle" value="1"/>
<input type="hidden" id="datosGrid" name="datosGrid"/>
<div id="productosCredito" style="width:100%;">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend class="ui-widget ui-widget-header ui-corner-all">Productos de Cr&eacute;dito</legend>
		<table border="0" width="100%">
					<tr>
						<td colspan="5">
							<table align="left">
								<tr>
									<td align="left">
										<input type="button" id="agregaProducto" value="Agregar" class="submit" tabIndex="19" onClick="agregaNuevoProducto()"/>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
				<br>
			<table id="miTabla" border="0" width="100%">
				<tr id="encabezadoLista">
					<td style="text-align: center;">Producto</td>
					<td style="text-align: center;">Descripcion</td>
					<td style="text-align: center;">Destino</td>
					<td style="text-align: center;">Descripcion</td>
					<td style="text-align: center;">Clasificacion</td>
				</tr>
				<c:forEach items="${productosCreditosLis}" var="producto" varStatus="status">
					<tr id="renglon${status.count}" name="renglon">
						<input type="hidden" id="consecutivoID${status.count}"  name="consecutivoID" size="3" value="${status.count}" readOnly="true" disabled="true"/>
						
						<td align="center">
							<input  type="text" id="producCreditoID${status.count}" name="lisProducCredito" value="${producto.productoCreditoID}"tabindex="20"  onkeyPress="listaProd(this.id)" onblur="consultaProductosCreditoAyuda(this.id)" style="text-align: center; width: 100% " />
						</td>
					  	<td>
							<input type="text" id="descripcionProd${status.count}" name="descripcionProd" readOnly="true" value="${producto.desCredito}" style="text-align: left; width: 100% " readOnly="true"/>
					  	</td>
					  	<td align="center">
							<input  type="text" id="destinoCreditoID${status.count}" name="lisDestinoCredito" value="${producto.destinoCreditoID}"tabindex="21"  onkeyPress="listaDestinos(this.id)" onblur="consultaDestinoCredito(this.id)" style="text-align: center; width: 100% " />
						</td>
					  	<td>
							<input type="text" id="descripcionDestino${status.count}" name="descripcionDestino" readOnly="true" value="${producto.desDestino}" style="text-align: left; width: 100% " readOnly="true"/>
					  	</td>
					  	<td>
							<input type="hidden" id="clasificacion${status.count}" name="lisClasificacion" readOnly="true" value="${producto.clasificacionDestino}" style="text-align: left; width: 100% " readOnly="true"/>
							<input type="text" id="desClasificacion${status.count}" name="desClasificacion" readOnly="true" value="${producto.desClasificacionDestino}" style="text-align: left; width: 100% " readOnly="true"/>
					  	</td>
					  	
					  	<td>
					  		<input type="button" name="agregaE" id="agregaE${status.count}" value="" class="btnAgrega" onclick="agregaNuevoProducto();" tabindex="22" />
							<input type="button" name="eliminaE" id="eliminaE${status.count}" value="" class="btnElimina" onclick="eliminarProducto(this.id);" tabindex="23" />
					  	</td>
					</tr>
				</c:forEach>
			</table>
			<input type="hidden" value="0" name="numeroProducto" id="numeroProducto" />
			<input type="hidden" value="0" name="producID" id="producID" />

			<input type="hidden" id="datosGridProducto" name="datosGridProducto" size="100" />
			<input type="hidden" id="datosGridBajaProducto" name="datosGridBajaProducto"  value="" size="100" />
		 </fieldset>
	</div>
</html>
<script type="text/javascript">
	esTab=true;
	
	$(':text').focus(function() {		
		esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;	
		}
	});

</script>