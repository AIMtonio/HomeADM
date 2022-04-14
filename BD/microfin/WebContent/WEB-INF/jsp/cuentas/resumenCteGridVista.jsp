<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

	
<c:set var="resCte" 	value="${listaResultado}"/>	   

<script type="text/javascript" charset="utf-8">
   	
    	</script>     	
    	
		<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend>Cuentas</legend>	
			<table width="100%">
			<tr id="encabezadoLista">
							<td class="label" align="center">No. Cuenta</td>
							<td class="label" align="center">Tipo</td>
							<td class="label" align="center">Etiqueta</td>
							<td class="label" align="center">Saldo</td>
							<td class="label" align="center">Saldo Disponible</td>					
							<td class="label" align="center">Saldo SBC</td>
							<td class="label" align="center">Saldo Bloqueado</td>
			</tr>
				<c:forEach items="${resumenCte}" var="resCte"> 
						<tr>
							<td  align="left"> 
								<label> ${resCte.cuentaAhoID}</label>				
							</td> 
							<td  align="left"> 
								<label>${resCte.tipoCuentaID}</label>				
							</td> 
							<td  align="left"> 
								<label>${resCte.etiqueta}</label>				
							</td> 
							<td  align="right"> 
								<label>${resCte.saldo}</label>				
							</td> 
							<td  align="right"> 
								<label>${resCte.saldoDispon}</label>				
							</td> 
						  	<td  align="right"> 
								<label>${resCte.saldoSBC}</label>					
							</td> 
							<td align="right"> 
				     		<label style="text-decoration:underline;color:#7d7d7d; cursor: pointer"  onclick="pegaHtml('${resCte.cuentaAhoID}', '${resCte.saldoBloq}')" >				     		
				     			${resCte.saldoBloq}  </label>
						  	</td> 	
						</tr>
					</c:forEach>
					
			</table>
			
				</fieldset>
		
	
	

		
			<div id="bloq" title="Bloqueos" style="display: none; font-size:100%">
			
		</div>
			
		

	

	
	
