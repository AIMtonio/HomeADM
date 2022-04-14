<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="tipoTransac" 	value="${listaResultado[0]}"/>	
<c:set var="listaResultado" 	value="${listaResultado[1]}"/>	
<c:set var="cont" value="0"/>	
 
<script type="text/javascript" charset="utf-8">
   	
    	</script>     	
    	
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend class="ui-widget ui-widget-header ui-corner-all">Cuentas</legend>	
		<!-- <table class="altColorFilasTabla" id="alternacolor" > 	 -->
			<table border="0" cellpadding="0" cellspacing="0" width="60%"> 
					<tr>
									<td class="label" align="center"> <label>N&uacute;mero de Cuenta</label>   </td>
									<td class="label" align="center"> <label>Tipo</label>   </td>
								    <td class="label" align="center"> <label> Saldo Disponible</label>  </td>	
									<td class="label" align="center">  <label>Saldo Bloqueado</label>  </td>
								    <td class="label" align="center"></td> 
					</tr>
						<c:forEach items="${listaResultado}" var="resCte" varStatus="status"> 
						<c:choose>	
							<c:when test="${resCte.saldoBloq > 0.00 && tipoTransac==2}">	
								<tr>
									<td align="center">
										<input type="text" id="cuentaAhoID${status.count}" disabled="true" readOnly="true" name="cuentaAhoID"	value="${resCte.cuentaAhoID}" />
								  	</td> 
								  	<td align="center"> 
										<input type="text" size="40" id="tipoCta${status.count}" disabled="true" readOnly="true" name="tipoCta"	value="${resCte.tipoCuentaID}" />
								  	</td>
								  	<td align="center"> 
										 <input type="text" style="text-align:right;" type="text" id="saldoDispon${status.count}" disabled="true" readOnly="true" name="saldoDispon" esMoneda="true" value="${resCte.saldoDispon}" />
									</td> 
						     		<td align="center"> 
						     			 <input type="text" style="text-align:right;"  esMoneda="true" type="text" id="saldoBloqeado${status.count}" disabled="true" readOnly="true" name="saldoBloqeado" value="${resCte.saldoBloq}" /> 
								  	</td> 						  	
								  	<td align="center">
								  	<input type="button" id="btnAgrega${status.count}" name="${status.count}" onClick="desbloquearSaldoCta('${status.count}')" tabindex="2" style="cursor: pointer"/>
								  	<input type="hidden" id="varBloq${status.count}" name="varBloq" value="B" />
								  	<input type="hidden" id="grid${status.count}" name="grid" value="" />
								  	</td>
								</tr>
						<c:set var="cont" value="${status.count}"/>
						
						</c:when>
						<c:when test="${resCte.saldoDispon > 0.00 && tipoTransac==1 && resCte.saldoBloq >= 0.00}">	
								<tr>
									<td> 
										<input type="text" id="cuentaAhoID${status.count}" disabled="true"  readOnly="true" name="cuentaAhoID"	value="${resCte.cuentaAhoID}" />
								  	</td> 
								  	<td> 
										<input type="text" size="40" id="tipoCta${status.count}" disabled="true" readOnly="true" name="tipoCta"	value="${resCte.tipoCuentaID}" />
								  	</td> 
						   			<td> 
										 <input style="text-align:right;" type="text" id="saldoDispon${status.count}" disabled="true" readOnly="true" name="saldoDispon" esMoneda="true"	value="${resCte.saldoDispon}" />
									</td>
						     		<td>
						     			 <input style="text-align:right;" type="text" id="saldoBloqeado${status.count}" disabled="true" readOnly="true" name="saldoBloqeado" esMoneda="true"	value="${resCte.saldoBloq}" /> 
								  	</td> 
								  	<td>
								  	<input type="button" id="btnAgrega${status.count}" name="${status.count}" onClick="desbloquearSaldoCta('${status.count}')" style="cursor: pointer"/>
								  	<input type="hidden" id="varBloq${status.count}" name="varBloq" value="B" />
								  	<input type="hidden" id="grid${status.count}" name="grid" value="" />
								  	<input  type="hidden" id="estatus${status.count}" name="estatus" value="${resCte.estatus}" />
								  	</td>
								</tr>
								<c:set var="cont" value="${status.count}"/>
						</c:when>
						</c:choose>
						
					</c:forEach>
					
			</table>	
		 <input type="hidden" value="${cont}" name="numeroDetCuentas" id="numeroDetCuentas" />	
	</fieldset>