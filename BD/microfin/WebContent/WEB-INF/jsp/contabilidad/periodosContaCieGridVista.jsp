<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head>

</head>
<body>
</br>

<c:set var="listaResultado"  value="${listaResultado}"/>

<form id="gridDetalle" name="gridDetalle">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend>Periodos</legend>
			<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%">
				<tbody>	
					<tr>
						<td class="label"> 
					   	<label for="lblNumero">Numero</label> 
						</td>
						<td class="label"> 
							<label for="lblCR">Inicio</label> 
				  		</td>	
						<td class="label"> 
							<label for="lblCuenta">Fin</label> 
				  		</td>
				  		<td class="label"> 
			         	<label for="lblReferencia">Estatus</label> 
			     		</td> 
			     		<td class="label"> 
			         	<label for="lblDescripcion">Fec.Cierre</label> 
			     		</td> 
			     		<td class="label"> 
			         	<label for="lblCargos">Usu.Cierre</label> 
			     		</td> 
					</tr>
					
					<c:forEach items="${listaResultado}" var="periodosConta" varStatus="status">
						<tr id="renglon${status.count}" name="renglon">
							<td> 
								<input id="numeroPeriodo${status.count}"  name="numeroPeriodo" size="6"  
										value="${periodosConta.numeroPeriodo}" readOnly="true" disabled="true"/> 
						  	</td> 
						  	<td> 
								<input id="inicioPeriodo${status.count}" name="inicioPeriodo" size="12" 
										value="${periodosConta.inicioPeriodo}" readOnly="true" disabled="true"/> 
						  	</td> 
						  	<td> 
								<input id="finPeriodo${status.count}" name="finPeriodo" size="12" 
										value="${periodosConta.finPeriodo}" readOnly="true" disabled="true"/> 
						  	</td>
						  	<td>
							    <c:choose>
							      <c:when test="${periodosConta.status=='N'}">
										<input id="status${status.count}" name="status" size="12"
												 value="Por Cerrar" readOnly="true" disabled="true"/> 							      
							      </c:when>
							      <c:otherwise>
										<input id="status${status.count}" name="status" size="12"
												 value="Cerrado" readOnly="true" disabled="true"/>
							      </c:otherwise>
							    </c:choose> 						  	
						  	</td> 
						  	<td>
							    <c:choose>
							      <c:when test="${periodosConta.fechaCierre!='1900-01-01'}">
										<input id="fechaCierre${status.count}" name="fechaCierre" size="12"
												 value="${periodosConta.fechaCierre}" readOnly="true" disabled="true"/>
							      </c:when>
							      <c:otherwise>
										<input id="fechaCierre${status.count}" name="fechaCierre" size="12"
												 value="" readOnly="true" disabled="true"/>
							      </c:otherwise>
							    </c:choose>
						  	</td>
						  	<td>
							    <c:choose>
							      <c:when test="${periodosConta.usuarioCierre!='0'}">
										<input id="usuarioCierre${status.count}" name="usuarioCierre" size="12"
												 value="${periodosConta.usuarioCierre}" readOnly="true" disabled="true"/>
							      </c:when>
							      <c:otherwise>
										<input id="usuarioCierre${status.count}" name="usuarioCierre" size="12"
												 value="" readOnly="true" disabled="true"/>
							      </c:otherwise>
							    </c:choose>
						  	</td>
						  	<td align="right">
						  		<c:choose>
							      <c:when test="${periodosConta.status=='N'}">
										<input type="submit" id="cerrar" name="cerrar" class="submit" value="Cerrar" tabindex="6"/>
										<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>	
										<script type="text/javascript">		
											$('#ejercicioRe').hide();
											$('#ejercicioGlo').hide();
											$('#balanza').hide();
										</script>
							      </c:when>
							      <c:otherwise>
										<script type="text/javascript">	
											$('#ejercicioRe').show();
											$('#ejercicioGlo').show();
											$('#balanza').show();
											$('#cerrar').hide();
										</script>	
							      </c:otherwise>
							    </c:choose>
								
							</td>
						</tr>
					</c:forEach>
				</tbody>
				<tr align="right">
					<td class="label" colspan="5"> 
				   	<br>
			     	</td>
				</tr>
			</table>
		</fieldset>	
</form>
</body>
</html>