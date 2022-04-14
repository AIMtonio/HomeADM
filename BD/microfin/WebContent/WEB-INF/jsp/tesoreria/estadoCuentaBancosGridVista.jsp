<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<c:set var="movsEdoCta"  value="${listaPaginada.pageList}"/>

<fieldset class="ui-widget ui-widget-content ui-corner-all">   
<table id="tablaLista" border = "0">
	<tr id="encabezadoLista">
		<td colspan ="2">Fecha</td>
		<td colspan ="2">Descripci&oacute;n</td>
		<td colspan ="2">Referencia</td>
		<td colspan ="2">Cargos</td>
		<td colspan ="2">Abonos</td>
		<td colspan ="2">Saldo</td>
	</tr>
	<c:forEach items="${movsEdoCta}" var="movs" varStatus="status">
	<tr>
		<td colspan ="2"> 
			<label for="fechaMov" id="fechaMov${status.count}"  name="fechaMov" size="15" >
				${movs.fechaMov}
			</label>  

		</td> 
		<td></td> 
		<td> 
			<label for="descripcionMov" id="descripcionMov${status.count}"  name="descripcionMov" size="30" >
				${movs.descripcionMov}
			</label>  
  		</td> 
  		
		<td> 
			<label for="referenciaMov" id="referenciaMov${status.count}"  name="referenciaMov" size="15" >
				${movs.referenciaMov}
			</label>  
  		</td> 
  		 <td></td>
  		<td  style="text-align: right"> 
			<label for="cargos" id="cargos${status.count}"  name="cargos" size="20" >
				${movs.cargos}
			</label>  
		</td> 
		<td ></td> 
		<td style="text-align: right;"> 
			<label for="abonos" id="abonos${status.count}"  name="abonos" size="20"  >
				${movs.abonos}
			</label>  
  		</td> 	 
  		<td></td>  
  		<td  style="text-align: right"> 
			<label for="saldoAcumulado" id="saldoAcumulado${status.count}"  name="saldoAcumulado" size="20" >
				${movs.saldoAcumulado}
			</label>  
  		</td> 	
	</tr>
	</c:forEach>
</table>
<c:if test="${!listaPaginada.firstPage}">
	 <input onclick="consultaMovimientosEstadoCuentaGrid('previous')" type="button" value="" class="btnAnterior" />
</c:if>
<c:if test="${!listaPaginada.lastPage}">
	 <input onclick="consultaMovimientosEstadoCuentaGrid('next')" type="button" value="" class="btnSiguiente" />
</c:if>		
</fieldset>

<script type="text/javascript">
function consultaMovimientosEstadoCuentaGrid(pageValor){
	var params = {};
	params['institucionID'] = $('#institucionID').val();
	params['numCtaInstit'] = $('#cuentaBancaria').val();
	params['fecha'] = $('#fecha').val(); 
	params['page'] = pageValor ;

	$.post("gridEstadoDeCuentaBancos.htm", params, function(data){
			if(data.length >0) {//alert("datos");
				$('#gridMovEstadoCuentaBancos').html(data);
				$('#gridMovEstadoCuentaBancos').show();
				$('#generar').show();
				$('#trGenerarReporte').show();
			}else{
				$('#gridMovEstadoCuentaBancos').html("");
				$('#gridMovEstadoCuentaBancos').show(); 
				$('#generar').hide(); 
			}
	});
	
}

   
</script>
