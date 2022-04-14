<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="listaResultado"	value="${listaResultado[0]}"/>

<br></br>
<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%">
	<tr>
		<td nowrap="nowrap" valign="top">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">                
			<legend>Movimientos Internos</legend>	
			<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td class="label"> 
						<label for="lblMovConcilia">Mov. Concilia</label> 
					</td> 
					<td class="label"> 
						<label for="lblFecha">Fecha Ope.</label> 
					</td>
					<td class="label"> 
						<label for="lblDescripcion">Descripci&oacute;n</label> 
					</td>
					<td class="label"> 
						<label for="lblDescripcion">Referencia</label> 
					</td>
					<td class="label"> 
						<label for="lblNaturaleza">Natura.</label> 
					</td>	
					<td class="label"> 
						<label for="lblMonto">Monto</label> 
					</td>
					<td class="label"> 
						<label for="lblestatus"></label> 
					</td>
				</tr>
				<c:forEach items="${listaResultado}" var="movsInter" varStatus="status">
				<tr id="renglon${status.count}" name="renglon" style="height: 40px;">
					<td> 
						<c:choose>
							<c:when test="${movsInter.fechaMov == '1900-01-01'}">
								<input id="numeroMov${status.count}" name="numeroMov" size="8" value="" readOnly="true" style="border: none;background-color: transparent;"/> 
								<input type="hidden" id="${status.count}" name="transaccion" size="10"  value="${movsInter.numeroMov}" /> 
								<input type="hidden" id="folioMovimiento${status.count}" name="folioMovimiento" size="10"  value="${movsInter.folioMovimiento}" />
							</c:when>
							<c:otherwise>
								<input id="numeroMov${status.count}" name="numeroMov" size="8" value="${movsInter.numeroMov}" readOnly="true" disabled="true"/> 
								<input type="hidden" id="${status.count}" name="transaccion" size="10"  value="${movsInter.numeroMov}" /> 
								<input type="hidden" id="folioMovimiento${status.count}" name="folioMovimiento" size="10"  value="${movsInter.folioMovimiento}" />
							</c:otherwise>
						</c:choose>	
	               	</td>
					<td> 
						<c:choose>
							<c:when test="${movsInter.fechaMov == '1900-01-01'}">
								<input id="fecha${status.count}"  name="fechaMov" size="11"  value="" readOnly="true" style="border: none;background-color: transparent;"/>
							</c:when>
							<c:otherwise>
								<input id="fecha${status.count}"  name="fechaMov" size="11"  value="${movsInter.fechaMov}" readOnly="true" disabled="true"/>
							</c:otherwise>
						</c:choose> 
					</td> 
					<td> 
						<c:choose>
							<c:when test="${movsInter.fechaMov == '1900-01-01'}">
								<textarea id="descripcion${status.count}"  name="descripcionMov" cols="12" rows="2" readOnly="true" style="border: none;background-color: transparent;resize:none">${movsInter.descripcionMov}</textarea>
							</c:when>
							<c:otherwise>
								<textarea id="descripcion${status.count}"  name="descripcionMov" cols="12" rows="2" readOnly="true" disabled="true">${movsInter.descripcionMov}</textarea>
							</c:otherwise>
						</c:choose>
					</td> 
					<td> 
						<c:choose>
							<c:when test="${movsInter.fechaMov == '1900-01-01'}">
								<textarea id="referencia${status.count}"  name="referenciaMov" cols="12" rows="2" style="border: none;background-color: transparent;resize:none">${movsInter.referenciaMov}</textarea>
							</c:when>
							<c:otherwise>
								<textarea id="referencia${status.count}"  name="referenciaMov" cols="12" rows="2" disabled="true">${movsInter.referenciaMov}</textarea>
							</c:otherwise>
						</c:choose>
					</td> 
					<td align="center"> 
						<c:choose>
							<c:when test="${movsInter.fechaMov == '1900-01-01'}">
								<input id="natMovimiento${status.count}"  name="natMovimiento" size="1" value="${movsInter.natMovimiento}" readOnly="true" style="border: none;background-color: transparent;" />
							</c:when>
							<c:otherwise>
								<input id="natMovimiento${status.count}"  name="natMovimiento" size="1" value="${movsInter.natMovimiento}" readOnly="true" disabled="true" />
							</c:otherwise>
						</c:choose>
					</td>   
					<td> 
						<c:choose>
							<c:when test="${movsInter.fechaMov == '1900-01-01'}">
								<input id="MontoMov${status.count}" name="montoMov" size="12" value="" readOnly="true"  esMoneda="true" style="text-align: right;border: none;background-color: transparent;" type="hidden"/>
							</c:when>
							<c:otherwise>
								<input id="MontoMov${status.count}" name="montoMov" size="12" value="${movsInter.montoMov}" readOnly="true" disabled="true" esMoneda="true" style="text-align: right"/>
							</c:otherwise>
						</c:choose>					
						<input id="tipoMov${status.count}" name="tipoMov" size="12" value="${movsInter.tipoMov}" readOnly="true" disabled="true" type="hidden"/>
					</td>
					<td> 
						<c:choose>
							<c:when test="${movsInter.fechaMov == '1900-01-01'}">
								<input type="checkbox" id="status${status.count}" name="listaConciliado" onchange="cambiaStatus('MontoMov${status.count}','status${status.count}')" 
											value="${movsInter.folioMovimiento},${movsInter.folioCargaIDArch},${movsInter.tipoMov},${movsInter.status},${movsInter.natMovimiento},${movsInter.montoMov}"  
												style="visibility: hidden;" class="cb"/>
				                <input type="hidden" id="valStatus${status.count}" name="valStatus" value="N" />
							</c:when>
							<c:otherwise>
								<c:choose>
									<c:when test="${movsInter.status == 'C'}">
										<input type="checkbox" id="status${status.count}" name="listaConciliado" onchange="cambiaStatus('MontoMov${status.count}','status${status.count}')"  
												value="${movsInter.folioMovimiento},${movsInter.folioCargaIDArch},${movsInter.tipoMov},${movsInter.status},${movsInter.natMovimiento},${movsInter.montoMov},${movsInter.tipoMov}" 
														CHECKED class="cb"/>
				                       	<input type="hidden" id="valStatus${status.count}" name="valStatus" value="S"/>									
									</c:when>
									<c:when test="${movsInter.status == 'N'}">
										<input type="checkbox" id="status${status.count}" name="listaConciliado" onchange="cambiaStatus('MontoMov${status.count}','status${status.count}')" 
												value="${movsInter.folioMovimiento},${movsInter.folioCargaIDArch},${movsInter.tipoMov},${movsInter.status},${movsInter.natMovimiento},${movsInter.montoMov},${movsInter.tipoMov}"  
														class="cb"/>
			                           	<input type="hidden" id="valStatus${status.count}" name="valStatus" value="N" />											
									</c:when>
								</c:choose>
							</c:otherwise>
						</c:choose>					
					</td>
				</tr>
				<c:set var="cont" value="${status.count}"/>
				</c:forEach>						
			</table>
			<input id="vacio"  name="vacio" value="${cont}" type="hidden" readOnly="true" disabled="true"/>
			</fieldset>
		</td>
		<td nowrap="nowrap" valign="top">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">                
			<legend>Movimientos Externos</legend>	
			<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td class="label"> 
						<label for="lblFecha">Fecha Ope.</label> 
					</td>
					<td class="label"> 
						<label for="lblDescripcion">Descripci&oacute;n</label> 
					</td>
					<td class="label"> 
						<label for="lblRefe">Referencia</label> 
					</td>
					<td class="label"> 
						<label for="lblNaturaleza">Natura.</label> 
					</td>	
					<td class="label"> 
						<label for="lblMonto">Monto</label> 
					</td>
					<td class="label"> 
				    	<label for="lblMovConcilia">Mov. Concilia</label> 
				   	</td> 
				</tr>
				<c:forEach items="${listaResultado}" var="movsExter" varStatus="status">
				<tr id="renglon${status.count}" name="renglon" style="height: 40px;">
					<td> 
						<c:choose>
							<c:when test="${movsExter.fechaOperacionArch == '1900-01-01'}">
								<input id="fechaOperacionArch${status.count}"  name="fechaOperacionArch" size="11"  value="" readOnly="true" style="border: none;background-color: transparent;"/> 
								<input type="hidden"  id="folioCargaIDArch${status.count}"  name="folioCargaIDArch" size="12"  value="0" /> 
								<input type="hidden"  id="folioMovExterno${status.count}"  name="folioMovExterno" size="12"  value="0" />
							</c:when>
							<c:otherwise>
								<input id="fechaOperacionArch${status.count}"  name="fechaOperacionArch" size="11"  value="${movsExter.fechaOperacionArch}" readOnly="true" disabled="true"/> 
								<input type="hidden"  id="folioCargaIDArch${status.count}"  name="folioCargaIDArch" size="12"  value="${movsExter.folioCargaIDArch}" /> 
								<input type="hidden"  id="folioMovExterno${status.count}"  name="folioMovExterno" size="12"  value="${movsExter.folioMovimiento}" />
							</c:otherwise>
						</c:choose>
					</td> 
					<td> 
						<c:choose>
							<c:when test="${movsExter.fechaOperacionArch == '1900-01-01'}">
								<textarea id="descripcionMovArch${status.count}"  name="descripcionMovArch" cols="12" rows="2" readOnly="true" style="border: none;background-color: transparent;resize:none" >${movsExter.descripcionMovArch}</textarea>
							</c:when>
							<c:otherwise>
								<textarea id="descripcionMovArch${status.count}"  name="descripcionMovArch" cols="12" rows="2" readOnly="true" disabled="true">${movsExter.descripcionMovArch}</textarea>
							</c:otherwise>
						</c:choose>								 
					</td> 
					<td>
						<c:choose>
							<c:when test="${movsExter.fechaOperacionArch == '1900-01-01'}">
								<textarea id="referenciaMovArch${status.count}"  name="referenciaMovArch" cols="12" rows="2" readOnly="true"  style="border: none;background-color: transparent;resize:none" >${movsExter.referenciaMovArch}</textarea>
							</c:when>
							<c:otherwise>
								<textarea id="referenciaMovArch${status.count}"  name="referenciaMovArch" cols="12" rows="2" readOnly="true" disabled="true">${movsExter.referenciaMovArch}</textarea>
							</c:otherwise>
						</c:choose>
					</td>
					<td align="center">
						<c:choose>
							<c:when test="${movsExter.fechaOperacionArch == '1900-01-01'}">
								<input id="naturalezaArch${status.count}"  name="natMovimientoArch" size="1" value="${movsExter.natMovimientoArch}" readOnly="true" style="border: none;background-color: transparent;"/>
							</c:when>
							<c:otherwise>
								<input id="naturalezaArch${status.count}"  name="natMovimientoArch" size="1" value="${movsExter.natMovimientoArch}" readOnly="true" disabled="true" />
							</c:otherwise>
						</c:choose>  
					</td>
					<td> 
						<c:choose>
							<c:when test="${movsExter.fechaOperacionArch == '1900-01-01'}">
								<input id="montoMovArch${status.count}" name="montoMovArch" size="12" value="" readOnly="true"  esMoneda="true" style="text-align: right;border: none;background-color: transparent;" type="hidden"/>
							</c:when>
							<c:otherwise>
								<input id="montoMovArch${status.count}" name="montoMovArch" size="12" value="${movsExter.montoMovArch}" readOnly="true" disabled="true" esMoneda="true" style="text-align: right" />
							</c:otherwise>
						</c:choose>  
					</td>
					<td> 
						<c:choose>
							<c:when test="${movsExter.numeroMovArch == '0' && movsExter.montoMovArch=='0.00'}">
								<input id="numeroMovArch${status.count}" name="numeroMovArch" size="8" value=""  type="hidden"
									onblur="conciliaManual('${status.count}');" readOnly="true" style="border: none;background-color: transparent;" />
								<input id="numeroMovArchVacio${status.count}" name="numeroMovArch" size="8" value=""  
									 readOnly="true" style="border: none;background-color: transparent;" />
							</c:when>
							<c:otherwise>
								<input id="numeroMovArch${status.count}" name="numeroMovArch" size="8" value="${movsExter.numeroMovArch}" onblur="conciliaManual('${status.count}');" />
							</c:otherwise>
						</c:choose>
					</td>
				</tr>
				</c:forEach>
			</table>
			</fieldset>
		</td>
	</tr>
