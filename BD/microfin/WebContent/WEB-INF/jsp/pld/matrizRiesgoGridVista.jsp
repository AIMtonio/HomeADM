<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<c:set var="parametrosRiesgo" value="${listaResultado}"/>
<%! int consecutivoID = 01; %>
<fieldset class="ui-widget ui-widget-content ui-corner-all" >
   <legend class="label">Variables de Usuario</var></legend>
   <table id="tabla1" border="0" cellpadding="0" cellspacing="0" width="100%">
      <tr id="encabezadoLista" style="font-size:0.9em">
         <td class="label" align="left" style="padding: 0.3%">No.</td>
         <td class="separador"></td>
         <td class="label" align="left">Concepto</td>
         <td class="separador"></td>
         <td class="label" align="left"></td>
         <td class="separador"></td>
         <td class="label" align="left">Ponderado</td>
         <td class="separador"></td>
      </tr>
      <tr>
         <td class="label" align="left" style="display: none;"><label>${parametrosRiesgo[0].conceptoMatrizID}</label></td>
         <td class="label" align="left" ><label><%=consecutivoID++ %></label></td>
         <td class="separador"></td>
         <td class="label" align="left"><label id="concepto${parametrosRiesgo[0].conceptoMatrizID}">${parametrosRiesgo[0].concepto}</label></td>
         <td class="separador"></td>
         <td class="label" align="left" size="15"> <input readonly="true" style="background: transparent; border: none;"></input>  </td>
         <td class="separador"></td>
         <td align="left"><input id="pepNacional" class="valorPonderado" name="pepNacional" tabindex="<%=consecutivoID%>" size="10" maxlength="5" esNumero="true" value="${parametrosRiesgo[0].valor}"></input>
            <a href="javaScript:" onclick="ayuda(${parametrosRiesgo[0].conceptoMatrizID});">
            <img src="images/help-icon.gif">
            </a>
         </td>
      </tr>
      <tr>
         <td class="label" align="left" style="display: none;"><label>${parametrosRiesgo[1].conceptoMatrizID}</label></td>
         <td class="label" align="left" ><label><%=consecutivoID++ %></label></td>
         <td class="separador"></td>
         <td class="label" align="left"><label id="concepto${parametrosRiesgo[1].conceptoMatrizID}">${parametrosRiesgo[1].concepto}</label></td>
         <td class="separador"></td>
         <td class="label" align="left" size="15"> <input readonly="true" style="background: transparent; border: none;"></input>  </td>
         <td class="separador"></td>
         <td align="left"><input id="pepExtranjero" class="valorPonderado" name="pepExtranjero" tabindex="<%=consecutivoID%>" size="10" maxlength="5" esNumero="true" value="${parametrosRiesgo[1].valor}"></input>
            <a href="javaScript:" onclick="ayuda(${parametrosRiesgo[1].conceptoMatrizID});">
            <img src="images/help-icon.gif">
            </a>
         </td>
      </tr>
      <tr>
         <td class="label" align="left" style="display: none;"><label>${parametrosRiesgo[2].conceptoMatrizID}</label></td>
         <td class="label" align="left" ><label><%=consecutivoID++ %></label></td>
         <td class="separador"></td>
         <td class="label" align="left"><label id="concepto${parametrosRiesgo[2].conceptoMatrizID}">${parametrosRiesgo[2].concepto}</label></td>
         <td class="separador"></td>
         <td class="label" align="left" size="15"> <input readonly="true" style="background: transparent; border: none;"></input>  </td>
         <td class="separador"></td>
         <td align="left"><input id="localidad" class="valorPonderado" name="localidad" tabindex="<%=consecutivoID%>" size="10" maxlength="5" esNumero="true" value="${parametrosRiesgo[2].valor}"></input>
            <a href="javaScript:" onclick="ayuda(${parametrosRiesgo[2].conceptoMatrizID});">
            <img src="images/help-icon.gif">
            </a>
         </td>
      </tr>
      <tr>
         <td class="label" align="left" style="display: none;"><label>${parametrosRiesgo[3].conceptoMatrizID}</label></td>
         <td class="label" align="left" ><label><%=consecutivoID++ %></label></td>
         <td class="separador"></td>
         <td class="label" align="left"><label id="concepto${parametrosRiesgo[3].conceptoMatrizID}">${parametrosRiesgo[3].concepto}</label></td>
         <td class="separador"></td>
         <td class="label" align="left" size="15"> <input readonly="true" style="background: transparent; border: none;"></input>  </td>
         <td class="separador"></td>
         <td align="left"><input id="actEconomica" class="valorPonderado" name="actEconomica" tabindex="<%=consecutivoID%>" size="10" maxlength="5" esNumero="true" value="${parametrosRiesgo[3].valor}"></input>
            <a href="javaScript:" onclick="ayuda(${parametrosRiesgo[3].conceptoMatrizID});">
            <img src="images/help-icon.gif">
            </a>
         </td>
      </tr>
      <tr>
         <td class="label" align="left" style="display: none;"><label>${parametrosRiesgo[4].conceptoMatrizID}</label></td>
         <td class="label" align="left" ><label><%=consecutivoID++ %></label></td>
         <td class="separador"></td>
         <td class="label" align="left"><label id="concepto${parametrosRiesgo[4].conceptoMatrizID}">${parametrosRiesgo[4].concepto}</label></td>
         <td class="separador"></td>
         <td class="label" align="left"></td>
         <td class="separador"></td>
         <td align="left"><input id="origenRecursos" class="valorPonderado"  name="origenRecursos" tabindex="<%=consecutivoID%>" size="10" maxlength="5" esNumero="true" value="${parametrosRiesgo[4].valor}"></input>
            <a href="javaScript:" onclick="ayuda(${parametrosRiesgo[4].conceptoMatrizID});">
            <img src="images/help-icon.gif">
            </a>
         </td>
      </tr>
		<tr>
			<td class="label" align="left" style="display: none;"><label>${parametrosRiesgo[9].conceptoMatrizID}</label></td>
			<td class="label" align="left" ><label><%=consecutivoID++ %></label></td>
			<td class="separador"></td>
			<td class="label" align="left"><label id="concepto${parametrosRiesgo[9].conceptoMatrizID}">${parametrosRiesgo[9].concepto}</label></td>
			<td class="separador"></td>
			<td class="label" align="left"></td>
			<td class="separador"></td>
			<td align="left"><input id="paisNacimiento" class="valorPonderado"  name="paisNacimiento" tabindex="<%=consecutivoID%>" size="10" maxlength="5" esNumero="true" value="${parametrosRiesgo[9].valor}"></input>
			<a href="javaScript:" onclick="ayuda(${parametrosRiesgo[9].conceptoMatrizID});">
			<img src="images/help-icon.gif">
			</a>
			</td>
		</tr>
		<tr>
			<td class="label" align="left" style="display: none;"><label>${parametrosRiesgo[10].conceptoMatrizID}</label></td>
			<td class="label" align="left" ><label><%=consecutivoID++ %></label></td>
			<td class="separador"></td>
			<td class="label" align="left"><label id="concepto${parametrosRiesgo[10].conceptoMatrizID}">${parametrosRiesgo[10].concepto}</label></td>
			<td class="separador"></td>
			<td class="label" align="left"></td>
			<td class="separador"></td>
			<td align="left"><input id="paisResidencia" class="valorPonderado"  name="paisResidencia" tabindex="<%=consecutivoID%>" size="10" maxlength="5" esNumero="true" value="${parametrosRiesgo[10].valor}"></input>
			<a href="javaScript:" onclick="ayuda(${parametrosRiesgo[10].conceptoMatrizID});">
			<img src="images/help-icon.gif">
			</a>
			</td>
		</tr>
   </table>
