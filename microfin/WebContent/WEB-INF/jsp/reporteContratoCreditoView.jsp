<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<html>
<head>

    	<link rel="stylesheet" type="text/css" href="css/forma.css" media="all"  >
	<script type="text/javascript" src="js/jquery.js"></script>
	<script type="text/javascript" src="dwr/engine.js"></script>
	<script type="text/javascript" src="dwr/interface/Traffic.js"></script>
	<script type="text/javascript" src="dwr/util.js"></script>


</head>
<BODY>

<DIV id="ajaxWin" class="loginAjaxWinBody quickpopup">
<DIV id="ajaxWinBody">

<DIV id="loginContainer">

    <DIV id="formContainer">
	<form:form method="POST" commandName="contrato" id="reporteContratoCreForm" name="reporteContratoCreForm">
	
		<DIV class="elmHldr">
			Numeros:
			<form:input path="numero" name="numeroContrato"
				id="numeroContrato" value="" tabindex="1"/>
		</DIV>

<form:input path="numero" name="zip" maxlength="5"/>

<form:select name="zoom" path="numero" >
				<form:option value="Sr"/>
		            	<form:option value="Sra"/>
			        <form:option value="Lic"/>				
</form:select>

<form:select name="severity" path="numero" >
				<form:option value="Sr1"/>
		            	<form:option value="Sra1"/>
			        <form:option value="Lic1"/>
</form:select>


		<DIV class="elmHldr">

			<INPUT type="button" name="envia" id="envia" value="Generar Reporte"
				  class="btn_orange_regular buyButton" tabindex="2">

			<INPUT type="button" name="consulta" id="consulta" value="consulta"
				  class="btn_orange_regular buyButton" tabindex="9">

		</DIV>
	</form:form>
    </DIV>
</DIV>

</DIV>
</DIV>

<table width="100%" border="1" style="font-size:8pt;">
	<thead>
	<tr><td width="100">Summary</td><td>Details</td></tr>
	</thead>
	<tbody id="trafficTable"></tbody>
</table>

<div id = "resultado" >
</div>
</body>
<script type="text/javascript">

	$('#envia').click(function(){		
		$.post( "repContratoCredito.htm",
			$("#reporteContratoCreForm").serialize(),
			function(data){
				
				//$('#resultado').html(data);
				//$.openPopupLayer({
				//	name: "myPopup",
				//	target: "resultado"
				//});

				var printing = window.open("","ImprimirVar");
				printing.document.open();
				printing.document.write(data);
				printing.print();
				printing.document.close();	
				
			});
		return false;
			
	});

	$('#resultado').hide();

	$('#consulta').click(function(){				
		alert('cliockeando');
		criteriaChanged();
	});



	function criteriaChanged() {
		//alert(document.reporteContratoCreForm.zip.value);
		//var zipCode = document.reporteContratoCreForm.zip.value;
		//		       reporteContratoCreForm
		//var zoom = document.reporteContratoCreForm.zoom.value;
		//var severity = document.reporteContratoCreForm.severity.value;
		alert('hilas1');
		Traffic.getTrafficInfo('3', '2', '1', updateTable);
	}

	function updateTable(results) {
		DWRUtil.removeAllRows("trafficTable");
		DWRUtil.addRows("trafficTable", results, cellFuncs);
	}

	var cellFuncs = [function(data) { return data.summary; }, function(data) { return data.details; }];	

</script>	
</html>

