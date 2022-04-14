<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<c:set var="paramsSubBINs"  value="${listaResultado}"/>


	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend>Patrocinadores SubBin</legend>	
			<table border="0" cellpadding="0" cellspacing="0" width="100%"> 		
				<tr>
					<td class="label"> 
						<label for="lblNo">No. SubBin</label> 
					</td> 	
					<td class="label"> 
						<label for="lblComentario">Proveedor</label> 
				  	</td>
			     	<td class="separador"></td> 
			 	</tr>
			    
			    <c:forEach items="${listaResultado}" var="listaResultado" varStatus="status"> 
				<tr>
					<td> 
						<input id="digSolID${status.count}"  name="digSolID" size="9" tabindex="1" 
										value="${listaResultado.numSubBIN}" readOnly="true"/> 
					</td> 
					<td> 
						<input id="digSolID${status.count}"  name="digSolID" size="30" tabindex="1" 
										value="${listaResultado.nombrePatroc}" readOnly="true"/> 
					</td>
					<td> 
						<input type="button" name="elimina" id="elimina${status.count}" class="btnElimina" value="" onclick="eliminaSubBin(${listaResultado.numSubBIN})"/>	
					</td> 
			    </tr>
				</c:forEach>
				<tr>
					<td>
						
					</td>
				</tr>
				
			</table>
		</fieldset>
