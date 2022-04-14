<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="listaResultado"  value="${listaResultado}"/>
<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend>Movimientos</legend>	
	<input type="button" id="agregaDetalle" value="Agregar" class="botonGral" tabindex="8"/>
	<input type="button" id="cargarCSV" value="Cargar CSV" class="botonGral" tabindex="9"/>
	<a href="javaScript:" onClick="descripcionCampo('cargarCSV');">
		<img src="images/help-icon.gif" >
	</a>
	<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%">
		<tbody>	
			<tr>
				<td class="label"><label for="lblNumero">Número</label></td>
				<td class="label"><label for="lblCR">C. Costos</label></td>	
				<td class="label"><label for="lblCuenta">Cuenta</label></td>
		  		<td class="label"><label for="lblReferencia">Referencia</label></td> 
	     		<td class="label"><label for="lblDescripcion">Descripción</label></td> 
	     		<td class="label"><label for="lblRFC">RFC</label></td> 
	     		<td class="label"><label for="lblTotalFactura">Total Factura</label></td>
	     		<td class="label"><label for="lblFolioUUID">Folio UUID</label></td> 
	     		<td class="label"><label for="lblCargos">Cargos</label></td> 
	     		<td class="label"><label for="lblAbonos">Abonos</label></td> 
			</tr>
			<c:forEach items="${listaResultado}" var="detallePoliza" varStatus="status">
				<tr id="renglon${status.count}" name="renglon">
					<td> 
						<input type="text" id="consecutivoID${status.count}"  name="consecutivoID" size="6"  
								value="${status.count}" readonly="true" disabled="true"/> 
				  	</td> 
				  	<td> 
						<input type="text" id="centroCostoID${status.count}" name="centroCostoID" size="6" 
								value="${detallePoliza.centroCostoID}" readonly="true" disabled="true"/> 
				  	</td> 
				  	<td> 
						<input type="text" id="cuentaCompleta${status.count}" name="cuentaCompleta" size="20" 
								value="${detallePoliza.cuentaCompleta}" readonly="true" disabled="true"/> 
				  	</td> 
				  	<td> 
						<input type="text" id="referencia${status.count}" name="referencia" size="7" 
								value="${detallePoliza.referencia}" readonly="true" disabled="true" maxlength="20"/> 
				  	</td> 
		     		<td> 
		         		<input type="text" id="descripcion${status.count}" name="descripcion" size="60"
		         			value="${detallePoliza.descripcion}" readonly="true" disabled="true"/> 
		     		</td> 
		    <td> 
		         		<input type="text" id="RFC${status.count}" name="RFC" size="16" style="text-align: right;"
		         			value="${detallePoliza.RFC}" readonly="true" disabled="true" /> 
		     		</td> 
		     		<td> 
		         		<input type="text" id="totalFactura${status.count}" name="totalFactura" size="15" style="text-align: right;"
		         			value="${detallePoliza.totalFactura}" readonly="true" disabled="true" esMoneda="true"/> 
		     		</td> 
		     		<td> 
		         		<input type="text" id="folioUUID${status.count}" name="folioUUID" size="48" style="text-align: right;"
		         			value="${detallePoliza.folioUUID}" readonly="true" disabled="true" onBlur=" ponerMayusculas(this);"/> 
		     		</td> 
		    
					<td> 
		         		<input type="text" id="cargos${status.count}" name="cargos" size="15" style="text-align: right;"
		         			value="${detallePoliza.cargos}" readonly="true" disabled="true" esMoneda="true"/> 
		     		</td> 
		     		<td> 
		         		<input type="text" id="abonos${status.count}" name="abonos" size="15" style="text-align: right;"
		         			value="${detallePoliza.abonos}" readonly="true" disabled="true" esMoneda="true"/> 
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
			<td colspan="5"  id="contenidoAyuda"> 
		   	<label for="lblCiCtrl">Cifras de Control</label> 
			</td> 	
			<td> 
         	<input type="text" id="ciCtrlCargos" name="ciCtrlCargos" size="15" value="" esMoneda="true" style="text-align: right;" readonly="true"/> 
	     	</td> 
	     	<td> 
         	<input type="text" id="ciCtrlAbonos" name="ciCtrlAbonos" size="15" value="" esMoneda="true" style="text-align: right;" readonly="true" /> 
	     	</td> 
	     	<td > 
	     	</td>
		</tr>
		<tr align="right">
			<td colspan="5"  id="contenidoAyuda" > 
		   	<label for="lblDiferencia">Diferencia</label> 
			</td> 	
	     	<td> 
         	<input id="diferencia" name="diferencia" size="15" value="" style="text-align: right;" esMoneda="true"  readonly="true"/> 
	     	</td> 
		</tr>
		<tr>								
				<td colspan="7" align="right">																							
					<input type="button" id="aplicaPro" name="aplicaPro" value="Aplicar Prorrateo" class="submit" style="display: none;"/>
				</td>
		</tr>
	</table>
	<input type="hidden" value="0" name="numeroDetalle" id="numeroDetalle" />
	<br></br>
	
	<!-- INICIO Seccion de Prorrrateo Contable y GRID -->
			<div id="prorrateoContable" style="display: none;">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend>Aplicar Métodos Prorrateo</legend>
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td>
								<table>
									<tr>
										<td>
											<label for="prorrateoID">Método Prorrateo: </label>
										</td>
										<td colspan="7">
											<input type="text" id="prorrateoID" name="prorrateoID" size="8" maxlength="50"/>
											<input type="text" id="nombreProrrateo" name="nombreProrrateo" readOnly="readOnly" size="40" maxlength="50"/>
										</td>
									</tr>	
									<tr>
										<td>
											<label for="descripcionProrrateo">Descripción: </label>
										</td>
										<td>
											<textarea cols="35" rows="3" value="" id="descripcionProrrateo" name="descripcionProrrateo" readOnly="readOnly" maxlength="100"></textarea>
										</td>
									</tr>										
								</table>
							</td>												
						</tr>							
						<tr>
							<td>
								<div id="gridProrrateoContable" name="gridProrrateoContable" style="display: none;"></div>
							</td>
						</tr>
						<tr>
							<td colspan="7" align="right">
								<input type="button" id="aplicaProrrateo" name="aplicaProrrateo" value="Aplicar" class="submit" disabled="disabled"/>
								<input type="button" id="cancelaProrrateo" name="cancelaProrrateo" value="Cancelar Prorrateo" class="submit"/>
							</td>
						</tr>
					</table>						
				</fieldset>					
			</div>			
	<!-- FIN Seccion de Prorrrateo Contable y GRID -->
