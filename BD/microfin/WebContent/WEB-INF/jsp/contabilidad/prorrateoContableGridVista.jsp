<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<html>
  <body>
	<br>
	<c:set var="ciclo" value="1"/>
	
		<fieldset class="ui-widget ui-widget-content ui-corner-all">	
			<legend>Distribución por Centros de Costo</legend>			
			<table id="tablaProrrateo" border="0" cellsPacing="10">
				<tbody>
					<tr>
						<td class="label" colspan="2">
							<label for="centroCostoID">Centro de Costo: </label>
						</td>
						<td class="label" colspan="2">
							<label for="nombreCentro">Nombre: </label>
						</td>
						<td class="label">
							<label for="participaPro">Participa: </label>
						</td>
						<td class="label">
							<label for="porcentajePro">Porcentaje: </label>
						</td>
					</tr>					
					<c:set var="numRows" scope="session" value="${fn:length(prorrateoContable)}"/>
					<c:if test="${numRows == 0}">
						<tr id="renglon${status.count}" name="renglon">
							<td nowrap class="label" colspan="12" align="center">																			
								<label><b>No se encontraron coincidencias.</b></label>
							</td>
						</tr>
					</c:if>
					<c:forEach items="${prorrateoContable}" var="prorrateo" varStatus="status">
						<tr id="renglon${status.count}" name="renglon">
								<td colspan="2">
									<input type="text" id="centroCostoID${status.count}" name="centroCostoID" 
														value="${prorrateo.centroCostoID}" readOnly="readOnly" 
														style="text-align: center" size="12"/>
								</td>
								<td colspan="2">
									<input type="text" id="nombreCentro${status.count}" name="nombreCentro" 
														value="${prorrateo.descripcion}" readOnly="readOnly" size="20"/>
								</td>
								<td align="center">
									<input type="checkbox" id="participaPro${status.count}" name="participaPro" class="cb" value=""/>
								</td>
								<td>
									<input type="text" id="porcentajePro${status.count}" name="porcentajePro" 
														value="${prorrateo.porcentaje}" size="8" maxlength="5" style="text-align: right"
														tabindex="${status.count+4}" class="PP"/>
														<label>%</label>
								</td>								
						</tr>									
					</c:forEach>									
					<c:if test="${numRows > 0}">					
						<tr>
							<td class="separador"/>
							<td class="separador"/>
							<td class="separador"/>						
							<td class="label">
									<label for="selecTodos">Seleccionar Todos: </label> 
							</td>	
							<td align="center">
									<input type="checkbox" id="selecTodos" name="selecTodos" value="" onClick="seleccionarChecks()"/>
							</td>
						</tr>
					</c:if>										
				</tbody>						
			</table>
		</fieldset>		
	
  </body>
