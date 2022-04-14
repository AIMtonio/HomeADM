<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head>
</head>
<body>
<br/>

<c:set var="listaResultado"  value="${listaResultado}"/>

<form id="gridCodigosResp" name="gridCodigosResp">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend>Respuestas</legend>	
			<table class="altColorFilasTabla" id="alternacolor2" border="4" cellpadding="1" cellspacing="0" >
				<tbody>	
					<tr id="encabezadoGrid" >
			     		<td width="10%"> 
					   		<b>	<center>	N&uacute;mero	</center> </b>
						</td>
						<td width="20%"> 
					    	<b>	<center>	C&oacute;digo 	</center> </b>
						</td>
				  		<td width="45%">  
			         		 <b>	<center> Respuesta 	</center></b>
			     		</td> 
			     		<td width="10%">  
			          		<b>	<center>	Cantidad 	</center></b>
			     		</td> 
						<td width="15%">  
			          		
			     		</td> 
					</tr>
					
					
					<c:forEach items="${listaResultado}" var="codigoResp" varStatus="status">
						<tr id="renglon${status.count}" name="renglon">
							<td> 
								<center>	<input id="consecutivoID${status.count}"  name="consecutivoID" size="6"  
										value="${status.count}" readOnly="true" class="sinBorde" style="background-color:transparent;" /> 
								</center>
						  	</td> 
							<td> 
								<center>
								<input id="codigoRespID${status.count}"  name="codigoRespID" size="6"  
										value="${codigoResp.codigoRespID}" readOnly="true" class="sinBorde" style="background-color:transparent;" />
								</center> 
						  	</td> 						  	
						  
						  	<td> 
						  			<center>
								<input id="descripcion${status.count}" name="descripcion" size="20" 
										value="${codigoResp.descripcion}" readOnly="true" class="sinBorde" style="background-color:transparent;" />
									</center> 
						  	</td> 
							<td> 
							<center>
								<input id="cantidad${status.count}" name="cantidad" size="10" 
										value="${codigoResp.campaniaID}" readOnly="true" class="sinBorde" style="background-color:transparent;" />
								</center>
						  	</td> 						  	
						   <td>
						   	<center>
						   		<a id="ligaPDF${status.count}" href="repDetalleResumenActSMS.htm" target="_blank" >
						  		<input type="button" id="detalle${status.count}" name="detalle" class="submit" value="Detalle" tabindex="6"
						  		onclick="consultaDetalleCodigo(this)" />
						  		</a>
						  		</center>
						  	</td>  
					  	
						</tr>
					</c:forEach>
				</tbody>
				
			</table>
			
		</fieldset>
	
</form>

</body>
</html>

	<script type="text/javascript">
	// codigos de respuesta desconocidos temporal
	var numCod = $('input[name=consecutivoID]').length;
	numCod = parseInt(numCod)+1;
			 $('#desconocido').val(numCod);	
			 
			 
			 
function consultaDetalleCodigo(idControl){	
	var parametroBean = consultaParametrosSession();   
		var valCampania 	= $('#campaniaID').val();
		var valClasific 	= $('#clasificacion').val();
		var valCategoria 	= $('#categoria').val();
		var valTipo 		= $('#tipo').val();
		var tipoReporte		= 2;
		var valEmpresa			= parametroBean.nombreInstitucion;
		var valorCantidad= 0;		
		
		var codigo= '0';
		
		var numCodig = $('input[name=consecutivoID]').length;
		var detalle  = idControl.id;
		var jqDetalle = 'detalle';
		var jqCodigo = 'codigoRespID';
		var jqLiga		= 'ligaPDF';
		var jqCantidad	= 'cantidad';
		for(var i = 1; i <= numCodig; i++){	
		/*#jqCodigo .text:focus{
    	outline:0px;
		}*/ 
			jqDetalle = 'detalle'+i;
			jqCodigo  = 'codigoRespID'+i;
			jqLiga	 = 'ligaPDF'+i;
			jqCantidad= 'cantidad'+i;
			if(detalle == jqDetalle) {
				codigo= $('#'+jqCodigo).val();
				var liga = jqLiga;
				valorCantidad = $('#'+jqCantidad).val();
			}
			
		}
		
		if(valorCantidad == 0){
			alert("No existen respuestas que mostrar");		
			event.preventDefault();
		}else{
		$('#'+liga).attr('href','repDetalleResumenActSMS.htm?campaniaID='+valCampania+'&clasificacion='+valClasific+
				'&categoria='+valCategoria+'&tipo='+valTipo+'&codigoRespuesta='+codigo+'&empresaID='+valEmpresa+
				'&tipoReporte='+tipoReporte);
		}
		
			
		
								 
		
	}

	
</script>