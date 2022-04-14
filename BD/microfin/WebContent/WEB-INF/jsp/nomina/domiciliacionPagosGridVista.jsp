<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="listaResultado"  value="${listaPaginada.pageList}"/>
<%! int numFilas = 0; %>
<%! int counter = 7; %>
	<table border="0" width="100%">
		<tr>
			<td>
				<fieldset class="ui-widget ui-widget-content ui-corner-all">   
					<legend>Detalle</legend>             	
					  <table id="miTabla" border="0" width="100%">
					  	<tbody>			
						<tr>
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
						        <label for="lblMonto">Monto Exigible</label> 
						    </td>
						</tr>	
						<c:forEach items="${listaResultado}" var="genera" varStatus="estatus">
						<% numFilas=numFilas+1; %>
						<% counter++; %>
						<tr id="renglon${estatus.count}" name="renglon">
						    <td  nowrap="nowrap">
						    	<input type="hidden" id="consecutivoID${estatus.count}" name="consecutivoID" size="6" value="${genera.consecutivoID}" />	
 						        <input type="hidden" id="numTransaccionGrid${estatus.count}" name="numTransaccionGrid" size="6" value="${genera.numTransaccion}" />	 
 						        <input type="hidden" id="foliosID${estatus.count}" name="foliosID" size="6" value="${genera.folioID}" />	 
						        <input type="text" id="clienteID${estatus.count}" name="listaClienteID" size="12" value="${genera.clienteID}" readonly="readonly"/> 
						    </td>  
						    <td  nowrap="nowrap">
						        <input type="text" id="nombreCliente${estatus.count}" name="nombreCliente" size="50" value="${genera.nombreCliente}" readonly="readonly"/> 
						    </td>  
						    <td  nowrap="nowrap">
						    	<input type="hidden" id="institucionID${estatus.count}" name="listaInstitucionID" size="3" value="${genera.institucionID}" readonly="readonly"/>
						        <input type="text" id="nombreInstitucion${estatus.count}" name="nombreInstitucion" size="30" value="${genera.nombreInstitucion}" readonly="readonly"/> 
						    </td> 
						    <td  nowrap="nowrap">
						        <input type="text" id="cuentaClabe${estatus.count}" name="listaCuentaClabe" size="20" value="${genera.cuentaClabe}" readonly="readonly"/> 
						    </td> 
						    <td  nowrap="nowrap">
						        <input type="text" id="creditoID${estatus.count}" name="listaCreditoID" size="15" value="${genera.creditoID}" readonly="readonly"/> 
						    </td> 
						    <td  nowrap="nowrap">
						        <input type="text" id="montoExigible${estatus.count}" name="listaMontoExigible" size="15" value="${genera.montoExigible}" 
						        readonly="readonly" style="text-align: right"/> 
						    </td> 
						    <td>
						  		<input type="button" name="eliminar" id="${estatus.count}"  value="" class="btnElimina"  onclick="eliminaDetalle(${genera.consecutivoID})"/>	
						  	</td>
						</tr>
						</c:forEach> 
						</tbody>        
						
					</table>
					<input type="hidden" id="numTab" value="<%=counter %>"/>
					<input type="hidden" id="numeroFila" value="<%=numFilas %>"/>
					<% numFilas=0; %>
					<% counter=7; %>
					<c:if test="${!listaPaginada.firstPage}">
						 <input onclick="consultaDomiciliacionPagos('previous')" type="button" value="" class="btnAnterior" />
					</c:if>
					<c:if test="${!listaPaginada.lastPage}">
						 <input onclick="consultaDomiciliacionPagos('next')" type="button" value="" class="btnSiguiente" />
					</c:if>	
				</fieldset>
			</td>
		</tr>
	</table>

	
	<script type="text/javascript">
	function consultaDomiciliacionPagos(pageValor){
		if($('#esNominaSI').is(':checked')){	
			var esNomina = $('#esNominaSI').val();
		}else{
			var esNomina = $('#esNominaNO').val();
		}	
		
		var params = {};
	  	params['esNomina'] 			= esNomina;
	  	params['institNominaID'] 	= $('#institNominaID').val();
	  	params['convenioID'] 		= $('#convenioID').val();
		params['clienteID']			= $('#clienteID').val();
		params['frecuencia']		= $('#frecuencia').val();
		params['numTransaccion']	= $('#numTransaccion').val();
		params['tipoLista'] 		= 4;
		params['page'] = pageValor ;
		
		$.post("generaDomiciliacionPagosGrid.htm", params, function(data){	
				if(data.length >0) {
					$('#gridGeneraDomicialiacionPagos').html(data);
					$('#gridGeneraDomicialiacionPagos').show();
					habilitaBoton('generarExcel');
					habilitaBoton('generarLayout');
					habilitaBoton('buscar');
					habilitaControl('busqueda');	
					agregaMonedaFormat();
					$('#trBuscar').show();
					$('#trGenerar').show();
				}else{
					$('#gridGeneraDomicialiacionPagos').html(data);
					$('#gridGeneraDomicialiacionPagos').show();
					deshabilitaBoton('generarExcel');
					deshabilitaBoton('generarLayout');
					deshabilitaBoton('buscar');
					deshabilitaControl('busqueda');
					$('#trBuscar').hide();
					$('#trGenerar').hide();
				}
				agregaFormatoControles('formaGenerica');
		});
	}
	
	/**
	 * Función para agregar formato Moneda a los Montos Exigibles
	 */
	function agregaMonedaFormat(){ 
	 $('input[name=listaMontoExigible]').each(function() {		
			numero= this.id.substr(13,this.id.length);
			varMontoExigigle = eval("'#montoExigible"+numero+"'");
			$(varMontoExigigle).formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
		});	 
	 }
	
	
	
	</script>