</fieldset>

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

	verificaDatos();
	agregaFormatoControles('gridDetalle');
	
	$("#numeroDetalle").val($('input[name=consecutivoID]').length);	
	
	function validaDigitos(e){
		if(e.which!=0 && (e.which<48 || e.which>57)){
    		return false;
  		}
	}
	

	function eliminaDetalle(trId){
		$("#renglon" + trId).remove();
		$("#renglonDescripcion" + trId).remove();	
		var numReng = getRenglones();	
		//ESTOS METODOS SE ENCUENTRAN EN polizaContableCatalogo.js 
		sumaCifrasControlCargos();
		sumaCifrasControlAbonos();
		asignaConsecutivos();
		if(numReng == '0'){
			deshabilitaBoton('grabar', 'submit');
		}

	}
	function agregaNuevoDetalle(){
		var numeroFila = document.getElementById("numeroDetalle").value;
		var concepto = document.getElementById("concepto").value;
		var nuevaFila = parseInt(numeroFila) + 1;			
      	var tds = '<tr id="renglon' + nuevaFila + '" name="renglon">';
	 	if(numeroFila == 0){
    		tds += '<td><input type="text"  id="consecutivoID'+nuevaFila+'" name="consecutivoID" size="6" value="1" autocomplete="off" /></td>';
    		tds += '<td><input type="text"  id="centroCostoID'+nuevaFila+'" name="centroCostoID" size="6" value="" autocomplete="off" onkeypress="listaCentroCostos(this.id);" onBlur="validaCentroCostos(this.id)" maxlength="10"/></td>';
    		tds += '<td><input type="text"  id="cuentaCompleta'+nuevaFila+'" name="cuentaCompleta" size="20" value="" '+'onkeypress="listaMaestroCuentas(this.id);"   onblur="maestroCuentasDescripcion(this.id);"  maxlength="50"/></td>';	
			tds += '<td><input type="text"  id="referencia'+nuevaFila+'" name="referencia" size="15" value="" autocomplete="off" maxlength="20"/></td>';
			tds += '<td><input type="text"  id="descripcion'+nuevaFila+'" name="descripcion" size="60" value="'+concepto+'" autocomplete="off" onBlur="cargosS(this.id);" maxlength="150"/></td>';
			tds += '<td><input type="text"  id="RFC'+nuevaFila+'" name="RFC" size="16" value="" autocomplete="off" maxlength="13" onBlur=" ponerMayusculas(this);validaRFC(this.id)"/></td>';
			tds += '<td><input type="text"  id="totalFactura'+nuevaFila+'" name="totalFactura" size="15" value="0.00" autocomplete="off" style="text-align: right;" esMoneda="true" disabled="true"/></td>';
			tds += '<td><input type="text"  id="folioUUID'+nuevaFila+'" name="folioUUID" size="48" value="" autocomplete="off" maxlength="36" onkeyup="mascara(this);" onBlur="ponerMayusculas(this);validaFolioUUID(this.id);"/></td>';
			tds += '<td><input type="text"  id="cargos'+nuevaFila+'" name="cargos" size="15" value="0.00" autocomplete="off" onBlur="consultaCargosAbonos(this.id);sumaCifrasControlCargos(this.id);" style="text-align: right;" /></td>';
			tds += '<td><input type="text"  id="abonos'+nuevaFila+'" name="abonos" size="15" value="0.00" autocomplete="off" onBlur="consultaCargosAbonos(this.id);sumaCifrasControlAbonos(this.id);" style="text-align: right;" /></td>';
			 
    	} else{    		
			var valor = getRenglones()+1;
    		tds += '<td><input type="text"  id="consecutivoID'+nuevaFila+'" name="consecutivoID" size="6" value="'+valor+'" autocomplete="off" /></td>';
    		tds += '<td><input type="text"  id="centroCostoID'+nuevaFila+'" name="centroCostoID" size="6" value="" autocomplete="off"   onkeypress="listaCentroCostos(this.id);" onBlur="validaCentroCostos(this.id)" maxlength="10"/></td>';			
    		tds += '<td><input type="text"  id="cuentaCompleta'+nuevaFila+'" name="cuentaCompleta" size="20" value="" '+'onkeypress="listaMaestroCuentas(this.id);" onblur="maestroCuentasDescripcion(this.id);" maxlength="50" /></td>';	
			tds += '<td><input id="referencia'+nuevaFila+'" name="referencia" size="15" value="" autocomplete="off" maxlength="20"/></td>';
			tds += '<td><input type="text"  id="descripcion'+nuevaFila+'" name="descripcion" size="60" value="'+concepto+'" autocomplete="off" onBlur="cargosS(this.id);" maxlength="150"/></td>';
			tds += '<td><input type="text"  id="RFC'+nuevaFila+'" name="RFC" size="16" value="" autocomplete="off" maxlength="13" onBlur=" ponerMayusculas(this);validaRFC(this.id)"/></td>';
			tds += '<td><input type="text"  id="totalFactura'+nuevaFila+'" name="totalFactura" size="15" value="0.00" autocomplete="off" style="text-align: right;" esMoneda="true" disabled="true" /></td>';
			tds += '<td><input type="text"  id="folioUUID'+nuevaFila+'" name="folioUUID" size="48" value="" autocomplete="off" maxlength="36" onkeyup="mascara(this);" onBlur=" ponerMayusculas(this);validaFolioUUID(this.id)"/></td>';	
			tds += '<td><input type="text"  id="cargos'+nuevaFila+'" name="cargos" size="15" value="0.00" autocomplete="off" onBlur="consultaCargosAbonos(this.id);sumaCifrasControlCargos(this.id);" style="text-align: right;" class="controlCargo"/></td>';
			tds += '<td><input type="text"  id="abonos'+nuevaFila+'" name="abonos" size="15" value="0.00" autocomplete="off" onBlur="consultaCargosAbonos(this.id); sumaCifrasControlAbonos(this.id);" style="text-align: right;" class="controlAbono"/></td>';
    	}
    	tds += '<td><input type="button" name="elimina" id="'+nuevaFila +'" value="" class="btnElimina" onclick="eliminaDetalle(this.id);"/></td>';
    	tds += '<td><input type="button" name="agrega" id="agrega'+nuevaFila +'" value="" class="btnAgrega" onclick="agregaNuevoDetalle()"/></td>';
	   tds += '</tr>';
	   
	   tds += '<tr id="renglonDescripcion' + nuevaFila + '" name="renglonDescripcion">';
	   tds += '<td colspan="2">&nbsp;</td>';	   
	   tds += '<td colspan="5"><input type="text" id="desCuentaCompleta'+nuevaFila+'" name="desCuentaCompleta" size="103" value="" readonly="true" disabled="true"/></td>';
	   tds += '</tr>';
	  
    	document.getElementById("numeroDetalle").value = nuevaFila;    	
    	$("#miTabla").append(tds);
    	asignaConsecutivos();
    	
    	agregaFormato("cargos" + nuevaFila);
		agregaFormato("abonos" + nuevaFila);
		
    	//ESTOS METODOS SE ENCUENTRAN EN polizaContableCatalogo.js 
		sumaCifrasControlCargos();
		sumaCifrasControlAbonos();		
		
		return false;		
	}	
	
			
	$("#agregaDetalle").click(function() {
		agregaNuevoDetalle();
		$("#centroCostoID1").focus();
 	});

 	$("#cargarCSV").click(function() {
		cargaMasivaPoliza();		
 	});

	// funcion para mostrar  ventana para adjuntar archivo
	var ventanaCargaPoliza ="";
	function cargaMasivaPoliza() {	
		var url ="polizasFileUploadVista.htm?polizaID="+$('#polizaID').val();
		var	leftPosition = (screen.width) ? (screen.width-850)/2 : 0;
		var	topPosition = (screen.height) ? (screen.height-500)/2 : 0;
		ventanaCargaPoliza = window.open(url,"PopUpSubirArchivo","width=980,height=340,scrollbars=yes,status=yes,location=no,addressbar=0,menubar=0,toolbar=0"+
										"left="+leftPosition+
										",top="+topPosition+
										",screenX="+leftPosition+
										",screenY="+topPosition);	
	}
	
	function recorrematriz(numTransaccion){
		var listaExito = {};
		bloquearPantallaCarga();
		polizaArchivosServicio.listaCargaArchivos(numTransaccion,1,function(list) {
			if( list!=null){
				listaExito = list;		
				for (var i = 0; i < listaExito.length; i++){
					bean = listaExito[i];       

					var numeroFila = document.getElementById("numeroDetalle").value;
					var nuevaFila = parseInt(numeroFila) + 1;	  
					var tds = '<tr id="renglon' + nuevaFila + '" name="renglon">';				
				   	if(numeroFila == 0){
			    		tds += '<td><input type="text"  id="consecutivoID'+nuevaFila+'" name="consecutivoID" size="6" value="1" autocomplete="off" /></td>';
			    		tds += '<td><input type="text"  id="centroCostoID'+nuevaFila+'" name="centroCostoID" size="6" value="'+bean.centroCostoID+'" autocomplete="off" onkeypress="listaCentroCostos(this.id);" maxlength="10"/></td>';
			    		tds += '<td><input type="text"  id="cuentaCompleta'+nuevaFila+'" name="cuentaCompleta" size="20" value="'+bean.cuentaCompleta+'" '+'onkeypress="listaMaestroCuentas(this.id);"   onblur="maestroCuentasDescripcion(this.id);"  maxlength="50"/></td>';	
						tds += '<td><input type="text"  id="referencia'+nuevaFila+'" name="referencia" size="15" value="'+bean.referencia+'" autocomplete="off" maxlength="20"/></td>';
						tds += '<td><input type="text"  id="descripcion'+nuevaFila+'" name="descripcion" size="60" value="'+bean.descripcion+'" autocomplete="off" onBlur="cargosS(this.id);" maxlength="150"/></td>';
						tds += '<td><input type="text"  id="RFC'+nuevaFila+'" name="RFC" size="16" value="'+bean.RFC+'" autocomplete="off" maxlength="13" onBlur=" ponerMayusculas(this);validaRFC(this.id)"/></td>';
						tds += '<td><input type="text"  id="totalFactura'+nuevaFila+'" name="totalFactura" size="15" value="0.00" autocomplete="off" style="text-align: right;" esMoneda="true" disabled="true"/></td>';
						tds += '<td><input type="text"  id="folioUUID'+nuevaFila+'" name="folioUUID" size="48" value="'+bean.folioUUID+'"  autocomplete="off" maxlength="36" onkeyup="mascara(this);" onBlur="ponerMayusculas(this);validaFolioUUID(this.id);"/></td>';
						tds += '<td><input type="text"  id="cargos'+nuevaFila+'" name="cargos" size="15" value="'+bean.cargos+'" autocomplete="off" onBlur="consultaCargosAbonos(this.id);sumaCifrasControlCargos(this.id);" style="text-align: right;" /></td>';
						tds += '<td><input type="text"  id="abonos'+nuevaFila+'" name="abonos" size="15" value="'+bean.abonos+'" autocomplete="off" onBlur="consultaCargosAbonos(this.id);sumaCifrasControlAbonos(this.id);" style="text-align: right;" /></td>';
						 
				    } else{   
				    	var valor = parseInt(document.getElementById("consecutivoID"+numeroFila+"").value) + 1;
			    		tds += '<td><input type="text"  id="consecutivoID'+nuevaFila+'" name="consecutivoID" size="6" value="'+valor+'" autocomplete="off" /></td>';
			    		tds += '<td><input type="text"  id="centroCostoID'+nuevaFila+'" name="centroCostoID" size="6" value="'+bean.centroCostoID+'" autocomplete="off"   onkeypress="listaCentroCostos(this.id);"  maxlength="10"/></td>';			
			    		tds += '<td><input type="text"  id="cuentaCompleta'+nuevaFila+'" name="cuentaCompleta" size="20" value="'+bean.cuentaCompleta+'" '+'onkeypress="listaMaestroCuentas(this.id);" onblur="maestroCuentasDescripcion(this.id);" maxlength="50" /></td>';	
						tds += '<td><input type="text"	id="referencia'+nuevaFila+'" name="referencia" size="15" value="'+bean.referencia+'" autocomplete="off" maxlength="20"/></td>';
						tds += '<td><input type="text"  id="descripcion'+nuevaFila+'" name="descripcion" size="60" value="'+bean.descripcion+'" autocomplete="off" onBlur="cargosS(this.id);" maxlength="150"/></td>';
						tds += '<td><input type="text"  id="RFC'+nuevaFila+'" name="RFC" size="16" value="'+bean.RFC+'" autocomplete="off" maxlength="13" onBlur=" ponerMayusculas(this);validaRFC(this.id)"/></td>';
						tds += '<td><input type="text"  id="totalFactura'+nuevaFila+'" name="totalFactura" size="15" value="0.00" autocomplete="off" style="text-align: right;" esMoneda="true" disabled="true" /></td>';
						tds += '<td><input type="text"  id="folioUUID'+nuevaFila+'" name="folioUUID" size="48" value="'+bean.folioUUID+'" autocomplete="off" maxlength="36" onkeyup="mascara(this);" onBlur=" ponerMayusculas(this);validaFolioUUID(this.id)"/></td>';	
						tds += '<td><input type="text"  id="cargos'+nuevaFila+'" name="cargos" size="15" value="'+bean.cargos+'" autocomplete="off" onBlur="consultaCargosAbonos(this.id);sumaCifrasControlCargos(this.id);" style="text-align: right;" class="controlCargo"/></td>';
						tds += '<td><input type="text"  id="abonos'+nuevaFila+'" name="abonos" size="15" value="'+bean.abonos+'" autocomplete="off" onBlur="consultaCargosAbonos(this.id); sumaCifrasControlAbonos(this.id);" style="text-align: right;" class="controlAbono"/></td>';
						
				    }
				    tds += '<td><input type="button" name="elimina" id="'+nuevaFila +'" value="" class="btnElimina" onclick="eliminaDetalle(this.id);"/></td>';
				    tds += '<td><input type="button" name="agrega" id="agrega'+nuevaFila +'" value="" class="btnAgrega" onclick="agregaNuevoDetalle()"/></td>';
					tds += '</tr>';
					  
					tds += '<tr id="renglonDescripcion' + nuevaFila + '" name="renglonDescripcion">';
					tds += '<td colspan="2">&nbsp;</td>';	   
					tds += '<td colspan="5"><input type="text" id="desCuentaCompleta'+nuevaFila+'" name="desCuentaCompleta" size="103" value="'+bean.desCuentaCompleta+'" readonly="true" disabled="true"/></td>';
					tds += '</tr>';
					  
			    	document.getElementById("numeroDetalle").value = nuevaFila;    	
			    	$("#miTabla").append(tds);
			    	
			    	agregaFormato("cargos" + nuevaFila);
					agregaFormato("abonos" + nuevaFila);
					
				}

		    	//ESTOS METODOS SE ENCUENTRAN EN polizaContableCatalogo.js 
				sumaCifrasControlCargos();
				sumaCifrasControlAbonos();	
				
				$('#contenedorForma').unblock(); // desbloquear
			}
		});	
				
		return false;		
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
		
	$('#aplicaProrrateo').click(function(){
		var mandar = verificarvacios();		
		if($('#conceptoID').val() == ''){
			$('#conceptoID').val('0');
		}

		if(mandar!=1){
			var confirmar=confirm('Confirmar Aplicación de Prorrateo');
			if(confirmar){
				var primeraVez=0;
				var nuevaFila=0;
				var factProrrateada='';
				var arrFilas=[];					
				$('input[name=consecutivoID]').each(function(){					
					var jqConse= eval("'#"+this.id+"'");
					if(!$(jqConse).is(':disabled')){
						nuevaFila=$(jqConse).asNumber();
						return false;

					}
				});										
				$('input[name=cenCostoID]').each(function(){
					
					var IDP = this.id.substring(10);
											
					var jqCentroCosto	= eval("'#"+this.id+"'");
					var jqPorcentaje	= eval("'#porcentajePro"+IDP+"'");
					
					valCentroCosto		= $(jqCentroCosto).asNumber();
					valPorcentaje		= $(jqPorcentaje).asNumber();
											
						$('input[name=consecutivoID]').each(function(){
							var jqConse= eval("'#"+this.id+"'");
							var IDG = this.id.substring(13);
							
							if(!$(jqConse).is(':disabled')){
								
								var totalProC=0.00;
								var totalProA=0.00;							
								var jqCentro = eval("'#centroCostoID"+IDG+"'");
								var jqCuentaCom = eval("'#cuentaCompleta"+IDG+"'");
								var jqReferencia=eval("'#referencia"+IDG+"'");
								var jqDescripcion=eval("'#descripcion"+IDG+"'");
								var jqRFC	=eval("'#RFC"+IDG+"'");
								var jqTotalFactura	=eval("'#totalFactura"+IDG+"'");
								var jqFolioUUID	=eval("'#folioUUID"+IDG+"'");
								var jqCargos	=eval("'#cargos"+IDG+"'");
								var jqAbonos	=eval("'#abonos"+IDG+"'");
								var jqdesCtaCompleta =eval("'#desCuentaCompleta"+IDG+"'");
								
								var valConse=$(jqConse).val();
								var valCentro=$(jqCentro).val();				
								var valCuentaCom=$(jqCuentaCom).val();
								var valReferencia=$(jqReferencia).val();
								var valDescripcion=$(jqDescripcion).val();
								var valRFC=$(jqRFC).val();
								var valTotalFactura=$(jqTotalFactura).asNumber();
								var valFolioUUID=$(jqFolioUUID).val();
								var valCargos=$(jqCargos).asNumber();
								var valAbonos=$(jqAbonos).asNumber();
								var valdesCtaCompleta=$(jqdesCtaCompleta).val();
														
								if(valCargos>0){
									totalProC=((valCargos*valPorcentaje)/100);
								}else if(valAbonos>0){
									totalProA=((valAbonos*valPorcentaje)/100);
								}
																					
								factProrrateada += '<tr id="renglon' + nuevaFila + '" name="renglon">';
								factProrrateada += '<td><input type="text"  id="consecutivoID'+nuevaFila+'" name="consecutivoID" size="6" value="'+nuevaFila+'" autocomplete="off" /></td>';
								factProrrateada += '<td><input type="text"  id="centroCostoID'+nuevaFila+'" name="centroCostoID" size="6" value="'+valCentroCosto+'" autocomplete="off"   onkeypress="listaCentroCostos(this.id);" onBlur="validaCentroCostos(this.id)" maxlength="10"/></td>';
								
								factProrrateada += '<td><input type="text"  id="cuentaCompleta'+nuevaFila+'" name="cuentaCompleta" size="20" value="'+valCuentaCom+'" '+
											'onkeypress="listaMaestroCuentas(this.id);" onblur="maestroCuentasDescripcion(this.id);" maxlength="50" /></td>';
								
								factProrrateada += '<td><input id="referencia'+nuevaFila+'" name="referencia" size="15" value="'+valReferencia+'" autocomplete="off" maxlength="20"/></td>';
								factProrrateada += '<td><input type="text"  id="descripcion'+nuevaFila+'" name="descripcion" size="60" value="'+valDescripcion+'" autocomplete="off" onBlur="cargosS(this.id);" maxlength="150"/></td>';
								factProrrateada += '<td><input type="text"  id="RFC'+nuevaFila+'" name="RFC" size="16" value="'+valRFC+'" autocomplete="off" maxlength="13" onBlur=" ponerMayusculas(this);validaRFC(this.id)"/></td>';
								factProrrateada += '<td><input type="text"  id="totalFactura'+nuevaFila+'" name="totalFactura" size="15"  autocomplete="off" style="text-align: right;" class="controlCargo" esMoneda="true" disabled="true"/></td>';
								factProrrateada += '<td><input type="text"  id="folioUUID'+nuevaFila+'" name="folioUUID" size="48" value="'+valFolioUUID+'" autocomplete="off" onkeyup="mascara(this);" onBlur=" ponerMayusculas(this);validaFolioUUID(this.id)" maxlength="36"/></td>';
								factProrrateada += '<td><input type="text"  id="cargos'+nuevaFila+'" name="cargos" size="11" value="'+parseFloat(totalProC.toFixed(2))+'" autocomplete="off" onBlur="consultaCargosAbonos(this.id);sumaCifrasControlCargos(this.id);" style="text-align: right;" class="controlCargo"/></td>';
								factProrrateada += '<td nowrap="nowrap"><input type="text"  id="abonos'+nuevaFila+'" name="abonos" size="11" value="'+parseFloat(totalProA.toFixed(2))+'" autocomplete="off" onBlur="consultaCargosAbonos(this.id); sumaCifrasControlAbonos(this.id);" style="text-align: right;" class="controlAbono"/>';
								factProrrateada += '<input type="button" name="elimina" id="'+nuevaFila +'" value="" class="btnElimina" onclick="eliminaDetalle(this.id);"/>';
								factProrrateada += '<input type="button" name="agrega" id="agrega'+nuevaFila +'" value="" class="btnAgrega" onclick="agregaNuevoDetalle()"/></td>';
								factProrrateada += '</tr>';
								factProrrateada += '<tr id="renglonDescripcion' + nuevaFila + '" name="renglonDescripcion">';
								factProrrateada += '<td colspan="2">&nbsp;</td>';	   
								factProrrateada += '<td colspan="5"><input type="text" id="desCuentaCompleta'+nuevaFila+'" name="desCuentaCompleta" size="100" value="'+valdesCtaCompleta+'" readonly="true" disabled="true"/></td>';
								factProrrateada += '</tr>';
								nuevaFila++;
								if(primeraVez==0){
									arrFilas.push(IDG);
								}								
							}
						});
						primeraVez=1;
				});
				
				for(var i=0;i<arrFilas.length;i++){
					var jqRenglon= eval("'#renglon"+arrFilas[i]+"'");			
					$(jqRenglon).remove();				
					var jqRenglonDescrip= eval("'#renglonDescripcion"+arrFilas[i]+"'");
					$(jqRenglonDescrip).remove();	
				}							
				
				$("#miTabla").append(factProrrateada);
																				
				$('#prorrateoContable').hide();
				deshabilitaBoton('aplicaProrrateo');
				nuevaFila=0;
				
				$('input[name=consecutivoID]').each(function(){
					nuevaFila++;
					agregaFormato("cargos" + nuevaFila);
					agregaFormato("abonos" + nuevaFila);
				});
			  					
				$('#prorrateoHecho').val('S');
				$('#numeroDetalle').val(nuevaFila);
				
				cuadrarCargosAbonos();
					
				//ESTOS METODOS SE ENCUENTRAN EN polizaContableCatalogo.js 
				sumaCifrasControlCargos();
				sumaCifrasControlAbonos();	
			}					
	}
		$('#grabar').focus();

});
		
		
	$('#aplicaPro').click(function(){
		deshabilitaBoton('aplicaProrrateo');
		$('#prorrateoContable').show(500);
		$('#aplicaPro').hide(500);
		$('#prorrateoID').focus();
	});
		
	$('#cancelaProrrateo').click(function(){
		$('#prorrateoContable').hide(500);
		$('#aplicaPro').show(500);
		limpiarCamposGrid();
		$('#grabar').focus();
	});
	
	function limpiarCamposGrid(){
		$('#prorrateoID').val('');
		$('#nombreProrrateo').val('');
		$('#descripcionProrrateo').val('');											
		deshabilitaBoton('aplicaProrrateo');
		$('#gridProrrateoContable').hide(500);
	}
			
	function consultaMetodoProrrateo(jqcontrol){
		deshabilitaBoton('aplicaProrrateo');
		var evalControl=eval("'#"+jqcontrol.id+"'");		
		var valorControl=$(evalControl).val();		
		var tipoLista=1;
		var estatusActiva='A', estatusInactiva='I';
		prorrateoBean={
				'prorrateoID' : valorControl
		};
		prorrateoContableServicio.consulta(tipoLista,prorrateoBean,function(prorrateo){
				if(prorrateo!=null){					
					$('#nombreProrrateo').val(prorrateo.nombreProrrateo);
					$('#descripcionProrrateo').val(prorrateo.descripcion);
					if(prorrateo.estatus==estatusActiva){
						var params={};
						params['tipoConsulta']=3;
						params['prorrateoID']=valorControl;
						consultaGridProrrateo(params);
					}else if(prorrateo.estatus==estatusInactiva){
						mensajeSis('El Método de Prorrateo esta Inactivo');
						$('#prorrateoID').focus();
						limpiarCamposGrid();
					}		
				}else{
					mensajeSis("El Método de Prorrateo no Existe");
					$('#prorrateoID').focus();
					limpiarCamposGrid();
				}
		});
	}
	
	
	
	function consultaGridProrrateo(params){
		$('#gridProrrateoContable').hide();				
		$.post("prorrateoConsultaGrid.htm", params,function(data){
			if (data.length > 0){
				$('#gridProrrateoContable').html(data);
				$('#gridProrrateoContable').show(500);
				habilitaBoton('aplicaProrrateo');
			}
		});
	}
	
	$('#prorrateoID').bind('keyup',function(){
		lista('prorrateoID','2','1','nombreProrrateo',$('#prorrateoID').val(),'prorrateoContableLista.htm');
	});
	
	$('#prorrateoID').blur(function(){
		if($('#prorrateoID').val()!=''){
			if(esTab){
				if(!isNaN($('#prorrateoID').val()) ){
					consultaMetodoProrrateo(this);
				}else{
					mensajeSis('Solo se Aceptan Números');					
					$('#prorrateoID').val('');
					$('#nombreProrrateo').val('');
					$('#descripcionProrrateo').val('');
					$('#gridProrrateoContable').hide();
					$('#prorrateoID').focus();
				}
			}						
		}	
	});
	
	function getRenglones(){
		var numRenglones = $('#miTabla >tbody >tr[name^="renglon"]').length;
		return numRenglones/2;
	}

	function asignaConsecutivos(){
		//Reordenamiento de Controles
		var contador = 1;
		var numero= 0;
		$('tr[name=renglon]').each(function() {		
			numero= this.id.substr(7,this.id.length);
			document.getElementById('numeroDetalle').value = contador;
	
			var jqRenglon1 				= eval("'#renglon"+numero+"'");
			var jqConsecutivoID1		= eval("'#consecutivoID" + numero + "'");	
			var jqCentroCostoID1		= eval("'#centroCostoID" + numero + "'");	
			var jqCuentaCompleta1		= eval("'#cuentaCompleta" + numero + "'");
			var jqReferencia1			= eval("'#referencia" + numero + "'");
			var jqDescripcion1			= eval("'#descripcion" + numero + "'");
			var jqRFC1 					= eval("'#RFC" + numero + "'"); 
			var jqTotalFactura1			= eval("'#totalFactura" + numero + "'");
			var jqFolioUUID1			= eval("'#folioUUID" + numero + "'");	
			var jqCargos1				= eval("'#cargos" + numero + "'");	
			var jqAbonos1				= eval("'#abonos" + numero + "'");
			var jqElimina1 				= eval("'#"+numero+ "'");
			var jqAgrega1 				= eval("'#agrega"+numero+ "'");
			var jqRenglonDescripcion1	= eval("'#renglonDescripcion" + numero + "'");
			var jqDesCuentaCompleta1	= eval("'#desCuentaCompleta" + numero + "'");			
	
			$(jqRenglon1).attr('id','renglon'+contador);
			$(jqConsecutivoID1).attr('id','consecutivoID'+contador);
			$(jqCentroCostoID1).attr('id','centroCostoID'+contador);
			$(jqCuentaCompleta1).attr('id','cuentaCompleta'+contador);
			$(jqReferencia1).attr('id','referencia'+contador);
			$(jqDescripcion1).attr('id','descripcion'+contador);
			$(jqRFC1).attr('id','RFC'+contador);
			$(jqTotalFactura1).attr('id','totalFactura'+contador);
			$(jqFolioUUID1).attr('id','folioUUID'+contador);
			$(jqCargos1).attr('id','cargos'+contador);	
			$(jqAbonos1).attr('id','abonos'+contador);
			$(jqElimina1).attr('id',contador);
			$(jqAgrega1).attr('id','agrega'+contador);
			$(jqRenglonDescripcion1).attr('id','renglonDescripcion'+contador);
			$(jqDesCuentaCompleta1).attr('id','desCuentaCompleta'+contador);
			
			document.getElementById('consecutivoID'+contador).value = contador;
			contador = parseInt(contador)+1;
		});
	}
	function bloquearPantallaCarga() {
		$('#mensaje').html('<img src="images/barras.jpg" alt=""/>');
		$('#contenedorForma').block({
			message : $('#mensaje'),
			css : {
				border : 'none',
				background : 'none'
			}
		});

	}
	
	var esTab =true;

	//FUNCION PARA MOSTRAR MENSAJES DE AYUDA
	function descripcionCampo(idCampo){	
		var data;	
		switch(idCampo) {
		    case 'cargarCSV':
		    	data ='<fieldset class="ui-widget ui-widget-content ui-corner-all">'+ 
				'<div id="ContenedorAyuda">'+ 			
				'<table id="tablaLista">'+
					'<tr align="center">'+
					'<td id="contenidoAyuda" align="center">'+
					'<b> Formato de carga csv '+
					'</b>'+
					'</td>'+
					'</tr>'+
					'<tr>'+
					'<td>'+
						'<table id="tablaLista">'+
							'<tr>'+
								'<td id="encabezadoAyuda"><b>'+
								'Cuenta'+
								'</b></td>'+
								'<td id="encabezadoAyuda"><b>'+
								'Centros Costo'+
								'</b></td>'+
								'<td id="encabezadoAyuda"><b>'+
								'Ref'+
								'</b></td>'+
								'<td id="encabezadoAyuda"><b>'+
								'Fecha'+
								'</b></td>'+
								'<td id="encabezadoAyuda"><b>'+
								'Debe(Cargo)'+
								'</b></td>'+
								'<td id="encabezadoAyuda"><b>'+
								'Haber (Abono)'+
								'</b></td>'+
								'<td id="encabezadoAyuda"><b>'+
								'Descripción Poliza'+
								'</b></td>'+
								'<td id="encabezadoAyuda"><b>'+
								'Descripción Cuenta'+
								'</b></td>'+
							'</tr>'+
						'</table>'+
					'</td>'+
					'</tr>'+
				'</table>'+
				'</fieldset>'; 
		        break;
		    default:
		    	data = "";
		} 
		
		
		$('#ContenedorAyuda').html(data); 
		$.blockUI({message: $('#ContenedorAyuda'),
					   css: { 
	             top:  ($(window).height() - 400) /2 + 'px', 
	             left: ($(window).width() - 400) /2 + 'px', 
	             width: '400px' 
	         } });  
	$('.blockOverlay').attr('title','Clic para Desbloquear').click($.unblockUI); 		      
	}
</script>