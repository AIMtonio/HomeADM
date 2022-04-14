$(document).ready(function() {

	var idCuentaPrincipal=0;

	var catTipoConsultaInstituciones = {
			'principal':1, 
			'foranea':2
	};
	var catTipoTranCuentas = {
			'grabar':1, 
			'modificar':2
	};
	var catTipoConsultaCtaNostro = {
			'folioInstit':5
	};	
	var catTipoListaSucursales={
			'principal':2
	};
	var catTipoConsultaReq= {

			'foranea':2

	};

	$('#editaClave').hide();
	$('#editaCta').hide();
	$('#radioAlta').attr('checked','true'); 	

	agregaFormatoControles('formaGenerica');
	deshabilitaBoton('agrega', 'submit');
	deshabilitaBoton('modifica', 'submit');


	$.validator.setDefaults({
		submitHandler: function(event) { 
			grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'sucursalID');

		}
	});	

	$('#institucionID').bind('keyup',function(e){
		//TODO Agregar Libreria de Constantes Tipo Enum
		lista('institucionID', '1', '1', 'nombre', 
				$('#institucionID').val(), 'listaInstituciones.htm');
	});

	$('#institucionID').blur(function() {
		if($('#institucionID').val()!=""){
			consultaInstitucion(this.id);

		}

	});

	$('#cueClave').blur(function(){
		if($('#cueClave').val()!="" && $('#institucionID').val()!=""){
			validaExisteFolio('cueClave','institucionID');	
		}		
	});

	$('#sucursalID').bind('keyup',function(e){
		//TODO Agregar Libreria de Constantes Tipo Enum
		lista('sucursalID', '2', '1', 'nombreSucurs', $('#sucursalID').val(), 'listaSucursales.htm');
	});

	$('#sucursalID').blur(function() {
		if($('#sucursalID').val() != '' && !isNaN($('#sucursalID').val()) ){
			validaSucursal(this);
		}
	});



	$('#radioAlta').click( function(){ 
		remplazaConInput();
		$('#editaCta').hide();

		deshabilitaBoton('modifica', 'submit');

	});

	$('#radioModifica').click( function(){ 
		remplazaConSelect();
		deshabilitaBoton('agrega', 'submit');
	});


	$('#esPrincipalChk').click( function(){ 
		var principal='S';
		var noPrincipal='N';
		if(	$('#esPrincipalChk').is(":checked") ){
			$('#esPrincipal').val(principal);
		}
		else{
			$('#esPrincipal').val(noPrincipal);
		}

	});

	$('#modifica').click( function(){ 

		$('#cuentaSucurID').val($('#cueClave').val());	   
		var valor = $("#cueClave option:selected").html();  
		$("#cueClave option:selected").val(valor);
		$('#tipoTransaccion').val(catTipoTranCuentas.modificar);

	});


	$('#agrega').click( function(){ 

		$('#tipoTransaccion').val(catTipoTranCuentas.grabar);
	});


	$('#editaClave').blur(function() {
		if($('#editaClave').val()!=''){
			validaExisteFolioEditado('editaClave','institucionID');

		}
	});

	function consultaInstitucion(idControl) {
		var jqInstituto = eval("'#" + idControl + "'");
		var numInstituto = $(jqInstituto).val();
		setTimeout("$('#cajaLista').hide();", 200);	
		var InstitutoBeanCon = {
				'institucionID':numInstituto
		};

		if(numInstituto != '' && !isNaN(numInstituto)){
			institucionesServicio.consultaInstitucion(catTipoConsultaInstituciones.foranea,InstitutoBeanCon,function(instituto){

				if(instituto!=null){							
					$('#nombreInstitucion').val(instituto.nombre);
					if( $('#radioModifica').is(":checked") ){
						buscaCuentasSucursales('institucionID','sucursalID');	
					}		
					if( $('#radioAlta').is(":checked") ){
						habilitaBoton('agrega', 'submit');
					}							
				}else{
					alert("No existe la Institución"); 
					$('#institucionID').val('');	
					$('#institucionID').focus();	
					$('#nombreInstitucion').val("");	
					deshabilitaBoton('agrega', 'submit');
					deshabilitaBoton('modifica', 'submit');				
				}    						
			});
		}
	}

	function validaExisteFolio(numCta,institID){
		var jqNumCtaInstit = eval("'#" + numCta + "'");
		var jqInstitucionID = eval("'#" + institID + "'");
		var numCtaInstit = $(jqNumCtaInstit).val();
		var institucionID = $(jqInstitucionID).val();
		var CtaNostroBeanCon = {
				'institucionID':institucionID,
				'numCtaInstit':numCtaInstit
		};

		cuentaNostroServicio.consultaExisteCta(catTipoConsultaCtaNostro.folioInstit,CtaNostroBeanCon, function(ctaNtro){

			if(ctaNtro!=null){  
				var folio = ctaNtro.cuentaClabe;// el folio de institucion se paso en el parametro cuentaClabe
				var cuentaClabe = $('#cueClave').val();
				var substrClabe= cuentaClabe.substr(0,3);
				if(folio!=substrClabe){
					alert("La Cuenta Clabe no coincide con la Institución.");
					$('#cueClave').focus();			 	
				}						 			
			}


		});

	}	////////////////////////////////////////////////////////

	function validaExisteFolioEditado(numCta,institID){
		var jqNumCtaInstit = eval("'#" + numCta + "'");
		var jqInstitucionID = eval("'#" + institID + "'");
		var numCtaInstit = $(jqNumCtaInstit).val();
		var institucionID = $(jqInstitucionID).val();
		var CtaNostroBeanCon = {
				'institucionID':institucionID,
				'numCtaInstit':numCtaInstit
		};

		cuentaNostroServicio.consultaExisteCta(catTipoConsultaCtaNostro.folioInstit,CtaNostroBeanCon, function(ctaNtro){

			if(ctaNtro!=null){  
				var folio = ctaNtro.cuentaClabe;// el folio de institucion se paso en el parametro cuentaClabe
				var cuentaClabe = $(jqNumCtaInstit).val();
				var substrClabe= cuentaClabe.substr(0,3);
				if(folio!=substrClabe){
					alert("La Cuenta Clabe no coincide con la Institución.");
					$(jqNumCtaInstit).focus();			 	
				}	
				else
				{
					$("#cueClave option:selected").html($('#editaClave').val());
					$(jqNumCtaInstit).hide('slow');
				}					 			
			}


		});

	}	////////////////////////////////////////////////////////


	function validaSucursal(control) {
		var numSucursal = $('#sucursalID').val();
		setTimeout("$('#cajaLista').hide();", 200);

		sucursalesServicio.consultaSucursal(1,numSucursal,function(sucursal) { 
			if(sucursal!=null){
				$('#sucursalID').val(sucursal.sucursalID);
				$('#nombreSucursal').val(sucursal.nombreSucurs);
			}
			else{
				alert("No existe la sucursal.");
				$('#nombreSucursal').val('');
			}
		});

	}	
	// 
	function remplazaConSelect(){
		var sel = '<select id="cueClave" name="cueClave" path="cueClave"  tabindex="3" onchange="cambiaEsPrincipal(this);"></select>';

		$('#cueClave').replaceWith(sel);	
		$('#editaCta').show();

		$('#editaCta').click( function(){ 
			var valor = $("#cueClave option:selected").html();
			$('#editaClave').val(valor);
			$('#editaClave').show('slow');
			$('#editaClave').focus();

		});		   			

	}

	function remplazaConInput(){
		var inp = '<input id="cueClave" name="cueClave" path="cueClave" size="38" tabindex="3" maxlength="18" />';
		$('#cueClave').replaceWith(inp);	
		$('#cueClave').blur(function(){
			if($('#cueClave').val()!="" && $('#institucionID').val()!=""){
				validaExisteFolio('cueClave','institucionID');	
			}		
		});
	}


	function buscaCuentasSucursales(idInstitucion,idSucursal){
		var jqInstit = eval("'#" + idInstitucion + "'");
		var jqSucursal = eval("'#" + idSucursal + "'");
		var institucionID = $(jqInstit).val();
		var sucursalID = $(jqSucursal).val();

		var RequisicionBean = {
				'sucursalID' : sucursalID,
				'institucionID' : institucionID
		};

		reqGastosSucServicio.cuentasAhoSuc(catTipoConsultaReq.foranea,RequisicionBean,function(data){
			if(data!=null){

				llenaSelectCuentas(data);

			}else{
				alert("No existe la cuenta");
				//dwr.util.removeAllOptions('cuentaDepositar');

			}	
		});		

	}

	function llenaSelectCuentas(data){//datos){

		dwr.util.removeAllOptions('cueClave');
		if(data!=''){
			dwr.util.addOptions('cueClave', data, 'cuentaSucurID', 'cueClave');
			habilitaBoton('modifica', 'submit');
			idCuentaPrincipal= $("#cueClave option:selected").val();	
			$('#cuentaPrincipalID').val(idCuentaPrincipal);
			$('#esPrincipalChk').attr('checked','true');
			$('#esPrincipal').val('S');
		} else{
			alert("No se encontraron cuentas para esta Institucion");
			deshabilitaBoton('modifica', 'submit'); 
		} 




	}


	$('#formaGenerica').validate({
		rules: {


			sucursalID :'required',
			institucionID: 'required',	


		},

		messages: {

			sucursalID :'La sucursal es requerida',
			institucionID: 'La Institución',	



		}
	});

});// fin de jQuery

function cambiaEsPrincipal(idControl){
	var idSelect =  eval("'#" + idControl.id + "'");
	var idOption= $(idSelect).val();

	if(idOption == $('#cuentaPrincipalID').val()){
		$('#esPrincipalChk').attr('checked',true);
		$('#esPrincipal').val('S');
	}
	else{
		$('#esPrincipalChk').removeAttr('checked');
		$('#esPrincipal').val('N');
	}
	//alert($('#cuentaPrincipalID').val());

}


