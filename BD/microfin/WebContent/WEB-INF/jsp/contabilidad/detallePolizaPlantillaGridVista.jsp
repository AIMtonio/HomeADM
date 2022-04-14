<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head>

</head>
<body>
<br/>

<c:set var="listaResultado"  value="${listaResultado}"/>

<form id="gridDetalle" name="gridDetalle">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend>Movimientos</legend>	
		<input type="button" id="agregaDetalle" value="Agregar" class="botonGral" tabindex="7"/>
			<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%">
				<tbody>	
					<tr>
						<td class="label"> 
					   	<label for="lblNumero">Número</label> 
						</td>
						<td class="label"> 
							<label for="lblCR">C. Costos</label> 
				  		</td>	
						<td class="label"> 
							<label for="lblCuenta">Cuenta</label> 
				  		</td>
				  		<td class="label"> 
			         	<label for="lblReferencia">Referencia</label> 
			     		</td> 
			     		<td class="label"> 
			         	<label for="lblDescripcion">Descripción</label> 
			     		</td> 
			     		<td class="label"> 
			         	<label for="lblCargos">Cargos</label> 
			     		</td> 
			     		<td class="label"> 
			         	<label for="lblAbonos">Abonos</label> 
			     		</td> 
					</tr>
					
					<c:forEach items="${listaResultado}" var="detallePoliza" varStatus="status">
						<tr id="renglon${status.count}" name="renglon">
							<td> 
								<input id="consecutivoID${status.count}"  name="consecutivoID" size="6"  
										value="${status.count}"/> 
						  	</td> 
						  	<td> 
								<input id="centroCostoID${status.count}" onblur="consultaCentroCostos(${status.count})" name="centroCostoID" size="6" 
										value="${detallePoliza.centroCostoID}"/> 
						  	</td> 
						  	<td> 
								<input id="cuentaCompleta${status.count}" name="cuentaCompleta" size="20" 
										value="${detallePoliza.cuentaCompleta}"  onblur="maestroCuentasDescripcion(this.id,'desCuentaCompleta${status.count}')"/> 
						  	</td> 
						  	<td> 
								<input id="referencia${status.count}" name="referencia" size="20" 
										value="${detallePoliza.referencia}" maxlength="20"/> 
						  	</td> 
				     		<td> 
				         	<input id="descripcion${status.count}" name="descripcion" size="60"
				         			value="${detallePoliza.descripcion}" onblur=" ponerMayusculas(this)" /> 
				     		</td> 
							<td> 
				         	<input id="cargos${status.count}" name="cargos" size="11" align="right"
				         			value="${detallePoliza.cargos}" onBlur="sumaCifrasControlCargos(${status.count});" style="text-align:right;"  esMoneda="true"/> 
				     		</td> 
				     		<td> 
				         	<input id="abonos${status.count}" name="abonos" size="11" align="right"
				         			value="${detallePoliza.abonos}" onBlur="sumaCifrasControlAbonos(${status.count});" style="text-align:right;"  esMoneda="true"/> 
				     		<input type="button" name="elimina" id="${status.count}" value="" class="btnElimina" onclick="eliminaDetalle(this)"/>
    						<input type="button" name="agrega" id="agrega${status.count}" value="" class="btnAgrega" onclick="agregaNuevoDetalle()"/>
    						</td>
						</tr>
						<tr id="renglonDescripcion${status.count}" name="renglonDescripcion">
	   						<td colspan="2">&nbsp;</td>  
	  						<td colspan="5">
	  						<input id="desCuentaCompleta${status.count}" name="desCuentaCompleta" size="100" value="" readOnly="true" disabled="true"/>
	  						</td>
	   					</tr>
					</c:forEach>
				</tbody>
				<tr align="right">
					<td class="label" colspan="5"> 
				   	<br>
			     	</td>
				</tr>
				<tr align="right">
					<td colspan="5" id="contenidoAyuda"> 
				   	<label for="lblCiCtrl">Cifras de Control</label> 
					</td> 	
					<td align="right"> 
		         	<input id="ciCtrlCargos" name="ciCtrlCargos" size="11" value="" esMoneda="true"  style="text-align:right;"  readOnly="true"/> 
			     	</td> 
			     	<td align="left"> 
		         	<input id="ciCtrlAbonos" name="ciCtrlAbonos" size="11" value="" esMoneda="true" style="text-align:right;"  readOnly="true"/> 
			     	</td> 
			     	<td > 
			     	</td>
				</tr>
				<tr>
					<td colspan="5" align="right"id="contenidoAyuda" > 
				   	<label for="lblDiferencia">Diferencia</label> 
					</td> 	
			     	<td align="left" colspan="2" > 
		         	<input id="diferencia" name="diferencia" size="11" value="" align="right" esMoneda="true" style="text-align:right;"  readOnly="true"/> 
			     	</td> 
			     	<td > 
			     	</td>
				</tr>
			</table>
			<input type="hidden" value="0" name="numeroDetalle" id="numeroDetalle" />
		</fieldset>
	