</fieldset>
<br/>
<fieldset class="ui-widget ui-widget-content ui-corner-all" >
   <legend class="label">Destino y Recursos</legend>
   <table id="tabla2" border="0" cellpadding="0" cellspacing="0" width="100%">
      <tr id="encabezadoLista" style="font-size:0.9em">
         <td class="label" align="left" style="padding: 0.3%">No.</td>
         <td class="separador"></td>
         <td class="label" align="left">Concepto</td>
         <td class="separador"></td>
         <td class="label" align="left"> </td>
         <td class="separador"></td>
         <td class="label" align="left">Ponderado</td>
         <td class="separador"></td>
      </tr>
      <tr>
         <td class="label" align="left" style="display: none;"><label>${parametrosRiesgo[5].conceptoMatrizID}</label></td>
         <td class="label" align="left" ><label><%=consecutivoID++ %></label></td>
         <td class="separador"></td>
         <td class="label" align="left"><label id="concepto${parametrosRiesgo[5].conceptoMatrizID}">${parametrosRiesgo[5].concepto}</label></td>
         <td class="separador"></td>
         <td class="label" align="left" size="15"> <input readonly="true" style="background: transparent; border: none;"></input>  </td>
         <td class="separador"></td>
         <td align="left"><input id="prodCredito" class="valorPonderado" name="prodCredito" tabindex="<%=consecutivoID%>" size="10" maxlength="5" esNumero="true" value="${parametrosRiesgo[5].valor}"></input>
            <a href="javaScript:" onclick="ayuda(${parametrosRiesgo[5].conceptoMatrizID});">
            <img src="images/help-icon.gif">
            </a>
         </td>
      </tr>
      <tr>
         <td class="label" align="left" style="display: none;"><label>${parametrosRiesgo[6].conceptoMatrizID}</label></td>
         <td class="label" align="left" ><label><%=consecutivoID++ %></label></td>
         <td class="separador"></td>
         <td class="label" align="left"><label id="concepto${parametrosRiesgo[6].conceptoMatrizID}">${parametrosRiesgo[6].concepto}</label></td>
         <td class="separador"></td>
         <td class="label" align="left" size="15"> <input readonly="true" style="background: transparent; border: none;"></input>  </td>
         <td class="separador"></td>
         <td align="left"><input id="destCredito" class="valorPonderado" name="destCredito" tabindex="<%=consecutivoID%>" size="10" maxlength="5" esNumero="true" value="${parametrosRiesgo[6].valor}"></input>
            <a href="javaScript:" onclick="ayuda(${parametrosRiesgo[6].conceptoMatrizID});">
            <img src="images/help-icon.gif">
            </a>
         </td>
      </tr>
   </table>
