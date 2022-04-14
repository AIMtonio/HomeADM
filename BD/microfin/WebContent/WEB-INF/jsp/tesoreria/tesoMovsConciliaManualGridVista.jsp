<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="listaResultado" value="${listaResultado[1]}"/>

<fieldset class="ui-widget ui-widget-content ui-corner-all">
<leyend>Movimientos</leyend>
	<table border="0" width="100%">
		<tr>
			<td class="label" align="center">
			 <label for="lblmovi">Cancelar</label>
			</td>
		    <td class="label" align="center">
		        <label for="lblmovi">#</label>
		    </td>
		    <td class="separador"></td>
		    <td class="label" align="center">
		        <label for="lblfechaOp">Fecha Operaci&oacute;n</label>
		    </td>
		    <td class="separador"></td>
		    <td class="label" align="center">
		        <label for="lbldesc">Descripci&oacute;n</label>
		    </td>
		    <td class="separador"></td>
		    <td class="label" align="center">
		        <label for="lblrefer">Referencia</label>
		    </td>
		    <td class="separador"></td>
		    <td class="label" align="center">
		        <label for="lbltip">Naturaleza</label>
		    </td>
		    <td class="separador"></td>
		    <td class="label" align="center">
		        <label for="lblmonto">Monto</label>
		    </td>
		    <td class="separador"></td>
		    <td class="label" align="center">
		        <label for="lbltipomov">Tipo Movimiento <br>Conciliación</label>
		    </td>
		    <td class="separador"></td>
		    <td class="label" colspan="2" align="center">
		        <label for="blctacont">Cuenta <br>Contable</label>
		    </td>
		    <td class="separador"></td>
		    <td class="label" align="center">
		    	<label for="lblCentroCostos">C. Costos</label>
		    </td>
		</tr>
		<c:forEach items="${listaResultado}" var="movs"   varStatus="status">
		<tr>
			<td align="center">
				<input type="checkbox"  id="check${status.count}" name="check" class="cb"/>
			</td>
		    <td class="label" align="center">
		        <input type="text" id="numero${status.count}" name="numero" value="${status.count}"
		        	 size="3" disabled="disabled" readonly="readonly"/>
		        <input type="hidden" id="folioCargaID${status.count}"	name="listaFolioCargaID"
		        	 size="3" value="${movs.folioCargaID}" />
		    </td>
		    <td class="separador"></td>
		    <td align="center">
		        <input type="text" id="fechaOperacion${status.count}" name="listaFechaOperacion"
		        	 size="12" value="${movs.fechaOperacion}" readonly="readonly"/>
		    </td>
		    <td class="separador"></td>
		    <td class="label" align="center">
		        <input type="text" id="descripcionMov${status.count}" name="listaDescripcionMov"
		        	 size="35" value="${movs.descripcionMov}"  readonly="readonly"/>
		    </td>
		    <td class="separador"></td>
		    <td align="center">
		        <input type="text" id="referenciaMov${status.count}" name="listaReferenciaMov"
		        	 size="15" value="${movs.referenciaMov}"  readonly="readonly"/>
		    </td>
		    <td class="separador"></td>
		    <td align="center">
		        <input type="text" id="natMovimiento${status.count}" name="listaNatMovimiento"
		        	 size="2" value="${movs.natMovimiento}" readonly="readonly"/>
		    </td>
		    <td class="separador"></td>
		    <td class="label" align="center">
		        <input type="text" id="montoMov${status.count}" name="listaMontoMov"  readonly="readonly"
		        	 size="14" value="${movs.montoMov}" style="text-align: right" />
		    </td>
		    <td class="separador"></td>
		    <td align="center">
		    	<select id="tipoMov${status.count}" name="listaTipoMov"
		    		onchange="validaFechaMovSeleccionado(this.id,${status.count});" >
					<option value="">SELECCIONAR</option>
				</select>
		    </td>
		    <td class="separador"></td>
		    <td colspan="0" align="center" id="tdEdiCtaCon${status.count}">
		        <input type="text" id="cuentaMayor${status.count}" name="listaCuentaMayor"
		        	 size="5" value="" disabled="disabled" readonly="readonly"/>
		    </td>
		    <td align="center" id="tdEdiCtaConEditable${status.count}">
	        	<input type="text" id="cuentaCon${status.count}" name="listaCuentaCon"
	        		onblur="ocultarLista(${status.count});" onkeypress="listaMaestroCuentas(${status.count});"
	        		 size="23" value=""  maxlength="25" />
	        </td>
	        <td align="center" colspan="2" id="tdNoEdiCtaCon${status.count}" style="display: none;">
	        	<input type="text" id="cuentaContableNoEdit${status.count}" name="listaCuentaContable1"
		        	 size="33" readonly="readonly"/>
		    </td>
		    <td>
		    <input type="hidden" id="cuentaContable${status.count}" name="listaCuentaContable"
	        	 size="33" readonly="readonly"/>
		    </td>
		    <td align="center">
		   		 <input type="text" id="cCostos${status.count}" name="listaCentroCosto" maxlength="10" onblur="consultaCentroCostos(this.id)"  onkeypress="listaCentroCostos(${status.count});"
		    	 size="8" value="" />
		   	 </td>
		   	</tr>
		</c:forEach>
	</table>

</fieldset>
<script type="text/javascript">
examinaChecks();
function examinaChecks(){
	if($('#numero1').length){
		habilitaBoton('guardar');
		$('#cerrar').hide(200);
	}else{
		deshabilitaBoton('guardar');
		$('#cerrar').hide(200);
	}
}

$('.cb').click(function(){
	var jqCampo = eval("'#"+this.id+"'");
	var campoCheckeado = false;

	var ID = this.id.substring(5);
	var jqTipoMov = eval("'#tipoMov"+ID+"'");
	var jqCtaContable = eval("'#cuentaContable1"+ID+"'");
	var jqCCostos = eval("'#cCostos"+ID+"'");
	var jqCtaCon  = eval("'#cuentaCon"+ID+"'");

	if($(jqCampo).is(':checked')){

		$(jqTipoMov).val('');
		$(jqCtaContable).val('');
		$(jqCCostos).val('');
		$(jqCtaCon).val('');

		$(jqTipoMov).attr('disabled',true);
		$(jqCtaContable).attr('disabled',true);
		$(jqCCostos).attr('disabled',true);
		$(jqCtaCon).attr('disabled',true);

		deshabilitaBoton('guardar');
		$('#cerrar').show(250);
	}else{
		$(jqTipoMov).attr('disabled',false);
		$(jqCtaContable).attr('disabled',false);
		$(jqCCostos).attr('disabled',false);
		$(jqCtaCon).attr('disabled',false);

		$('input[name=check]').each(function(){
			var jqCheck = eval("'#"+this.id+"'");
			if($(jqCheck).is(':checked')){
				campoCheckeado=true;
			}
		});
		if(!campoCheckeado){
			habilitaBoton('guardar');
			$('#cerrar').hide(250);
		}
	}
});

</script>