</form>

</body>
</html>

<script type="text/javascript">
	
	agregaFormatoControles('gridDetalle');
	
	$("#numeroDetalle").val($('input[name=consecutivoID]').length);	
	
	function validaDigitos(e){
		if(e.which!=0 && (e.which<48 || e.which>57)){
    		return false;
  		}
	}
	$('#gridDetalle').validate({
		rules: {
			consecutivoID: { 
				minlength: 1
			}
		},
		messages: { 			
		 	consecutivoID: {
				minlength: 'Al menos un Caracter'
			}
		}		
	});	
	
	function eliminaDetalle(control){		
		var numeroID = control.id;
		var jqTr = eval("'#renglon" + numeroID + "'");
		var jqTr2 = eval("'#renglonDescripcion" + numeroID + "'");
		
		var jqDesCuentaCompleta = eval("'#desCuentaCompleta" + numeroID + "'");
		var jqCentroCosto = eval("'#centroCostoID" + numeroID + "'");		
		var jqConsecutivoID = eval("'#consecutivoID" + numeroID + "'");
		var jqCuentaCompleta = eval("'#cuentaCompleta" + numeroID + "'");
		var jqReferencia = eval("'#referencia" + numeroID + "'");
		var jqDescripcion = eval("'#descripcion" + numeroID + "'");
		var jqCargos = eval("'#cargos" + numeroID + "'");
		var jqAbonos = eval("'#abonos" + numeroID + "'");
		var jqElimina = eval("'#" + numeroID + "'");
		var jqAgrega = eval("'#agrega" + numeroID + "'");
		
		var jqConsecutivoIDAnt = eval("'#consecutivoID" + String(eval(parseInt(numeroID)-1)) + "'");				
		var jqConsecutivoIDSig = eval("'#consecutivoID" + String(eval(parseInt(numeroID)+1)) + "'");										  
								
		//Si es el primer Elemento
		if ($(jqConsecutivoID).attr("id") == $("input[name=consecutivoID]:first-child").attr("id")){
			$(jqConsecutivoIDSig).val("1");				
		}else 
			if($(jqConsecutivoIDSig).val()!= null && $(jqConsecutivoIDSig).val()!= undefined) {
			//Valida Antes de actualizar, que si exista un sig elemento
			for (i=(parseInt(numeroID)+1);i<=$("#numeroDetalle").val();i++){
				jqConsecutivoIDSig = eval("'#consecutivoID" + i + "'");			 		 	
				$(jqConsecutivoIDSig).val(numeroID);
				numeroID++;
			}
		}
	
	
		$(jqDesCuentaCompleta).remove();
		$(jqTr2).remove();
		
		$(jqConsecutivoID).remove();
		$(jqCentroCosto).remove();
		$(jqCuentaCompleta).remove();
		$(jqReferencia).remove();
		$(jqDescripcion).remove();
		$(jqCargos).remove();
		$(jqAbonos).remove();
		$(jqElimina).remove();
		$(jqAgrega).remove();
		$(jqTr).remove();
		
		//Reordenamiento de Controles
		var contador = 1;
		$('input[name=consecutivoID]').each(function() {		
			var jqCicInf = eval("'#" + this.id + "'");	
			$(jqCicInf).attr("id", "consecutivoID" + contador);			
			contador = contador + 1;	
		});
		//Reordenamiento de Controles
		contador = 1;
		$('input[name=centroCostoID]').each(function() {		
			var jqCicInf = eval("'#" + this.id + "'");	
			$(jqCicInf).unbind();	
			$(jqCicInf).attr("id", "centroCostoID" + contador);			
			listaCentroCostos("centroCostoID" + contador);
			contador = contador + 1;	
		});
		contador = 1;
		//Reordenamiento de Controles
		$('tr[name=desCuentaCompleta]').each(function() {
			var jqDesCuentaCompleta = eval("'#" + this.id + "'");			
			$(jqDesCuentaCompleta).attr("id", "desCuentaCompleta" + contador);
			contador = contador + 1;	
		});	
		contador = 1;
		//Reordenamiento de Controles
		$('tr[name=agrega]').each(function() {
			var jqAgrega = eval("'#" + this.id + "'");			
			$(jqAgrega).attr("id", "agrega" + contador);
			contador = contador + 1;	
		});		
		//Reordenamiento de Controles		
		contador = 1;		
		$('input[name=cuentaCompleta]').each(function() {		
			var jqCicSup = eval("'#" + this.id + "'");
			$(jqCicSup).unbind();			
			$(jqCicSup).attr("id", "cuentaCompleta" + contador);			
			listaMaestroCuentas("cuentaCompleta" + contador);
			maestroCuentasDescripcion("cuentaCompleta" + contador, "desCuentaCompleta" + contador);
			contador = contador + 1;
		});
		//Reordenamiento de Controles
		var contador = 1;
		$('input[name=referencia]').each(function() {		
			var jqCicInf = eval("'#" + this.id + "'");		
			$(jqCicInf).attr("id", "referencia" + contador);
			contador = contador + 1;	
		});
		//Reordenamiento de Controles
		contador = 1;
		$('input[name=descripcion]').each(function() {		
			var jqCicSup = eval("'#" + this.id + "'");			
			$(jqCicSup).attr("id", "descripcion" + contador);
			contador = contador + 1;
		});
		contador = 1;
		//Reordenamiento de Controles
		var contador = 1;
		$('input[name=cargos]').each(function() {		
			var jqCicInf = eval("'#" + this.id + "'");		
			$(jqCicInf).attr("id", "cargos" + contador);
			contador = contador + 1;	
		});
		//Reordenamiento de Controles
		contador = 1;
		$('input[name=abonos]').each(function() {		
			var jqCicSup = eval("'#" + this.id + "'");			
			$(jqCicSup).attr("id", "abonos" + contador);
			contador = contador + 1;
		});
		contador = 1;
		//Reordenamiento de Controles
		$('input[name=elimina]').each(function() {
			var jqCicElim = eval("'#" + this.id + "'");
			$(jqCicElim).attr("id", contador);
			contador = contador + 1;	
		});			
		contador = 1;
		//Reordenamiento de Controles
		$('tr[name=renglon]').each(function() {
			var jqCicTr = eval("'#" + this.id + "'");			
			$(jqCicTr).attr("id", "renglon" + contador);
			contador = contador + 1;	
		});
		contador = 1;
		//Reordenamiento de Controles
		$('tr[name=renglonDescripcion]').each(function() {
			var jqCicTr = eval("'#" + this.id + "'");			
			$(jqCicTr).attr("id", "renglonDescripcion" + contador);
			contador = contador + 1;	
		});
		
		$('#numeroDetalle').val($('#numeroDetalle').val()-1);
		
		//ESTOS METODOS SE ENCUENTRAN EN polizaContableCatalogo.js 
		sumaCifrasControlCargos();
		sumaCifrasControlAbonos();		
	}
	
	function agregaNuevoDetalle(){
		var numeroFila =  consultaFilas();
		var nuevaFila = parseInt(numeroFila) + 1;			
     	 var tds = '<tr id="renglon' + nuevaFila + '" name="renglon">';
	 	 	  
   	if(numeroFila == 0){
    		tds += '<td><input id="consecutivoID'+nuevaFila+'" name="consecutivoID" size="6" value="1" autocomplete="off" /></td>';
    		tds += '<td><input type="text" id="centroCostoID'+nuevaFila+'" name="centroCostoID" size="6" value="" onblur="consultaCentroCostos('+nuevaFila+')"  autocomplete="off" onkeypress="listaCentroCostos(\'centroCostoID'+nuevaFila+'\');"/></td>';
			tds += '<td><input id="cuentaCompleta'+nuevaFila+'" name="cuentaCompleta" size="20" value="" '+
						'onkeypress="listaMaestroCuentas(\'cuentaCompleta'+nuevaFila+'\');" onblur="maestroCuentasDescripcion(this.id, \'desCuentaCompleta'+nuevaFila+'\');"/></td>';
			tds += '<td><input id="referencia'+nuevaFila+'" name="referencia" size="15" value="" autocomplete="off" maxlength="20"/></td>';
			tds += '<td><input id="descripcion'+nuevaFila+'" name="descripcion" size="60" value="" autocomplete="off" onblur="ponerMayusculas(this)"/></td>';
			tds += '<td><input id="cargos'+nuevaFila+'" name="cargos" size="11" value="0" style="text-align:right;"  autocomplete="off" onBlur="sumaCifrasControlCargos('+nuevaFila+');" align="right" /></td>';
			tds += '<td><input id="abonos'+nuevaFila+'" name="abonos" size="11" value="0" style="text-align:right;" autocomplete="off" onBlur="sumaCifrasControlAbonos('+nuevaFila+');" align="right"/>';
			tds += '<input type="button" name="elimina" id="'+nuevaFila +'" value="" class="btnElimina" onclick="eliminaDetalle(this)"/>';
	    	tds += '<input type="button" name="agrega" id="agrega'+nuevaFila +'" value="" class="btnAgrega" onclick="agregaNuevoDetalle()"/></td>';
	    	 tds += '</tr>';
    	} else{    		
			var valor = parseInt(document.getElementById("consecutivoID"+numeroFila+"").value) + 1;
    		tds += '<td><input id="consecutivoID'+nuevaFila+'" name="consecutivoID" size="6" value="'+valor+'" autocomplete="off" /></td>';
    		tds += '<td><input id="centroCostoID'+nuevaFila+'" name="centroCostoID" size="6" value="" autocomplete="off" onblur="consultaCentroCostos('+nuevaFila+')" onkeypress="listaCentroCostos(\'centroCostoID'+nuevaFila+'\');"/></td>';
			tds += '<td><input id="cuentaCompleta'+nuevaFila+'" name="cuentaCompleta" size="20" value="" '+
						'onkeypress="listaMaestroCuentas(\'cuentaCompleta'+nuevaFila+'\');" onblur="maestroCuentasDescripcion(this.id,\'desCuentaCompleta'+nuevaFila+'\');" /></td>';
			tds += '<td><input id="referencia'+nuevaFila+'" name="referencia" size="15" value="" autocomplete="off" maxlength="20"/></td>';
			tds += '<td><input id="descripcion'+nuevaFila+'" name="descripcion" size="60" value="" autocomplete="off"onblur=" ponerMayusculas(this)"/></td>';
			tds += '<td><input id="cargos'+nuevaFila+'" name="cargos" size="11" value="0" autocomplete="off" style="text-align:right;"  onBlur="sumaCifrasControlCargos('+nuevaFila+');" align="right"/></td>';
			tds += '<td><input id="abonos'+nuevaFila+'" name="abonos" size="11" value="0" autocomplete="off" style="text-align:right;" onBlur="sumaCifrasControlAbonos('+nuevaFila+');" align="right"/>';
			tds += '<input type="button" name="elimina" id="'+nuevaFila +'" value="" class="btnElimina" onclick="eliminaDetalle(this)"/>';
	    	tds += '<input type="button" name="agrega" id="agrega'+nuevaFila +'" value="" class="btnAgrega" onclick="agregaNuevoDetalle()"/></td>';
	    	 tds += '</tr>';
    	}
	   tds += '<tr id="renglonDescripcion' + nuevaFila + '" name="renglonDescripcion">';
	   tds += '<td colspan="2">&nbsp;</td>';	   
	   tds += '<td colspan="5"><input id="desCuentaCompleta'+nuevaFila+'" name="desCuentaCompleta" size="100" value="" readOnly="true" disabled="true"/></td>';
	   tds += '</tr>';
	   
    	document.getElementById("numeroDetalle").value = nuevaFila;    	
    	$("#miTabla").append(tds);
    	
    	agregaFormato("cargos" + nuevaFila);
		agregaFormato("abonos" + nuevaFila);
		
    	//ESTOS METODOS SE ENCUENTRAN EN polizaContableCatalogo.js 
		sumaCifrasControlCargos();
		sumaCifrasControlAbonos();		
		
		return false;		
	}

			
	$("#agregaDetalle").click(function() {
		agregaNuevoDetalle();
 	});
	function consultaFilas(){
		var totales=0;
		$('tr[name=renglon]').each(function() {
			totales++;		
		});
		return totales;

	}

	function agregaFormato(idControl){
		var jControl = eval("'#" + idControl + "'"); 
		
     	$(jControl).bind('keyup',function(){
			$(jControl).formatCurrency({
						colorize: true,
						positiveFormat: '%n', 
						roundToDecimalPlace: -1
						});
		});
		$(jControl).blur(function() {
				$(jControl).formatCurrency({
						positiveFormat: '%n', 
						roundToDecimalPlace: 2	
				});
		});
		$(jControl).formatCurrency({
			positiveFormat: '%n', 
			roundToDecimalPlace: 2	
		});			
	}	

</script>