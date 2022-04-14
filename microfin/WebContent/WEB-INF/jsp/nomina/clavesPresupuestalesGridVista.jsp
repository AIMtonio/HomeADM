<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<c:set var="tipoLista" value="${listaResultado[0]}" />
<c:set var="listaPaginada" value="${listaResultado[1]}" />
<c:set var="listaClavePresupGrid" value="${listaPaginada.pageList}" />

<c:choose>
	<c:when test="${tipoLista == '3'}">
			<table id="miTabla">
				<tbody>
					<tr>
						<td class="label">
							<label for="lblClave">Clave </label>
						</td>
						<td class="label">
							<label for="lblDescripcion">Descripci&oacute;n </label>
						</td>
						<td class="label">
							<label for="lblReqClave">Seleccionar </br> &nbsp;&nbsp;&nbsp;Todos </label><br>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" id="selecionarTodo" onclick="seleccionarTodos()" name="selecionarTodo"/>
						</td>
					</tr>
					<c:forEach items="${listaClavePresupGrid}" var="clavePresup" varStatus="status">
						<tr id="renglon${status.count}" name="renglon">
							<td>
								<input type="hidden" id="nomClavePresupID${status.count}" name="nomClavePresupID" size="6"  value="${clavePresup.nomClavePresupID}"/>
								<input type="text" id="clave${status.count}" name="clave" size="10" value="${clavePresup.clave}"  tabindex="4" readonly="true"/>
							</td>

							<td>
								<input type="text"  id="descripcion${status.count}" name="descripcion" size="50" value="${clavePresup.descripcion}"  onBlur="ponerMayusculas(this)" tabindex="5" readonly="true" />
							</td>
							<td>
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" id="reqClave${status.count}" name="reqClave" onclick="estableceClavePresup('reqClave${status.count}')"/>
							</td> 
						</tr>
						<c:set var="numeroFilas" value="${status.count}" />
					</c:forEach>
					<input type="hidden" value="${numeroFilas}" name="numero" id="numero" />
				</tbody>
			</table>

			<c:if test="${!listaPaginada.firstPage}">
				<input onclick="clavePresup('previous')" type="button" value="" id="anterior" class="btnAnterior" />
			</c:if>
			<c:if test="${!listaPaginada.lastPage}">
				<input onclick="clavePresup('next')" type="button" id="siguiente" value="" class="btnSiguiente" />
			</c:if>

			<div class="alinear">
				<c:forEach begin="1" end="${listaPaginada.pageCount}"  varStatus="loop">
					<li class="pagination" id="pag-${loop.count - 1}"><a class="active cambioColor" onclick="clavePresup(${loop.count})">${loop.count}</a></li>
				</c:forEach>
			</div>
	</c:when>
</c:choose>


<script type="text/javascript">
/**
* Metodo para visualizar
*/
habilitaDeshabilitaClavePesup();
	function clavePresup(pageValor){
		var params = {};
		params['tipoLista'] = 1;
		params['page'] 	= pageValor ;
				
		$.post("clavePresupuestalesGridVista.htm",params,function(data) {
			if(data.length >0 || data != null) { 
				$('#gridClavePresup').html(data);
				agregaFormatoControles('formaGenerica');
				seleccionarCheck();
				$('#gridClavePresup').show();
			}
		});
	} //fin metodo: 

	function habilitaDeshabilitaClavePesup(){
		var numCodig = $('#numero').val();

		for(var i = 1; i <= numCodig; i++){
			var jqIdClave = eval("'clave" + i+ "'");
			var clave = document.getElementById(jqIdClave).value;

			if( clave == "" ){
				document.getElementById(jqIdClave).disabled = true;
				$('#'+jqIdClave).val("NA");
			}
		}
	}

</script>


<style>
	li.pagination {
		display: inline-block;
		padding: 0;
		margin: 0;
	}

	li.pagination {display: inline ;}

	li.pagination a {
		color: black;
		float: left;
		padding: 2px 4px;
		text-decoration: none;
		border-radius: 5px;
	}

	li.pagination a.cambioColor:hover {
		background-color: powderblue;
		transition: background-color .5s;
	}

	li.pagination a.active {
		background-color: white;
		color: black;
		border-radius: 4px;
		cursor: pointer;
		white-space:nowrap;

	}

	div.alinear {
		float: right;
	}

</style>