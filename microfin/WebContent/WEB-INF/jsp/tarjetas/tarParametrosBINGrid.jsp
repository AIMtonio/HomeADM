<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<c:set var="parametroBINs"  value="${listaPaginada.pageList}"/>
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend>Registros</legend>	
			<table border="0" cellpadding="0" cellspacing="0" width="100%"> 		
					<tr id="encabezadoLista">
						<td align="center">Consecutivo</td> 	
						<td align="center">No.Bin</td>
						<td align="center">Maneja SubBin</td>
						<td align="center">Marca</td>
					</tr>					
				<c:forEach items="${parametroBINs}" var="parametroBIN" varStatus="status">
					<tr>
						<td style="text-align: center;"> 
							<label for="consecutivo" id="consecutivo${status.count}"  name="consecutivo" size="11" >
								${parametroBIN.tarBinParamsID}
							</label>  
						</td> 
					  	<td style="text-align: center;"> 
							<label for="bin" id="bin${status.count}"  name="bin" size="16" >
								${parametroBIN.numBIN}
							</label>  
					  	</td> 
			     		<td style="text-align: center;"> 
		     				<label for="esSubbin" id="esSubbin${status.count}" name="esSubbin" size="50">
		     					${parametroBIN.esSubBin}
		     				</label>
			     		</td>
			     		<td style="text-align: center;"> 
		     				<label for="descMarcaTar" id="descMarcaTar${status.count}" name="descMarcaTar" size="50">
		     					${parametroBIN.descMarcaTar}
		     				</label>
			     		</td>
					</tr>
				</c:forEach>
			</table>
			<c:if test="${!listaPaginada.firstPage}">
				 <input onclick="consultaBINs('previous')" type="button" value="" class="btnAnterior" />
			</c:if>
			<c:if test="${!listaPaginada.lastPage}">
				 <input onclick="consultaBINs('next')" type="button" value="" class="btnSiguiente" />
			</c:if>		
		</fieldset>		
</div>	
	
<script type="text/javascript">
function consultaBINs(pageValor){
	var params = {};
	params['tipoLista'] =  '2';
	params['page'] = pageValor ;
	$.post("gridParamsBINs.htm", params, function(data){		
	
		if(data.length >0) {
			$('#gridBINs').html(data);
			$('#gridBINs').show();

		}else{
			$('#gridBINs').html("");
			$('#gridBINs').show(); 
		}
	});
	
}

   
</script>