</html>
<script type="text/javascript">
	var total='0';
	validaParticipantes();	
	function validaParticipantes(){
		var tabindexP=9;
		$('input[name=porcentajePro]').each(function(){
			var ID=this.id.substring(13);			
			var evalJQ=eval("'#"+this.id+"'");
			var valorJQ=$(evalJQ).val();
			
			// evaluar campo participa
			var evalParticipa = eval("'#participaPro"+ID+"'");			
			// 	evaluar campo porcentaje
			var evalPorcen = eval("'#porcentajePro"+ID+"'");
			
			if(valorJQ>0){				
				$(evalParticipa).attr('checked','checked');				
				habilitaControl(('porcentajePro'+ID));
			}else{
				$(evalParticipa).attr('checked',false);
				deshabilitaControl(('porcentajePro'+ID));
			}
		});		
	}
	
	function seleccionarChecks(){		
		$('input[name=participaPro]').each(function(){
			ID = this.id.substring(12);
			
			evalJQ=eval("'#"+this.id+"'");
			evalPorcen=eval("'#porcentajePro"+ID+"'");
			
			if($('#selecTodos').is(':checked')){
				$(evalJQ).attr("checked","checked");
				habilitaControl(('porcentajePro'+ID));
			}else{
				$(evalJQ).removeAttr("checked");
				deshabilitaControl(('porcentajePro'+ID));
			}
			$(evalPorcen).val('0.00');			
		});
		if($('#selecTodos').is(':checked')) $('#porcentajePro1').select();					
	}	
	
	$('.cb').click(function(){
		ID = this.id.substring(12);
		
		evalJQ = eval("'#"+this.id+"'");
		evalPorcentaje = eval("'#porcentajePro"+ID+"'");
		
		if($(evalJQ).is(':checked')){			
			habilitaControl(('porcentajePro'+ID));
			$(evalPorcentaje).select();
		}else{
			deshabilitaControl(('porcentajePro'+ID));
			$(evalPorcentaje).val('0.00');
		}		
	});
	
	$('.PP').blur(function(){
		total=0;
		var jqPorcen =eval("'#"+this.id+"'");
		if($(jqPorcen).val()==''){
			$(jqPorcen).val('0.00');
		}
		
		if(!isNaN($(jqPorcen).asNumber())){
			if($(jqPorcen).asNumber()>0){
				if(parseFloat($(jqPorcen).asNumber())>100){
					alert('El Porcentaje No Debe ser Mayor a 100%.');
					$(jqPorcen).val('0.00');
					regresarFoco(jqPorcen);
				}else{
					
					$('input[name=porcentajePro]').each(function(){			
						var porcenJQ = eval("'#"+this.id+"'");		
							if(porcenJQ!=jqPorcen){
								total=parseFloat(total)+parseFloat($(porcenJQ).asNumber());											
							}					
					});							
					if((parseFloat($(jqPorcen).asNumber())+total)>100){						
						alert("La Suma de los Porcentajes exceden el 100%.");
						$(jqPorcen).val((100-parseFloat(total)).toPrecision(4));
						$(jqPorcen).formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
						regresarFoco(jqPorcen);
					}	
					$(jqPorcen).formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
				}
			}else{
				$(jqPorcen).val('0.00');
			}
		}else{
			alert('Especifique un Porcentaje con Números.');
			$(jqPorcen).val('0.00');
			regresarFoco(jqPorcen);
		}			
	});
	
	$('#agrega').click(function(){
		$('#listaCentros').val('');
		$('#porcentajes').val('');
		$('#totalPorcentajes').val('');
		var total=0;
		$('input[name=participaPro]').each(function(){			
			var ID	= this.id.substring(12);
			
			var evalJQ = eval("'#"+this.id+"'");
			var evalCentro = eval("'#centroCostoID"+ID+"'");
			var evalPorcen = eval("'#porcentajePro"+ID+"'");
			
			if($(evalJQ).is(':checked')){
				if(parseFloat($(evalPorcen).asNumber())<=0){
					$(evalJQ).attr('checked',false);
					deshabilitaControl(('porcentajePro'+ID));
					$(evalPorcen).val('0');
				}else{
					$('#listaCentros').val($('#listaCentros').val()+","+$(evalCentro).val());
					$('#porcentajes').val($('#porcentajes').val()+","+$(evalPorcen).val());
					total=parseFloat(total)+parseFloat($(evalPorcen).asNumber());
				}
				
			}
		});		
		$('#listaCentros').val($('#listaCentros').val().substring(1));
		$('#porcentajes').val($('#porcentajes').val().substring(1));
		$('#totalPorcentajes').val(total.toPrecision(4));
	});
	
	$('#modifica').click(function(){	
		$('#listaCentros').val('');
		$('#porcentajes').val('');
		$('#totalPorcentajes').val('');
		var total=0;
		$('input[name=participaPro]').each(function(){			
			var ID	= this.id.substring(12);
			
			var evalJQ = eval("'#"+this.id+"'");
			var evalCentro = eval("'#centroCostoID"+ID+"'");
			var evalPorcen = eval("'#porcentajePro"+ID+"'");
			
			if($(evalJQ).is(':checked')){
				if(parseFloat($(evalPorcen).asNumber())<=0){
					$(evalJQ).attr('checked',false);
					deshabilitaControl(('porcentajePro'+ID));
					$(evalPorcen).val('0.00');
				}else{
					$('#listaCentros').val($('#listaCentros').val()+","+$(evalCentro).val());
					$('#porcentajes').val($('#porcentajes').val()+","+$(evalPorcen).val());
					total=(parseFloat(total))+parseFloat($(evalPorcen).asNumber());					
				}
			}
		});		
		$('#listaCentros').val($('#listaCentros').val().substring(1));
		$('#porcentajes').val($('#porcentajes').val().substring(1));	
		$('#totalPorcentajes').val(total.toPrecision(4));		
	});
	//Regresar el foco a un campo de texto. Habia problemas al regresar el foco a un input en el nav. firefox
	function regresarFoco(idControl){
		var jqControl=eval("'"+idControl+"'");
		setTimeout(function(){
			$(jqControl).focus();
			$(jqControl).select();
		 },0);
	}
</script>
	