</fieldset>
<br/>
<fieldset class="ui-widget ui-widget-content ui-corner-all" >
   <legend class="label">Comportamiento Transaccional</legend>
   <table id="tabla3" border="0" cellpadding="0" cellspacing="0" width="100%">
      <tr id="encabezadoLista" style="font-size:0.9em">
         <td class="label" align="left" style="padding: 0.3%">No.</td>
         <td class="separador"></td>
         <td class="label" align="left">Concepto</td>
         <td class="separador"></td>
         <td class="label" align="left">Mayor o Igual a</td>
         <td class="separador"></td>
         <td class="label" align="left">Ponderado</td>
         <td class="separador"></td>
      </tr>
      <tr>
         <td class="label" align="left" style="display: none;"><label>${parametrosRiesgo[7].conceptoMatrizID}</label></td>
         <td class="label" align="left" ><label><%=consecutivoID++ %></label></td>
         <td class="separador"></td>
         <td class="label" align="left"><label id="concepto${parametrosRiesgo[7].conceptoMatrizID}">${parametrosRiesgo[7].concepto}</label></td>
         <td class="separador"></td>
         <td align="left"><input id="liAlertInusualesMesLimite" name="liAlertInusualesMesLimite" tabindex="<%=consecutivoID%>"  maxlength="2" size="4" esNumero="true" value="${parametrosRiesgo[7].limiteValida}"></input>
         </td>
         <td class="separador"></td>
         <td align="left"><input id="liAlertInusualesMesVal" class="valorPonderado" name="liAlertInusualesMesVal" tabindex="<%=consecutivoID%>" size="10" maxlength="5" esNumero="true" value="${parametrosRiesgo[7].valor}"></input>
            <a href="javaScript:" onclick="ayuda(${parametrosRiesgo[7].conceptoMatrizID});">
            <img src="images/help-icon.gif">
            </a>
         </td>
      </tr>
      <tr>
         <td class="label" align="left" style="display: none;"><label>${parametrosRiesgo[8].conceptoMatrizID}</label></td>
         <td class="label" align="left" ><label><%=consecutivoID++ %></label></td>
         <td class="separador"></td>
         <td class="label" align="left"><label id="concepto${parametrosRiesgo[8].conceptoMatrizID}">${parametrosRiesgo[8].concepto}</label></td>
         <td class="separador"></td>
         <td align="left"><input id="liOperRelevMesLimite" name="liOperRelevMesLimite" tabindex="<%=consecutivoID%>" maxlength="2" size="4" value="${parametrosRiesgo[8].limiteValida}"></input>
         </td>
         <td class="separador"></td>
         <td align="left"><input id="liOperRelevMesVal" class="valorPonderado" name="liOperRelevMesVal" tabindex="<%=consecutivoID%>" size="10" maxlength="5" esNumero="true" value="${parametrosRiesgo[8].valor}"></input>
            <a href="javaScript:" onclick="ayuda(${parametrosRiesgo[8].conceptoMatrizID});">
            <img src="images/help-icon.gif">
            </a>
         </td>
		<% consecutivoID = 01; %>
         <input id="ayuda${parametrosRiesgo[0].conceptoMatrizID}" type="hidden" value="${parametrosRiesgo[0].descripcion}"></input>
         <input id="ayuda${parametrosRiesgo[1].conceptoMatrizID}" type="hidden" value="${parametrosRiesgo[1].descripcion}"></input>
         <input id="ayuda${parametrosRiesgo[2].conceptoMatrizID}" type="hidden" value="${parametrosRiesgo[2].descripcion}"></input>
         <input id="ayuda${parametrosRiesgo[3].conceptoMatrizID}" type="hidden" value="${parametrosRiesgo[3].descripcion}"></input>
         <input id="ayuda${parametrosRiesgo[4].conceptoMatrizID}" type="hidden" value="${parametrosRiesgo[4].descripcion}"></input>
         <input id="ayuda${parametrosRiesgo[5].conceptoMatrizID}" type="hidden" value="${parametrosRiesgo[5].descripcion}"></input>
         <input id="ayuda${parametrosRiesgo[6].conceptoMatrizID}" type="hidden" value="${parametrosRiesgo[6].descripcion}"></input>
         <input id="ayuda${parametrosRiesgo[7].conceptoMatrizID}" type="hidden" value="${parametrosRiesgo[7].descripcion}"></input>
         <input id="ayuda${parametrosRiesgo[8].conceptoMatrizID}" type="hidden" value="${parametrosRiesgo[8].descripcion}"></input>
         <input id="ayuda${parametrosRiesgo[9].conceptoMatrizID}" type="hidden" value="${parametrosRiesgo[9].descripcion}"></input>
         <input id="ayuda${parametrosRiesgo[10].conceptoMatrizID}" type="hidden" value="${parametrosRiesgo[10].descripcion}"></input>
      </tr>
   </table>
