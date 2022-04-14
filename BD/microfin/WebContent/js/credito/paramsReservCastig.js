$(document).ready(function() {
	esTab = true;
	
	var catTipoTransaccion = { 
	  		'modificar'	: '2'
		};
 //*************Metos y Manejos de Eventos******************//	
	 deshabilitaBoton('modifica', 'submit');
	 $('#regContaEPRC1').attr("checked",true);
	 $('#ePRCIntMorato1').attr("checked",true);
	 $('#divideEPRCCapitaInteres1').attr("checked",true);
	 $('#condonaIntereCarVen').attr("checked",true);
	 $('#condonaMoratoCarVen').attr("checked",true);
	 $('#condonaAccesorios').attr("checked",true);
	 $('#eprcAdicional1').attr("checked",true);
	 $('#divideCastigo').attr("checked",true);
	 $('#IVARecuperacion').attr("checked",true);
	 
	 
	 $(':text').focus(function() {	
		 	esTab = false;
		});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});	
	$('#empresaID').bind('keyup',function(e){	
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "nombreInstitucion";
		parametrosLista[0] = $('#empresaID').val();
		lista('empresaID', '1', '1', camposLista,parametrosLista, 'listaParametrosSis.htm');	
	});
	$('#empresaID').blur(function() { 
  		consultaParamEmpresa(this.id); 
	});
	$('#modifica').click(function() { 
		$('#tipoTransaccion').val(catTipoTransaccion.modificar); 
	});
	
	$.validator.setDefaults({
        submitHandler: function(event) {             	
        	grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','EmpresaID','limpia','error');
        }
});	
//**************Validaciones de la Forma*******************//
	 $('#formaGenerica').validate({
			rules: {
				empresaID: {
					required: true
				},	

			},
			messages: {
				empresaID: {
					required: 'Se requiere el número de empresa'
				},	

			}
		 
	});
//*************Funciones**********************************//
	 function consultaParamEmpresa(idControl){
		var jqEmpresaID = eval("'#" + idControl + "'");
		var numEmpresa = $(jqEmpresaID).val();	
		var tipoCon=1;
		var paramsReservCastigoBean = {  
				'empresaID':numEmpresa
				};
		if(numEmpresa != '' && !isNaN(numEmpresa) && esTab && numEmpresa > 0){
			paramsReservCastigServicio.consulta(tipoCon,paramsReservCastigoBean,function(params) {
				if(params != null){
					 habilitaBoton('modifica', 'submit');
					 if(params.regContaEPRC == 'P'){
							$('#regContaEPRC').attr("checked",true);
							$('#regContaEPRC1').attr("checked",false);
					 }else{
						 $('#regContaEPRC').attr("checked",false);
						 $('#regContaEPRC1').attr("checked",true);
					 }
					 if(params.ePRCIntMorato == 'S'){
							$('#ePRCIntMorato').attr("checked",true);
							$('#ePRCIntMorato1').attr("checked",false);
					 }else{
						 $('#ePRCIntMorato').attr("checked",false);
						 $('#ePRCIntMorato1').attr("checked",true);
					 }
					 if(params.divideEPRCCapitaInteres == 'S'){
							$('#divideEPRCCapitaInteres').attr("checked",true);
							$('#divideEPRCCapitaInteres1').attr("checked",false);
					 }else{
						 $('#divideEPRCCapitaInteres').attr("checked",false);
						 $('#divideEPRCCapitaInteres1').attr("checked",true);
					 }
					 if(params.condonaIntereCarVen == 'S'){
							$('#condonaIntereCarVen').attr("checked",true);
							$('#condonaIntereCarVen1').attr("checked",false);
					 }else{
						 $('#condonaIntereCarVen').attr("checked",false);
						 $('#condonaIntereCarVen1').attr("checked",true);
					 }
					 if(params.condonaMoratoCarVen == 'S'){
							$('#condonaMoratoCarVen').attr("checked",true);
							$('#condonaMoratoCarVen1').attr("checked",false);
					 }else{
						 $('#condonaMoratoCarVen').attr("checked",false);
						 $('#condonaMoratoCarVen1').attr("checked",true);
					 }
					 if(params.condonaAccesorios == 'S'){
							$('#condonaAccesorios').attr("checked",true);
							$('#condonaAccesorios1').attr("checked",false);
					 }else{
						 $('#condonaAccesorios').attr("checked",false);
						 $('#condonaAccesorios1').attr("checked",true);
					 }
					 if(params.divideCastigo == 'S'){						 
						 $('#divideCastigo').attr('checked',true);
					 }else{
						 $('#divideCastigo1').attr('checked',true);
					 }
					 if(params.eprcAdicional == 'S'){
						 $('#eprcAdicional').attr('checked',true);
					 }else{
						 $('#eprcAdicional1').attr('checked',true);
					 }
					 if(params.IVARecuperacion == 'S'){
						 $('#IVARecuperacion').attr('checked',true);
					 }else{
						 $('#IVARecuperacion1').attr('checked',true);
					 }
				}
				else{
					alert("La Empresa no Existe.");
					limpia();
					$("#empresaID").focus();
					$("#empresaID").val("");
					 deshabilitaBoton('modifica', 'submit');
				}
		});
	  }
 	}
	 
});

function limpia(){
	 $('#regContaEPRC1').attr("checked",false);
	 $('#ePRCIntMorato1').attr("checked",false);
	 $('#divideEPRCCapitaInteres1').attr("checked",false);
	 $('#condonaIntereCarVen').attr("checked",false);
	 $('#condonaMoratoCarVen').attr("checked",false);
	 $('#condonaAccesorios').attr("checked",false);
	 
	 $('#regContaEPRC').attr("checked",false);
	 $('#ePRCIntMorato').attr("checked",false);
	 $('#divideEPRCCapitaInteres').attr("checked",false);
	 $('#condonaIntereCarVen1').attr("checked",false);
	 $('#condonaMoratoCarVen1').attr("checked",false);
	 $('#condonaAccesorios1').attr("checked",false);
	 
	 $('#eprcAdicional').attr("checked",false);
	 $('#eprcAdicional1').attr("checked",false);
	 $('#divideCastigo').attr("checked",false);
	 $('#divideCastigo1').attr("checked",false);
	 $('#IVARecuperacion').attr("checked",false);
	 $('#IVARecuperacion1').attr("checked",false);
	 
	 
	 deshabilitaBoton('modifica', 'submit');
}
function error(){
	
}