</table>
<script type="text/javascript">

examinaChecks();
function examinaChecks(){
	if($('#fecha1').length){
		if($('#fecha1').val()!=''){
			$('#cerrar').show(200);	
		}else{
			$('#cerrar').hide(200);
			deshabilitaBoton('procesar');
		}		
	}else{
		$('#cerrar').hide(200);
		deshabilitaBoton('procesar');	
	}
	var campoCheckeado = false;
	$('input[name=listaConciliado]').each(function(){
		var jqCampo = eval("'#"+this.id+"'");
		if($(jqCampo).is(':checked')){
			campoCheckeado = true;
		}
	});	
	if(campoCheckeado){
		habilitaBoton('procesar');
		$('#cerrar').hide(250);
	}
}


$('.cb').click(function(){
	var jqCampo = eval("'#"+this.id+"'");
	var campoCheckeado = false;
	if($(jqCampo).is(':checked')){
		habilitaBoton('procesar');		
		$('#cerrar').hide(250);
	}else{
		$('input[name=listaConciliado]').each(function(){
			var jqCheck = eval("'#"+this.id+"'");
			if($(jqCheck).is(':checked')){
				campoCheckeado=true;				
			}
		});
		if(!campoCheckeado){
			deshabilitaBoton('procesar');
			$('#cerrar').show(250);
		}
	}
});

$('#cerrar').click(function(){
	
	if ($('#tipoLista').val() != 1) {
		$('#listaFoliosMovs').val('');	
	
		$('input[name=listaConciliado]').each(function(){
			var ID = this.id.substring(6);
			var jqFolioMovimiento = 	eval("'#folioMovimiento"+ID+"'");			
			
			$('#listaFoliosMovs').val($('#listaFoliosMovs').val()+','+$(jqFolioMovimiento).val());
		});	
		$('#listaFoliosMovs').val($('#listaFoliosMovs').val().substring(1));
	}

});

</script>