</fieldset>
</br>
<c:set var="totalPuntaje" value="0"/>
<c:forEach var="i" begin="0" end="9">
   <c:set var="totalPuntaje" value="${totalPuntaje+parametrosRiesgo[i].valor}"/>
</c:forEach>
<table id="tabla3" border="0" cellpadding="0" cellspacing="0" width="95%">
   <tr>
      <td class="separador"></td>
      <td class="separador"></td>
      <td class="separador"></td>
      <td class="separador"></td>
      <td class="separador"></td>
      <td class="separador"></td>
      <td class="label">
      <label><b>&emsp;&emsp;&emsp;Total Ponderado:</b></label>
      <input id="totalSuma" size="11" esNumero="true" value="${totalPuntaje}" readonly="true"/>
      </td>
   </tr>
</table>
<script type="text/javascript">
   function ayuda(posicion) {
               
   
               var jqConcepto = eval("'#concepto" + posicion + "'");   
               var jqDescripcion= eval("'#ayuda" + posicion+ "'");   
               
                   data = '<fieldset class="ui-widget ui-widget-content ui-corner-all">' +
                       '<div id="ContenedorAyuda">' +
                       '<legend class="ui-widget ui-widget-header ui-corner-all">'+$(jqConcepto).text()+'</legend>' +
                       '<table border="1" id="tablaLista" width="100%" style="margin-top:10px">' +
                       '</br><label class="label" align="left">'+$(jqDescripcion).val()+'</label>' +
                       '</table>' +
                       '</div>' +
                       '</fieldset>';
               
                   $('#ContenedorAyuda').html(data);
               
                   $.blockUI({
                       message: $('#ContenedorAyuda'),
                       css: {
                           left: '50%',
                           top: '50%',
                           margin: '-200px 0 0 -200px',
                           border: '0',
                           'background-color': 'transparent'
                       }
                   });
                   $('.blockOverlay').attr('title', 'Clic para Desbloquear').click($.unblockUI);
               }
      
      
          $('.valorPonderado').blur(function(){
                      var valor_total = 0
                      $(".valorPonderado").each(
                          function(index, value) {
                              valor_total = valor_total + eval($(this).val().replace(",", ""));
                          }
                      );
                       if(!isNaN(valor_total)){
                         $("#totalSuma").val(valor_total);
                       }
                      agregaFormatoNumero('formaGenerica');
           });
</script>