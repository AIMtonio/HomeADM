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
						        <label for="lblFolio">Folio<br>Afiliaci&oacute;n</br></label> 
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
						        <label for="lblAfiliada">Afiliada</label> 
						    </td>
						    <td class="label" nowrap="nowrap">
						        <label for="lblComentario">Comentario</label> 
						    </td>
						</tr>	
						<c:forEach items="${listaResultado}" var="procesos" varStatus="estatus">
						<tr id="renglon${estatus.count}" name="renglon">
						    <td  nowrap="nowrap">
						        <input type="text" id="numAfiliacionID${estatus.count}" name="listaNumAfiliacionID" size="12" value="${procesos.numAfiliacionID}" readonly="readonly" /> 
						    </td>
						    <td  nowrap="nowrap">
						        <input type="text" id="clienteID${estatus.count}" name="listaClienteID" size="12" value="${procesos.clienteID}" readonly="readonly"/> 
						    </td>  
						    <td  nowrap="nowrap">
						        <input type="text" id="nombCliente${estatus.count}" name="nombCliente" size="50" value="${procesos.nombCliente}" readonly="readonly"/> 
						    </td>  
						    <td  nowrap="nowrap">
						    	<input type="hidden" id="institucionID${estatus.count}" name="listaInstitucionID" size="3" value="${procesos.institucionID}" readonly="readonly"/>
						        <input type="text" id="nombInstitucion${estatus.count}" name="nombInstitucion" size="30" value="${procesos.nombInstitucion}" readonly="readonly"/> 
						    </td> 
						    <td  nowrap="nowrap">
						        <input type="text" id="cuentaClabe${estatus.count}" name="listaCuentaClabe" size="20" value="${procesos.cuentaClabe}" readonly="readonly"/> 
						    </td> 
						    <td  nowrap="nowrap">
						        <input type="text" id="afiliada${estatus.count}" name="listaAfiliada" size="8" value="${procesos.afiliada}" readonly="readonly" /> 
						    </td>
						     <td  nowrap="nowrap">
						        <input type="text" id="comentario${estatus.count}" name="listaComentario" size="65" value="${procesos.comentario}"  readonly="readonly"/> 
						        <input type="hidden" id="claveAfiliacion${estatus.count}" name="listaClaveAfiliacion" size="3" value="${procesos.claveAfiliacion}" readonly="readonly"/>
						        <input type="hidden" id="tipo${estatus.count}" name="listaTipo" size="3" value="${procesos.tipo}" readonly="readonly"/>
						        
						    </td>  
						</tr>
						</c:forEach>
						</tbody>        
						
					</table>
					<c:if test="${!listaPaginada.firstPage}">
						 <input onclick="consultaGridAfiliacionProcesar('previous')" type="button" value="" class="btnAnterior" />
					</c:if>
					<c:if test="${!listaPaginada.lastPage}">
						 <input onclick="consultaGridAfiliacionProcesar('next')" type="button" value="" class="btnSiguiente" />
					</c:if>	
				</fieldset>
			</td>
		</tr>
	</table>

	
	<script type="text/javascript">
	function consultaGridAfiliacionProcesar(pageValor){
		var params = {};
		params['tipo'] = $('#tipo').val();		
		params['tipoLista'] = 1;
		params['page'] = pageValor ;
		
		$.post("procAfiliaBajaCtaClabeGrid.htm", params, function(data){		
				if(data.length >0) {
					$('#gridAfiliacionBajasCtaClabe').html(data);
					$('#gridAfiliacionBajasCtaClabe').show();
					$('#procesar').focus();
				}else{
					$('#gridAfiliacionBajasCtaClabe').html(data);
					$('#gridAfiliacionBajasCtaClabe').show();
				}
		});
	}
	</script>
