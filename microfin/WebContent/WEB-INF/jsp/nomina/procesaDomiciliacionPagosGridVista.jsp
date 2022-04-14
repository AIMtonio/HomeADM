<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="listaPaginada" value="${listaResultado[0]}" />
<c:set var="listaResultado" value="${listaPaginada.pageList}"/>

	<table border="0" width="100%">
		<tr>
			<td>
				<fieldset class="ui-widget ui-widget-content ui-corner-all">   
					<legend>Detalle</legend>             	
					  <table border="0" width="100%">
					  	<tbody>			
						<tr>
						    <td class="label" nowrap="nowrap">
						        <label for="lblFolio">Folio</label> 
						    </td>
						    <td class="label" nowrap="nowrap">
						        <label for="lblCliente">No. Cliente</br></label> 
						    </td>
						    <td class="label" nowrap="nowrap">
						        <label for="lblNombre">Nombre</label> 
						    </td>
						    <td class="label" nowrap="nowrap">
						        <label for="lblInstitucion">Instituci&oacute;n</label> 
						    </td>
						    <td class="label" nowrap="nowrap">
						        <label for="lblCuentaClabe">Cuenta Clabe</label> 
						    </td>
						    <td class="label" nowrap="nowrap">
						        <label for="lblCredito">No. Cr&eacute;dito</label> 
						    </td>
						    <td class="label" nowrap="nowrap">
						        <label for="lblMonto">Monto</label> 
						    </td>
						    <td class="label" nowrap="nowrap">
						        <label for="lblMontoPendiente">Monto Pendiente</label> 
						    </td>
						    <td class="label" nowrap="nowrap">
						        <label for="lblEstatus">Estatus</label> 
						    </td>
						    <td class="label" nowrap="nowrap">
						        <label for="lblComentario">Comentario</label> 
						    </td>
						</tr>	
						<c:forEach items="${listaResultado}" var="procesos" varStatus="estatus">
						<tr id="renglon${estatus.count}" name="renglon">
						    <td  nowrap="nowrap">
						        <input type="text" id="folioID${estatus.count}" name="listaFolioID" size="12" value="${procesos.folioID}" readonly="readonly" /> 
						    </td>
						    <td  nowrap="nowrap">
						        <input type="text" id="clienteID${estatus.count}" name="listaClienteID" size="12" value="${procesos.clienteID}" readonly="readonly"/> 
						    </td>  
						    <td  nowrap="nowrap">
						        <input type="text" id="nombreCliente${estatus.count}" name="nombreCliente" size="50" value="${procesos.nombreCliente}" readonly="readonly"/> 
						    </td>  
						    <td  nowrap="nowrap">
						    	<input type="hidden" id="institucionID${estatus.count}" name="listaInstitucionID" size="3" value="${procesos.institucionID}" readonly="readonly"/>
						        <input type="text" id="nombreInstitucion${estatus.count}" name="nombreInstitucion" size="30" value="${procesos.nombreInstitucion}" readonly="readonly"/> 
						    </td> 
						    <td  nowrap="nowrap">
						        <input type="text" id="cuentaClabe${estatus.count}" name="listaCuentaClabe" size="20" value="${procesos.cuentaClabe}" readonly="readonly"/> 
						    </td> 
						    <td  nowrap="nowrap">
						        <input type="text" id="creditoID${estatus.count}" name="listaCreditoID" size="12" value="${procesos.creditoID}" readonly="readonly" /> 
						    </td>
						    <td  nowrap="nowrap">
						        <input type="text" id="monto${estatus.count}" name="listaMonto" size="15" value="${procesos.monto}" readonly="readonly" style="text-align: right"/> 
						    </td>
						    <td  nowrap="nowrap">
						        <input type="text" id="montoPendiente${estatus.count}" name="listaMontoPendiente" size="15" value="${procesos.montoPendiente}" readonly="readonly" style="text-align: right" /> 
						    	<input type="hidden" id="montoAplicado${estatus.count}" name="listaMontoAplicado" size="15" value="${procesos.montoAplicado}" readonly="readonly" style="text-align: right" /> 
						    </td>
						    <td  nowrap="nowrap">
						        <input type="text" id="estatus${estatus.count}" name="listaEstatus" size="8" value="${procesos.estatus}" readonly="readonly" /> 
						    </td>
						     <td  nowrap="nowrap">
						        <input type="text" id="comentario${estatus.count}" name="listaComentario" size="65" value="${procesos.comentario}"  readonly="readonly"/> 
						        <input type="hidden" id="claveDomiciliacion${estatus.count}" name="listaClaveDomiciliacion" size="3" value="${procesos.claveDomiciliacion}" readonly="readonly"/>
						    </td>  
						</tr>
						</c:forEach> 
						</tbody>        
						
					</table>
					<c:if test="${!listaPaginada.firstPage}">
						 <input onclick="consultaGridDomiciliacionProcesar('previous')" type="button" value="" class="btnAnterior" />
					</c:if>
					<c:if test="${!listaPaginada.lastPage}">
						 <input onclick="consultaGridDomiciliacionProcesar('next')" type="button" value="" class="btnSiguiente" />
					</c:if>	
				</fieldset>
			</td>
		</tr>
	</table>

	
	<script type="text/javascript">
	function consultaGridDomiciliacionProcesar(pageValor){
		var params = {};
		params['tipoLista'] = 1;
		params['page'] = pageValor ;
		
		$.post("procesaDomiciliacionPagosGrid.htm", params, function(data){		
			if(data.length >0) {
				$('#gridProcesaDomiciliacionPagos').html(data);
				$('#gridProcesaDomiciliacionPagos').show();
				$('#procesar').focus();
				agregaMonedaFormat();
			}else{
				$('#gridProcesaDomiciliacionPagos').html(data);
				$('#gridProcesaDomiciliacionPagos').show();
			}
		});
	}
	
	/**
	 * Función para agregar fromato Moneda a los Montos
	 */
	function agregaMonedaFormat(){ 
		$('input[name=listaMonto]').each(function() {		
			numero= this.id.substr(5,this.id.length);
			varMonto = eval("'#monto"+numero+"'");
			$(varMonto).formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
	 	});	 
	 
	 	$('input[name=listaMontoPendiente]').each(function() {		
			numero= this.id.substr(14,this.id.length);
			varMonto = eval("'#montoPendiente"+numero+"'");
			$(varMonto).formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
	 	});	 
	 
	 	$('input[name=listaMontoAplicado]').each(function() {		
			numero= this.id.substr(13,this.id.length);
			varMonto = eval("'#montoAplicado"+numero+"'");
			$(varMonto).formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
		});
	 }
	</script>