<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="listaPaginada" value="${listaResultado[1]}" />
<c:set var="listaResultado" value="${listaPaginada.pageList}"/>
<fieldset class="ui-widget ui-widget-content ui-corner-all">
  <table border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr>
		    <td class="label" nowrap="nowrap">
		        <label for="lblFolio">N&uacute;mero</label>
		    </td>
		    <td width="10px"></td>
		    <td nowrap="nowrap" class="label">
		        <label for="lblNumCredito">No. Cr&eacute;dito</label>
		    </td>
		     <td width="10px"></td>
		    <td nowrap="nowrap" class="label">
		        <label for="lblNumEmpleado">No. Empleado</label>
		    </td>
		    <td width="10px"></td>
		    <td nowrap="nowrap" class="label">
		        <label for="lblNomEmpleado">Nombre</label>
		    </td>
		    <td width="10px"></td>
		    <td class="label" nowrap="nowrap">
		        <label for="lblMonto">Monto Descuento</label>
		    </td>
		    <td width="10px"></td>
		    <td class="label" nowrap="nowrap">
		        <label for="lblProucto">Producto de Cr&eacute;dito</label>
		    </td>
		    <td width="10px"></td>
		    <td class="label" nowrap="nowrap">
		        <label for="lblseleccionar">Seleccionar Todos</label>
		    </td>
		</tr>
		<tr>
		    <td  nowrap="nowrap">
		    </td>
		    <td width="10px"></td>
		    <td  nowrap="nowrap">
		    </td>
		    <td width="10px"></td>
		    <td  nowrap="nowrap">
		    </td>
		    <td width="10px"></td>
		    <td  nowrap="nowrap">
		    </td>
		    <td width="10px"></td>
		    <td  nowrap="nowrap">
		    </td>
		    <td width="10px"></td>
		    <td  nowrap="nowrap">
		    </td>
		   <td width="10px"></td>
		   <td align="center"  nowrap="nowrap">
              	<input type="checkbox" id="seleccionaTodos" name="seleccionaTodos"  onclick="seleccionarTodos()"/>
              	 <input type="hidden" id="seleccionado${estatus.count}" name="listaSeleccionados"
		       value="N"/>
			</td>
		</tr>
		<c:forEach items="${listaResultado}" var="pagos"   varStatus="estatus">
		<tr>
		    <td  nowrap="nowrap">
		        <input type="text" id="folioNominaID${estatus.count}"	name="listaFolioNominaID"
		        	tabindex="100" size="11" value="${pagos.folioNum}" readonly="readonly" />
		    </td>
		    <td width="10px"></td>
		    <td  nowrap="nowrap">
		        <input type="text" id="creditoID${estatus.count}" name="listaCreditoID"
		        	tabindex="101" size="11" value="${pagos.creditoID}" readonly="readonly"/>
		    </td>
		    <td width="10px"></td>
		    <td  nowrap="nowrap">
		        <input type="text" id="clienteID${estatus.count}" name="listaClienteID"
		        	tabindex="101" size="11" value="${pagos.clienteID}" readonly="readonly"/>
		    </td>
		    <td width="10px"></td>
		    <td  nowrap="nowrap">
		        <input type="text" id="nomEmpleado${estatus.count}" name="listaNomEmpleado"
		        	tabindex="101" size="30" value="${pagos.nomEmpleado}" readonly="readonly"/>
		    </td>
		    <td width="10px"></td>
		    <td  nowrap="nowrap">
		        <input type="text" id="montoPagos${estatus.count}" name="listaMontoPagos" esMoneda="true"
		        	tabindex="101" size="12" value="${pagos.montoPagos}" readonly="readonly" style="text-align: right"/>
		    </td>
		    <td width="10px"></td>
		    <td  nowrap="nowrap">
		        <input type="text" id="productoCredito${estatus.count}" name="listaProductoCredito"
		        	tabindex="101" size="20" value="${pagos.productoCredito}" readonly="readonly"/>
		    </td>
		   <td width="10px"></td>
		   <td align="center"  nowrap="nowrap">
              	<input type="checkbox" id="seleccionaCheck${estatus.count}" name="seleccionaCheck"
              	onclick="sumaCheck(this.id, ${pagos.consecutivoID})"
              	${pagos.esSeleccionado == 'S' ? "checked" : ""}
              	${pagos.esAplicado == 'S' ? "disabled" : ""}
              	/>
              	<input type="hidden" id="seleccionado${estatus.count}" name="listaSeleccionadoss"  value="N"/>
		      	<input type="hidden" id="esSeleccionado${estatus.count}" name="listaEsSeleccionado" tabindex="101" size="30" value="${pagos.esSeleccionado}" />
		      	<input type="hidden" id="consecutivoID${estatus.count}" name="listaConsecutivoID" tabindex="101" size="30" value="${pagos.consecutivoID}" />
			</td>
		</tr>
		</c:forEach>
	</table>
	<c:if test="${!listaPaginada.firstPage}">
		 <input onclick="consultaGridPagosAntes('previous')" type="button" value="" class="btnAnterior" id="btnAnterior" />
	</c:if>
	<c:if test="${!listaPaginada.lastPage}">
		 <input onclick="consultaGridPagosDespues('next')" type="button" value="" class="btnSiguiente" id="btnSiguiente"/>
	</c:if>
