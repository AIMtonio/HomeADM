<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>

<html> 
<head>
</head>

<body>
	<c:set var="tipoLista"  value="${listaResultado[0]}"/>
	<c:set var="listaPaginada" value="${listaResultado[1]}" />
	<c:set var="listaResultado" value="${listaPaginada.pageList}"/>
	
	<table id="miTabla" border="0" >
		<c:choose>

			<c:when test="${tipoLista == '1'}">
			<td >
				<input type="button" id="RegresarPrincipal" name="RegresarPrincipal" class="submit" onclick="mostrarFiltros()" tabIndex = "15" value="Regresar" />
			</td>
				<tbody>	
						<tr id="encabezadoLista" width="300px">							
							<td align="center">Estatus</td>	
							<td align="center">Cantidad</td>
							<td align="center"></td>		
						</tr>
													
						<c:forEach items="${listaResultado}" var="estatusLis" varStatus="status">	
							<tr id="renglons${status.count}" name="renglons">	
								<td nowrap="nowrap" width="300px"> 
									<input type="hidden" id="estatusValor${status.count}" name="estatusValor"  value="${estatusLis.estatusValor}" /> 
									<label for="fecha" id="tipoEstatus${status.count}" name="tipoEstatus" size="20" >${estatusLis.tipoEstatus}:</label>  
								</td>
							  	<td> 
									<input  type="text" id="totalEstUsuario${status.count}" name="totalEstUsuario" size="10" value="${estatusLis.totalEstUsuario}"  readOnly="true" disabled="true" style="text-align:right;"  /> 							 							
							  		
							  	</td>
							  	<td >
									<input type="button" id="ver${status.count}" onclick="consultaDetalle(this.id)" name="ver" class="submit" tabIndex = "15" value="Ver" />
								</td>					  				
							</tr>	

						</c:forEach>						
						<tr align="right">							
							<td class="label"> 
								<label>Total:</label> 
					  		</td>
					  		<td class="label"> 
								<input  type="text" id="total" name="total" size="10" value="0" readOnly="true" disabled="true" style="text-align:right;"  /> 
					  		</td>					  		
													
						</tr>		
					</tbody>
			</c:when>
			<c:when test="${tipoLista == '2'}">
			<td >
				<input type="button" id="RegresarPrincipal" name="RegresarPrincipal" onclick="mostrarListaEstatus()" class="submit" tabIndex = "15" value="Regresar" />
			</td>
				<tbody>	
						<tr id="encabezadoLista">							
							<td align="center">Solicitud</td>	
							<td align="center">Sucursal</td>					  						  		
							<td align="center">Producto Credito</td>					  						  		
							<td align="center">Monto</td>	
							<td align="center">Nombre</td>						  		
					  		<td align="center">Promotor</td>
					  		<td align="center">Ejecutivo</td>
					  		<td align="center">Fecha</td>		
							<td align="center">Analista</td>							
							<td align="center">Motivo Regreso</td>		
							<td align="center">Estatus</td>				
						</tr>						
						<c:forEach items="${listaResultado}" var="estatusLis" varStatus="status">	
							<tr id="renglonSol${status.count}" name="renglon" class= "rfinal">	
								<td nowrap="nowrap"> 
									<input  type="text" id="solicitudCreditoID${status.count}" name="solicitudCreditoID" size="13" value="${estatusLis.solicitudCreditoID}"  readOnly="true" disabled="true" style="text-align:center;"  />  
									<input  type="hidden" id="creditoID${status.count}" name="lcredito" size="13" value="${estatusLis.creditoID}" readOnly="true" style="text-align:center;"  />
								</td>	
								<td nowrap="nowrap"> 
								     <input  type="text" id="nombreSucursal${status.count}" name="lsolicitud" size="13" value="${estatusLis.nombreSucursal}" readOnly="true" disabled="true" style="text-align:left;"  />  
								</td>
								<td nowrap="nowrap"> 
								     <input  type="text" id="descripcionProducto${status.count}" name="lsolicitud" size="18" value="${estatusLis.descripcionProducto}" readOnly="true" disabled="true" style="text-align:left;"  />  
								</td>
								<td nowrap="nowrap"> 
								     <input  type="text" id="montoOtorgado${status.count}" name="lsolicitud" size="13" value="${estatusLis.montoOtorgado}" readOnly="true" disabled="true" style="text-align:left;" esMoneda="true" />  
								</td>						  
							  	<td>
							  		<input type="hidden" id="clienteID${status.count}" name="lclienteID" value="${estatusLis.clienteID}" /> 
									<input  type="text" id="nombreCliente${status.count}" name="lnombreCliente" size="35" value="${estatusLis.nombreCliente}"  readOnly="true" disabled="true" style="text-align:left;"  /> 							 							
							  	</td>						  
							  	<td >
							  		<input type="hidden" id="promotorID${status.count}" name="lpromotorID"  value="${estatusLis.promotorID}" /> 
									<input  type="text" id="nombrePromotor${status.count}" name="lnombrePromotor" size="30" value="${estatusLis.nombrePromotor}"  readOnly="true" disabled="true" style="text-align:left;"  /> 	
								</td>
								<td>
									<input type="hidden" id="usuarioID${status.count}" name="lusuarioID"  value="${estatusLis.usuarioID}" /> 	
									<input  type="text" id="nombreUsuario${status.count}" name="lnombreUsuario" size="30" value="${estatusLis.nombreUsuario}"  readOnly="true" disabled="true" style="text-align:left;"  />
							  	</td>							  	
							  	<td>
									<input  type="text" id="fechaComentario${status.count}" name="lfechaComentario" size="20" value="${estatusLis.fechaComentario}"  readOnly="true" disabled="true" style="text-align:left;"  />	
							  	</td>
								<td nowrap="nowrap"> 
								    <input  type="text" id="claveAnalista${status.count}" name="lsolicitud" size="13" value="${estatusLis.claveAnalista}" readOnly="true" disabled="true" style="text-align:left;"  />  
								</td>
								<td nowrap="nowrap"> 
								     <input  type="text" id="descripcionRegreso${status.count}" name="lsolicitud" size="18" value="${estatusLis.descripcionRegreso}" readOnly="true" disabled="true" style="text-align:left;"  />  
								</td>

								<td nowrap="nowrap" > 
									<c:if test="${estatusLis.estatusSolicitud == 'N'}"  >
											<select name="estatusSolicitud" id="estatusSolicitud${status.count}"  value="${estatusLis.estatusSolicitud}" disabled="true">
											  <option value="N">No Asignada</option>   
											</select> 
									</c:if> 
									<c:if test="${estatusLis.estatusSolicitud== 'A'}" >
											<select name="estatusSolicitud" id="estatusSolicitud${status.count}"  value="${estatusLis.estatusSolicitud}" >
											  <option value="A">Asignada</option>  
											  <option value="E">En Revision</option>
											</select> 
									</c:if> 
									<c:if test="${estatusLis.estatusSolicitud == 'E'}"  >
											<select name="estatusSolicitud" id="estatusSolicitud${status.count}"  value="${estatusLis.estatusSolicitud}" >
											  <option value="E">En revision</option>   
											  <option value="A">Asignada</option>  
											</select>  
									</c:if>
								</td>	

							  	<td >
							  		<div id="divPrincipalAplicacion" class="divPrincipalAplicacion">
							  			<a id="imgComentario${status.count}" href="javascript:" onclick="muestraComentario(this.id)";>
											<img src="images/comentario.png" align="bottom" height="20" width="20">
										</a>
									</div>
							  	</td>
							  	<td >
							  		<div id="divPrincipalAplicacion" class="divPrincipalAplicacion">
							  			<a id="Continuar${status.count}" href="javascript:" onclick="mostrarPantalla(this.id)";>
											<img src="images/continuar.png" align="bottom" height="20" width="20">
										</a>
									</div>
							  	</td>
							  		<td>	
								     <input  type="hidden" id="tipoAsignacionID${status.count}" name="lsolicitud"  value="${estatusLis.tipoAsignacionID}"    />  
								</td>	
							  							  						  					  				
							</tr>
							<tr id="renglonSol${status.count}" name="renglon">	
								<td colspan="1">									
							  	</td>					  	
							  	<td colspan="4">								
									<textarea  id="comentarioSol${status.count}" name="lcomentario" style="text-align:left; display: none;"  COLS="115" ROWS="1" readOnly="true" disabled="true" onBlur=" ponerMayusculas(this);">${estatusLis.comentarioSol}</textarea>		
							  	</td>
							  							  						  					  				
							</tr>

						</c:forEach>	
						
						<input type="hidden" id="numSolicitud" name="numSolicitud"  value="" /> 
						<input type="hidden" id="solicitudCreditoID" name="solicitudCreditoID"  value="" />  
						<input type="hidden" id="creditoID" name="creditoID"  value="" />  							
					</tbody>
			</c:when>
			<c:when test="${tipoLista == '3'}">			
				<tbody>	
						<tr id="encabezadoLista">	
							<td align="left" width="300px">Canal</td>											  		 						  		
							<td align="center">Cantidad</td>					  		
					  			
						</tr>						
						<c:forEach items="${listaResultado}" var="estatusLis" varStatus="status">	
							<tr id="renglon${status.count}" name="renglon">	
								<td nowrap="nowrap"> 
									<label for="fecha" id="tipoCanalIng${status.count}" name="tipoCanalIng" size="20" >${estatusLis.tipoCanalIng}:</label>  
								</td>
							  	<td>
									<input  type="text" id="totalCanalIng${status.count}" name="totalCanalIng" size="10" value="${estatusLis.totalCanalIng}"  readOnly="true" disabled="true" style="text-align:right;"  />
							  	</td>		  												 						  						  					  				
							</tr>
						</c:forEach>
						<tr align="right">													
							<td class="label"> 
								<label>Total:</label> 
					  		</td>
					  		<td class="label"> 
								<input  type="text" id="totalCI" name="totalCI" size="10" value="0" readOnly="true" disabled="true" style="text-align:right;"  /> 
					  		</td>					  		
													
						</tr>							
					</tbody>
			</c:when>
			<c:when test="${tipoLista == '4'}">
			<td >
				<input type="button" id="RegresarPrincipal" name="RegresarPrincipal" onclick="mostrarListaEstatus()" class="submit" tabIndex = "15" value="Regresar" />
			</td>
				<tbody>	
						<tr id="encabezadoLista" >							
							<td align="center">Solicitud</td>					  						  		
							<td align="center">Nombre</td>						  		
					  		<td align="center">Promotor</td>
					  		<td align="center">Ejecutivo</td>				  		
					  		<td align="center">Fecha</td>
					  		<td align="center">Comentario Sucursal</td>	
					  		<td align="center"></td>	
					  		<td><input type="checkbox" id="selecTodas" name="selecTodas" onclick="seleccionaTodas()" value="" /></td>			
						</tr>						
						<c:forEach items="${listaResultado}" var="estatusLis" varStatus="status">	
							<tr id="renglon${status.count}" name="renglon">	
								<td nowrap="nowrap"> 
									<input  type="text" id="solicitudCreditoID${status.count}" name="lsolicitud" size="13" value="${estatusLis.solicitudCreditoID}"  readOnly="true" disabled="true" style="text-align:center;"  />  
									<input  type="hidden" id="solicitudCreditoID${status.count}" name="lsolicitud" size="13" value="${estatusLis.solicitudCreditoID}"  readOnly="true" style="text-align:center;"  />
									<input  type="hidden" id="creditoID${status.count}" name="lcredito" size="13" value="${estatusLis.creditoID}" readOnly="true" style="text-align:center;"  />
								</td>						  
							  	<td>
							  		<input type="hidden" id="clienteID${status.count}" name="lclienteID" value="${estatusLis.clienteID}" /> 
									<input  type="text" id="nombreCliente${status.count}" name="lnombreCliente" size="35" value="${estatusLis.nombreCliente}"  readOnly="true" disabled="true" style="text-align:left;"  /> 							 							
							  	</td>						  
							  	<td >
							  		<input type="hidden" id="promotorID${status.count}" name="lpromotorID"  value="${estatusLis.promotorID}" /> 
									<input  type="text" id="nombrePromotor${status.count}" name="lnombrePromotor" size="30" value="${estatusLis.nombrePromotor}"  readOnly="true" disabled="true" style="text-align:left;"  /> 		
								</td>
								<td>
									<input type="hidden" id="usuarioID${status.count}" name="lusuarioID"  value="${estatusLis.usuarioID}" /> 
									<input  type="text" id="nombreUsuario${status.count}" name="lnombreUsuario" size="30" value="${estatusLis.nombreUsuario}"  readOnly="true" disabled="true" style="text-align:left;"  />

							  	</td>						  	
							  	<td >
									<input  type="text" id="fechaComentario${status.count}" name="lfechaComentario" size="20" value="${estatusLis.fechaComentario}"  readOnly="true" disabled="true" style="text-align:left;"  /> 		
							  	</td>
							  	<td >
									<textarea  id="comentario" name="lcomentario"  COLS="40" ROWS="1" onBlur=" ponerMayusculas(this);"></textarea>		
							  	</td>
							  	<td >
							  		<div id="divPrincipalAplicacion" class="divPrincipalAplicacion">
							  			<a id="imgComentario${status.count}" href="javascript:" onclick="muestraComentario(this.id)";>
											<img src="images/comentario.png" align="bottom" height="18" width="18">
										</a>
									</div>
							  	</td>
							  	<td>  
									<input type="checkbox" id="checkSol${status.count}" name="checkSol"  readOnly="true" value = "N"  onclick="verificaSeleccion()" />
									<input  type="hidden" id="valorSolventar${status.count}" name="lvalorSolventar" size="30"/> 		
						  		</td> 								  						  					  				
							</tr>
							<tr id="renglonSol${status.count}" name="renglon">	
								<td colspan="1">									
							  	</td>				  	
							  	<td colspan="5">
									<input  type="text" id="comentarioSol${status.count}" name="lcomentarioSol" size="161" value="${estatusLis.comentarioSol}"  readOnly="true" disabled="true" style="text-align:left; display: none;"  />
							  	</td>
							  							  						  					  				
							</tr>

						</c:forEach>	
						<tr>							
							</td>							
						</tr>						
					</tbody>
			</c:when>
		</c:choose>
	</table>
	<c:if test="${!listaPaginada.firstPage}">
		<input onclick="consultaGridSolicitudes('previous')" type="button" id="anterior" value="" class="btnAnterior" />
	</c:if>
	<c:if test="${!listaPaginada.lastPage}">
		<input onclick="consultaGridSolicitudes('next')" type="button" id="siguiente" value="" class="btnSiguiente" />
	</c:if>
	
	<script type="text/javascript">	
		function consultaGridSolicitudes(pageValor) {
			var lista = ${tipoLista};
			var nomValor = $('#estatusSol').val();

			var params = {};		


		if(nomValor == 'CC'){
			var params = {};
			params['tipoLista'] = 4;
			params['fechaInicio'] = $('#fechaInicio').val();
			params['fechaFin'] = $('#fechaFin').val();
			params['sucursalID'] = $('#sucursal').val();	
			params['promotorID'] =  $('#promotorID').val();	
			params['estatus'] = nomValor;	
			params['productoCreditoID'] = $('#productoCreditoID').val();	
			params['page'] = pageValor;	
					

			$.post("monitorCantidadSolicitudesGridVista.htm", params, function(data){
					
					if(data.length >0) {	
						$('#divListaDetalle').html(data);
						$('#divListaDetalle').show();	
						$('#fieldsetLisDetalle').show();
						$('#solventar').show();
					//	consultaID();
								
					}else{				
						$('#divListaDetalle').html("");
						$('#divListaDetalle').hide();
						$('#fieldsetLisDetalle').hide();	
						mensajeSis('No se Encontraron Coincidencias');
					}
					$('#contenedorForma').unblock(); // desbloquear
					$('#fieldsetLisTotal').hide();
				});
		}
		else{
			var params = {};
			params['tipoLista'] = 2;
			params['fechaInicio'] = $('#fechaInicio').val();
			params['fechaFin'] = $('#fechaFin').val();
			params['sucursalID'] = $('#sucursal').val();	
			params['promotorID'] =  $('#promotorID').val();	
			params['estatus'] = nomValor;	
			params['productoCreditoID'] = $('#productoCreditoID').val();
			params['page'] = pageValor;		
					
				$.post("monitorCantidadSolicitudesGridVista.htm", params, function(data){
					if(data.length >0) {	
						$('#divListaDetalle').html(data);
						$('#divListaDetalle').show();	
						$('#fieldsetLisDetalle').show();
						$('#solventar').hide();
						consultaComentario();
								
					}else{				
						$('#divListaDetalle').html("");
						$('#divListaDetalle').hide();
						$('#fieldsetLisDetalle').hide();	
						mensajeSis('No se Encontraron Coincidencias');
					}

					$('#contenedorForma').unblock(); // desbloquear
					$('#fieldsetLisTotal').hide();
				});
		}
		

		}

		function consultaComentario(){
			$('textarea[name=lcomentario]').each(function() {		
			var valorID = eval("'#" + this.id + "'");
			var id = valorID.replace(/\D/g,'');	
			var comentarioID= $(valorID).val();		

			var imgComentario = eval("'#imgComentario" + id + "'");
			if(comentarioID != "")	{
				$(imgComentario).show();
			}
			else{
				$(imgComentario).hide();
			}
			
	        
	   	});
			
			
}

actualizaFormatoMoneda("formaGenerica");
	</script>
	
	
</body>
</html>