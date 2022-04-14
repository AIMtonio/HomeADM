<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Agenda</title>
	<script type="text/javascript" src="dwr/engine.js"></script>
    <script type="text/javascript" src="dwr/util.js"></script>     
	<script type="text/javascript" src="js/forma.js"></script>

	<script type="text/javascript" src="js/gestionComercial/jquery-1.7.2.min.js"></script>
	<script type="text/javascript" src="js/gestionComercial/jquery-ui-1.8.20.custom.min.js"></script>
	
			<link type="text/css" href="css/redmond/jquery-ui-1.8.20.custom.css" rel="stylesheet" />

  <script type="text/javascript" charset="utf-8">
    $(document).ready(function() {
    	
    	$('#tableCon').hide();
    	
		$("#campofecha").datepicker({
			changeYear: true,
			changeMonth: true,
			onSelect: function(textoFecha, objDatepicker){
				$("#mensaje").html("<p>Has seleccionado: " + textoFecha + "</p>");
				$('#tableCon').show();
				crearRegistros();
			}
		});
		
		function crearRegistros(){
	    	
	    	var regis = '';
	    	for(i=8; i<=20; i++){
	    		if( i != 14 && i !=15){
	    			regis += '<input type="text" id="numero'+i+'" name="numero'+i+'" onclick="abreDialogo(\'cuentaAhoID'+i+'\');" value="'+i+':00"  /></br>';	
	    		}else{
	    			regis += '</br>';
	    		}
	    	}
	    	$('#tableCon').html(regis);
	    }
		
		
		// Dialog
		$('#dialog').dialog({
			autoOpen: false,
			width: 600,
			modal: true,
			buttons: {
				"Agregar": function() {
					$(this).dialog("close");
				},
				"Cancel": function() {
					$(this).dialog("close");
				}
			}
		});
		
		

		// Dialog Link
		$('#dialog_link').click(function(){
			$('#dialog').dialog('open');
			return false;
		});
		
    });
    
    function abreDialogo(posicion){
		$('#dialog').dialog('open');
		return false;
	}
       
  </script> 
</head>
<body>

<div id="contenedorForma">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend class="ui-widget ui-widget-header ui-corner-all">Agenda</legend>
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="operDispersion"> 
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<tr>
							<td colspan="2">Agenda de actividades a realizar</td>
						</tr>
						<td>
							<div id="campofecha"></div>
						</td>
						<td rowspan="2">
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
								<legend >Actividades</legend>
									<div id="mensaje" /> </div>
									<div id="tableCon">
										
									</div>
							</fieldset>
						</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
				</table>
	</fieldset>
	
	<input type="button" id="dialog_link" class="submit" value="Open Dialog" />
	
	<div class="cuerpoBody">
		<!-- ui-dialog -->
		<div id="dialog" title="Dialog Title" style="font-size:80%">
			<p>Ejemplo del modal</p>
		</div>
	</div>
	
	 
	</form:form>
</div>	





</body>
</html>