</fieldset>
<script type="text/javascript">

		function consultaGridPagosAntes(pageValor) {
			var lista = ${tipoLista};
			var totalAcumulado = $('#totalPagos').asNumber();
            var EstFolio = $('#estatusPagoInst').val();

			var params = {};
			params['numFolio'] = $('#numFolio').val();
			params['tipoLista'] = lista;
			params['page'] = pageValor;
			params['institNominaID']	=	$('#institNominaID').val();


			var listaEsSeleccionado = '';
			$("input[name='listaEsSeleccionado']").each(function(){
  				listaEsSeleccionado = listaEsSeleccionado+$(this).val()+",";
			});

			var listaConsecutivoID = '';
			$("input[name='listaConsecutivoID']").each(function(){
  				listaConsecutivoID = listaConsecutivoID+$(this).val()+",";
			});

			params['listaConsecutivoID'] = listaConsecutivoID;
			params['listaEsSeleccionado'] = listaEsSeleccionado;
			$('#gridDescuento').hide();
			bloquearPantalla();
			$.post("aplicaPagosInstGrid.htm", params, function(data) {
				desbloquearPantalla();
				if (data.length > 0) {
					$('#gridDescuento').html(data);
					$('#gridDescuento').show();
					agregaMonedaFormat();
					validaMontos('', 0, '', '');
					
					if(EstFolio == 'A'){
                        habilitaControl('seleccionaTodos');
                    }else{
						deshabilitaControl('seleccionaTodos');
                    }
					
				} else {
					$('#gridDescuento').html("");
					$('#gridDescuento').show();
					$('#seleccionaTodos').attr('checked', false);
					deshabilitaControl('seleccionaTodos');
				}
			});
		}

		function consultaGridPagosDespues(pageValor) {
			var lista = ${tipoLista};
			var totalAcumulado = $('#totalPagos').asNumber();
            var EstFolio = $('#estatusPagoInst').val();
			var params = {};
			params['numFolio'] = $('#numFolio').val();
			params['tipoLista'] = lista;
			params['page'] = pageValor;
			params['institNominaID']	=	$('#institNominaID').val();

			var listaEsSeleccionado = '';
			$("input[name='listaEsSeleccionado']").each(function(){
  					listaEsSeleccionado = listaEsSeleccionado+$(this).val()+",";
			});

			var listaConsecutivoID = '';
			$("input[name='listaConsecutivoID']").each(function(){
  					listaConsecutivoID = listaConsecutivoID+$(this).val()+",";
			});

			params['listaConsecutivoID'] = listaConsecutivoID;
			params['listaEsSeleccionado'] = listaEsSeleccionado;


			$('#gridDescuento').hide();
			bloquearPantalla();
			$.post("aplicaPagosInstGrid.htm", params, function(data) {
				desbloquearPantalla();
				if (data.length > 0) {
					$('#gridDescuento').html(data);
					$('#gridDescuento').show();
					agregaMonedaFormat();
					validaMontos('', 0, '', '');
					
					if(EstFolio == 'A'){
                        habilitaControl('seleccionaTodos');
                    }else{
						deshabilitaControl('seleccionaTodos');
                    }
                    
				} else {
					$('#gridDescuento').html("");
					$('#gridDescuento').show();
					$('#seleccionaTodos').attr('checked', false);
					deshabilitaControl('seleccionaTodos');
				}
			});
		}
</script>
