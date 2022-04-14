<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="tipoLista" value="${listaResultado[0]}" />
<c:set var="listaPaginada" value="${listaResultado[1]}" />
<c:set var="listaResultado"  value="${listaPaginada.pageList}"/>
<input type="hidden" id="numeroDetalle" name="numeroDetalle" value="1"/>
<input type="hidden" id="datosGrid" name="datosGrid"/>
	
	<div id="productosCredito" style="width:100%;">
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
			<c:choose>
				<c:when test="${tipoLista == '3'}">
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<table id="miTabla" border="0" width="100%">
							<tr id="encabezadoLista">
								<td style="text-align: center;">Producto</td>
								<td style="text-align: center;">Descripci&oacute;n</td>
								<td style="text-align: center;">Destino</td>
								<td style="text-align: center;">Descripci&oacute;n</td>
								<td style="text-align: center;">Clasificaci&oacute;n</td>
							</tr>
							<c:forEach items="${listaResultado}" var="producto" varStatus="status">
								<tr id="renglon${producto.productoCreditoFWID}" name="renglon">
									<input type="hidden" id="consecutivoID${producto.productoCreditoFWID}"  name="consecutivoID" size="3" value="${producto.productoCreditoFWID}" disabled="true"/>
									<input type="hidden" id="productoCreditoFWID${producto.productoCreditoFWID}"  name="lisProductoCreditoFWID" size="3" value="${producto.productoCreditoFWID}"/>
									<td align="center">
										<input  type="text" id="producCreditoID${producto.productoCreditoFWID}" name="lisProducCredito" value="${producto.productoCreditoID}"tabindex="20"  onkeyPress="listaProd(this.id)" onblur="consultaProductosCreditoAyuda(this.id)" style="text-align: center; width: 100% " />
									</td>
								  	<td>
										<input type="text" id="descripcionProd${producto.productoCreditoFWID}" name="descripcionProd" readOnly="true" value="${producto.desCredito}" style="text-align: left; width: 100% " readOnly="true"/>
								  	</td>
								  	<td align="center">
										<input  type="text" id="destinoCreditoID${producto.productoCreditoFWID}" name="lisDestinoCredito" value="${producto.destinoCreditoID}"tabindex="21"  onkeyPress="listaDestinos(this.id)" onblur="consultaDestinoCredito(this.id)" style="text-align: center; width: 100% " />
									</td>
								  	<td>
										<input type="text" id="descripcionDestino${producto.productoCreditoFWID}" name="descripcionDestino" readOnly="true" value="${producto.desDestino}" style="text-align: left; width: 100% " readOnly="true"/>
								  	</td>
								  	<td>
										<input type="hidden" id="clasificacion${producto.productoCreditoFWID}" name="lisClasificacion" readOnly="true" value="${producto.clasificacionDestino}" style="text-align: left; width: 100% " readOnly="true"/>
										<input type="text" id="desClasificacion${producto.productoCreditoFWID}" name="desClasificacion" readOnly="true" value="${producto.desClasificacionDestino}" style="text-align: left; width: 100% " readOnly="true"/>
								  	</td>
								  	
								  	<td>
								  		<input type="button" name="agregaE" id="agregaE${status.count}" value="" class="btnAgrega" onclick="agregaNuevoProducto();" tabindex="22" />
										<input type="button" name="eliminaE" id="eliminaE${producto.productoCreditoFWID}" value="" class="btnElimina" onclick="eliminarProducto(this.id);" tabindex="23" />
								  	</td>
								</tr>
							</c:forEach>
						</table>
						<c:if test="${!listaPaginada.firstPage}">
							 <input onclick="consultaPagina('previous')" type="button" value="" class="btnAnterior" />
						</c:if>
						<c:if test="${!listaPaginada.lastPage}">
							 <input onclick="consultaPagina('next')" type="button" value="" class="btnSiguiente" />
						</c:if>
					</fieldset>
				</c:when>
			</c:choose>
		<input type="hidden" value="0" name="numeroProducto" id="numeroProducto" />
		<input type="hidden" value="0" name="producID" id="producID" />
		<input type="hidden" value="" id="productoCreditoFWIDs" name="productoCreditoFWIDs"/>
		<input type="hidden" value="0" id="esModificado" name="esModificado"/>
		<input type="hidden" id="datosGridProducto" name="datosGridProducto" size="100" />
		<input type="hidden" id="datosGridBajaProducto" name="datosGridBajaProducto"  value="" size="100" />
	
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
	
	function consultaPagina(pageValor){
		var params = {};
		params['perfilID'] = parametroBean.perfilUsuario;
		params['page'] = pageValor;
		params['numRegistros'] = 15;
		
		var cambiosPen = $('#esModificado').val();
		if(cambiosPen == "0"){
			$.post("listaFWProductosCredito.htm", params, function(data){		
				
				if(data.length >0) {
					$('#gridProductosCreditos').html(data);
					$('#gridProductosCreditos').show();

				}else{
					$('#gridProductosCreditos').html("");
					$('#gridProductosCreditos').show(); 
				}
			});
		}else{
			mensajeSis("Hay cambios pendientes por modificar.");
		}
		
		
	}

</script>